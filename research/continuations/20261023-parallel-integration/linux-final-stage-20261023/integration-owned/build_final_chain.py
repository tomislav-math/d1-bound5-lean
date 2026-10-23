"""Final integration only; run after all graph and analytic prerequisites exist.

This runner neither downloads nor rebuilds prerequisites and never changes source.
It records compilation and type/axiom audit evidence, leaving the independent
fresh-kernel gate and repository publication to the root coordinator.
"""
from pathlib import Path
import argparse, importlib.util, json, subprocess, sys, time
from provenance_gate import Registry

R=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('integration_final_guards',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec)
sys.modules[spec.name]=g
spec.loader.exec_module(g)
FINAL=['SmallPairGraphs','SmallPairRepresentativeProperties','SmallPairOrbitProperties',
       'SmallPairBoundedExtensions','TwoSmallSextuple','TwoSmallNondegenerateImpossible','MainTheorem']
ROWS=[x[9:] for x in g.imports('SmallPairGraphs') if x.startswith('D1Bound5.')]
TARGETS=ROWS+FINAL
AUDIT=Path(__file__).resolve().parent/'FinalIntegrationAudit.lean'

def parts(names):
    result={}
    for name in names:
        base=g.artifact(name)
        assert base.exists(),f'MISSING_ARTIFACT {name}'
        for p in [base,Path(str(base)+'.server'),Path(str(base)+'.private')]:
            if p.exists():result[str(p)]=g.sha(p)
    return result

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--out',default='results-integration-final')
    ap.add_argument('--timeout',type=int,default=900)
    ap.add_argument('--preflight-only',action='store_true')
    a=ap.parse_args()
    O=R/a.out
    O.mkdir(exist_ok=True)
    frozen=g.closure('MainTheorem')
    missing=sorted(n for n in frozen if n not in TARGETS and not g.artifact(n).exists())
    preflight={'status':'PREFLIGHT_ONLY','closure_modules':len(frozen),
        'source_closure':frozen,'ordered_targets':TARGETS,'missing_prerequisites':missing,
        'audit_sha256':g.sha(AUDIT),'main_theorem_complete':False}
    g.save(O/'PREFLIGHT.json',preflight)
    print('FINAL_PREFLIGHT',len(frozen),'MODULES',len(missing),'MISSING_PREREQUISITES',flush=True)
    registry=Registry(g,frozen)
    provenance=registry.report(set(frozen)-set(TARGETS))
    g.save(O/'PREREQUISITE_PROVENANCE.json',provenance)
    print('PREREQUISITE_PROVENANCE',provenance['status'],len(provenance['accepted']),
          'ACCEPTED',len(provenance['rejected']),'REJECTED',flush=True)
    if a.preflight_only:return
    assert not missing,'PREREQUISITES_INCOMPLETE '+repr(missing[:30])
    assert provenance['status']=='PASS','PREREQUISITE_PROVENANCE_INCOMPLETE'
    original_parts=parts(set(frozen)-set(TARGETS))
    g.save(O/'PREREQUISITE_ARTIFACT_PARTS.json',original_parts)
    built,reused=[],[]
    for n in TARGETS:
        assert g.closure('MainTheorem')==frozen,'GLOBAL_SOURCE_CHANGED_BEFORE '+n
        if registry.validate(n):
            reused.append(n)
            print(n,'REUSED_CURRENT_ACCEPTED_RECEIPT',flush=True)
            continue
        result=g.build(n,O,a.timeout)
        assert result['proof_status']=='COMPILED_ONLY','COMPILE_FAILED '+n
        built.append(n)
        registry.rejected.pop(n,None)
        registry.candidates.setdefault(n,[]).insert(0,(O/(n+'-receipt.json'),result))
        assert registry.validate(n),'NEW_TARGET_RECEIPT_DID_NOT_VALIDATE '+n
    g.save(O/'TARGET_COMPILATION_PROVENANCE.json',{'built':built,'reused':reused,
        'accepted':{n:registry.selected[n] for n in TARGETS}})
    all_parts=parts(frozen)
    g.save(O/'FINAL_ARTIFACT_PARTS.json',all_parts)
    external_artifacts=g.external(frozen)
    audit_hash=g.sha(AUDIT)
    command=[str(g.BIN/'lean'),'-j1','-DautoImplicit=false',str(AUDIT)]
    start=time.monotonic()
    with (O/'FinalIntegrationAudit.log').open('w') as log:
        run=subprocess.run(command,cwd=g.P,env=g.ENV,stdout=log,
                           stderr=subprocess.STDOUT,timeout=a.timeout)
    log=(O/'FinalIntegrationAudit.log').read_text()
    row={'command':command,'exit_code':run.returncode,'seconds':time.monotonic()-start,
         'audit_sha256':audit_hash,'checked_named_types':log.count('ORIGINAL_TYPE_AXIOMS_PASS'),
         'newly_compiled_targets':built,'reused_current_accepted_targets':reused,
         'expanded_mathematical_proposition_checked':run.returncode==0,
         'source_closure':frozen,'artifact_parts':all_parts,
         'external_import_artifacts':external_artifacts,
         'status':'AUDIT_FINISHED_GUARDS_PENDING','main_theorem_complete':False,
         'independent_fresh_kernel_gate':'REQUIRED'}
    g.save(O/'FINAL_COMPILATION_AND_AUDIT.json',row)
    assert run.returncode==0,'FINAL_AUDIT_FAILED'
    assert row['checked_named_types']==114,'WRONG_AUDIT_MARKER_COUNT'
    assert g.sha(AUDIT)==audit_hash,'AUDIT_SOURCE_CHANGED'
    assert g.closure('MainTheorem')==frozen,'GLOBAL_SOURCE_CHANGED'
    assert parts(frozen)==all_parts,'ARTIFACT_PART_CHANGED'
    assert g.external(frozen)==external_artifacts,'EXTERNAL_IMPORT_CHANGED'
    assert all(all_parts.get(p)==h for p,h in original_parts.items()),'PREREQUISITE_CHANGED'
    assert all(g.sha(Path(r['receipt']))==r['receipt_sha256'] for r in provenance['accepted'].values()),'PREREQUISITE_RECEIPT_CHANGED'
    assert all(g.sha(Path(p))==h for p,h in provenance['historical_export_manifests'].items()),'HISTORICAL_EXPORT_CHANGED'
    assert g.sha(g.R/'RUNTIME_SETUP.json')==provenance['runtime_setup_sha256'],'RUNTIME_SETUP_CHANGED'
    row['status']='COMPILED_AND_TYPE_AXIOM_AUDIT_ONLY'
    row['all_post_audit_source_and_artifact_guards_passed']=True
    g.save(O/'FINAL_COMPILATION_AND_AUDIT.json',row)
    print('FINAL_COMPILATION_AND_EXACT_TYPE_AXIOM_AUDIT_PASS; INDEPENDENT FRESH KERNEL GATE STILL REQUIRED',flush=True)

if __name__=='__main__':main()
