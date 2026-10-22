"""Bounded serial proof unit for graph43, preserving complete tails and original sources."""
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
  C=W.parent/'20261022-economical-graph43-closure';P=C/'proposal'
  prior=json.loads((W.parent/'20261022-economical-graph43-closure-rest003/VERIFICATION_SUMMARY.json').read_text())
  assert prior['status']=='SCOPED_VERIFICATION_PASS' and prior['heads']==256 and prior['start_offset']==576 and prior['global_closure_vertices']==963
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in prior['source_closure'].items())
  assert all(d.artifacts(n)==v for n,v in prior['artifacts'].items()) and d.manifest_matches(prior['configuration'])
  plan=json.loads((P/'PLAN.json').read_text());assert plan['status']=='REVIEWED_GRAPH43_CLOSURE_SOURCE_PROPOSAL_NOT_INSTALLED'
  payload=json.loads((P/'PAYLOAD_SHA256.json').read_text());assert all(sha(P/n)==h for n,h in payload.items())
  references={str((P/n).relative_to(R)):h for n,h in payload.items()}
  references.update({str(p.relative_to(R)):sha(p) for p in [P/'PAYLOAD_SHA256.json',C/'closure_inputs.py']})
  assert sha(R/'D1Bound5/SmallPairGraphData43.lean')==plan['original_merged_sha256']
  targets=plan['scopes']['closure-rest'][12:16];assert len(targets)==4
  for n in targets:
   p=P/'candidates'/(n+'.lean');assert sha(p)==plan['source_manifest'][n] and not (R/'D1Bound5'/(n+'.lean')).exists()
  for n in targets:(R/'D1Bound5'/(n+'.lean')).write_bytes((P/'candidates'/(n+'.lean')).read_bytes())
  counts=[64, 64, 3]
  save('PROPOSAL_BINDING.json',{'reference_files':references,'plan_sha256':sha(P/'PLAN.json'),'source_inspection_sha256':sha(P/'SOURCE_INSPECTION.json'),'source_manifest':{n:plan['source_manifest'][n] for n in targets},'global_closure_vertices':963,'global_indices_preserved':True,'merged_endpoint_unchanged':True})
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
  save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'parts':counts,'heads':131,'start_offset':832,'complete_tails':True,'base_commit':git('rev-parse','HEAD'),'graph43_complete':False})
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
  assert all(sha(R/n)==h for n,h in references.items())
  specg=importlib.util.spec_from_file_location('graph43_pure',C/'closure_inputs.py');g=importlib.util.module_from_spec(specg);specg.loader.exec_module(g)
  audit=''.join('import D1Bound5.'+n+'\n' for n in targets)+'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n'
  names=[];headers={}
  for n in targets:
   text=(R/'D1Bound5'/(n+'.lean')).read_text();origin=plan['origins'][n];expected=(P/'originals'/(origin['original_module']+'.lean')).read_text()
   expected_decls=[x for x in g.declarations(expected) if x['local_name'] in origin['names']]
   assert [x['local_name'] for x in expected_decls]==origin['names']
   assert [x['raw_header'] for x in g.declarations(text)]==[x['raw_header'] for x in expected_decls]
   headers[n]=[]
   for item in g.declarations(text):
    name,ty,ns=item['local_name'],item['header'],item['namespace'];assert ty.startswith(':')
    audit+='namespace '+ns+'\n'+'\n'.join(item['opens'])+'\nexample '+ty+' := '+name+'\nend '+ns+'\n';names.append(item['name']);headers[n].append(item['raw_header'])
  save('PRESERVED_DECLARATION_HEADERS.json',headers)
  audit+='run_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
  (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
  commands=[('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
  for label,args in commands:
   row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits)
   assert row['exit']==0 and not row['timed_out'] and not d.stop
  assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
  assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
  assert sha(R/'D1Bound5/SmallPairGraphData43.lean')==plan['original_merged_sha256']
  assert all(sha(R/n)==h for n,h in references.items())
  save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'heads':131,'start_offset':832,'full_tails':True,'parts':counts,'new_part_theorems':3,'existing_trial_now_guarded':0,'coverage_theorems':0,'composition_theorems':1,'derived_closure_theorems':1,'global_closure_vertices':963,'targeted_kernel_replays':len(targets),'type_axiom_audit_exit':0,'reference_files':references,'source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph43_endpoint_complete':False,'root_integration':False})
  print('GRAPH43_CLOSURE_REST004_SCOPED_VERIFICATION_PASS',flush=True)
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
