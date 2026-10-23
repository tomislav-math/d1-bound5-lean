#!/usr/bin/env python3
"""Short supplementary phase sample using RUNNING receipts, not stale SUMMARY slots."""
from pathlib import Path
import json,time,os,types
B=Path('/workspace/scratch/fed64f41ca78');O=B/'lean-offload/tail-cap3-observation';build=B/'clean-build';inv='929db4e315db4a22aac28e8fd8dd230c'
p=B/'lean-offload/balance-pulse-proposal/balance_pulse.py';m=types.ModuleType('slot_sample');m.__file__=str(p);exec(compile(p.read_bytes(),str(p),'exec'),m.__dict__);deps,kinds=m.graph(json.loads((B/'lean-offload/CLEAN_SOURCE_LOCK.json').read_text()),json.loads((B/'lean-offload/FRESH_COST_HINTS_V2.json').read_text()))
rows=[];last_running=set();end=time.monotonic()+15
while time.monotonic()<end:
 s=json.loads((build/'SUMMARY.json').read_text());assert s['invocation']==inv and not s['failed']
 accepted=set(s['compiled_this_invocation']+s['validated_passes_from_prior_invocations']);ready={n for n in s['waiting'] if deps[n]<=accepted};actual=set()
 for name in os.listdir('/proc'):
  if not name.isdigit():continue
  try:
   argv=(Path('/proc')/name/'cmdline').read_bytes().split(b'\0')
   if not argv or argv[0]!=str(B/'lean-offload/lean-4.33.1-linux/bin/lean').encode():continue
   paths=[x.decode() for x in argv if x.startswith(str(B/'clean-checkout').encode()+b'/') and x.endswith(b'.lean')]
   if paths:actual.add(paths[-1].split('/clean-checkout/')[1][:-5].replace('/','.'))
  except OSError:pass
 candidates=ready|set(s['active'])|actual|last_running;running=set()
 for n in candidates:
  path=build/'attempts'/n
  if not path.exists():continue
  for receipt in path.glob('*/receipt.json'):
   try:
    r=json.loads(receipt.read_text())
    if r.get('invocation')==inv and r.get('status')=='RUNNING':running.add(n)
   except (OSError,ValueError):pass
 rows.append({'epoch':time.time(),'completed':s['completed_modules'],'running_receipt_modules':sorted(running),'actual_lean_modules':sorted(actual),'running_without_observed_lean':sorted(running-actual),'actual_without_running_snapshot':sorted(actual-running),'ready_waiting_mathlib':sum(kinds[n]=='mathlib' for n in ready),'remaining_pure':sum(kinds[n]=='pure' for n in s['waiting']+s['active'])});last_running=running;time.sleep(.5)
(O/'RUNNING_RECEIPT_SLOT_SAMPLE.json').write_text(json.dumps({'status':'READ_ONLY_RUNNING_RECEIPT_SLOT_SAMPLE_COMPLETE','samples':rows,'limitation':'Receipt/process snapshots are sequential, not atomic. RUNNING without observed Lean includes guards, launch and completion transitions; no private phase instrumentation was added.'},indent=2,sort_keys=True)+'\n');print(len(rows),flush=True)
