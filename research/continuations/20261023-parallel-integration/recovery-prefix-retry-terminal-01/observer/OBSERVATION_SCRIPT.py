"""Read-only observation of the already-authorized isolated compiler; no proof gate."""
import datetime
import json
import os
from pathlib import Path
import time

OUT = Path('/tmp/d1bound5-operational-prefix-v3-20261023/retry43-observation')
SOURCE = '/workspace/scratch/fed64f41ca78/recovery-20261023/source/D1Bound5/PellLightPrefixData43.lean'
STAGE = '/tmp/d1bound5-verification-20261023/clean-build/attempts/D1Bound5.PellLightPrefixData43/'

def cgroup():
    p = Path('/sys/fs/cgroup')
    stats = dict((k, int(v)) for k, v in (line.split() for line in (p/'memory.stat').read_text().splitlines()))
    events = dict((k, int(v)) for k, v in (line.split() for line in (p/'memory.events').read_text().splitlines()))
    return {'current': int((p/'memory.current').read_text()), 'limit': int((p/'memory.max').read_text()),
            'anon': stats.get('anon', 0), 'kernel': stats.get('kernel', 0), 'file': stats.get('file', 0),
            'floor': sum(stats.get(k, 0) for k in ('anon','kernel','shmem','file_dirty','file_writeback')),
            'events': events}

def candidates():
    found = []
    for p in Path('/proc').iterdir():
        if not p.name.isdigit():
            continue
        try:
            argv = (p/'cmdline').read_bytes().decode().rstrip('\0').split('\0')
            if SOURCE not in argv or '-o' not in argv or not argv[0].endswith('/bin/lean'):
                continue
            output = argv[argv.index('-o')+1]
            if output.startswith(STAGE) and output.endswith('/stage/D1Bound5/PellLightPrefixData43.olean'):
                found.append((p, argv, (p/'stat').read_text().rsplit(')',1)[1].split()[19]))
        except (FileNotFoundError, ProcessLookupError, PermissionError, UnicodeDecodeError, ValueError, IndexError):
            continue
    return found

def status(p):
    result = {}
    for line in (p/'status').read_text().splitlines():
        key, _, value = line.partition(':')
        if key in ('VmRSS','VmHWM','VmSize','VmPeak','RssAnon','RssFile','RssShmem'):
            result[key] = int(value.split()[0])*1024
    return result

OUT.mkdir(exist_ok=False)
started = time.monotonic()
baseline = cgroup()
(OUT/'START.json').write_text(json.dumps({'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'scope': 'Read-only resource observation; no compiler launch or proof acceptance', 'sample_interval_seconds': 0.5,
    'source': SOURCE, 'baseline': baseline}, indent=2)+'\n')
print('OBSERVER_READY', flush=True)
selected = None
count = 0
peak = {}
state = 'NO_MATCH_WITHIN_600_SECONDS'
with (OUT/'SAMPLES.jsonl').open('x') as log:
    while time.monotonic()-started < 600:
        if selected is None:
            matches = candidates()
            if len(matches) > 1:
                state = 'AMBIGUOUS_MATCH'; break
            if matches:
                selected = matches[0]
                print('OBSERVED_CHILD', selected[0].name, flush=True)
        sample = {'elapsed': round(time.monotonic()-started,3), 'cgroup': cgroup()}
        if selected is not None:
            p, argv, identity = selected
            try:
                current_identity = (p/'stat').read_text().rsplit(')',1)[1].split()[19]
                if current_identity != identity:
                    state = 'PROCESS_ID_REUSED'; break
                child = status(p)
                sample.update(proc=str(p),child=child)
                if not child:
                    state = 'OBSERVED_CHILD_EXITED'; break
                for k,v in child.items(): peak[k] = max(v,peak.get(k,0))
            except (FileNotFoundError, ProcessLookupError):
                state = 'OBSERVED_CHILD_EXITED'; break
        log.write(json.dumps(sample,sort_keys=True)+'\n'); log.flush(); count += 1
        time.sleep(0.5)
ending = cgroup()
result = {'status':state,'samples':count,'seconds':time.monotonic()-started,'baseline':baseline,'ending':ending,
          'peak_observed_child_fields':peak,'selected_command':selected[1] if selected else None,
          'selected_proc':str(selected[0]) if selected else None,'selected_start_ticks':selected[2] if selected else None,
          'oom_deltas':{k:ending['events'].get(k,0)-baseline['events'].get(k,0) for k in ('oom','oom_kill','oom_group_kill')},
          'limitations':'Sampled VmRSS and kernel-reported VmHWM are observations, not a proven future bound or proof acceptance.'}
(OUT/'SUMMARY.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print(json.dumps(result,sort_keys=True),flush=True)
