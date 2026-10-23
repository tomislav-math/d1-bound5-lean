"""Compile the prepared, retained-import canonical root after full integration.

This does not publish or alter the remote root and does not run the final fresh
kernel replay. The coordinator owns that one final replay and publication.
"""
from pathlib import Path
import argparse, importlib.util, json, subprocess, sys, time
from provenance_gate import Registry

R=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('canonical_root_guards',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec)
sys.modules[spec.name]=g
spec.loader.exec_module(g)
OWN=Path(__file__).resolve().parent
ROOT=g.P/'D1Bound5.lean'

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--preflight-only',action='store_true')
    ap.add_argument('--timeout',type=int,default=900)
    a=ap.parse_args()
    O=R/'results-integration-canonical-root'
    O.mkdir(exist_ok=True)
    plan=json.loads((OWN/'ROOT_UNION_PLAN.json').read_text())
    assert g.sha(ROOT)==plan['candidate_root_sha256'],'CANONICAL_CANDIDATE_CHANGED'
    old=(OWN/'OriginalCanonicalRoot.lean').read_bytes()
    assert ROOT.read_bytes()==old+b'\nimport D1Bound5.MainTheorem\n','ORIGINAL_ROOT_IMPORTS_NOT_RETAINED'
    imports=[x for line in ROOT.read_text().splitlines() if line.startswith('import ') for x in line[7:].split()]
    assert all(x.startswith('D1Bound5.') for x in imports)
    sources={}
    for mod in imports:sources.update(g.closure(mod[9:]))
    registry=Registry(g,sources)
    provenance=registry.report(set(sources))
    g.save(O/'PREREQUISITE_PROVENANCE.json',provenance)
    preflight={'status':provenance['status'],'source_closure':sources,
        'canonical_root_sha256':g.sha(ROOT),'retained_original_root_sha256':g.sha(OWN/'OriginalCanonicalRoot.lean'),
        'original_import_lines':plan['original_import_lines'],'current_import_lines':len(imports),
        'project_dependency_modules':len(sources),'main_theorem_complete':False}
    g.save(O/'PREFLIGHT.json',preflight)
    print('CANONICAL_ROOT_PREFLIGHT',len(sources),'MODULES',provenance['status'],flush=True)
    if a.preflight_only:return
    assert provenance['status']=='PASS','CANONICAL_ROOT_PREREQUISITES_UNACCEPTED'
    integration=json.loads((R/'results-integration-final/FINAL_COMPILATION_AND_AUDIT.json').read_text())
    assert integration['status']=='COMPILED_AND_TYPE_AXIOM_AUDIT_ONLY'
    assert integration['checked_named_types']==114
    assert integration['expanded_mathematical_proposition_checked'] is True
    assert all(sources.get(n)==h for n,h in integration['source_closure'].items()),'INTEGRATION_AUDIT_SOURCE_STALE'
    assert all(g.sha(Path(p))==h for p,h in integration['artifact_parts'].items()),'INTEGRATION_AUDIT_ARTIFACT_STALE'
    assert g.sha(OWN/'FinalIntegrationAudit.lean')==integration['audit_sha256'],'INTEGRATION_AUDIT_HARNESS_CHANGED'
    assert g.external(integration['source_closure'])==integration['external_import_artifacts'],'INTEGRATION_AUDIT_EXTERNAL_STALE'
    frozen_parts={p:h for n in sources for p,h in registry.parts(n).items()}
    external=g.external(sources)
    out=g.B/'D1Bound5.olean'
    command=[str(g.BIN/'lean'),'-j1','-DautoImplicit=false','-o',str(out),str(ROOT)]
    start=time.monotonic()
    with (O/'D1Bound5.log').open('w') as log:
        run=subprocess.run(command,cwd=g.P,env=g.ENV,stdout=log,stderr=subprocess.STDOUT,timeout=a.timeout)
    receipt={**preflight,'status':'COMPILER_FINISHED_GUARDS_PENDING','command':command,
        'exit_code':run.returncode,'seconds':time.monotonic()-start,'dependency_artifact_parts':frozen_parts,
        'external_import_artifacts':external,'fresh_kernel_replay':'REQUIRED',
        'publication_status':'NOT_PUBLISHED'}
    g.save(O/'CanonicalRoot-receipt.json',receipt)
    assert run.returncode==0,'CANONICAL_ROOT_COMPILE_FAILED'
    assert g.sha(ROOT)==preflight['canonical_root_sha256'],'ROOT_SOURCE_CHANGED'
    assert all(g.sha(g.src(n))==h for n,h in sources.items()),'DEPENDENCY_SOURCE_CHANGED'
    assert all(g.sha(Path(p))==h for p,h in frozen_parts.items()),'DEPENDENCY_ARTIFACT_CHANGED'
    assert g.external(sources)==external,'EXTERNAL_ARTIFACT_CHANGED'
    assert all(g.sha(Path(r['receipt']))==r['receipt_sha256'] for r in provenance['accepted'].values()),'RECEIPT_CHANGED'
    receipt['artifact_sha256']=g.sha(out)
    receipt['status']='CANONICAL_ROOT_COMPILED_ONLY_FRESH_KERNEL_REQUIRED'
    g.save(O/'CanonicalRoot-receipt.json',receipt)
    print('CANONICAL_ROOT_COMPILED; FINAL FRESH KERNEL REPLAY STILL REQUIRED',flush=True)

if __name__=='__main__':main()
