"""Run the eleven reviewed remaining right25 targets serially; stop on first failure."""
from pathlib import Path
import json,signal,subprocess,sys
O=Path(__file__).resolve().parent
names=json.loads((O/'right-TARGETS.json').read_text())
assert len(names)==12 and names[0]=='SmallPairLightAdaptiveRight25_000Part00'
pilot=json.loads((O/(names[0]+'-BUILD_RECEIPT.json')).read_text())
assert pilot['accepted_build'] and pilot['exit']==0
child=None
stopping=False
def stop(signum,frame):
 global stopping
 stopping=True
 if child is not None and child.poll() is None: child.terminate()
for sig in (signal.SIGTERM,signal.SIGINT,signal.SIGHUP): signal.signal(sig,stop)
for name in names[1:]:
 if stopping: sys.exit(130)
 log=O/(name+'-wrapper.log')
 with log.open('x') as out:
  child=subprocess.Popen([sys.executable,'-B',str(O/'bounded_build.py'),name],stdout=out,stderr=subprocess.STDOUT)
  try: code=child.wait()
  finally:
   if child.poll() is None:
    child.terminate()
    child.wait()
 print(json.dumps({'target':name,'wrapper_exit':code,'log':str(log)}),flush=True)
 if code:
  print(log.read_text(),flush=True)
  sys.exit(code)
print('REMAINING_RIGHT25_GUARDED_BUILDS_PASS',flush=True)
