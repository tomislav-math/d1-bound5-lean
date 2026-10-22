"""Run only the four remaining foundation targets through the guarded worker."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json, os, signal, subprocess, sys
O=Path(__file__).resolve().parent
targets=['SmallPairLightData11RightRows','SmallPairLightData11','SmallPairLightAdaptiveData11','SmallPairLightAdaptiveValidation11']
worker=O/'bounded_build.py'
manifest=json.loads((O/'PREPARED_PAYLOAD_SHA256.json').read_text())
assert hashlib.sha256(worker.read_bytes()).hexdigest()==manifest['bounded_build.py']
record={'status':'RUNNING','pid':os.getpid(),'started_utc':datetime.now(timezone.utc).isoformat(),'targets':targets,'worker_sha256':manifest['bounded_build.py'],'children':[]}
path=O/'FOUNDATION_REMAINDER_BATCH.json';assert not path.exists()
current=None;stopped=False
def save():path.write_text(json.dumps(record,indent=2,sort_keys=True)+'\n')
def halt(*_):
 global stopped
 stopped=True
 if current is not None and current.poll() is None:current.terminate()
for sig in [signal.SIGTERM,signal.SIGINT,signal.SIGHUP]:signal.signal(sig,halt)
save()
try:
 for name in targets:
  assert not stopped,'Stop requested'
  current=subprocess.Popen(['/Users/tp/.local/bin/python3.12','-B',str(worker),name])
  child={'name':name,'pid':current.pid};record['children'].append(child);save()
  child['exit']=current.wait();save();assert child['exit']==0,name
 record['status']='GUARDED_BUILDS_PASS'
except BaseException:
 record['status']='STOPPED_OR_FAILED';raise
finally:
 record['finished_utc']=datetime.now(timezone.utc).isoformat();save()
print(json.dumps(record),flush=True)
