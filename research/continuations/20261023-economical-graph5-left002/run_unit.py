"""Bounded serial proof unit for graph5, preserving complete tails and original sources."""
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
  seed=R/'D1Bound5/SmallPairLightAdaptiveLeft5_Pilot12Part00.lean'
  references={'D1Bound5/SmallPairLightAdaptiveLeft5_Pilot12Part00.lean': '01b06891bc475491892e68b0dfcd774c99f63f30c5e877d033fe3ea7148816f2', 'D1Bound5/SmallPairLightData5Sieve.lean': 'c4b4ee0dc22e482da8ec7f621a38c73dd9f79fc59e26d7927be0a598488843bf', 'D1Bound5/SmallPairLightData5LeftVertices.lean': 'ac9f05645e1f43a8edabfc2f430764266f4699355f41be32c926220fede24317', 'D1Bound5/SmallPairLightData5LeftCached.lean': 'be98051e17b7be7a1f39e931ad469e5de82295af840d8176dd1c9c88654cb094', 'D1Bound5/SmallPairLightData5LeftRows.lean': 'de46e1daadaa50242548a106b81b45463f6569c33fcedd7b2c7e3e488f2e105b'}
  assert all(sha(R/p)==h for p,h in references.items())
  counts=[24, 24, 24, 24, 24, 24, 18];parts=[];decls=[];original=seed.read_text().replace('left_pilot12_part00_checked','left_prefix_000_part00_checked')
  for i,c in enumerate(counts):
   n=f'SmallPairLightAdaptiveLeft5_002Part{i:02d}';th=f'left_prefix_002_part{i:02d}_checked';offset=269+sum(counts[:i])
   s=original.replace('left_prefix_000_part00_checked',th).replace('sieve 12','sieve '+str(c)).replace('.drop 0)',f'.drop {offset})').replace('Original heads 0 through 11',f'Original heads {offset} through {offset+c-1}')
   p=R/'D1Bound5'/(n+'.lean')
   assert not p.exists() or p.read_text()==s;p.write_text(s)
   parts.append(n);decls.append((th,c,offset))
  n='SmallPairLightLeft5Prefix002'
  s='import D1Bound5.PairLightArithmeticPrefixConcat\n'+''.join('import D1Bound5.'+x+'\n' for x in parts)
  s+='\nnamespace D1Bound5.PairLightAdaptivePrepared5\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\ntheorem left_prefix_002_direct_checked :\n    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 162\n      (PairLightPrepared5.leftCached.drop 269) (PairLightPrepared5.leftRows.drop 269) = true := by\n'
  for i in reversed(range(len(counts))):
   offset=269+sum(counts[:i]);c=counts[i];rest=162-sum(counts[:i])
   s+=f'  have h{offset:03d} : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve {rest}\n      (PairLightPrepared5.leftCached.drop {offset}) (PairLightPrepared5.leftRows.drop {offset}) = true := '
   if i==len(counts)-1:s+=f'left_prefix_002_part{i:02d}_checked\n'
   else:s+=f'by\n    apply pairLightSelectedFloorPrefixBool_of_add 0 1 PairLightPrepared5.sieve {c} {rest-c}\n      (PairLightPrepared5.leftCached.drop {offset}) (PairLightPrepared5.leftRows.drop {offset})\n    · exact left_prefix_002_part{i:02d}_checked\n    · simpa only [List.drop_drop, Nat.reduceAdd] using h{offset+c:03d}\n'
  s+='  exact h269\nend D1Bound5.PairLightAdaptivePrepared5\n'
  p=R/'D1Bound5'/(n+'.lean');assert not p.exists() or p.read_text()==s;p.write_text(s)
  targets=parts+[n]
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
  save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'parts':counts,'heads':162,'start_offset':269,'complete_tails':True,'base_commit':git('rev-parse','HEAD'),'graph5_complete':False,'reference_files':references})
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
  audit='import D1Bound5.SmallPairLightLeft5Prefix002\nimport Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\nnamespace D1Bound5.PairLightAdaptivePrepared5\n'
  for th,c,offset in decls+[('left_prefix_002_direct_checked',162,269)]:
   a=f'(PairLightPrepared5.leftCached.drop {offset})'
   b=f'(PairLightPrepared5.leftRows.drop {offset})'
   audit+=f'example : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve {c}\n  {a} {b} = true := {th}\n'
  names=['D1Bound5.PairLightAdaptivePrepared5.'+th for th,_,_ in decls]+['D1Bound5.PairLightAdaptivePrepared5.left_prefix_002_direct_checked']+['D1Bound5.PairLightPrepared5.'+v for v in ['sieve','leftVertices','leftCached','leftRows']]
  audit+='end D1Bound5.PairLightAdaptivePrepared5\nrun_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
  (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits)
   assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert all(sha(R/p)==h for p,h in references.items())
  assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':162,'start_offset':269,'full_tails':True,'parts':counts,'new_part_theorems':7,'existing_trial_now_guarded':0,'composition_theorems':1,'targeted_kernel_replays':len(targets),'type_axiom_audit_exit':0,'reference_files':references,'source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph5_endpoint_complete':False,'root_integration':False})
  print('GRAPH5_LEFT_002_SCOPED_VERIFICATION_PASS',flush=True)
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
