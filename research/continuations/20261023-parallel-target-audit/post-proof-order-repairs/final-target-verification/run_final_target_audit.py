#!/usr/bin/env python3
"""Independent exact mathematical target/axiom gate after MainTheorem compilation."""
import hashlib,json,pathlib,subprocess,time
import guarded_general as G
R=pathlib.Path(__file__).resolve().parent;O=R/'final-target-verification'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def main():
    O.mkdir(exist_ok=True)
    audit=R/'FinalTargetAudit.lean';assert sha(audit)=='b21a0deae156faabd97ad38e87920a5f9f16700cad843c3e38e040c90aaa61d7'
    sc=G.closure('MainTheorem')
    prior=json.loads((R/'target-source-audit-final/SOURCE_MANIFEST.json').read_text())
    assert sc=={n.removeprefix('D1Bound5.'):row['sha256'] for n,row in prior.items()},'FINAL_SOURCE_MANIFEST_CHANGED_RESCAN_REQUIRED'
    art={n:sha(G.artifact(n)) for n in sc};ext=G.external(sc)
    def guard():
        assert G.closure('MainTheorem')==sc,'SOURCE_CHANGED'
        assert {n:sha(G.artifact(n)) for n in sc}==art,'ARTIFACT_CHANGED'
        assert G.external(sc)==ext,'EXTERNAL_IMPORT_CHANGED'
        assert sha(audit)=='b21a0deae156faabd97ad38e87920a5f9f16700cad843c3e38e040c90aaa61d7','AUDIT_CHANGED'
    guard()
    save(O/'FROZEN_INPUTS.json',{'sources':sc,'artifacts':art,'external_import_artifacts':ext,
      'runner_sha256':sha(pathlib.Path(__file__)),'harness_sha256':sha(audit),'lean_binary_sha256':sha(G.BIN/'lean'),
      'runtime_setup_sha256':sha(R/'RUNTIME_SETUP.json'),'environment_sha256':sha(R/'lean-env.json'),
      'source_audit_sha256':sha(R/'target-source-audit-final/SOURCE_AUDIT_REVIEWED.json')})
    (O/'FinalTargetAudit.lean').write_bytes(audit.read_bytes());start=time.time()
    cmd=[str(G.BIN/'lean'),'-j1','-DautoImplicit=false',str(audit)]
    with (O/'FinalTargetAudit.log').open('w') as log:
        p=subprocess.run(cmd,cwd=G.P,env=G.ENV,stdout=log,stderr=subprocess.STDOUT,timeout=300)
    guard();log=(O/'FinalTargetAudit.log').read_text();count=log.count('FINAL_TARGET_AXIOMS_PASS ')
    ok=p.returncode==0 and count==4
    save(O/'VERIFICATION_SUMMARY.json',{'status':'FINAL_TARGET_EXACT_STATEMENT_AND_AXIOMS_PASS' if ok else 'FAILED',
      'command':cmd,'exit_code':p.returncode,'seconds':time.time()-start,'source_module_count':len(sc),
      'mathematical_target_expansion_examples':2,'strict_transitive_axiom_checks':count,
      'allowed_axioms':['propext','Classical.choice','Quot.sound'],
      'target':'Every degree-two totally complex number field; finite sets in its full ring of integers; all entries nonzero, all distinct pairs have a square product-plus-one, roots may be zero; card at most five.',
      'extra_mathematical_premises':[],'global_acceptance_decision_deferred_to_root':True,
      'frozen_inputs_sha256':sha(O/'FROZEN_INPUTS.json'),'harness_sha256':sha(audit)})
    print('FINAL_TARGET_AUDIT',p.returncode,count,round(time.time()-start,2),flush=True)
    raise SystemExit(0 if ok else 1)
if __name__=='__main__':main()
