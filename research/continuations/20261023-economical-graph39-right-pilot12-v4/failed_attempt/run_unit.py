"""Bounded serial proof unit for graph39, preserving complete tails and original sources."""
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
  pilot=R/'research/continuations/20261023-economical-graph39-left-pilot12'
  ps=json.loads((pilot/'VERIFICATION_SUMMARY.json').read_text());assert ps['status']=='SCOPED_VERIFICATION_PASS' and ps['targeted_kernel_replays']==6
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in ps['source_closure'].items())
  assert all(d.artifacts(n)==v for n,v in ps['artifacts'].items()) and d.manifest_matches(ps['configuration'])
  seed=R/'D1Bound5/SmallPairLightAdaptiveLeft39_Pilot12Part00.lean'
  references={str(p.relative_to(R)):sha(p) for p in [seed,pilot/'VERIFICATION_SUMMARY.json',pilot/'AUDIT_RESULTS.json',pilot/'SOURCE_INSPECTION.json']}
  data_names=['SmallPairLightData39RightVertices','SmallPairLightData39RightCached','SmallPairLightData39RightRows']
  for n in data_names:
   p=R/'D1Bound5'/(n+'.lean');original=(pilot/'candidates'/(n+'.lean')).read_bytes()
   references[str((pilot/'candidates'/(n+'.lean')).relative_to(R))]=sha(pilot/'candidates'/(n+'.lean'))
   if n=='SmallPairLightData39RightCached':
    before=(O/'failed_attempt/sources'/(n+'.lean')).read_bytes();assert p.read_bytes()==before
    after=original.replace(b'\ndef rightCached :',b'\nnoncomputable\ndef rightCached :',1)
    assert original!=after and original.split(b'def rightCached',1)[1]==after.split(b'def rightCached',1)[1]
    assert after.replace(b'noncomputable\n',b'',1)==original
    (O/'before-RightCached.lean').write_bytes(before);(O/'original-RightCached.lean').write_bytes(original);p.write_bytes(after)
    save('NONCOMPUTABLE_RECOVERY.json',{'status':'UNVERIFIED_MODIFIER_ONLY_RECOVERY_AFTER_TWO_RECORDED_TIMEOUTS','original_literal_source_sha256':hashlib.sha256(original).hexdigest(),'failed_source_sha256':hashlib.sha256(before).hexdigest(),'candidate_source_sha256':sha(p),'original_logical_type_unchanged':True,'original_definition_body_bytes_identical':True,'declaration_modifier_added':'noncomputable','complete_modified_declaration_header_byte_identical':False,'runtime_codegen_intentionally_omitted_for_this_data_definition':True,'no_new_axiom_or_proof_statement_change':True,'pilot_and_installed_kernel_gates_required':True})
    refs=[O/'before-RightCached.lean',O/'original-RightCached.lean',O/'NONCOMPUTABLE_RECOVERY.json']
    for name,folder in [('Basic.lean','Elab/PreDefinition'),('NoncomputableAttr.lean','Compiler')]:
     source=Path('/Users/tp/.elan/toolchains/leanprover--lean4---v4.33.1/src/lean/Lean')/folder/name;archive=O/('Lean-'+name);archive.write_bytes(source.read_bytes());refs.append(archive)
    references.update({str(ref.relative_to(R)):sha(ref) for ref in refs})
   else:assert p.read_bytes()==original
  model_source=R/'D1Bound5/SmallPairLightAdaptiveRight39_000.lean'
  assert sha(model_source)=='4eb0b5f0cda3b454f299d8b05cb8f491588a9693430bffa058a2389fd35da0ef'
  assert 'pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 98' in model_source.read_text()
  (O/'originals').mkdir();model_archive=O/'originals/SmallPairLightAdaptiveRight39_000.lean';model_archive.write_bytes(model_source.read_bytes())
  save('MODEL_BINDING.json',{'tau':1,'nu':2,'basis':'original complete RIGHT parent header','original_source_sha256':sha(model_source)})
  references.update({str(p.relative_to(R)):sha(p) for p in [model_archive,O/'MODEL_BINDING.json']})
  counts=[12];parts=['SmallPairLightAdaptiveRight39_Pilot12Part00'];decls=[('right_pilot12_part00_checked',12,0)];literal_counts=json.loads((pilot/'SOURCE_INSPECTION.json').read_text())['literal_row_counts']
  s=seed.read_text().replace('Left','Right').replace('left','right')
  p=R/'D1Bound5'/(parts[0]+'.lean');assert p.read_text()==s;assert not d.latest().get((parts[0],m.fingerprint(d.closure(parts[0]))));p.write_text(s)
  n='SmallPairLightRight39Pilot12';source=R/'D1Bound5/SmallPairLightLeft39Pilot12.lean';references[str(source.relative_to(R))]=sha(source)
  s=source.read_text().replace('Left','Right').replace('left','right')
  p=R/'D1Bound5'/(n+'.lean');assert p.read_text()==s;assert not d.latest().get((n,m.fingerprint(d.closure(n))));p.write_text(s)
  targets=data_names+parts+[n]
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
  save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'parts':counts,'heads':12,'start_offset':0,'complete_tails':True,'base_commit':git('rev-parse','HEAD'),'graph39_complete':False,'reference_files':references,'literal_counts':literal_counts})
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
  audit='import D1Bound5.SmallPairLightRight39Pilot12\nimport Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\nnamespace D1Bound5.PairLightAdaptivePrepared39\n'
  for th,c,offset in decls+[('right_pilot12_direct_checked',12,0)]:
   a=f'(PairLightPrepared39.rightCached.drop {offset})'
   b=f'(PairLightPrepared39.rightRows.drop {offset})'
   audit+=f'example : pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve {c}\n  {a} {b} = true := {th}\n'
  names=['D1Bound5.PairLightAdaptivePrepared39.'+th for th,_,_ in decls]+['D1Bound5.PairLightAdaptivePrepared39.right_pilot12_direct_checked']+['D1Bound5.PairLightPrepared39.'+v for v in ['sieve','rightVertices','rightCached','rightRows']]
  audit+='end D1Bound5.PairLightAdaptivePrepared39\nrun_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
  (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits)
   assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert all(sha(R/p)==h for p,h in references.items())
  assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':12,'start_offset':0,'full_tails':True,'parts':counts,'new_part_theorems':1,'existing_trial_now_guarded':0,'composition_theorems':1,'targeted_kernel_replays':len(targets),'type_axiom_audit_exit':0,'reference_files':references,'source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph39_endpoint_complete':False,'root_integration':False})
  print('GRAPH39_RIGHT_PILOT12_SCOPED_VERIFICATION_PASS',flush=True)
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
