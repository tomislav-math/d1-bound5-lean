"""Finalize only completed, current guarded proof checks. No compilation or Git mutation."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,v):p.write_text(json.dumps(v,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_finalize_current_unit',work/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 active=json.loads((work/'continuation-active.json').read_text());assert not active.get('active') and not active.get('protected_closure')
 driver=m.Driver(root,work);q,ns,closures,accepted,unknown,eligible=driver.snapshot();assert not unknown and q['max_parallel']==1
 groups=['shared-audit','a3-audit'];targets=[];decls=[];guards={};artifacts={};receipts=[];builds=[]
 for g in groups:
  p=out/g;names=json.loads((p/'TARGETS.json').read_text());targets+=names;decls+=json.loads((p/'DECLARATIONS.json').read_text())
  checks=json.loads((p/'TARGETED_REPLAY_RECEIPTS.json').read_text());expected=json.loads((p/'REPLAY_TARGETS.json').read_text());assert len(checks)==1+len(expected)
  assert checks[0]['label']=='analytic-type-axioms'
  assert [x['label'] for x in checks[1:]]==[n+'-targeted-replay' for n in expected]
  assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in checks)
  assert json.loads((p/'active-targeted-replay.json').read_text())['active'] is False
  log=(p/'analytic-type-axioms.log').read_text();assert log.count('ANALYTIC_AXIOMS_PASS ')==len(json.loads((p/'DECLARATIONS.json').read_text()))
  assert not any(line.startswith('error:') for line in log.splitlines())
  guard=json.loads((p/'TARGETED_REPLAY_GUARDS.json').read_text())
  for n,h in guard['project_sources'].items():assert sha(root/'D1Bound5'/(n+'.lean'))==h;assert n not in guards or guards[n]==h;guards[n]=h
  for name,h in {**guard['compiled_artifacts'],**guard['immutable_inputs']}.items():assert sha(root/name)==h;assert name not in artifacts or artifacts[name]==h;artifacts[name]=h
  receipts.extend(checks)
 assert len(targets)==len(set(targets))==12 and all(t in accepted for t in targets)
 assert len(decls)==len({d['name'] for d in decls})
 latest=driver.latest();snap=out/'verified-sources';snap.mkdir();sources={}
 for n in targets:
  key=m.fingerprint(closures[n]);row=latest[(n,key)];assert row['accepted_build'] and row['exit']==0
  assert row['source_sha256']==sha(root/'D1Bound5'/(n+'.lean'))
  builds.append(row);p=snap/(n+'.lean');p.write_bytes((root/'D1Bound5'/(n+'.lean')).read_bytes());sources[n]={'source':'D1Bound5/'+n+'.lean','snapshot':str(p.relative_to(root)),'sha256':sha(p)}
 flags=[]
 for n in guards:
  text=(root/'D1Bound5'/(n+'.lean')).read_text();text=re.sub(r'/\-[\s\S]*?\-/','',text);text=re.sub(r'--[^\n]*','',text)
  bad=re.findall(r'\b(?:sorry|admit|sorryAx|native_decide)\b|decide\s+\+native|^\s*axiom\b|debug\.skipKernelTC|^\s*unsafe\s+(?:def|theorem)',text,re.M)
  if bad:flags.append({'module':n,'flags':bad})
 assert not flags,flags
 own={}
 for p in out.glob('wave*/BATCH_RESULTS.json'):
  for row in json.loads(p.read_text()):
   if row.get('accepted_build'):own[row['name']]=row
 verified_own=[n for n in targets if n in own and own[n]['source_sha256']==sources[n]['sha256']]
 now=datetime.now().astimezone().isoformat()
 summary={'time':now,'outcome':'COMPLETED_UNIT','targets':targets,'public_theorems':sum(d['kind']=='theorem' for d in decls),'public_declarations':len(decls),'new_current_guarded_compilations':verified_own,'recovered_guarded_compilations':[n for n in targets if n not in verified_own],'targeted_installed_same_kernel_replays':sum(x['label']!='analytic-type-axioms' for x in receipts),'source_closure_modules':len(guards),'original_public_statements_preserved':True,'source_scan_flags':flags,'allowed_axioms':['propext','Classical.choice','Quot.sound'],'root_integrated':False,'independent_review':False,'clean_checkout':False,'main_statement_proved':False,'next':'FiniteA4 and FiniteA5 via the verified unequal-pole residual, then P and final analytic/finite graph dependencies.'}
 for name,value in [('VERIFICATION_SUMMARY.json',summary),('SOURCE_MAP.json',sources),('FINAL_SOURCE_GUARDS.json',guards),('FINAL_ARTIFACT_GUARDS.json',artifacts),('BUILD_RECEIPTS.json',builds),('CHECK_RECEIPTS.json',receipts)]:dump(out/name,value)
 text='# FINISH\n\n'+now+'\nOutcome: COMPLETED_UNIT.\n\nThe actual A3 construction is verified through its full-ring inequality and closed forbidden interval. Its polynomial matrix, determinant, coefficient sums, height2265, residue identity, residual35/16 and integral nonzero-row transfer are all proved. The shared unequal-pole theorem proves convergence, cancellation and the majorant for actual residue polynomials with arbitrary positive pole multiplicities. Original public statements and frozen manuscript remain unchanged.\n\nAll12 selected modules have guarded pinned compilation, exact original-theorem examples and public type/transitive-axiom checks. '+str(summary['targeted_installed_same_kernel_replays'])+' installed SAME-kernel replay milestones passed. The checks cover'+str(len(guards))+' project source modules. These are targeted checks, not independent review or clean-checkout validation. Meaningful failed attempts remain in their wave directories.\n\nRoot integration, other approximation families, finite graph completeness and MainStatement remain open. This record predates the separate ordinary private Git save and does not claim that any push has happened. Preserve the547 inherited staged blobs and keep the existing automation unchanged.\n'
 (root/'records/runs'/(out.name+'-FINISH.md')).write_text(text)
 print('VERIFIED_A3_AND_UNEQUAL_POLES',json.dumps(summary))
