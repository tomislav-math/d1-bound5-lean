"""Read-only bounded monitoring; never launches or signals a compiler."""
import datetime
import json
from pathlib import Path
import re
import time

OUT = Path('/tmp/d1bound5-operational-prefix-v3-20261023/full-v3-prefix-observation')
BUILD = Path('/tmp/d1bound5-verification-20261023/clean-build')
SOURCE = '/workspace/scratch/fed64f41ca78/recovery-20261023/source/D1Bound5/'
MIB = 1024**2

def cgroup():
    p = Path('/sys/fs/cgroup')
    stats = dict((k, int(v)) for k, v in (line.split() for line in (p/'memory.stat').read_text().splitlines()))
    events = dict((k, int(v)) for k, v in (line.split() for line in (p/'memory.events').read_text().splitlines()))
    return {'current': int((p/'memory.current').read_text()),
            'floor': sum(stats.get(k,0) for k in ('anon','kernel','shmem','file_dirty','file_writeback')),
            'anon': stats.get('anon',0), 'kernel': stats.get('kernel',0), 'events': events}

def children():
    result = []
    for p in Path('/proc').iterdir():
        if not p.name.isdigit(): continue
        try:
            argv = (p/'cmdline').read_bytes().decode().rstrip('\0').split('\0')
            if not argv[0].endswith('/bin/lean') or '-o' not in argv: continue
            outputs = argv[argv.index('-o')+1]
            if not outputs.startswith(str(BUILD/'attempts')+'/'): continue
            sources = [a for a in argv if re.fullmatch(re.escape(SOURCE)+r'PellLightPrefixData\d+\.lean',a)]
            if len(sources) != 1: continue
            name = 'D1Bound5.'+Path(sources[0]).stem
            if not outputs.startswith(str(BUILD/'attempts'/name)+'/'): continue
            start = (p/'stat').read_text().rsplit(')',1)[1].split()[19]
            fields = {}
            for line in (p/'status').read_text().splitlines():
                k,_,v = line.partition(':')
                if k in ('VmRSS','VmHWM','RssAnon','RssFile'): fields[k] = int(v.split()[0])*1024
            if fields: result.append({'module':name,'proc':str(p),'start_ticks':start,'output':outputs,**fields})
        except (FileNotFoundError, ProcessLookupError, PermissionError, ValueError, IndexError, UnicodeDecodeError): pass
    return result

OUT.mkdir(exist_ok=False)
baseline = cgroup(); began = time.monotonic(); seen = {}; notices = set(); count = 0
family = ['D1Bound5.PellLightPrefixData'+str(n) for n in range(1,65)]
def accepted_count():
    return sum((BUILD/'accepted'/Path(n.replace('.','/')).with_suffix('.json')).is_file() for n in family)
start = {'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'baseline':baseline,
         'accepted_prefix_at_start':accepted_count(),'scope':'Exact owned prefix compiler processes, read-only; no proof gate',
         'interval_seconds':0.5,'near_reservation_bytes':1950*MIB,'reservation_bytes':2048*MIB,'floor_notice_bytes':6656*MIB}
(OUT/'START.json').write_text(json.dumps(start,indent=2,sort_keys=True)+'\n')
print('FULL_PREFIX_OBSERVER_READY',flush=True)
state = 'BOUNDED_OBSERVATION_TIME_EXPIRED'
with (OUT/'SAMPLES.jsonl').open('x') as f:
    while time.monotonic()-began < 900:
        cg = cgroup(); active = children(); elapsed = round(time.monotonic()-began,3)
        row = {'elapsed':elapsed,'cgroup':cg,'children':active}
        f.write(json.dumps(row,sort_keys=True)+'\n');f.flush(); count += 1
        for child in active:
            key = child['module']+'@'+child['proc']+'@'+child['start_ticks']
            saved = seen.setdefault(key,{'module':child['module'],'proc':child['proc'],'start_ticks':child['start_ticks'],
                                         'output':child['output'],'first_seen':elapsed,'peaks':{}})
            saved['last_seen'] = elapsed
            for field in ('VmRSS','VmHWM','RssAnon','RssFile'):
                saved['peaks'][field] = max(saved['peaks'].get(field,0),child.get(field,0))
            for label,threshold in [('NEAR_2GIB',1950*MIB),('EXCEEDS_2GIB',2048*MIB)]:
                if max(child.get('VmRSS',0),child.get('VmHWM',0)) >= threshold and (key,label) not in notices:
                    notices.add((key,label)); print(json.dumps({'notice':label,'elapsed':elapsed,'child':child,'cgroup':cg}),flush=True)
        if cg['floor'] > 6656*MIB and ('cgroup','HIGH_FLOOR') not in notices:
            notices.add(('cgroup','HIGH_FLOOR'));print(json.dumps({'notice':'FLOOR_GT_6_5_GIB','elapsed':elapsed,'cgroup':cg}),flush=True)
        if accepted_count()==64 and not active:
            state='ALL64_PREFIX_POINTERS_PRESENT_NO_ACTIVE_PREFIX';break
        time.sleep(0.5)
ending=cgroup()
result={'status':state,'samples':count,'seconds':time.monotonic()-began,'observed_children':seen,'baseline':baseline,'ending':ending,
        'accepted_prefix_at_end':accepted_count(),'oom_deltas':{k:ending['events'].get(k,0)-baseline['events'].get(k,0) for k in ('oom','oom_kill','oom_group_kill')},
        'limitations':'Pointers only determine observation stop; accepted proof status and actual invocation exit are checked separately by root. Per-process peaks are samples, not a uniform future memory bound.'}
(OUT/'SUMMARY.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print(json.dumps({'status':state,'samples':count,'observed_children':len(seen),'oom_deltas':result['oom_deltas']}),flush=True)
