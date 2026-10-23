"""Scoped guarded checking of exactly owned graph candidates. No shared queue/Git writes.
Compilation requires an externally allocated root-coordinator slot.
"""
from pathlib import Path
import argparse,datetime,hashlib,importlib.util,json,os,signal,subprocess,sys,time
R=Path('/Users/tp/Lean/D1Bound5');O=Path(__file__).resolve().parent
W=R/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def utc():return datetime.datetime.now(datetime.timezone.utc).isoformat()
def save(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
p=W/'continuation_driver_capacity.py'
assert sha(p)=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('graphs_c_readonly_guards',p)
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
ap=argparse.ArgumentParser();ap.add_argument('graph',type=int,choices=[23,30]);ap.add_argument('--install',action='store_true');ap.add_argument('--execute',action='store_true');ap.add_argument('--limit',type=int);ap.add_argument('--timeout',type=int,default=240)
a=ap.parse_args();G=O/f'graph{a.graph}';plan=json.loads((G/'PLAN.json').read_text());assert plan['graph']==a.graph
owned=set(plan['build_order']);assert owned==set(plan['source_manifest'])
for n,h in plan['source_manifest'].items():assert sha(G/'candidates'/(n+'.lean'))==h,n
if a.install:
 changes=[]
 for n in plan['build_order']:
  dst=R/'D1Bound5'/(n+'.lean');src=G/'candidates'/(n+'.lean');old=sha(dst) if dst.exists() else None
  if old==plan['source_manifest'][n]:continue
  if dst.exists():assert plan['original_manifest'].get(n)==old,'Unexpected current source '+n
  dst.write_bytes(src.read_bytes());changes.append({'module':n,'before_sha256':old,'after_sha256':sha(dst)})
 save(G/'INSTALL_RECEIPT.json',{'utc':utc(),'status':'CANDIDATES_INSTALLED_NOT_COMPILED','changes':changes})
 print(json.dumps({'installed':len(changes),'graph':a.graph}),flush=True)
if not a.execute:raise SystemExit(0)
assert (G/'INSTALL_RECEIPT.json').exists()
d=m.Driver(R,W);os.environ['LEAN_NUM_THREADS']='1';latest=d.latest()
run=G/'runs'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ');run.mkdir(parents=True)
receipts=G/'module_receipts';receipts.mkdir(exist_ok=True)
child=None;done=[]
def stop(sig,frame):
 if child is not None and child.poll() is None:os.killpg(child.pid,signal.SIGTERM)
 raise InterruptedError(str(sig))
for sig in [signal.SIGINT,signal.SIGTERM,signal.SIGHUP]:signal.signal(sig,stop)
def check(label,args):
 global child
 t=time.monotonic();timed=False
 with (run/(label+'.log')).open('w') as out:
  child=subprocess.Popen(args,cwd=R,stdout=out,stderr=subprocess.STDOUT,start_new_session=True)
  save(G/'ACTIVE.json',{'active':True,'utc':utc(),'runner_pid':os.getpid(),'child_pid':child.pid,'label':label,'command':args,'log':str(run/(label+'.log'))})
  try:code=child.wait(timeout=a.timeout)
  except subprocess.TimeoutExpired:
   timed=True;os.killpg(child.pid,signal.SIGTERM)
   try:code=child.wait(timeout=10)
   except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);code=child.wait()
 child=None
 row={'utc':utc(),'label':label,'command':args,'exit':code,'timed_out':timed,'seconds':round(time.monotonic()-t,3),'log':str(run/(label+'.log'))}
 save(run/(label+'-receipt.json'),row);print(json.dumps(row),flush=True);return row

def expected(n):
 c=d.closure(n);fp=m.fingerprint(c)
 p=receipts/(n+'.json')
 if p.exists():
  r=json.loads(p.read_text())
  if r['source_closure']==c:
   assert r['status']=='COMPILED_AND_KERNEL_REPLAYED','Previous exact failed attempt '+n
   return r['artifacts']
 return d.expected_manifest(n,fp,latest)

try:
 count=0
 for n in plan['build_order']:
  assert sha(R/'D1Bound5'/(n+'.lean'))==plan['source_manifest'][n],n
  c=d.closure(n);fp=m.fingerprint(c)
  prior=receipts/(n+'.json')
  if prior.exists():
   r=json.loads(prior.read_text())
   if r['source_closure']==c:
    assert r['status']=='COMPILED_AND_KERNEL_REPLAYED','Do not blindly repeat an exact failed fingerprint '+n
    assert d.manifest_matches(r['artifacts'],cached=True),n
    done.append(n);continue
  frozen={}
  for dep in set(c)-{n}:
   e=expected(dep);assert e and d.manifest_matches(e,cached=True),'Missing current guarded dependency '+dep
   frozen.update(e)
  assert d.manifest_matches(d.static)
  save(run/(n+'-sources.json'),c);save(run/(n+'-dependencies.json'),frozen)
  build=check(n+'-build',['/usr/bin/time','-l','/Users/tp/.elan/bin/lake','env','lean','-DautoImplicit=false','-o',str(R/'.lake/build/lib/lean/D1Bound5'/(n+'.olean')),'-i',str(R/'.lake/build/lib/lean/D1Bound5'/(n+'.ilean')),str(R/'D1Bound5'/(n+'.lean'))])
  row={'utc':utc(),'module':n,'source_closure':c,'configuration':d.static,'dependency_artifacts':frozen,'build':build,'status':'BUILD_FAILED'}
  save(prior,row)
  assert build['exit']==0 and not build['timed_out'],'Build failed '+n
  assert d.closure(n)==c and d.manifest_matches(frozen,cached=True) and d.manifest_matches(d.static),'Source/dependency guard changed '+n
  artifacts=d.artifacts(n);assert any(k.endswith('.olean') for k in artifacts),n
  row.update(status='COMPILED_KERNEL_PENDING',artifacts=artifacts);save(prior,row)
  kernel=check(n+'-kernel',['/usr/bin/time','-l','/Users/tp/.elan/bin/lake','env','leanchecker','--verbose','D1Bound5.'+n])
  row['kernel']=kernel;save(prior,row)
  assert kernel['exit']==0 and not kernel['timed_out'],'Kernel failed '+n
  assert d.closure(n)==c and d.manifest_matches(frozen,cached=True) and d.artifacts(n)==artifacts and d.manifest_matches(d.static)
  row['status']='COMPILED_AND_KERNEL_REPLAYED';save(prior,row);done.append(n);count+=1
  save(G/'PROGRESS.json',{'utc':utc(),'completed':done,'completed_count':len(done),'total':len(plan['build_order']),'main_theorem_complete':False})
  if a.limit is not None and count>=a.limit:break
 if len(done)==len(plan['build_order']):
  audit=G/'OriginalTypesAxioms.lean';ah=sha(audit);all_sources=d.closure(f'SmallPairGraphData{a.graph}');all_artifacts={}
  for n in all_sources:
   e=expected(n);assert e and d.manifest_matches(e,cached=True),n;all_artifacts.update(e)
  ar=check('original-types-axioms',['/usr/bin/time','-l','/Users/tp/.elan/bin/lake','env','lean',str(audit)])
  assert ar['exit']==0 and not ar['timed_out'],'Original type/axiom audit failed'
  assert d.closure(f'SmallPairGraphData{a.graph}')==all_sources and sha(audit)==ah and d.manifest_matches(all_artifacts,cached=True) and d.manifest_matches(d.static)
  save(G/'VERIFICATION_SUMMARY.json',{'status':'SCOPED_VERIFICATION_PASS','utc':utc(),'graph':a.graph,'endpoint':f'SmallPairGraphData{a.graph}','original_type_checks':69,'source_closure':all_sources,'artifacts':all_artifacts,'configuration':d.static,'audit_sha256':ah,'audit':ar,'kernel_replayed_modules':done,'complete_original_tails':True,'both_mutation_signs_and_global_destination_indices':True,'closure_rows':plan['closure_rows'],'main_theorem_complete':False,'root_integration':False})
  print('GRAPH_ENDPOINT_SCOPED_VERIFICATION_PASS '+str(a.graph),flush=True)
except BaseException as e:
 save(run/'FAILURE.json',{'utc':utc(),'type':type(e).__name__,'detail':str(e)});raise
finally:
 if child is not None and child.poll() is None:
  os.killpg(child.pid,signal.SIGTERM)
  try:child.wait(timeout=10)
  except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait()
 save(G/'ACTIVE.json',{'active':False,'utc':utc(),'runner_pid':os.getpid(),'completed_count':len(done),'total':len(plan['build_order'])})
