#!/usr/bin/env python3
"""Read-only verification of cap5 resume, then a bounded 60-second resource sample."""
from pathlib import Path
import hashlib,json,os,time,types
B=Path('/workspace/scratch/fed64f41ca78');O=B/'lean-offload/resource-transition-mathlib5';build=B/'clean-build'
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def read(p):return json.loads(p.read_text())
def save(p,v):p.write_text(json.dumps(v,indent=2,sort_keys=True)+'\n')
prepared=read(O/'PREPARED_TRANSITION.json');old=read(O/'DRAINED_SUMMARY.json')
assert h(O/'DRAINED_SUMMARY.json')=='1fc10c0842024d514945f2794f08265cfa0cc94629070f7f83454f3c0e2a8e79'
assert old['completed_modules']==3564 and old['failed']==[] and old['active']==[]
old_names=set(old['compiled_this_invocation']+old['validated_passes_from_prior_invocations']);assert len(old_names)==3564
end=time.monotonic()+600
while True:
 s=read(build/'SUMMARY.json')
 if s['invocation']!=old['invocation']:break
 assert time.monotonic()<end,'New invocation did not start within bounded ten-minute observer wait'
 time.sleep(2)
assert s['status'] in ['RUNNING','WAITING_FOR_MEMORY','PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'] and not s['failed']
inv=build/'invocations'/s['invocation']; rv=read(inv/'RESUME_VALIDATION.json');start=read(inv/'START.json')
assert len(rv['accepted'])==3564 and set(rv['accepted'])==old_names and rv['rejected']==[]
assert start['reservation_budget'] >= 5500*1048576, 'Actual reservation budget does not admit five normal Mathlib slots'
assert set(start['reused'])==old_names and start['jobs']==7 and start['hints_sha256']==prepared['pins']['FRESH_COST_HINTS_V2.json']
assert s['identity_hash']==prepared['identity_hash'] and s['build_id']==prepared['build_id']
assert h(build/'ORIGIN.json')==prepared['origin_sha256']
sl=read(B/'lean-offload/CLEAN_SOURCE_LOCK.json')
for n in sorted(old_names):
 ptr=read(build/'accepted'/Path(*n.split('.')).with_suffix('.json'));path=build/ptr['receipt_path'];assert path.resolve().is_relative_to((build/'attempts').resolve())
 assert h(path)==ptr['receipt_sha256'];row=read(path)
 assert row['module']==n and row['status']=='COMPILE_PASS' and row['exit_code']==0
 assert row['source_sha256']==sl['sources'][n]['sha256'] and row['identity_hash']==prepared['identity_hash'] and row['build_id']==prepared['build_id']
observed=[]
for name in os.listdir('/proc'):
 if not name.isdigit():continue
 try:
  a=[x.decode() for x in (Path('/proc')/name/'cmdline').read_bytes().split(b'\0') if x]
  if a==prepared['preferred_new_argv']:observed.append(int(name))
 except (OSError,UnicodeError):pass
assert len(observed)==1,observed
verification={'status':'INDEPENDENT_RESUME_REVALIDATION_PASS','utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'new_invocation':s['invocation'],'runner_pid_snapshot':observed[0],'observed_argv_exactly_matches_prepared':True,'actual_START_budget_mib':start['reservation_budget']/1048576,'actual_START_baseline_mib':start['memory_snapshot']['nonreclaimable']/1048576,'five_slots_5500_mib_admitted_by_budget':True,'accepted':3564,'rejected':0,'exact_old_drained_set_matches':True,'all_3564_pointer_receipt_hash_source_identity_status_checks':True,'artifact_rehash_performed_by_this_observer':False,'artifact_revalidation_performed_by_unchanged_builder':True,'build_id':s['build_id'],'identity_hash':s['identity_hash'],'resume_validation_sha256':h(inv/'RESUME_VALIDATION.json'),'start_sha256':h(inv/'START.json'),'drained_summary_sha256':h(O/'DRAINED_SUMMARY.json'),'prepared_transition_sha256':h(O/'PREPARED_TRANSITION.json'),'no_control_source_or_artifact_mutations':True,'proof_completion_claim':False}
save(O/'INDEPENDENT_RESUME_VERIFICATION.json',verification);print(json.dumps(verification),flush=True)
p=B/'lean-offload/balance-pulse-proposal/balance_pulse.py';m=types.ModuleType('sampler');m.__file__=str(p);exec(compile(p.read_bytes(),str(p),'exec'),m.__dict__);deps,kinds=m.graph(sl,read(B/'lean-offload/FRESH_COST_HINTS_V2.json'))
def cpu():return {x.split()[0]:int(x.split()[1]) for x in Path('/sys/fs/cgroup/cpu.stat').read_text().splitlines()}
def events():return {x.split()[0]:int(x.split()[1]) for x in Path('/sys/fs/cgroup/memory.events').read_text().splitlines()}
started=time.time();mono=time.monotonic();deadline=mono+60;cpu0=cpu();events0=events();samples=[];private_denied=False
while time.monotonic()<deadline:
 rows=[]
 for name in os.listdir('/proc'):
  if not name.isdigit():continue
  q=Path('/proc')/name
  try:
   argv=(q/'cmdline').read_bytes().split(b'\0')
   if not argv or argv[0]!=str(B/'lean-offload/lean-4.33.1-linux/bin/lean').encode():continue
   paths=[x.decode() for x in argv if x.startswith(str(B/'clean-checkout/').encode()+b'/') and x.endswith(b'.lean')]
   if not paths:continue
   n=paths[-1].split('/clean-checkout/')[1][:-5].replace('/','.')
   st={x.split(':',1)[0]:x.split(':',1)[1].strip() for x in (q/'status').read_text().splitlines() if ':' in x}
   vals={k:int(st[k].split()[0]) for k in ['VmHWM','VmRSS','RssAnon','RssFile','RssShmem'] if k in st}
   if not private_denied:
    try:sm=(q/'smaps_rollup').read_text();vals['private_kib']=sum(int(x.split()[1]) for x in sm.splitlines() if x.startswith(('Private_Clean:','Private_Dirty:')))
    except PermissionError:private_denied=True
   rows.append({'pid':int(name),'module':n,'kind':kinds[n],'kib':vals})
  except (OSError,KeyError,ValueError):pass
 st={x.split()[0]:int(x.split()[1]) for x in Path('/sys/fs/cgroup/memory.stat').read_text().splitlines()};cg={k:st[k] for k in ['anon','kernel','file_dirty','file_writeback','file']};cg['nonreclaimable']=sum(cg[k] for k in ['anon','kernel','file_dirty','file_writeback'])
 samples.append({'epoch':time.time(),'processes':rows,'cgroup_bytes':cg,'cpu_stat':cpu()});time.sleep(.5)
duration=time.monotonic()-mono;cpu1=cpu();events1=events()
r={'status':'READ_ONLY_CAP5_OBSERVATIONS','started_epoch':started,'finished_epoch':time.time(),'duration_seconds':duration,'new_invocation':s['invocation'],'samples':samples,'cpu_stat_delta':{k:cpu1[k]-cpu0[k] for k in cpu0},'average_cpu_cores':(cpu1['usage_usec']-cpu0['usage_usec'])/1e6/duration,'memory_events_delta':{k:events1[k]-events0[k] for k in events0},'smaps_rollup_access_denied':private_denied,'interpretation':'RssAnon is measured anonymous resident memory, not exact private RSS. VmHWM includes shared file pages; sample maxima can miss short lifetime peaks. No control/source/artifact writes.'}
save(O/'CAP5_MEMORY_CPU_OBSERVATIONS.json',r);print(json.dumps({'samples':len(samples),'average_cpu_cores':r['average_cpu_cores'],'memory_events_delta':r['memory_events_delta']}),flush=True)
