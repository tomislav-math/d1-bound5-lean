#!/usr/bin/env python3
"""Audit owned graph23/30 exact original types, transitive axioms, and milestone kernels."""
import argparse, concurrent.futures, hashlib, json, os, pathlib, re, subprocess, time
import guarded_general as G
R=pathlib.Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,obj):
    t=p.with_suffix('.tmp');t.write_text(json.dumps(obj,indent=2,sort_keys=True)+'\n');t.replace(p)
def audit(g,timeout):
    assert g in (23,30)
    O=R/f'results-graph{g}-full-audit';O.mkdir(exist_ok=True)
    p=json.loads((R/f'graph{g}-plan.json').read_text())
    q=json.loads((R/f'graph{g}-pure-closure-plan.json').read_text())
    ap=json.loads((R/f'graph{g}-AUDIT_PLAN.json').read_text())
    af=R/f'graph{g}-OriginalTypesAxioms.lean'
    assert sha(af)==ap['audit_sha256'] and ap['required_closure_backend']=='pure'
    removed={n for n in p['source_manifest'] if re.fullmatch(f'SmallPairGraphClosure{g}Chunk[0-9]+',n)}
    manifest={n:h for n,h in p['source_manifest'].items() if n not in removed}
    manifest.update(q['source_manifest'])
    manifest[f'SmallPairGraphClosure{g}']=sha(R/f'graph{g}-ORIGINAL_CLOSURE_REPLACEMENT.lean')
    assert all(sha(G.src(n))==h for n,h in manifest.items()),'PLANNED_SOURCE_MISMATCH'
    endpoint=f'SmallPairGraphData{g}';sc=G.closure(endpoint)
    assert set(manifest)<=set(sc),'UNREACHABLE_PLANNED_MODULES '+str(set(manifest)-set(sc))
    artifacts={n:sha(G.artifact(n)) for n in sc};ext=G.external(sc)
    def guard():
        assert G.closure(endpoint)==sc,'SOURCE_CHANGED'
        assert {n:sha(G.artifact(n)) for n in sc}==artifacts,'ARTIFACT_CHANGED'
        assert G.external(sc)==ext,'EXTERNAL_CHANGED'
        assert sha(af)==ap['audit_sha256'],'AUDIT_CHANGED'
    guard()
    (O/'OriginalTypesAxioms.lean').write_bytes(af.read_bytes())
    (O/'AUDIT_PLAN.json').write_bytes((R/f'graph{g}-AUDIT_PLAN.json').read_bytes())
    (O/'ORIGINAL_TYPE_DECLARATIONS.json').write_bytes((R/f'graph{g}-ORIGINAL_TYPE_DECLARATIONS.json').read_bytes())
    save(O/'FROZEN_INPUTS.json',{'source_closure':sc,'artifact_closure':artifacts,'external_import_artifacts':ext,'planned_modules':manifest,
      'auditor_source_sha256':sha(pathlib.Path(__file__)), 'source_guard_helper_sha256':sha(R/'guarded_general.py'),
      'lean_binary_sha256':sha(G.BIN/'lean'),'leanchecker_binary_sha256':sha(G.BIN/'leanchecker'),
      'runtime_setup_sha256':sha(R/'RUNTIME_SETUP.json'),'runtime_environment_sha256':sha(R/'lean-env.json'),
      'proc_path_compat_sha256':sha(R/'proc_self_exe_compat.so'),'toolchain':'4.33.1',
      'mathlib_commit':'0df444a360eaa60ab8c11dca51a86af692955474'})
    modules=[f'SmallPairLightAdaptive{side}{g}_{i:03}' for side in ['Left','Right'] for i in range(3)]
    modules += [f'SmallPairLightLeft{g}',f'SmallPairLightRight{g}',f'SmallPairPureClosure{g}',
      f'SmallPairPureClosureAdapter{g}',f'SmallPairGraphClosure{g}',f'SmallPairGraphTriangle{g}',endpoint]
    assert len(modules)==13 and set(modules)<=set(manifest)
    commands=[('original-types-axioms',[str(G.BIN/'lean'),'-j1','-DautoImplicit=false',str(af)])]
    commands += [(n+'-kernel',[str(G.BIN/'leanchecker'),'--verbose','D1Bound5.'+n]) for n in modules]
    rows=[]
    for label,cmd in commands:
        guard();t=time.time()
        row={'label':label,'command':cmd,'utc_start':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'exit_code':None}
        with (O/(label+'.log')).open('w') as log:
            try:row['exit_code']=subprocess.run(cmd,cwd=G.P,env=G.ENV,stdout=log,stderr=subprocess.STDOUT,timeout=timeout).returncode
            except subprocess.TimeoutExpired:row['timeout']=True
        row['seconds']=time.time()-t;rows.append(row);save(O/'AUDIT_RESULTS.json',rows)
        guard();print(g,label,row['exit_code'],round(row['seconds'],2),flush=True)
        if row['exit_code']!=0:
            save(O/'VERIFICATION_SUMMARY.json',{'status':'FAILED_OR_TIMED_OUT','graph':g,'failed':row,'main_theorem_complete':False})
            return False
        if label=='original-types-axioms':
            assert (O/(label+'.log')).read_text().count('TYPE_AXIOMS_PASS ')==ap['axiom_checks'],'AXIOM_AUDIT_COUNT_MISMATCH'
    guard()
    save(O/'VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','graph':g,'scope':f'Complete graph{g} certificate endpoint with unchanged original public types, mandatory coverage, both mutation signs and all global destinations; excludes full-ring wrapper and final main theorem.',
      'endpoint':endpoint,'planned_module_count':len(manifest),'original_exact_type_examples':ap['original_type_checks'],
      'transitive_axiom_checks':ap['axiom_checks'],'kernel_replays':len(modules),'allowed_axioms':['propext','Classical.choice','Quot.sound'],
      'frozen_inputs_sha256':sha(O/'FROZEN_INPUTS.json'),'audit_source_sha256':sha(af),'graph_certificate_complete':True,
      'full_ring_wrapper_complete':False,'main_theorem_complete':False})
    return True
if __name__=='__main__':
    a=argparse.ArgumentParser();a.add_argument('--graphs',type=int,nargs='+',default=[23,30]);a.add_argument('--jobs',type=int,default=1);a.add_argument('--timeout',type=int,default=240);args=a.parse_args()
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as pool:
        results=list(pool.map(lambda g:audit(g,args.timeout),args.graphs))
    raise SystemExit(0 if all(results) else 1)
