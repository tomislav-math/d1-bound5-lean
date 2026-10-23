#!/usr/bin/env python3
"""Exact source types, transitive axioms, and installed-kernel replay for graph15 pure light units."""
import pathlib, re, json, hashlib, time, subprocess, os
R=pathlib.Path(__file__).resolve().parent;P=R/'project';O=R/'results-graph15-pure-audit';O.mkdir(exist_ok=True)
env=os.environ.copy();env.update(json.loads((R/'lean-env.json').read_text()));BIN=R/'lean-4.33.1-linux/bin'
plan=json.loads((R/'graph15-plan.json').read_text());mods=plan['pure_init_targets'];names=[];headers=[]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True))
source={n:sha(P/'D1Bound5'/(n+'.lean')) for n in mods};art={n:sha(P/'.lake/build/lib/lean/D1Bound5'/(n+'.olean')) for n in mods}
assert all(source[n]==plan['source_manifest'][n] for n in mods)
audit=''.join('import D1Bound5.'+n+'\n' for n in mods)+'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\nnoncomputable section\n'
for n in mods:
    s=(P/'D1Bound5'/(n+'.lean')).read_text();nm=re.search(r'^namespace (\S+)',s,re.M)
    if nm is None:
        assert not re.search(r'^(?:noncomputable )?(def|theorem) ',s,re.M)
        continue
    ns=nm.group(1)
    for m in re.finditer(r'^(?:noncomputable )?(def|theorem) ([A-Za-z0-9_]+)\s*(:[\s\S]*?)\s*:=',s,re.M):
        kind,name,ty=m.groups();assert '\ndef ' not in ty and '\ntheorem ' not in ty,(n,name)
        qn=ns+'.'+name;names.append(qn);headers.append({'module':n,'name':qn,'source_type':ty})
        audit+='namespace '+ns+'\nexample '+ty+' := '+name+'\nend '+ns+'\n'
audit+='run_cmd do\n  for name in (['+', '.join('`'+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
(O/'ExactTypesAxioms.lean').write_text(audit);save(O/'DECLARATION_TYPES.json',headers)
rows=[]
commands=[('exact-types-axioms',[str(BIN/'lean'),'-j1','-DautoImplicit=false',str(O/'ExactTypesAxioms.lean')])]+[(n+'-kernel',[str(BIN/'leanchecker'),'--verbose','D1Bound5.'+n]) for n in mods]
for label,cmd in commands:
    t=time.time()
    with (O/(label+'.log')).open('w') as log:
        proc=subprocess.run(cmd,cwd=P,env=env,stdout=log,stderr=subprocess.STDOUT,timeout=240)
    row={'label':label,'command':cmd,'exit_code':proc.returncode,'seconds':time.time()-t};rows.append(row);save(O/'AUDIT_RESULTS.json',rows)
    assert source=={n:sha(P/'D1Bound5'/(n+'.lean')) for n in mods}
    assert art=={n:sha(P/'.lake/build/lib/lean/D1Bound5'/(n+'.olean')) for n in mods}
    print(label,proc.returncode,round(row['seconds'],2),flush=True)
    if proc.returncode:raise SystemExit(proc.returncode)
save(O/'VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','scope':'Graph15 pure-Init light data, exact original validation declarations, and complete-head arithmetic leaf certificates only. Parent joins, mutation closure, full-ring endpoint and final theorem are outside this audit.','modules':mods,'exact_source_type_examples':len(names),'transitive_axiom_audits':len(names),'kernel_replays':len(mods),'source_manifest':source,'artifact_manifest':art,'allowed_axioms':['propext','Classical.choice','Quot.sound'],'runtime_setup_sha256':sha(R/'RUNTIME_SETUP.json'),'graph15_endpoint_complete':False,'main_theorem_complete':False})
