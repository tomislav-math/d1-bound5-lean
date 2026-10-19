"""Finalize this bounded unit only from actual guarded compiler/audit receipts.
Read-only Git inspection only. No commits, pushes, or queue changes.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,shutil,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
rid=out.name
targets=['UnitPairCubicNumeric','UnitPairCubic','UnitPairCubicIteration','UnitPairFirstExtensionBound']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_cubic_final',work/'continuation_driver_capacity.py')
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=m.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
 q,n,cl,ac,un,el=driver.snapshot();assert not un and q['max_parallel']==1 and q['pause_after_current'];assert all(t in ac for t in targets)
 checks=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text());assert len(checks)==5 and all(x['exit']==0 and x['guards_unchanged'] and not x['timed_out'] for x in checks)
 audit=(out/'unit-pair-type-axioms.log').read_text();assert audit.count('UNIT_PAIR_AXIOMS_PASS')==10 and 'sorryAx' not in audit and 'error:' not in audit
 guards=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text());assert all(sha(root/'D1Bound5'/(t+'.lean'))==h for t,h in guards['project_sources'].items());assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
 source_map={};header_review={}
 def headers(text):return {x.group(1):x.group(0).split(':=')[0].strip() for x in re.finditer(r'^(?:private\s+)?theorem\s+(\S+)[\s\S]*?:=\s*by',text,re.M)}
 for t in targets:
  src=root/'D1Bound5'/(t+'.lean');r=json.loads((out/(t+'-BUILD_RECEIPT.json')).read_text());assert r['exit']==0 and r['accepted_build'] and r['source_sha256']==sha(src) and r['fingerprint']==m.fingerprint(cl[t]);assert r['closure_unchanged'] and r['shared_artifacts_unchanged']
  assert headers(src.read_text())==headers((out/(t+'.before.lean')).read_text()),t
  assert re.findall(r'^import .+$',src.read_text(),re.M)==re.findall(r'^import .+$',(out/(t+'.before.lean')).read_text(),re.M)
  header_review[t]=len(headers(src.read_text()));shutil.copyfile(src,out/(t+'.lean'));shutil.copyfile(r['log'],out/(t+'-build.log'))
  (out/(t+'-SOURCE_CLOSURE.json')).write_text(json.dumps(cl[t],indent=2)+'\n')
  source_map[t]={'working_source':str(src.relative_to(root)),'preserved_copy':str((out/(t+'.lean')).relative_to(root)),'sha256':sha(src),'build_seconds':r['seconds'],'root_integrated':False}
 root_modules=set()
 def root_visit(t):
  if t in root_modules:return
  root_modules.add(t);p=root/'D1Bound5'/(t+'.lean');assert p.exists(),t
  for d in re.findall(r'^(?:public\s+)?import\s+D1Bound5\.(\S+)',p.read_text(),re.M):root_visit(d)
 for t in re.findall(r'^(?:public\s+)?import\s+D1Bound5\.(\S+)',(root/'D1Bound5.lean').read_text(),re.M):root_visit(t)
 for t in targets:source_map[t]['root_integrated']=t in root_modules
 assert not any(t in root_modules for t in targets)
 (out/'SOURCE_MAP.json').write_text(json.dumps(source_map,indent=2)+'\n')
 now=datetime.now().astimezone().isoformat()
 summary={'time':now,'outcome':'COMPLETED_UNIT','public_theorems':10,'private_helpers':1,'modules':targets,'all_original_headers_preserved':header_review,'source_closure_count':len(guards['project_sources']),'pinned_builds_passed':True,'public_type_axioms_passed':True,'allowed_transitive_axioms':['propext','Classical.choice','Quot.sound'],'targeted_same_kernel_replays':[t for t in targets],'full_clean_checkout':False,'independent_final_review':False,'root_integrated':False,'main_statement_proved':False,'source_map':source_map}
 (out/'VERIFICATION_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
 next_names=['UnitPairFieldBound'];next_state={t:{'accepted_current_build':t in ac,'eligible':t in el,'unaccepted_dependencies':[s for s in cl[t] if s!=t and s not in ac],'ready_prerequisites':[s for s in cl[t] if s!=t and s in el]} for t in next_names}
 (out/'NEXT_DEPENDENCIES.json').write_text(json.dumps({'time':now,'unknown':un,'targets':next_state},indent=2)+'\n')
 headline='19 October 2026 — unit-pair cubic growth and first-extension cutoff verified'
 text='Four working modules now prove the full-ring cubic gap, its three-step iteration, and |a_2|<10000 for an actual modulus-ordered D(1)-sextuple with a_0=-1 and a_1=1. Opposite-pair exclusions, nonzero integral forms, signed roots and the all-order Bennett input are derived, not supplied as certificates. All ten original public theorems and one private helper compiled with unchanged statements. Public type/transitive-axiom audit and four targeted installed SAME-kernel replays passed with only propext, Classical.choice and Quot.sound. The cutoff does not exclude the remaining small range. Field/axis reduction, finite Pell certificates, global exclusions, root integration and final whole-project gates remain open. Evidence: research/continuations/'+rid+'/VERIFICATION_SUMMARY.json.'
 for fn in ['STATUS.md','records/open-obligations.md']:
  p=root/fn;s=p.read_text();head,tail=s.split('\n',1);p.write_text(head+'\n\n## '+headline+'\n\n'+text+'\n\n'+tail.lstrip('\n'))
 for fn in ['records/build-record.md','records/paper-to-lean.md']:
  p=root/fn;p.write_text(p.read_text().rstrip()+'\n\n## '+headline+'\n\n'+text+'\n')
 (out/'README.md').write_text('# Unit-pair cubic growth and first-extension cutoff\n\nCOMPLETED_UNIT for the four separately verified working modules. See MATHEMATICS.md, VERIFICATION_SUMMARY.json, exact types and compiler/kernel logs. Original failed attempts are retained with FAILED labels. No root integration or MainStatement proof. Source copies must not be imported alongside the canonical working modules.\n\nThe author explicitly requested shortening the existing hourly task during this invocation. The verified update used exactly `Nastavi rad na formalizaciji.` and retained hourly :15 Europe/Zagreb. No other task changed. This is not proof of future scheduled execution.\n')
 (root/'records/runs'/(rid+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+text+'\n\nAll owned proof/check processes have completed; their tool PIDs must be collected before final reporting. The queue stays paused between bounded jobs and the inherited staged record is preserved. The authorized hourly-task simplification is separately recorded in AUTOMATION_UPDATE.json. No frozen source or pins changed. Ordinary reviewed Git synchronization follows in separate calls; this pre-commit FINISH does not claim a push.\n')
 print('FINALIZED',now,'10 public theorems;',len(guards['project_sources']),'source dependencies')
 print('NEXT',json.dumps(next_state))
