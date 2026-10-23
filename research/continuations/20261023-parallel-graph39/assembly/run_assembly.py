"""Graph39 assembly owned serial lane. No shared driver state, queue, or Git writes."""
from pathlib import Path
import contextlib,hashlib,importlib.util,json,os,signal,subprocess,sys,time
R=Path('/Users/tp/Lean/D1Bound5');W=R/'research/continuations/20261018T010800CEST-main-continuation';O=Path(__file__).resolve().parent
P=R/'research/continuations/20261023-graph39-closure/proposal';C=P.parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def save(n,x):(O/n).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
p=W/'continuation_driver_capacity.py'
assert sha(p)=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_guarded',p);m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
d=m.Driver(R,W)
closure_summary=json.loads((O.parent/'VERIFICATION_SUMMARY.json').read_text())
assert closure_summary['status']=='SCOPED_VERIFICATION_PASS'
assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in closure_summary['source_closure'].items())
assert all(d.artifacts(n)==a for n,a in closure_summary['artifacts'].items())
d.rows=json.loads((O.parent/'continuation-builds.json').read_text())
# Keep inherited trust evidence, redirect every mutable path into this owned lane.
d.run=O;d.queue_path=O/'unused-queue.json';d.state_path=O/'continuation-builds.json';d.active_path=O/'continuation-active.json';d.lock_path=O/'continuation-intake.lock';d.logs=O/'continuation-builds'
save('INHERITED_BUILD_ROWS.json',d.rows);save('INHERITED_BASELINE.json',d.baseline)
os.environ['LEAN_NUM_THREADS']='1';child=None

def stop(sig,frame):
 d.stop=True
 if child is not None and child.poll() is None:os.killpg(child.pid,signal.SIGTERM)
for sig in (signal.SIGINT,signal.SIGTERM,signal.SIGHUP):signal.signal(sig,stop)

def check(label,args):
 global child
 assert not d.stop
 start=time.monotonic();timed=False
 with (O/(label+'.log')).open('w') as f:
  child=subprocess.Popen(args,cwd=R,stdout=f,stderr=subprocess.STDOUT,start_new_session=True)
  save('CHECK_ACTIVE.json',{'label':label,'pid':child.pid,'command':args,'utc':m.utc()})
  try:code=child.wait(timeout=240)
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(child.pid,signal.SIGTERM)
   try:code=child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);code=child.wait()
 child=None;save('CHECK_ACTIVE.json',{'active':False,'utc':m.utc()})
 row={'label':label,'command':args,'exit':code,'timed_out':timed,'seconds':round(time.monotonic()-start,3)}
 print(json.dumps(row),flush=True);return row

plan=json.loads((P/'PLAN.json').read_text());targets=json.loads((O/'targets.json').read_text())
assert targets==plan['scopes']['assembly']
sources={}
for n in targets:
 proposed=(P/'candidates'/(n+'.lean')).read_text()
 actual=(R/'D1Bound5'/(n+'.lean')).read_text()
 if n in ['SmallPairRawSelectedData39LeftCached','SmallPairRawSelectedData39RightCached']:
  key='leftCached' if 'Left' in n else 'rightCached'
  assert actual==proposed.replace('def '+key+' :','noncomputable\ndef '+key+' :')
 else: assert sha(R/'D1Bound5'/(n+'.lean'))==plan['source_manifest'][n]
 sources.update(d.closure(n))
(O/'sources').mkdir(exist_ok=True)
for n in sources:(O/'sources'/(n+'.lean')).write_bytes((R/'D1Bound5'/(n+'.lean')).read_bytes())
save('PLAN.json',{'targets':targets,'source_closure':sources,'configuration':d.static,'closure_rows':915,'scope':'final graph39 arithmetic/assembly/triangle endpoints','base_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),'parallel_lane':True,'shared_driver_state_untouched':True})
save('OWNER.json',{'active':True,'pid':os.getpid(),'utc':m.utc()})
builds=[];audits=[]
try:
 for n in targets:
  assert not d.stop and d.manifest_matches(d.static)
  assert all(sha(R/'D1Bound5'/(x+'.lean'))==h for x,h in sources.items())
  c=d.closure(n);key=m.fingerprint(c);prior=d.latest().get((n,key));expected=d.expected_manifest(n,key,d.latest())
  if expected and expected==d.artifacts(n):
   row={'name':n,'reused_current_accepted_build':True,'original_receipt':prior};builds.append(row);save('BUILD_RESULTS.json',builds);print('REUSE '+n,flush=True);continue
  assert prior is None,'Prior exact attempt requires diagnosis: '+n
  assert d.launch(n,c,240)
  while d.jobs:
   time.sleep(2)
   with (O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
  row=d.rows[-1];save(n+'-BUILD_RECEIPT.json',row);(O/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes());builds.append(row);save('BUILD_RESULTS.json',builds)
  print(json.dumps({k:row[k] for k in ['name','exit','accepted_build','seconds']}),flush=True)
  assert row['name']==n and row['accepted_build'] and not d.stop
 specg=importlib.util.spec_from_file_location('graph39_headers',C/'closure_inputs.py');g=importlib.util.module_from_spec(specg);specg.loader.exec_module(g)
 audit=''.join('import D1Bound5.'+n+'\n' for n in targets)+'import Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n';names=[];headers={}
 for n in targets:
  text=(R/'D1Bound5'/(n+'.lean')).read_text();origin=plan['origins'][n];expected=(P/'originals'/(origin['original_module']+'.lean')).read_text();decls=g.declarations(text)
  expected_decls=[x for x in g.declarations(expected) if x['local_name'] in origin['names']]
  assert [x['raw_header'] for x in decls]==[x['raw_header'] for x in expected_decls]
  headers[n]=[x['raw_header'] for x in decls]
  for item in decls:
   name,ty,ns=item['local_name'],item['header'],item['namespace'];assert ty.startswith(':')
   audit+='namespace '+ns+'\n'+'\n'.join(item['opens'])+'\nexample '+ty+' := '+name+'\nend '+ns+'\n';names.append(item['name'])
 save('PRESERVED_DECLARATION_HEADERS.json',headers)
 # Audit all 28 original merged public declarations through the final facade.
 endpoint_names=[]
 endpoint='import D1Bound5.SmallPairGraphData39\nimport Lean.Util.CollectAxioms\nimport Lean.Elab.Command\nset_option autoImplicit false\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n'
 for item in g.declarations((O/'SmallPairGraphData39.merged.before.lean').read_text()):
  name,ty,ns=item['local_name'],item['header'],item['namespace'];assert ty.startswith(':')
  endpoint+='namespace '+ns+'\n'+'\n'.join(item['opens'])+'\nexample '+ty+' := '+name+'\nend '+ns+'\n';endpoint_names.append(item['name'])
 assert len(endpoint_names)==28
 endpoint+='run_cmd do\n  for name in (['+', '.join(chr(96)+n for n in endpoint_names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
 (O/'EndpointAudit.lean').write_text(endpoint)

 audit+='run_cmd do\n  for name in (['+', '.join(chr(96)+n for n in names)+'] : List Lean.Name) do\n    let ax ← Lean.collectAxioms name\n    let bad := ax.filter fun n => !(['+chr(96)+'propext, '+chr(96)+'Classical.choice, '+chr(96)+'Quot.sound] : List Lean.Name).contains n\n    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"\n    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"\n'
 (O/'AnalyticAudit.lean').write_text(audit);frozen={n:d.artifacts(n) for n in sources}
 commands=[('all28-original-endpoint-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'EndpointAudit.lean')]),('exact-types-axioms',['/Users/tp/.elan/bin/lake','env','lean',str(O/'AnalyticAudit.lean')])]+[(n+'-kernel',['/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n]) for n in targets]
 for label,args in commands:
  row=check(label,args);audits.append(row);save('AUDIT_RESULTS.json',audits);assert row['exit']==0 and not row['timed_out'] and not d.stop
 assert all(sha(R/'D1Bound5'/(n+'.lean'))==h for n,h in sources.items())
 assert all(d.artifacts(n)==a for n,a in frozen.items()) and d.manifest_matches(d.static)
 save('VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':m.utc(),'targets':targets,'all_closure_rows':915,'left_heads':458,'right_heads':456,'new_scope_public_declarations':len(names),'original_public_declarations':28,'raw_cached_modifier_only_changes':json.loads((O/'DECLARATION_MODIFIER_CHANGES.json').read_text()),'targeted_kernel_replay_scopes':len(targets),'fresh_declaration_modules_replayed':7,'import_facade_scopes':['SmallPairRawSelectedData39','SmallPairGraphData39'],'type_axiom_audit_exit':0,'source_closure':sources,'artifacts':frozen,'configuration':d.static,'main_theorem_complete':False,'graph39_endpoint_complete':True,'root_integration':False,'shared_driver_state_untouched':True})
 print('GRAPH39_ENDPOINT_COMPLETE_VERIFIED',flush=True)
except BaseException as e:
 save('FAILURE.json',{'utc':m.utc(),'type':type(e).__name__,'detail':str(e)});raise
finally:
 d.stop=True
 while d.jobs:
  with (O/'driver-events.log').open('a') as log,contextlib.redirect_stdout(log):d.reap()
  time.sleep(1)
 if child is not None and child.poll() is None:
  os.killpg(child.pid,signal.SIGTERM)
  try:child.wait(timeout=10)
  except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait()
 save('OWNER.json',{'active':False,'pid':os.getpid(),'utc':m.utc(),'child_processes':[]})
