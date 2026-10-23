"""Validate explicit completed scopes and combine their reviewed publication paths; no Git mutation."""
from pathlib import Path
import hashlib,json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');C=R/'research/continuations';P=Path(__file__).resolve().parent
assert len(sys.argv)>=4
previous=sys.argv[1];scopes=sys.argv[2:];assert len(set(scopes))==len(scopes)
allpaths=set()
for name in ["PUSH_PENDING_STATUS.json","PUSH_STALL_RECOVERY.json"]:
 q=C/previous/name
 if q.exists():allpaths.add(str(q.relative_to(R)))
for name in scopes:
 assert name.startswith('20261023-economical-graph39-')
 r=subprocess.run(['/Users/tp/.local/bin/python3.12','-B',str(P/'prepare.py'),name,previous],cwd=R,capture_output=True,text=True,timeout=120)
 print(r.stdout,flush=True)
 if r.returncode:print(r.stderr,flush=True);raise SystemExit(r.returncode)
 O=C/name;allpaths.update((O/'PUBLICATION_PATHS.txt').read_text().splitlines());previous=name
O=C/scopes[-1]
allpaths=sorted(allpaths);assert not any('__pycache__' in x for x in allpaths)
(O/'PUBLICATION_PATHS.txt').write_text('\n'.join(allpaths)+'\n')
(O/'PUBLICATION_HASHES.json').write_text(json.dumps({n:hashlib.sha256((R/n).read_bytes()).hexdigest() for n in allpaths},indent=2,sort_keys=True)+'\n')
print(json.dumps({'status':'EXPLICIT_COMPLETED_BATCH_PUBLICATION_PREPARED','scopes':scopes,'review_paths':len(allpaths)}),flush=True)
