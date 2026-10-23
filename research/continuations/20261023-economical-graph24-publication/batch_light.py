"""Run explicit bounded proof units sequentially; no Git mutations."""
from pathlib import Path
import json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');B=R/'research/continuations';P=Path(__file__).resolve().parent
head=subprocess.check_output(['git','-C',str(R),'rev-parse','HEAD'],text=True).strip()
allowed={side+block for side in ['left','right'] for block in ['000','001','002']}
assert len(sys.argv)>1 and set(sys.argv[1:])<=allowed and len(set(sys.argv[1:]))==len(sys.argv)-1
for scope in sys.argv[1:]:
 O=B/('20261023-economical-graph24-'+scope);assert not (O/'PLAN.json').exists()
 with (O/'unit-process.log').open('w') as f:
  r=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(O/'run_unit.py'),head],cwd=R,stdout=f,stderr=subprocess.STDOUT,timeout=5400)
 if r.returncode:
  print('BATCH_UNIT_FAILED '+scope+' '+(O/'unit-process.log').read_text()[-5000:],flush=True);raise SystemExit(r.returncode)
 a=json.loads((O/'VERIFICATION_SUMMARY.json').read_text());assert a['status']=='SCOPED_VERIFICATION_PASS' and not json.loads((O/'OWNER.json').read_text())['active']
 print(json.dumps({'scope':scope,'status':a['status'],'heads':a['heads'],'offset':a['start_offset'],'kernel_replays':a['targeted_kernel_replays']}),flush=True)
print('GRAPH24_EXPLICIT_LIGHT_BATCH_PASS',flush=True)
