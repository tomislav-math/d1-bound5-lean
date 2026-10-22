"""Validate a scoped checked archive and prepare explicit publication manifests. No Git mutation."""
from pathlib import Path
import fcntl,hashlib,importlib.util,json,subprocess,sys
R=Path('/Users/tp/Lean/D1Bound5');O=Path(__file__).resolve().parent
W=R/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
spec=importlib.util.spec_from_file_location('pubdriver',W/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m);d=m.Driver(R,W)
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  assert not subprocess.check_output(['git','-C',str(R),'diff','--cached','--name-only'],text=True).strip()
  assert not json.loads(d.active_path.read_text()).get('active')
  assert not json.loads((O/'OWNER.json').read_text())['active']
  a=json.loads((O/'VERIFICATION_SUMMARY.json').read_text());assert a['status']=='SCOPED_VERIFICATION_PASS'
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h and sha(O/'sources'/(n+'.lean'))==h for n,h in a['source_closure'].items())
  assert all(d.artifacts(n)==v for n,v in a['artifacts'].items()) and d.manifest_matches(a['configuration'])
  handoff=R/'records/PRO_CONTINUATION_HANDOFF.md'
  handoff.write_text(handoff.read_text()+'\nLatest completed scope: graph43 LEFT heads 212..481, 270 heads with complete tails.\nTwelve parts and exact composition passed guarded builds, exact-type/transitive-axiom audit,\nand 13 targeted installed-kernel replays. Evidence: 20261022-economical-graph43-left002/VERIFICATION_SUMMARY.json.\nAll LEFT heads 0..481 are now verified in three separate scopes. Original parents and canonical\nroot remain unintegrated. Graph43 remains incomplete; endpoint count stays 30/48.\nThe earlier block002 prepared status is superseded. Next: guarded RIGHT raw data and 12-head pilot;\nprepared script in 20261022-economical-graph43-right-pilot12, not yet verified.\n')
  previous=R/'research/continuations/20261022-economical-graph43-left001'
  paths=[handoff]+[p for p in O.rglob('*') if p.is_file() and p.name not in {'PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','INDEX_REVIEW.json','POST_PUSH_RECEIPT.json'}]+[previous/n for n in ['PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','POST_PUSH_RECEIPT.json']]+[R/'research/continuations/20261022-economical-graph43-right-pilot12/run_unit.py']
  paths=sorted(set(str(p.relative_to(R)) for p in paths));assert not any('__pycache__' in x for x in paths)
  (O/'PUBLICATION_PATHS.txt').write_text('\n'.join(paths)+'\n')
  (O/'PUBLICATION_HASHES.json').write_text(json.dumps({p:sha(R/p) for p in paths},indent=2,sort_keys=True)+'\n')
  print(json.dumps({'status':'PUBLICATION_SCOPE_VALIDATED','paths':len(paths),'heads':a['heads'],'kernel_replays':a['targeted_kernel_replays']}))
