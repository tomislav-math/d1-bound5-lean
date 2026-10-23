"""Finite wait for the three current closure units, then read-only evidence validation and path preparation; no Git or compiler."""
from pathlib import Path
import json,subprocess,time
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';P=Path(__file__).resolve().parent
scopes=['20261023-economical-graph24-closure-rest'+n for n in ['001','002','003']];start=time.monotonic()
while True:
 for name in scopes:
  O=C/name
  if (O/'FAILURE.json').exists():print('CLOSURE_FAILURE '+name+' '+(O/'FAILURE.json').read_text(),flush=True);raise SystemExit(1)
 if all((C/n/'VERIFICATION_SUMMARY.json').exists() and not json.loads((C/n/'OWNER.json').read_text())['active'] for n in scopes):break
 if time.monotonic()-start>7200:print('FINITE_MONITOR_TIMEOUT_NO_PREPARATION',flush=True);raise SystemExit(1)
 time.sleep(5)
for args in [[str(P/'prepare_batch.py'),'20261023-economical-graph24-closure-pilot',*scopes],[str(R/'scripts/git_sync_preflight.py')]]:
 r=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',*args],cwd=R,capture_output=True,text=True,timeout=120);print(r.stdout,flush=True)
 if r.returncode:print(r.stderr,flush=True);raise SystemExit(r.returncode)
print('GRAPH24_CLOSURE_BATCH_AND_PUBLICATION_SCOPE_PREPARED_NO_GIT_MUTATION',flush=True)
