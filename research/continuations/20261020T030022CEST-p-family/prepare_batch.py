"""Prepare an explicit bounded batch for the existing reviewed driver. No execution or Git mutation."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
label=sys.argv[1];targets=sys.argv[2:]
assert re.fullmatch(r'wave[0-9]+',label) and targets and len(targets)==len(set(targets))
assert all((out/'before'/(n+'.lean')).exists() for n in targets)
assert hashlib.sha256((work/'continuation_driver_capacity.py').read_bytes()).hexdigest()=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_current_batch_prepare',work/'continuation_driver_capacity.py')
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
 driver=m.Driver(root,work);q,ns,cs,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
 folder=out/label;folder.mkdir()
 (folder/'batch_run.py').write_bytes((out/'batch_template.py').read_bytes())
 (folder/'TARGETS.json').write_text(json.dumps(targets,indent=2)+'\n')
 (folder/'PRE_BUILD_SOURCE_REVIEW.json').write_text(json.dumps({n:{'sha256':m.sha((root/'D1Bound5'/(n+'.lean')).read_bytes())} for n in targets},indent=2)+'\n')
 readiness={n:{'compiled':n in accepted,'eligible':n in eligible,'missing':[d for d in cs[n] if d!=n and d not in accepted]} for n in targets}
 (folder/'READINESS.json').write_text(json.dumps({'time':datetime.now().astimezone().isoformat(),'unknown':unknown,'targets':readiness},indent=2)+'\n')
 print('BATCH_PREPARED_NOT_LAUNCHED',label,json.dumps(readiness))
