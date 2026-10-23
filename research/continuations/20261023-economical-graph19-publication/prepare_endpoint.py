"""Scoped archive validation and path preparation. No Git mutations or scheduling."""
from pathlib import Path
import fcntl,hashlib,importlib.util,json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation'
O=R/'research/continuations'/sys.argv[1];P=R/'research/continuations'/sys.argv[2]
assert O.parent==P.parent==W.parent and O.is_dir() and P.is_dir()
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
spec=importlib.util.spec_from_file_location('pubdriver',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W)
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  assert not subprocess.check_output(['git','-C',str(R),'diff','--cached','--name-only'],text=True).strip()
  assert not json.loads(d.active_path.read_text()).get('active') and not json.loads((O/'OWNER.json').read_text())['active']
  a=json.loads((O/'VERIFICATION_SUMMARY.json').read_text());assert a['status']=='SCOPED_VERIFICATION_PASS'
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h and sha(O/'sources'/(n+'.lean'))==h for n,h in a['source_closure'].items())
  assert all(d.artifacts(n)==v for n,v in a['artifacts'].items()) and d.manifest_matches(a['configuration'])
  assert all(sha(R/n)==h for n,h in a.get('reference_files',{}).items())
  endpoint_complete=a.get('graph19_endpoint_complete',False)
  if endpoint_complete:
   inventory=json.loads((O/'CURRENT_ENDPOINT_INVENTORY.json').read_text());state_path=O/'ENDPOINT_PROOF_STATE.json';state=json.loads(state_path.read_text())
   assert inventory['expected_transition_matches'] and inventory['added_endpoints']==[19] and inventory['accepted_endpoint_count']==35 and inventory['total_endpoints']==48
   assert inventory['graph19_endpoint_proof_state_sha256']==sha(state_path) and state['collector_sha256']==sha(W.parent/'20261023-economical-graph19-closure-reuse/collect_endpoint.py')
   assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in state['verified_sources'].items()) and d.manifest_matches(state['verified_artifacts']) and d.manifest_matches(state['configuration'])
   assert len(state['scope_records'])==14
   for short,row in state['scope_records'].items():
    folder=W.parent/('20261023-economical-graph19-'+short)
    assert sha(folder/'VERIFICATION_SUMMARY.json')==row['summary_sha256'] and sha(folder/'AUDIT_RESULTS.json')==row['audit_results_sha256']
    assert all(sha(path)==h for path,h in row['audit_input_sha256'].items())
   latest=d.latest();current=[]
   for number in range(1,49):
    n='SmallPairGraphData'+str(number);c=d.closure(n);expected=d.expected_manifest(n,m.fingerprint(c),latest)
    if expected and d.artifacts(n)==expected:current.append(number)
   assert current==inventory['current_accepted_endpoints']
  handoff=R/'records/PRO_CONTINUATION_HANDOFF.md'
  assert '34/48 finite graph endpoints' in handoff.read_text()
  scope=a.get('scope_description',f"graph19 closure witness rows {a['start_offset']}..{a['start_offset']+a['heads']-1} over the complete {a['global_closure_vertices']}-vertex list" if a.get('global_closure_vertices') else f"graph19 LEFT heads {a['start_offset']}..{a['start_offset']+a['heads']-1}, complete original tails")
  entry=f"\nLatest checked archive: {O.name}. {scope}.\nGuarded builds, exact-type/transitive-axiom audit and {a['targeted_kernel_replays']} targeted installed-kernel replays passed.\nGraph19 endpoint remains incomplete; current endpoint inventory remains31/48. MainTheorem UNPROVED, root integration unverified.\n"
  assert 'Latest checked archive: '+O.name not in handoff.read_text()
  if endpoint_complete:
   handoff.write_text("# Current D1 formalization handoff\n\nMainTheorem UNPROVED. Canonical-root integration and a pinned clean-checkout build remain unverified.\n35/48 finite graph endpoints are verified working endpoints; 13 remain.\nAuthoritative inventory: research/continuations/20261023-economical-graph19-assembly/CURRENT_ENDPOINT_INVENTORY.json.\nGraph19 endpoint proof state: the same folder's ENDPOINT_PROOF_STATE.json.\n\nGraph19 now has both light-side certificates, all 893 indexed closure witness rows, mandatory full coverage,\nand its original arithmetic/assembly/triangle endpoint declarations checked. The original 28 public\ndeclarations (13 definitions and 15 theorems), complete vertex lists, both mutation signs, and global\ndestination indices are preserved. Exact-type/transitive-axiom audits and scoped installed-kernel\nreplays are recorded in 14 scopes; their exact fingerprints and current artifacts were reconciled.\nThe import facades and 16 adaptive aliases are explicitly distinguished from fresh proof-module replays.\n\nSource archives are under research/continuations/20261023-economical-graph19-*. Canonical proof sources\nremain working-tree artifacts until integrated-root review; the 110-source accepted root manifest is unchanged.\nGraph7's previous endpoint inventory and all failed/prepared records remain preserved.\n\nNext: remaining finite endpoints, then SmallPairGraphs, bounded extensions/TwoSmallSextuple, two-small bounds,\nTwoSmallNondegenerateImpossible and MainTheorem. Reuse verified OneSmallReducedImpossible and OneSmallImpossible.\nA clean-checkout pinned build, original-type/axiom review, and integrated-root kernel replay remain required.\nPreserve the full original theorem over O_K of every imaginary quadratic field, including half-integral bases,\ntied moduli, zero pair-square roots, and distinct nonzero elements.\n\nWorking practice: economize Work-mode tokens, reuse exact matching successful evidence, one compiler, and\nexplicit bounded proof units with regular private Git publication. The Chat hourly task keeps its original\nprompt and is PAUSED BY THE USER; do not resume or edit it without direction.\n\nGraph19 Cached data modules use `set_option compiler.extract_closed false` based on verified Graph5 recovery.\nOriginal declaration header and literal body bytes are unchanged; guarded build, exact-type/axiom audit and\ninstalled-kernel replay passed. No Graph19 timeout is claimed; the original model is (tau,nu)=(1,1). Reuse existing matching PASS artifacts.\n")
  else:handoff.write_text(handoff.read_text()+entry)
  paths=[handoff]+list(Path(__file__).resolve().parent.glob('*.py'))+[p for p in O.rglob('*') if p.is_file() and p.name not in {'PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','INDEX_REVIEW.json','POST_PUSH_RECEIPT.json'}]+[P/n for n in ['PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','POST_PUSH_RECEIPT.json','INDEX_REVIEW.json'] if (P/n).exists()]
  for folder in ['20261023-graph19-closure','20261023-economical-graph19-closure-reuse','20261023-economical-graph19-parent-proposal','20261023-economical-graph19-right-pilot12']:
   paths += [p for p in (W.parent/folder).rglob('*') if p.is_file()]
  paths=sorted(set(str(p.relative_to(R)) for p in paths));assert not any('__pycache__' in x for x in paths)
  (O/'PUBLICATION_PATHS.txt').write_text('\n'.join(paths)+'\n');(O/'PUBLICATION_HASHES.json').write_text(json.dumps({p:sha(R/p) for p in paths},indent=2,sort_keys=True)+'\n')
  print(json.dumps({'status':'PUBLICATION_SCOPE_VALIDATED','paths':len(paths),'heads':a['heads'],'kernel_replays':a['targeted_kernel_replays']}))
