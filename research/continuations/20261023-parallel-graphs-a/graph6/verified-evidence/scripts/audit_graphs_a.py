#!/usr/bin/env python3
"""Exact original types, strict axioms, and endpoint kernel replay for owned graphs."""
from pathlib import Path
import importlib.util, json, subprocess, time, sys
R=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('guarded',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
G=int(sys.argv[1]);assert G in [6,8,10]
O=R/f'graph{G}-owned'
sizes={6:[658,657],8:[716,718],10:[596,596]}
closure_plan=json.loads((O/'PURE_CLOSURE_PLAN.json').read_text())
for scope in ['LIGHT','CLOSURE']:
    plan=json.loads((O/f'FULL_{scope}_AUDIT_PLAN.json').read_text())
    audit=O/('FullLightAudit.lean' if scope=='LIGHT' else 'FullClosureAudit.lean')
    assert g.sha(audit)==plan['source_sha256']
    sources={}
    for n in plan['targets']:sources.update(g.closure(n))
    artifacts={n:g.sha(g.artifact(n)) for n in sources};external=g.external(sources)
    kernels=([f'SmallPairLightLeft{G}',f'SmallPairLightRight{G}'] if scope=='LIGHT' else
      [f'SmallPairPureClosure{G}',f'SmallPairPureClosureAdapter{G}',f'SmallPairGraphClosure{G}',
       f'SmallPairGraphArithmetic{G}',f'SmallPairLightAssembly{G}',f'SmallPairGraphTriangle{G}',f'SmallPairGraphData{G}'])
    commands=[(scope.lower()+'-exact-types-axioms',[str(g.BIN/'lean'),'-j1','-DautoImplicit=false',str(audit)])]
    commands += [(n+'-kernel',[str(g.BIN/'leanchecker'),'--verbose','D1Bound5.'+n]) for n in kernels]
    rows=[]
    for label,args in commands:
        assert all(g.sha(g.src(n))==h for n,h in sources.items()),'SOURCE_CHANGED_BEFORE'
        assert all(g.sha(g.artifact(n))==h for n,h in artifacts.items()),'ARTIFACT_CHANGED_BEFORE'
        assert g.external(sources)==external,'EXTERNAL_CHANGED_BEFORE'
        start=time.monotonic();log=O/(label+'.log')
        with log.open('w') as f:
            p=subprocess.run(args,cwd=g.P,env=g.ENV,stdout=f,stderr=subprocess.STDOUT,timeout=300)
        row={'label':label,'command':args,'exit':p.returncode,'seconds':time.monotonic()-start,'log_sha256':g.sha(log)};rows.append(row)
        g.save(O/(scope+'_AUDIT_RESULTS.json'),rows)
        print(G,label,p.returncode,round(row['seconds'],2),flush=True)
        assert p.returncode==0,label
        if 'exact-types-axioms' in label:
            text=log.read_text();assert text.count('TYPE_AXIOMS_PASS ')==len(plan['names']),'AXIOM_OUTPUT_COUNT'
            assert 'sorry' not in text and 'Unexpected axioms' not in text,'FORBIDDEN_AXIOM'
        assert all(g.sha(g.src(n))==h for n,h in sources.items()),'SOURCE_CHANGED_AFTER'
        assert all(g.sha(g.artifact(n))==h for n,h in artifacts.items()),'ARTIFACT_CHANGED_AFTER'
        assert g.external(sources)==external,'EXTERNAL_CHANGED_AFTER'
    summary={'status':'SCOPED_VERIFICATION_PASS','graph':G,'scope':scope,
      'public_declarations':len(plan['names']),'preserved_original_header_count':len(plan['original_headers']),
      'exact_type_axiom_exit':0,'targeted_kernel_replays':len(kernels),
      'source_closure':sources,'artifact_sha256':artifacts,'external_import_artifacts':external,
      'lean_binary_sha256':g.sha(g.BIN/'lean'),'leanchecker_binary_sha256':g.sha(g.BIN/'leanchecker'),
      'toolchain':'4.33.1','mathlib_commit':'0df444a360eaa60ab8c11dca51a86af692955474',
      'complete_original_tails':True,'graph_endpoint_complete':scope=='CLOSURE','main_theorem_complete':False}
    if scope=='LIGHT':summary.update(complete_light_side_certificates=2,original_vertices=sizes[G])
    else:summary.update(closure_rows=closure_plan['rows'],complete_global_destinations=True,both_mutation_signs=True,
      original_closure_replacement_sha256=g.sha(g.src(f'SmallPairGraphClosure{G}')))
    g.save(O/('VERIFICATION_SUMMARY.json' if scope=='LIGHT' else 'CLOSURE_VERIFICATION_SUMMARY.json'),summary)
print(f'GRAPH{G}_ENDPOINT_VERIFIED',flush=True)
