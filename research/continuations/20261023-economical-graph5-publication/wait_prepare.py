"""Finite current-unit monitor and fail-closed evidence preparation; no compiler or Git mutations."""
from pathlib import Path
import json,subprocess,time
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';O=C/'20261023-economical-graph5-assembly';P=Path(__file__).resolve().parent
while True:
 if (O/'FAILURE.json').exists():
  print('ASSEMBLY_FAILED_NO_PREPARATION '+(O/'FAILURE.json').read_text(),flush=True);raise SystemExit(1)
 owner=json.loads((O/'OWNER.json').read_text()) if (O/'OWNER.json').exists() else {'active':True}
 if (O/'VERIFICATION_SUMMARY.json').exists() and not owner['active']:break
 time.sleep(5)
for script,args in [(C/'20261023-economical-graph5-closure-reuse/collect_endpoint.py',[]),(P/'prepare_endpoint.py',['20261023-economical-graph5-assembly','20261023-economical-graph5-closure-rest003'])]:
 result=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(script),*args],cwd=R,capture_output=True,text=True,timeout=120)
 print(result.stdout,flush=True)
 if result.returncode:
  print(result.stderr,flush=True);raise SystemExit(result.returncode)
print('GRAPH5_ENDPOINT_EVIDENCE_AND_PUBLICATION_SCOPE_PREPARED_NO_GIT_MUTATION',flush=True)
