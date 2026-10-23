"""Exercise rejection paths using copied receipts; never mutate proof artifacts."""
from pathlib import Path
import copy, importlib.util, json, sys
from provenance_gate import Registry

R=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('provenance_gate_checks',R/'guarded_general.py')
g=importlib.util.module_from_spec(spec)
sys.modules[spec.name]=g
spec.loader.exec_module(g)
n='SmallPairGraphFullRing4'
sc=g.closure(n)
registry=Registry(g,sc)
assert registry.report(set(sc))['status']=='PASS'
receipt_path=R/'results-integration-fullring'/(n+'-receipt.json')
original=json.loads(receipt_path.read_text())
checks=[]

def rejected(label,change):
    row=copy.deepcopy(original)
    change(row)
    try:registry.validate_row(n,row)
    except AssertionError as exc:checks.append({'test':label,'result':'REJECTED_AS_REQUIRED','reason':str(exc)})
    else:raise AssertionError('INVALID_RECEIPT_ACCEPTED '+label)

rejected('running receipt',lambda r:r.update(proof_status='RUNNING'))
rejected('failed receipt',lambda r:r.update(proof_status='FAILED',exit_code=1))
rejected('wrong artifact bytes',lambda r:r.update(artifact_sha256='0'*64))
rejected('wrong source closure',lambda r:r['source_closure'].update(Basic='0'*64))
rejected('missing dependency guard',lambda r:r['dependency_artifacts'].pop('Basic'))
rejected('wrong external bytes',lambda r:next(iter(r['external_import_artifacts'].values())).update(sha256='0'*64))
rejected('unrecognized compiler',lambda r:r['command'].__setitem__(0,'/tmp/unrecognized-lean'))
missing_dependency=Registry(g,sc)
missing_dependency.candidates.pop('Basic')
assert missing_dependency.validate(n) is False,'DEPENDENCY_EXISTENCE_ACCEPTED_WITHOUT_RECEIPT'
checks.append({'test':'existing dependency artifact without acceptance receipt','result':'REJECTED_AS_REQUIRED'})
report={'status':'PROVENANCE_REJECTION_CHECKS_PASS','positive_control':'CURRENT_FULL_RING4_CLOSURE_ACCEPTED',
        'checks':checks,'production_sources_or_artifacts_modified':False}
g.save(R/'integration-owned/PROVENANCE_GATE_CHECKS.json',report)
print(json.dumps(report,indent=2))
