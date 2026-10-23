#!/usr/bin/env python3
"""Use the released closure lane for sequential joins and audits; never exceed one lane."""
from pathlib import Path
import importlib.util,json,subprocess,time
R=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('guarded',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
def read(p):
    try:return json.loads(p.read_text())
    except (FileNotFoundError,json.JSONDecodeError):return {}
def finished(n):
    p=g.artifact(n)
    if not p.exists():return False
    for d in R.glob('results-*'):
        if not d.is_dir():continue
        row=read(d/(n+'-receipt.json'))
        if row.get('proof_status')!='COMPILED_ONLY':continue
        if row.get('artifact_sha256')!=g.sha(p) or row.get('source_closure')!=g.closure(n):continue
        if any(not g.artifact(x).exists() or g.sha(g.artifact(x))!=h for x,h in row.get('dependency_artifacts',{}).items()):continue
        if 'external_import_artifacts' in row and row['external_import_artifacts']!=g.external(row['source_closure']):continue
        return True
    return False
p=R/'results-graphs-a-other-closure/SUMMARY.json'
while 'uncompiled' not in (s:=read(p)):
    assert not s.get('failed'),'PURE_CLOSURE_FAILURE'
    time.sleep(10)
assert not s['failed'] and not s['uncompiled'],'PURE_CLOSURE_INCOMPLETE'
print('PURE_CLOSURE_LANE_RELEASED',flush=True)
for G in [10,6,8]:
    plan=read(R/f'graph{G}-plan.json')
    required=[n for n in plan['data'] if n!=f'SmallPairLightAdaptiveData{G}']+[p['module'] for p in plan['parts']]
    while True:
        s=read(R/'results-graphs-a-other-numeric/SUMMARY.json');assert not s.get('failed'),'NUMERIC_FAILURE'
        pending=[n for n in required if not finished(n)]
        if not pending:break
        print('WAIT_NUMERIC',G,len(pending),flush=True);time.sleep(15)
    out=f'results-graph{G}-endpoint'
    p=subprocess.run(['python3',str(R/'guarded_general.py'),'--targets',f'SmallPairGraphData{G}','--out',out,'--jobs','1'],cwd=R)
    assert p.returncode==0
    s=read(R/out/'SUMMARY.json');assert not s['failed'] and not s['uncompiled'],'ENDPOINT_BUILD_FAILED'
    p=subprocess.run(['python3',str(R/'audit_graphs_a.py'),str(G)],cwd=R)
    assert p.returncode==0,'ENDPOINT_AUDIT_FAILED'
print('ALL_GRAPHS_A_ENDPOINTS_VERIFIED',flush=True)
