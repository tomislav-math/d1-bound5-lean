#!/usr/bin/env python3
"""Passive bounded observation only. Never signals processes or edits build/control."""
from pathlib import Path
import collections, hashlib, json, os, time, types
B=Path('/workspace/scratch/fed64f41ca78');O=B/'lean-offload/tail-cap3-observation';build=B/'clean-build'
def read(p):return json.loads(p.read_text())
def save(n,v):(O/n).write_text(json.dumps(v,indent=2,sort_keys=True)+'\n')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def stats(p):return {x.split()[0]:int(x.split()[1]) for x in p.read_text().splitlines()}
def utc():return time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())
p=B/'lean-offload/balance-pulse-proposal/balance_pulse.py';assert sha(p)=='598ef0b13c4d20a71fc54e608859148b873aa6c483898bdfc40738a788612631'
m=types.ModuleType('tail_sampler');m.__file__=str(p);exec(compile(p.read_bytes(),str(p),'exec'),m.__dict__)
sl=B/'lean-offload/CLEAN_SOURCE_LOCK.json';assert sha(sl)=='b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c'
deps,kinds=m.graph(read(sl),read(B/'lean-offload/FRESH_COST_HINTS_V2.json'))
origin=read(build/'ORIGIN.json');expected_invocation='929db4e315db4a22aac28e8fd8dd230c';deadline=time.monotonic()+1200;history=[]
def summary():
 s=read(build/'SUMMARY.json');assert s['build_id']==origin['build_id'] and s['identity_hash']==origin['identity_hash']
 assert s['invocation']==expected_invocation,'Invocation changed; root review needed'
 return s
while True:
 s=summary();remaining=collections.Counter(kinds[n] for n in s['waiting']+s['active']);active=collections.Counter(kinds[n] for n in s['active'])
 row={'utc':utc(),'completed':s['completed_modules'],'remaining':dict(remaining),'active_slots':dict(active),'summary_status':s['status'],'failed':s['failed']};history.append(row)
 if s['failed'] or s['status'] not in ['RUNNING','WAITING_FOR_MEMORY']:
  save('RESULT.json',{'status':'BUILD_STOPPED_OR_FINISHED_BEFORE_TAIL_TRIGGER','last':row,'history':history});print('No sample: build stopped/finished',flush=True);raise SystemExit(0)
 if remaining['pure']<=10 and active['pure']<=2:
  save('TRIGGER.json',{'status':'TAIL_PHASE_TRIGGERED','last':row,'history':history,'criteria':{'remaining_pure_at_most':10,'active_pure_slots_at_most':2},'source_lock_sha256':sha(sl),'origin_sha256':sha(build/'ORIGIN.json')});print(json.dumps(row),flush=True);break
 save('STATUS.json',{'status':'PASSIVE_WAIT_FOR_PURE_TAIL','last':row,'poll_seconds':10,'maximum_wait_seconds':1200})
 if time.monotonic()>=deadline:
  save('RESULT.json',{'status':'TAIL_TRIGGER_TIMEOUT_NO_SAMPLE','history':history});print('Trigger timeout',flush=True);raise SystemExit(0)
 time.sleep(10)
started=time.time();mono=time.monotonic();cpu_path=Path('/sys/fs/cgroup/cpu.stat');event_path=Path('/sys/fs/cgroup/memory.events');cpu0=stats(cpu_path);events0=stats(event_path);samples=[];private_denied=False
while time.monotonic()-mono<60:
 s=summary();rows=[]
 for name in os.listdir('/proc'):
  if not name.isdigit():continue
  q=Path('/proc')/name
  try:
   argv=(q/'cmdline').read_bytes().split(b'\0')
   if not argv or argv[0]!=str(B/'lean-offload/lean-4.33.1-linux/bin/lean').encode():continue
   paths=[x.decode() for x in argv if x.startswith(str(B/'clean-checkout').encode()+b'/') and x.endswith(b'.lean')]
   if not paths:continue
   n=paths[-1].split('/clean-checkout/')[1][:-5].replace('/','.')
   st={x.split(':',1)[0]:x.split(':',1)[1].strip() for x in (q/'status').read_text().splitlines() if ':' in x}
   vals={k:int(st[k].split()[0]) for k in ['VmHWM','VmRSS','RssAnon','RssFile','RssShmem'] if k in st}
   if not private_denied:
    try:
     sm=(q/'smaps_rollup').read_text();vals['private_kib']=sum(int(x.split()[1]) for x in sm.splitlines() if x.startswith(('Private_Clean:','Private_Dirty:')))
    except PermissionError:private_denied=True
   rows.append({'pid':int(name),'module':n,'kind':kinds[n],'kib':vals})
  except (OSError,KeyError,ValueError):pass
 accepted=set(s['compiled_this_invocation']+s['validated_passes_from_prior_invocations']);ready=[n for n in s['waiting'] if deps[n]<=accepted];observed_names={r['module'] for r in rows}
 st=stats(Path('/sys/fs/cgroup/memory.stat'));cg={k:st[k] for k in ['anon','kernel','file_dirty','file_writeback','file']};cg['nonreclaimable']=sum(cg[k] for k in ['anon','kernel','file_dirty','file_writeback'])
 samples.append({'epoch':time.time(),'completed':s['completed_modules'],'summary_age_seconds':time.time()-(build/'SUMMARY.json').stat().st_mtime,'remaining':dict(collections.Counter(kinds[n] for n in s['waiting']+s['active'])),'active_scheduler_slots':dict(collections.Counter(kinds[n] for n in s['active'])),'active_slot_modules':s['active'],'active_slots_without_observed_compiler':sorted(set(s['active'])-observed_names),'actual_compilers':dict(collections.Counter(r['kind'] for r in rows)),'ready_waiting':dict(collections.Counter(kinds[n] for n in ready)),'processes':rows,'cgroup_bytes':cg,'cpu_stat':stats(cpu_path),'failed':s['failed'],'summary_status':s['status']})
 if s['failed'] or s['status'] not in ['RUNNING','WAITING_FOR_MEMORY']:break
 time.sleep(.5)
duration=time.monotonic()-mono;cpu1=stats(cpu_path);events1=stats(event_path)
r={'status':'TAIL_CAP3_PASSIVE_OBSERVATION_COMPLETE','started_epoch':started,'finished_epoch':time.time(),'duration_seconds':duration,'invocation':expected_invocation,'samples':samples,'cpu_stat_delta':{k:cpu1[k]-cpu0[k] for k in cpu0},'average_cgroup_cpu_cores':(cpu1['usage_usec']-cpu0['usage_usec'])/1e6/duration,'memory_events_delta':{k:events1[k]-events0[k] for k in events0},'smaps_rollup_access_denied':private_denied,'interpretation':'A scheduler slot without an observed Lean process may be in source/dependency/runtime guards, launching, or between process completion and collection; snapshots are not atomic. RssAnon is not exact private RSS. No control/source/artifact edits or process signals.'}
save('RAW_OBSERVATIONS.json',r);print(json.dumps({'status':r['status'],'samples':len(samples),'average_cgroup_cpu_cores':r['average_cgroup_cpu_cores'],'events':r['memory_events_delta']}),flush=True)
