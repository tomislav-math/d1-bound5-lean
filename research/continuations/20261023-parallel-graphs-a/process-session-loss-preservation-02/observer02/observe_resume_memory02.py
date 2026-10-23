"""Read-only bounded observations; no compiler launches, writes or signals."""
from pathlib import Path
import datetime, hashlib, json, sys, time

OUT=Path('/tmp/d1bound5-second-workspace-incident-graph39-20261023/resume-memory-observation-02')
BUILD=Path('/tmp/d1bound5-verification-20261023/clean-build')
SOURCE=Path('/workspace/scratch/fed64f41ca78/recovery-20261023/source')
CONTROL=Path('/tmp/d1bound5-second-loss-recovery-20261023/CONTROL_RESUME.json')
INVOCATION=Path('/tmp/d1bound5-process-session-loss-20261023/ROOT_RESUME_INVOCATION.json')
EXPECTED_BUILD='2c06f4e3f2014ea78ba92a0b48e5ad92'
EXPECTED_IDENTITY='8f423712a4950a66821d8a82716de9c6e9cbc83ad175d3d54ff8ddf1d47eda39'
OLD_INVOCATION='b93538c3f6114869b1805a3d66079cf0'
MIB=1024**2

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(name,obj):(OUT/name).write_text(json.dumps(obj,sort_keys=True,indent=2)+'\n')
def memory():
 p=Path('/sys/fs/cgroup')
 st=dict((k,int(v)) for k,v in (x.split() for x in (p/'memory.stat').read_text().splitlines()))
 ev=dict((k,int(v)) for k,v in (x.split() for x in (p/'memory.events').read_text().splitlines()))
 return {'floor':sum(st.get(k,0) for k in ('anon','kernel','shmem','file_dirty','file_writeback')),'anon':st.get('anon',0),'kernel':st.get('kernel',0),'current':int((p/'memory.current').read_text()),'events':ev}
def owned_lean_memory():
 result=[]
 for d in Path('/proc').iterdir():
  if not d.name.isdigit():continue
  try:
   argv=[x.decode() for x in (d/'cmdline').read_bytes().split(b'\0') if x]
   if not argv or not argv[0].endswith('/bin/lean') or '-R' not in argv or '-o' not in argv:continue
   if argv[argv.index('-R')+1]!=str(SOURCE) or not argv[argv.index('-o')+1].startswith(str(BUILD/'attempts')+'/'):continue
   st=dict(x.split(':',1) for x in (d/'status').read_text().splitlines() if ':' in x)
   r={'pid':int(d.name),'source':argv[-1]}
   for k in ('VmRSS','VmHWM','VmSize','VmPeak','VmSwap'):
    if k in st:r[k]=int(st[k].strip().split()[0])*1024
   result.append(r)
  except (OSError,ValueError,IndexError,UnicodeDecodeError):continue
 return sorted(result,key=lambda r:r.get('VmRSS',0),reverse=True)

OUT.mkdir(exist_ok=False)
baseline=memory();began=time.monotonic();count=0;peak=baseline;high=0;announced=False
save('START.json',{'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'baseline':baseline,'script_sha256':sha(Path(__file__)),'root_preparation_sha256':sha(INVOCATION),'control_path':str(CONTROL),'control_sha256':sha(CONTROL),'interval_seconds':0.5,'maximum_seconds':1800,'scope':'Read-only sampled global and matching owned-child memory; no proof acceptance or control mutations. Old terminal summary is ignored while root resume initializes.'})
print('RESUME_MEMORY_OBSERVER_READY',flush=True)
state='BOUNDED_OBSERVATION_TIME_EXPIRED';error=None;latest=None;new_invocation=None;milestone=1500;exitcode=0
try:
 with (OUT/'SAMPLES.jsonl').open('x') as f:
  while time.monotonic()-began<1800:
   m=memory();row={'elapsed':round(time.monotonic()-began,3),**m};count+=1
   if m['floor']>peak['floor']:peak=row
   high=high+1 if m['floor']>6656*MIB else 0
   if m['floor']<6144*MIB:announced=False
   if not announced and (m['floor']>7168*MIB or high>=6):
    announced=True;print(json.dumps({'notice':'NEAR7GIB_OR_SUSTAINED_GT6_5GIB','sample':row,'consecutive_high_samples':high}),flush=True)
   if count%10==1:
    if not SOURCE.is_dir():raise FileNotFoundError('Original source root disappeared: '+str(SOURCE))
    latest=json.loads((BUILD/'SUMMARY.json').read_text())
    if latest['build_id']!=EXPECTED_BUILD or latest['identity_hash']!=EXPECTED_IDENTITY:raise ValueError('Observed build identity changed')
    row['build']={k:latest[k] for k in ('status','completed_modules','invocation','active','failed')}
    row['control_sha256']=sha(CONTROL);row['owned_lean_memory']=owned_lean_memory()
    if latest['invocation']!=OLD_INVOCATION:
     if new_invocation is None:
      new_invocation=latest['invocation'];print(json.dumps({'notice':'NEW_RESUME_INVOCATION_OBSERVED','invocation':new_invocation,'completed_modules':latest['completed_modules']}),flush=True)
     elif new_invocation!=latest['invocation']:raise ValueError('A second invocation replaced the monitored resume')
     if latest['completed_modules']//500*500>milestone:
      milestone=latest['completed_modules']//500*500;print(json.dumps({'notice':'ACCEPTED_COUNT_MILESTONE','count':latest['completed_modules'],'active':latest['active']}),flush=True)
   f.write(json.dumps(row,sort_keys=True)+'\n');f.flush()
   if latest and new_invocation and not latest['active'] and latest['status'] not in ('RUNNING','WAITING_FOR_MEMORY'):
    state='BUILD_TERMINAL_SUMMARY_OBSERVED';break
   time.sleep(0.5)
except (OSError,ValueError,KeyError) as e:
 state='OBSERVATION_INPUT_FAILURE_RECORDED';error={'type':type(e).__name__,'repr':repr(e)};exitcode=2
finally:
 try:ending=memory()
 except (OSError,ValueError) as e:ending={'error':repr(e)}
 result={'status':state,'error':error,'samples_attempted':count,'seconds':time.monotonic()-began,'baseline':baseline,'ending':ending,'peak_floor_sample':peak,'new_invocation':new_invocation,'last_observed_build':latest,'observer_exit_code':exitcode,'oom_deltas':{k:ending.get('events',{}).get(k,baseline['events'].get(k,0))-baseline['events'].get(k,0) for k in ('oom','oom_kill','oom_group_kill')},'limitations':'Sampled observations only. Individual RSS is never summed. No hard memory bound, actual driver exit, source-build completion acceptance, audit or kernel claim.'}
 save('SUMMARY.json',result)
 print(json.dumps({k:result[k] for k in ('status','error','samples_attempted','seconds','new_invocation','observer_exit_code','oom_deltas')},sort_keys=True),flush=True)
sys.exit(exitcode)
