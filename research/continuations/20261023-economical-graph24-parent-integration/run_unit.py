"""Bounded serial proof unit for graph3, preserving complete tails and original sources."""
from pathlib import Path
import ast,contextlib,fcntl,hashlib,importlib.util,json,os,signal,subprocess,sys,time
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';O=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(n,x):(O/n).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def git(*a):return subprocess.check_output(['git','-C',str(R),*a],text=True).strip()
p=W/'continuation_driver_capacity.py'
assert sha(p)=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_serial',p);m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
d=m.Driver(R,W);os.environ['LEAN_NUM_THREADS']='1';child=None
def stop(sig,frame):
 d.stop=True
 if child is not None and child.poll() is None:os.killpg(child.pid,signal.SIGTERM)
for sig in (signal.SIGINT,signal.SIGTERM,signal.SIGHUP):signal.signal(sig,stop)
def idle():
 a=json.loads(d.active_path.read_text());assert not a.get('active') and not a.get('protected_closure')
 assert not any(Path(s.strip()).name in ('lean','lake','leanchecker') for s in subprocess.check_output(['ps','-axo','comm='],text=True).splitlines())
def check(label,args):
 global child
 assert not d.stop
 start=time.monotonic();timed=False
 with (O/(label+'.log')).open('w') as f:
  child=subprocess.Popen(args,cwd=R,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
  try:code=child.wait(timeout=240)
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(child.pid,signal.SIGTERM)
   try:code=child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);code=child.wait()
 child=None
 row={'label':label,'command':args,'exit':code,'timed_out':timed,'seconds':round(time.monotonic()-start,3)}
 print(json.dumps(row),flush=True);return row
with (W/'continuation-driver.lock').open('r+') as owner:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB)
 with d.locked():
  idle();assert not git('diff','--cached','--name-only')
  assert len(sys.argv)==2 and git('rev-parse','HEAD')==sys.argv[1]
  assert not (O/'PLAN.json').exists()
  proposal=R/'research/continuations/20261023-economical-graph24-parent-proposal'
  plan=json.loads((proposal/'PLAN.json').read_text());assert plan['status']=='PREPARED_NOT_PROVED'
  for side in ['Left','Right']:
   for block in ['000','001','002']:
    n='SmallPairLight'+side+'19Prefix'+block;c=d.closure(n);key=m.fingerprint(c);expected=d.expected_manifest(n,key,d.latest())
    assert expected and expected==d.artifacts(n),'Missing current verified prefix '+n
  scopes=[R/'research/continuations'/('20261023-economical-graph24-'+short) for short in ['left-pilot12','left000','left001','left002','right-pilot12','right000','right001','right002']]
  refs=[p for p in proposal.rglob('*') if p.is_file()]+[R/'research/continuations/20261022-graph3-foundation/foundation_inputs.py']
  for scope in scopes:
   a=json.loads((scope/'VERIFICATION_SUMMARY.json').read_text());assert a['status']=='SCOPED_VERIFICATION_PASS'
   audits=json.loads((scope/'AUDIT_RESULTS.json').read_text());assert all(x['exit']==0 and not x['timed_out'] for x in audits)
   assert sum(x['label'].endswith('-kernel') for x in audits)==a['targeted_kernel_replays']
   assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in a['source_closure'].items())
   assert all(d.artifacts(n)==v for n,v in a['artifacts'].items()) and d.manifest_matches(a['configuration'])
   refs += [scope/n for n in ['VERIFICATION_SUMMARY.json','AUDIT_RESULTS.json','AnalyticAudit.lean','run_unit.py']]
  references={str(p.relative_to(R)):sha(p) for p in refs}
  _,_,closures,accepted,_,_=d.snapshot()
  changed=set(plan['parents'])|{'SmallPairLightData24'}
  assert not any(changed & set(closures[n]) for n in accepted), 'Accepted dependent would change'
  literal=plan['literal_facade'];name=literal['module'];assert name=='SmallPairLightData24'
  src=R/'D1Bound5'/(name+'.lean');old=proposal/'originals'/(name+'.lean');new=proposal/'candidates'/(name+'.lean')
  assert sha(old)==literal['original'] and sha(src)==sha(new)==literal['candidate']
  (O/'originals').mkdir()
  (O/'originals'/(name+'.lean')).write_bytes(old.read_bytes())

  parents=list(plan['parents'])
  for n,pins in plan['parents'].items():
   src=R/'D1Bound5'/(n+'.lean');old=proposal/'originals'/(n+'.lean');new=proposal/'candidates'/(n+'.lean')
   assert sha(src)==sha(old)==pins['original'] and sha(new)==pins['candidate']
   assert old.read_text().split('theorem ',1)[1].split(':=',1)[0]==new.read_text().split('theorem ',1)[1].split(':=',1)[0]
   (O/'originals'/(n+'.lean')).write_bytes(old.read_bytes())
  for n,h in plan['unchanged_modules'].items():
   src=R/'D1Bound5'/(n+'.lean');old=proposal/'originals'/(n+'.lean');assert sha(src)==sha(old)==h
   (O/'originals'/(n+'.lean')).write_bytes(old.read_bytes())
  (R/'D1Bound5/SmallPairLightData24.lean').write_bytes((proposal/'candidates/SmallPairLightData24.lean').read_bytes())
  for n in parents:(R/'D1Bound5'/(n+'.lean')).write_bytes((proposal/'candidates'/(n+'.lean')).read_bytes())
  save('INSTALLATION.json',{'status':'UNVERIFIED_CANDIDATE_PARENTS_INSTALLED','parents':plan['parents'],'originals_archived':True,'main_theorem_complete':False})
  targets=['SmallPairLightData24','SmallPairLightAdaptiveData24']+parents+['SmallPairLightAdaptiveValidation24','SmallPairLightLeft24','SmallPairLightRight24']
  proof_targets=parents+['SmallPairLightAdaptiveValidation24','SmallPairLightLeft24','SmallPairLightRight24']
  counts=[]
  q=json.loads(d.queue_path.read_text());assert q['max_parallel']==1 and q['pause_after_current'] is True
  save('QUEUE_BEFORE.json',q)
  for n in targets:
   assert n not in q.get('blocked_modules',[])
   if n not in q['names']:q['names'].append(n)
   q.setdefault('target_timeout_seconds',{})[n]=240
  m.atomic_json(d.queue_path,q);save('QUEUE_AFTER.json',q)
  sources={}
  for n in targets:sources.update(d.closure(n))
  (O/'sources').mkdir()
  for n in sources:(O/'sources'/(n+'.lean')).write_bytes((R/'D1Bound5'/(n+'.lean')).read_bytes())
  save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'parts':counts,'heads':892,'start_offset':0,'complete_tails':True,'base_commit':git('rev-parse','HEAD'),'graph3_complete':False,'reference_files':references})
  save('OWNER.json',{'active':True,'pid':os.getpid(),'utc':m.utc()})
 audits=[];builds=[]
 try:
  for n in targets:
   with d.locked():
    idle();assert not d.stop and d.manifest_matches(d.static)
    assert all(sha(R/'D1Bound5'/(x+'.lean'))==h for x,h in sources.items())
    c=d.closure(n);key=m.fingerprint(c);prior=d.latest().get((n,key));expected=d.expected_manifest(n,key,d.latest())
    if expected and expected==d.artifacts(n):
     builds.append({'name':n,'reused_current_accepted_build':True});continue
    assert prior is None,'Prior exact attempt: '+n
    assert d.launch(n,c,240)
   while d.jobs:
    time.sleep(2)
    with d.locked(),(O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
   row=d.rows[-1];save(n+'-BUILD_RECEIPT.json',row);(O/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes())
   builds.append(row);save('BUILD_RESULTS.json',builds)
   print(json.dumps({k:row[k] for k in ['name','exit','accepted_build','seconds']}),flush=True)
   assert row['name']==n and row['accepted_build'] and not d.stop
  import re
  audit=''.join('import D1Bound5.'+n+'\n' for n in proof_targets)+'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n'
  factory=R/'research/continuations/20261022-graph3-foundation/foundation_inputs.py'
  assert sha(factory)=='88fa0cea7f98b670cd441932278b985803855d6623f772ed3ff44a1abc8f7d40'
  fs=importlib.util.spec_from_file_location('graph3_header_parser',factory);fm=importlib.util.module_from_spec(fs);sys.modules[fs.name]=fm;fs.loader.exec_module(fm)
  names=[];headers={}
  for n in targets:
   original=(O/'originals'/(n+'.lean')).read_text();decls=fm.declarations(original);headers[n]=[]
   for item in decls:
    ns=item['namespace'];name=item['name'];ty=item['header']
    audit+='namespace '+ns+'\n'+'\n'.join(item['opens'])+'\nexample '+ty+' := _root_.'+name+'\nend '+ns+'\n'
    names.append(name);headers[n].append(item['raw_header'])
  assert len(names)==len(set(names))==41
  save('PRESERVED_THEOREM_HEADERS.json',headers)
  audit+='run_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
  (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in proof_targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits)
   assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert all(sha(R/p)==h for p,h in references.items())
  assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
  save('KERNEL_COVERAGE.json',{'guarded_build_modules':targets,'fresh_kernel_replay_modules':proof_targets,'no_separate_replay':{'SmallPairLightData24':'Import-only facade, zero declarations; seven original literal definitions preserved in seven already replayed data modules','SmallPairLightAdaptiveData24':'Sixteen unchanged drop aliases, no theorems; exact definition types audited'},'fresh_replays':9,'original_public_declarations_type_checked':41})
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':892,'start_offset':0,'full_tails':True,'parts':counts,'new_part_theorems':0,'existing_trial_now_guarded':0,'preserved_parent_theorems':6,'light_side_certificates':2,'targeted_kernel_replays':len(proof_targets),'type_axiom_audit_exit':0,'reference_files':references,'original_public_declarations_type_checked':41,'scope_description':'graph24 both complete light-side certificates, six original parent theorem headers preserved','source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph3_endpoint_complete':False,'root_integration':False})
  print('GRAPH24_PARENT_INTEGRATION_SCOPED_VERIFICATION_PASS',flush=True)
 except BaseException as e:
  save('FAILURE.json',{'utc':m.utc(),'type':type(e).__name__,'detail':str(e)});raise
 finally:
  d.stop=True
  while d.jobs:
   with d.locked(),(O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
   time.sleep(1)
  if child is not None and child.poll() is None:
   os.killpg(child.pid,signal.SIGTERM)
   try:child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait()
  save('OWNER.json',{'active':False,'pid':os.getpid(),'utc':m.utc(),'child_processes':[]})
