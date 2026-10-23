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
  assert not a.get('graph24_endpoint_complete',False)
  handoff=R/'records/PRO_CONTINUATION_HANDOFF.md'
  assert '35/48 finite graph endpoints' in handoff.read_text()
  side="RIGHT" if "-right" in O.name else "LEFT"
  scope=a.get("scope_description",f"graph24 closure witness rows {a['start_offset']}..{a['start_offset']+a['heads']-1} over all {a['global_closure_vertices']} original vertices" if a.get("global_closure_vertices") else f"graph24 {side} heads {a['start_offset']}..{a['start_offset']+a['heads']-1}, complete original tails")
  entry=f"\nLatest checked archive: {O.name}. {scope}.\nGuarded builds, exact-type/transitive-axiom audit and {a['targeted_kernel_replays']} targeted installed-kernel replays passed.\nGraph24 endpoint remains incomplete; current endpoint inventory remains 35/48. MainTheorem UNPROVED, root integration unverified.\n"
  assert 'Latest checked archive: '+O.name not in handoff.read_text()
  handoff.write_text(handoff.read_text()+entry)
  paths=[handoff]+list(Path(__file__).resolve().parent.glob('*.py'))+[p for p in O.rglob('*') if p.is_file() and p.name not in {'PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','INDEX_REVIEW.json','POST_PUSH_RECEIPT.json'}]+[P/n for n in ['PUBLICATION_PATHS.txt','PUBLICATION_HASHES.json','POST_PUSH_RECEIPT.json','INDEX_REVIEW.json'] if (P/n).exists()]
  if "parent-integration" in O.name:
   paths += [p for p in (W.parent/"20261023-economical-graph24-parent-proposal").rglob("*") if p.is_file()]
  if "closure" in O.name or "assembly" in O.name:
   paths += [p for p in (W.parent/"20261023-graph24-closure").rglob("*") if p.is_file()]
  paths=sorted(set(str(p.relative_to(R)) for p in paths));assert not any('__pycache__' in x for x in paths)
  (O/'PUBLICATION_PATHS.txt').write_text('\n'.join(paths)+'\n');(O/'PUBLICATION_HASHES.json').write_text(json.dumps({p:sha(R/p) for p in paths},indent=2,sort_keys=True)+'\n')
  print(json.dumps({'status':'PUBLICATION_SCOPE_VALIDATED','paths':len(paths),'heads':a['heads'],'kernel_replays':a['targeted_kernel_replays']}))
