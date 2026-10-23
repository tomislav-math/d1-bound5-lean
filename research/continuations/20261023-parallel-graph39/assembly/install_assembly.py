"""Install reviewed graph39 assembly only after the closure unit is verified."""
from pathlib import Path
import hashlib,importlib.util,json,sys
R=Path('/Users/tp/Lean/D1Bound5');O=Path(__file__).resolve().parent
W=R/'research/continuations/20261018T010800CEST-main-continuation';P=R/'research/continuations/20261023-graph39-closure/proposal'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
q=json.loads((P/'PLAN.json').read_text());prior=json.loads((O.parent/'VERIFICATION_SUMMARY.json').read_text())
assert prior['status']=='SCOPED_VERIFICATION_PASS' and prior['all_closure_rows']==915
assert not json.loads((O.parent/'OWNER.json').read_text())['active']
assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in prior['source_closure'].items())
assert sha(W/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_guarded_install',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W)
assert d.manifest_matches(prior['configuration']) and all(d.artifacts(n)==a for n,a in prior['artifacts'].items())
targets=json.loads((O/'targets.json').read_text());assert targets==q['scopes']['assembly']
changes=json.loads((O/'DECLARATION_MODIFIER_CHANGES.json').read_text())
assert sha(R/'D1Bound5/SmallPairGraphData39.lean')==q['original_merged_sha256']
for n in targets:
 p=O/'prepared_sources'/(n+'.lean');s=p.read_bytes();h=sha(p)
 assert h==(changes[n]['new_sha256'] if n in changes else q['source_manifest'][n])
 t=R/'D1Bound5'/(n+'.lean');assert n=='SmallPairGraphData39' or not t.exists() or t.read_bytes()==s
(O/'SmallPairGraphData39.merged.before.lean').write_bytes((R/'D1Bound5/SmallPairGraphData39.lean').read_bytes())
for n in targets:(R/'D1Bound5'/(n+'.lean')).write_bytes((O/'prepared_sources'/(n+'.lean')).read_bytes())
(O/'INSTALL_RECEIPT.json').write_text(json.dumps({'utc':m.utc(),'targets':targets,'original_merged_sha256':q['original_merged_sha256'],'modifier_only_changes':changes,'source_manifest':{n:sha(R/'D1Bound5'/(n+'.lean')) for n in targets},'status':'INSTALLED_NOT_YET_COMPILED'},indent=2)+'\n')
print('INSTALLED_GRAPH39_ASSEMBLY',len(targets))
