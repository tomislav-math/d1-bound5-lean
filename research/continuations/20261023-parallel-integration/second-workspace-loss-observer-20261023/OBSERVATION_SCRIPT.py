"""Read-only bounded cgroup observations; never launch or signal a compiler."""
from pathlib import Path
import datetime
import hashlib
import json
import time

OUT = Path('/tmp/d1bound5-operational-prefix-v3-20261023/build-memory-observation-01')
BUILD = Path('/tmp/d1bound5-verification-20261023/clean-build')
CONTROL = Path('/workspace/scratch/fed64f41ca78/recovery-20261023/launch/CONTROL.json')
MIB = 1024**2

def memory():
    p=Path('/sys/fs/cgroup')
    stats=dict((k,int(v)) for k,v in (x.split() for x in (p/'memory.stat').read_text().splitlines()))
    events=dict((k,int(v)) for k,v in (x.split() for x in (p/'memory.events').read_text().splitlines()))
    return {'floor':sum(stats.get(k,0) for k in ('anon','kernel','shmem','file_dirty','file_writeback')),
            'anon':stats.get('anon',0),'kernel':stats.get('kernel',0),'current':int((p/'memory.current').read_text()),'events':events}

OUT.mkdir(exist_ok=False)
baseline=memory(); began=time.monotonic(); count=0; peak=baseline; high=0; announced=False
(OUT/'START.json').write_text(json.dumps({'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'baseline':baseline,'scope':'Read-only global resource observations, no proof acceptance or control mutations',
    'interval_seconds':0.5,'maximum_seconds':1800},indent=2,sort_keys=True)+'\n')
print('BUILD_MEMORY_OBSERVER_READY',flush=True)
state='BOUNDED_OBSERVATION_TIME_EXPIRED'
latest=None
with (OUT/'SAMPLES.jsonl').open('x') as f:
    while time.monotonic()-began<1800:
        m=memory(); row={'elapsed':round(time.monotonic()-began,3),**m}; count+=1
        if m['floor']>peak['floor']:peak=row
        high=high+1 if m['floor']>6656*MIB else 0
        if m['floor']<6144*MIB:announced=False
        if not announced and (m['floor']>7168*MIB or high>=6):
            announced=True; print(json.dumps({'notice':'NEAR7GIB_OR_SUSTAINED_GT6_5GIB','sample':row,'consecutive_high_samples':high}),flush=True)
        if count%10==1:
            latest=json.loads((BUILD/'SUMMARY.json').read_text())
            row['build']={k:latest[k] for k in ('status','completed_modules','invocation','active','failed')}
            row['control_sha256']=hashlib.sha256(CONTROL.read_bytes()).hexdigest()
        f.write(json.dumps(row,sort_keys=True)+'\n');f.flush()
        if latest is not None and not latest['active'] and latest['status'] not in ('RUNNING','WAITING_FOR_MEMORY'):
            state='BUILD_TERMINAL_SUMMARY_OBSERVED';break
        time.sleep(0.5)
ending=memory()
result={'status':state,'samples':count,'seconds':time.monotonic()-began,'baseline':baseline,'ending':ending,
        'peak_floor_sample':peak,'last_observed_build_status':latest['status'] if latest else None,
        'oom_deltas':{k:ending['events'].get(k,0)-baseline['events'].get(k,0) for k in ('oom','oom_kill','oom_group_kill')},
        'limitations':'Sampled global observations, not hard memory limits, compiler attribution, or actual driver exit/proof acceptance.'}
(OUT/'SUMMARY.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print(json.dumps(result,sort_keys=True),flush=True)
