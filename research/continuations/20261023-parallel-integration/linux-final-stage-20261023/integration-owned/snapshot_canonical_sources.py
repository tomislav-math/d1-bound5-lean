"""Freeze the exact prepared canonical-root source graph for the final checker."""
from pathlib import Path
import hashlib, json, time

R=Path(__file__).resolve().parent.parent
P=R/'project'
sources={}
dependencies={}
paths={}

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def walk(n):
    if n in sources:return
    p=P/(n.replace('.','/')+'.lean')
    raw=p.read_bytes()
    sources[n]=hashlib.sha256(raw).hexdigest()
    paths[n]=str(p)
    dependencies[n]=[x for line in raw.decode().splitlines() if line.startswith('import ')
        for x in line[7:].split() if x=='D1Bound5' or x.startswith('D1Bound5.')]
    for d in dependencies[n]:walk(d)

walk('D1Bound5')
assert all(sha(Path(paths[n]))==h for n,h in sources.items()),'SOURCE_CHANGED_DURING_SNAPSHOT'
out=R/'integration-owned/CANONICAL_SOURCE_INVENTORY.json'
out.write_text(json.dumps({'status':'SOURCE_ONLY_PREPARED_NOT_PROOF_ACCEPTANCE',
    'root_module':'D1Bound5','source_closure':sources,'dependencies':dependencies,
    'paths':paths,'total_modules_including_root':len(sources),
    'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'main_theorem_complete':False},indent=2,sort_keys=True)+'\n')
print('CANONICAL_SOURCE_GRAPH',len(sources),'MODULES',sha(out),flush=True)
