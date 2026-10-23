from pathlib import Path
import hashlib, importlib.util, json, os, subprocess, time
O=Path(__file__).resolve().parent; R=O.parent
spec=importlib.util.spec_from_file_location('guarded',(R/'guarded_general.py')); g=importlib.util.module_from_spec(spec); spec.loader.exec_module(g)
plan=json.loads((O/'FULL_CLOSURE_AUDIT_PLAN.json').read_text())
targets=plan['targets']; sources={}
for n in targets:sources.update(g.closure(n))
artifacts={n:g.sha(g.artifact(n)) for n in sources}; external=g.external(sources)
assert g.sha(O/'FullClosureAudit.lean')==plan['source_sha256']
commands=[('closure-exact-types-axioms',[str(g.BIN/'lean'),'-j1','-DautoImplicit=false',str(O/'FullClosureAudit.lean')])]
commands += [(n+'-kernel',[str(g.BIN/'leanchecker'),'--verbose','D1Bound5.'+n]) for n in ['SmallPairPureClosure4','SmallPairPureClosureAdapter4','SmallPairGraphClosure4','SmallPairGraphArithmetic4','SmallPairLightAssembly4','SmallPairGraphTriangle4']]
rows=[]
for label,args in commands:
 start=time.monotonic()
 with (O/(label+'.log')).open('w') as f:
  p=subprocess.run(args,cwd=g.P,env=g.ENV,stdout=f,stderr=subprocess.STDOUT,timeout=240)
 row={'label':label,'command':args,'exit':p.returncode,'seconds':time.monotonic()-start};rows.append(row)
 (O/'CLOSURE_AUDIT_RESULTS.json').write_text(json.dumps(rows,indent=2)+'\n')
 print(label,p.returncode,round(row['seconds'],2),flush=True)
 assert p.returncode==0,label
 assert all(g.sha(g.src(n))==h for n,h in sources.items()),'SOURCE_CHANGED'
 assert all(g.sha(g.artifact(n))==h for n,h in artifacts.items()),'ARTIFACT_CHANGED'
 assert g.external(sources)==external,'EXTERNAL_CHANGED'
summary={'status':'SCOPED_VERIFICATION_PASS','graph':4,'closure_rows':1195,'complete_global_destinations':True,'both_mutation_signs':True,'complete_original_tails':True,'public_declarations':len(plan['names']),'preserved_original_header_count':len(plan['original_headers']),'exact_type_axiom_exit':0,'targeted_kernel_replays':len(commands)-1,'source_closure':sources,'artifact_sha256':artifacts,'external_import_artifacts':external,'lean_binary_sha256':g.sha(g.BIN/'lean'),'toolchain':'4.33.1','mathlib_commit':'0df444a360eaa60ab8c11dca51a86af692955474','graph_endpoint_complete':True,'main_theorem_complete':False}
(O/'CLOSURE_VERIFICATION_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
print('GRAPH4_CLOSURE_AND_ENDPOINT_VERIFIED',flush=True)
