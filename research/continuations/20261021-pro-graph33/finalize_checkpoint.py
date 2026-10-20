"""Finalize this proof checkpoint after all real checks pass. No Git mutations."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl, hashlib, importlib.util, json, os, subprocess, sys

ROOT=Path('/Users/tp/Lean/D1Bound5')
WORK=ROOT/'research/continuations/20261018T010800CEST-main-continuation'
RUN=ROOT/'research/continuations/20261020T100000CEST-work-resume'
OUT=Path(__file__).resolve().parent
AUDIT=RUN/'pro-graph33-audit'
BASE='61898e5136b6ac2c10b4b2f17c6cdb5ed7972e0e'
TARGETS=['SmallPairGraphClosure33Chunk04','SmallPairGraphClosure33Chunk05',
         'SmallPairGraphClosure33Coverage','SmallPairGraphClosure33','SmallPairGraphData33']
def read(p):return json.loads(Path(p).read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def digest(x):return hashlib.sha256(json.dumps(x,sort_keys=True,separators=(',',':')).encode()).hexdigest()
def save(p,x):Path(p).write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
def unit(n):return OUT/'coverage-projection' if n=='SmallPairGraphClosure33Coverage' else OUT
def git(*args):return subprocess.run(['git',*args],cwd=ROOT,text=True,capture_output=True,check=True,timeout=30).stdout.strip()
spec=importlib.util.spec_from_file_location('d1_pro_final_driver',WORK/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (WORK/'continuation-driver.lock').open('r+') as owner,(WORK/'continuation-intake.lock').open('r+') as intake:
 for f in [owner,intake]:fcntl.flock(f,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('rev-parse','HEAD')==BASE and git('branch','--show-current')=='main'
 assert not git('diff','--cached','--name-only'), 'Another staged snapshot appeared'
 assert not read(WORK/'continuation-active.json').get('active')
 final=read(AUDIT/'BOUND_AUDIT_FINAL.json')
 assert final['status']=='BOUND_SCOPED_AUDIT_PASS'
 assert not read(AUDIT/'active-targeted-replay.json')['active']
 checks=read(AUDIT/'TARGETED_REPLAY_RECEIPTS.json')
 expected=['analytic-type-axioms']+[n+'-targeted-replay' for n in TARGETS[:-1]]
 assert [x['label'] for x in checks]==expected
 assert all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] and not x['binding_drift_paths'] for x in checks)
 audit_log=(AUDIT/'analytic-type-axioms.log').read_text()
 assert audit_log.count('GRAPH33_AXIOMS_PASS ')==5
 assert 'Unexpected axioms' not in audit_log
 d=mod.Driver(ROOT,WORK);latest=d.latest()
 closure=d.closure('SmallPairGraphData33')
 archived=read(OUT/'SOURCE_MAP.json')
 evidence=read(OUT/'ACCEPTED_DEPENDENCY_EVIDENCE.json')
 assert set(closure)==set(archived['sources'])==set(evidence)
 for n,h in closure.items():
  assert sha(ROOT/'D1Bound5'/(n+'.lean'))==h==archived['sources'][n]['sha256']
  assert mod.fingerprint(d.closure(n))==evidence[n]['fingerprint']
  assert d.artifacts(n)==evidence[n]['artifacts']
 assert d.manifest_matches(read(OUT/'CONFIGURATION.json'))
 builds={}
 for n in TARGETS:
  row=read(unit(n)/(n+'-BUILD_RECEIPT.json'))
  assert row['accepted_build'] and row['exit']==0 and not row['timed_out'] and not row['interrupted']
  assert row['closure_unchanged'] and row['shared_artifacts_unchanged']
  assert row['fingerprint']==evidence[n]['fingerprint'] and row['artifacts']==evidence[n]['artifacts']
  assert sha(unit(n)/(n+'.lean'))==row['source_sha256']==closure[n]
  builds[n]=row
  archived['sources'][n]['assurance']=('guarded_build_exact_public_types_axioms_targeted_same_kernel_replay'
    if n in TARGETS[:-1] else 'guarded_build_import_only_aggregate_no_new_declarations')
 ps=subprocess.run(['ps','-axo','pid=,ppid=,comm=,args='],text=True,capture_output=True,check=True,timeout=10).stdout
 live=[]
 for line in ps.splitlines():
  fields=line.strip().split(None,3)
  if len(fields)<4 or int(fields[0])==os.getpid():continue
  pid,_,exe,cmd=fields
  if Path(exe).name in ('lean','lake','leanchecker'):
   cwd=subprocess.run(['/usr/sbin/lsof','-a','-p',pid,'-d','cwd','-Fn'],text=True,capture_output=True,timeout=10).stdout
   if any(s=='n'+str(ROOT) or s.startswith('n'+str(ROOT)+'/') for s in cwd.splitlines()):live.append({'pid':int(pid),'command':cmd})
 assert not live, 'Project compiler is live'
 known=read(ROOT/'research/continuations/20261020-completed-checkpoint/STATUS.json')['accepted_graph_endpoints']
 cache={};endpoint_status={}
 for i in sorted(set(known+[33])):
  n='SmallPairGraphData'+str(i);c=d.closure(n,source_cache=cache)
  manifest=d.expected_manifest(n,mod.fingerprint(c),latest)
  endpoint_status[str(i)]=bool(manifest and d.artifacts(n)==manifest)
 assert all(endpoint_status.values())
 next_name='RationalTripleExclusion'
 next_plan=RUN/'repair-rational-triple-exclusion-wave25.json'
 plan=read(next_plan);preimage=plan['targets'][0]['source_sha256']
 assert sha(ROOT/'D1Bound5'/(next_name+'.lean'))==preimage
 assert not (RUN/'repair-rational-triple-exclusion-wave25-APPLIED.json').exists()
 q=read(WORK/'continuation-queue.json');nc=d.closure(next_name)
 assert next_name in q['names'] and not set(nc).intersection(q.get('blocked_modules',[]))
 for dep in set(nc)-{next_name}:
  m=d.expected_manifest(dep,mod.fingerprint(d.closure(dep)),latest)
  assert m and d.artifacts(dep)==m, 'Next dependency is not currently accepted: '+dep
 next_command='/Users/tp/.local/bin/python3.12 -B '+str(RUN/'apply_reviewed_patch.py')+' '+str(next_plan)
 names=read(AUDIT/'DECLARATION_NAMES.json')
 build_keys={n:{'source_closure':builds[n]['fingerprint'],
   'olean':builds[n]['artifacts']['.lake/build/lib/lean/D1Bound5/'+n+'.olean']} for n in TARGETS}
 audit_state={'harness_sha256':sha(AUDIT/'AnalyticAudit.lean'),'declarations':names,
   'allowed_transitive_axioms':['propext','Classical.choice','Quot.sound'],'exact_type_axiom_exit':0,
   'targets':{n:{**build_keys[n],'targeted_replay_exit':0,'guards_unchanged':True} for n in TARGETS[:-1]}}
 state={'sorted_source_hashes':[[n,closure[n]] for n in sorted(closure)],
   'configuration_hashes':d.static,'accepted_build_fingerprints':build_keys,'accepted_audit_fingerprint':digest(audit_state)}
 fingerprint=digest(state)
 save(OUT/'SOURCE_MAP.json',archived)
 save(OUT/'PROGRESS_FINGERPRINT_INPUT.json',state)
 save(OUT/'AUDIT_FINGERPRINT_INPUT.json',audit_state)
 save(OUT/'PROGRESS_FINGERPRINT.json',{'sha256':fingerprint,'prefix12':fingerprint[:12],
   'encoding':'SHA-256 of UTF-8 JSON with sorted keys and compact separators',
   'excludes':['timestamps','PIDs','durations','report-only changes']})
 summary={'utc':datetime.now(timezone.utc).isoformat(),'main_theorem_complete':False,'root_integration':False,
  'new_guarded_builds':{n:{k:builds[n][k] for k in ['exit','seconds','source_sha256','fingerprint']} for n in TARGETS},
  'exact_original_public_type_and_axiom_checks':5,'targeted_installed_same_kernel_replays':4,
  'source_closure_modules':len(closure),'reused_dependency_modules':len(closure)-len(TARGETS),
  'current_matching_graph_endpoints':endpoint_status,'graph_endpoint_count':len(endpoint_status),
  'graph_total':48,'fresh_whole_root_replay':False,'independent_semantic_review':False,
  'compiler_processes':live,'locks_were_free':True,'publication':'PREPARED_NOT_YET_COMMITTED_OR_PUSHED',
  'preparation_head':BASE,'next_unit':next_name,'next_patch_sha256':sha(next_plan),
  'next_source_sha256':preimage,'next_exact_command':next_command,'progress_fingerprint':fingerprint}
 save(OUT/'VERIFICATION_SUMMARY.json',summary)
 (OUT/'README.md').write_text('# Graph 33 accepted working checkpoint\n\n'
  'Five current working modules passed guarded compilation. The two remaining prefix\n'
  'certificates, structural coverage proof and original closure parent are archived\n'
  'with exact original build receipts. Data33 is an import-only aggregate.\n\n'
  'The original coverage decision timed out at 240 seconds. That failed attempt is\n'
  'preserved at this directory root. The accepted changed proof and its receipts\n'
  'are under coverage-projection/. The statement and all numerical data are unchanged.\n\n'
  'Five exact original public statements passed the transitive-axiom audit and four\n'
  'concrete-proof modules passed targeted installed SAME-kernel replay. Audit records\n'
  'are in ../20261020T100000CEST-work-resume/pro-graph33-audit/.\n\n'
  'SOURCE_MAP.json reconstructs the 83-module accepted source closure using five\n'
  'new payloads and 78 exact prior Git/source references. No proof objects are saved.\n'
  'TOOLS_MAP.json preserves exact reviewed guard-tool sources without changing them.\n\n'
  'There are now 21 matching accepted graph endpoint modules out of 48. These are\n'
  'module counts, not counts of mathematical results. MainTheorem, OneSmallImpossible,\n'
  'accepted-root integration and final whole-project gates remain unfinished.\n'
  'No independent semantic review or fresh whole-root replay is claimed here.\n\n'
  'VERIFICATION_SUMMARY.json is a preparation record. Successful publication is\n'
  'established separately by the post-push receipt and the current handoff.\n')
 (ROOT/'records/PRO_CONTINUATION_HANDOFF.md').write_text('# Pro continuation handoff\n\n'
  'Main theorem UNPROVED. No new canonical root integration.\n'
  'Completed unit: graph 33, with five guarded successful builds, five exact original\n'
  'public-type/transitive-axiom checks and four targeted installed SAME-kernel replays.\n'
  'Twenty-one of 48 graph endpoint modules have matching accepted current states.\n\n'
  'Evidence: research/continuations/20261021-pro-graph33/VERIFICATION_SUMMARY.json,\n'
  'SOURCE_MAP.json, original build receipts and coverage-projection/.\n'
  'Audit: research/continuations/20261020T100000CEST-work-resume/pro-graph33-audit/.\n'
  'The original Coverage timeout remains failed; only its structural replacement passed.\n'
  'No compiler or audit owner remains. Both locks were verified free.\n\n'
  'Publication pending for this prepared checkpoint. Preparation HEAD: '+BASE+'.\n'
  'Next unit: apply the reviewed two-site numeral-coercion repair to\n'
  'RationalTripleExclusion, then perform one guarded build and exact scoped checks.\n'
  'Its current preimage and accepted dependencies were revalidated.\n'
  'After the mandatory new-turn access/ownership inspection, next exact command:\n'+next_command+'\n')
 print(json.dumps({'status':'CHECKPOINT_VERIFIED_READY_FOR_EXPLICIT_GIT_REVIEW','graph_endpoints':len(endpoint_status),
  'fingerprint':fingerprint,'next_unit':next_name,'compiler_processes':live}))
