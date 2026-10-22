"""Build one explicit graph25 scope serially through the existing bounded wrapper."""
from pathlib import Path
import json,signal,subprocess,sys
O=Path(__file__).resolve().parent
scope=sys.argv[1]
assert scope in ['closure-pilot','closure-rest','assembly']
names=json.loads((O/(scope+'-TARGETS.json')).read_text())
plan=json.loads((O/'PLAN.json').read_text())
assert names and len(names)==len(set(names)) and set(names)<=set(plan['source_manifest'])
child=None
stopping=False
def stop(signum,frame):
 global stopping
 stopping=True
 if child is not None and child.poll() is None: child.terminate()
for sig in (signal.SIGTERM,signal.SIGINT,signal.SIGHUP): signal.signal(sig,stop)
for name in names:
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
print('GRAPH25_SCOPE_GUARDED_BUILDS_PASS '+scope,flush=True)
