"""Preserve reviewed proof sources and prepare an explicit private save scope.
All Git calls here are read-only. Staging, commit and push are separate commands.
"""
from pathlib import Path
from datetime import datetime
import hashlib,json,re,runpy,subprocess,fcntl,importlib.util,sys
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
prefix='20261018T205247CEST-mixed-bridge'
targets=['CoherentRetainedMixedSizes','CoherentRetainedMixedForms','CoherentRetainedMixedGap']
sha=lambda b:hashlib.sha256(b).hexdigest()
def git(*args):
 return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
with (work/'continuation-driver.lock').open('a+') as owner, (work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 assert git('branch','--show-current').decode().strip()=='main'
 active=json.loads((work/'continuation-active.json').read_text())
 assert not active.get('active') and not active.get('protected_closure')
 checks=json.loads((out/'CHECK_RECEIPTS.json').read_text())
 assert len(checks)==4 and all(c['exit']==0 and not c['timed_out'] and c['guards_unchanged'] for c in checks)
 guards=json.loads((out/'CHECK_GUARDS.json').read_text())
 for name,digest in guards['sources'].items(): assert sha((root/'D1Bound5'/(name+'.lean')).read_bytes())==digest
 for rel,digest in {**guards['artifacts'],**guards['static']}.items(): assert sha((root/rel).read_bytes())==digest
 type_log=(out/'types-axioms.log').read_text()
 assert type_log.count('MIXED_BRIDGE_AXIOMS_PASS')==6 and 'sorryAx' not in type_log
 builds={}
 for name in targets:
  row=json.loads(max(out.glob(name+'-*-BUILD.json'),key=lambda p:p.stat().st_mtime).read_text())
  assert row['accepted_build'] and row['exit']==0 and row['source_sha256']==guards['sources'][name]
  builds[name]=row
  (out/(name+'.lean')).write_bytes((root/'D1Bound5'/(name+'.lean')).read_bytes())
 before=(out/'CoherentRetainedMixedGap-before-repair.lean').read_text()
 replacement='  refine ⟨hret, ?_⟩\n  change A^2*P^5/S^2 < C\n  simpa only [one_mul] using hh.trans hret'
 assert (out/'CoherentRetainedMixedGap.lean').read_text()==before.replace('  exact ⟨hret,(by simpa only [one_mul] using hh).trans hret⟩',replacement)
 def strip_comments(s):
  result=[];i=0;depth=0
  while i<len(s):
   if s[i:i+2]=='/-':depth+=1;i+=2
   elif depth and s[i:i+2]=='-/':depth-=1;i+=2
   elif depth:i+=1
   elif s[i:i+2]=='--':
    j=s.find('\n',i);i=len(s) if j<0 else j
   else:result.append(s[i]);i+=1
  assert depth==0
  return ''.join(result)
 findings=[]
 for name in guards['sources']:
  source=strip_comments((root/'D1Bound5'/(name+'.lean')).read_text())
  for pattern in [r'\b(sorry|admit|sorryAx|native_decide)\b',r'^\s*(?:private\s+|protected\s+)?axiom\b',r'\b(unsafe|implemented_by|extern)\b']:
   if re.search(pattern,source,re.M): findings.append({'module':name,'pattern':pattern})
 assert not findings,findings
 spec=importlib.util.spec_from_file_location('mixed_next_dependencies',work/'continuation_driver_capacity.py')
 mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
 driver=mod.Driver(root,work)
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and all(n in accepted for n in targets)
 nxt='OrdinaryHeightEnvelope'
 missing=sorted(set(closures[nxt])-{nxt}-accepted)
 next_info={'target':nxt,'eligible':nxt in eligible,'accepted':nxt in accepted,'missing_dependencies':missing,'unknown':unknown,'active':active.get('active'),'queue_paused':queue.get('pause_after_current')}
 (out/'NEXT_DEPENDENCIES.json').write_text(json.dumps(next_info,indent=2)+'\n')
 now=datetime.now().astimezone().isoformat()
 summary={'time':now,'outcome':'COMPLETED_UNIT','targets':targets,'theorems':5,'definitions':1,'builds':builds,'checks':checks,'source_closure_count':len(guards['sources']),'source_scan_findings':findings,'original_statements_unchanged':True,'same_kernel_targeted_replay':True,'fresh_whole_root_replay':False,'clean_checkout_build':False,'independent_final_review':False,'root_integrated':False,'main_statement_proved':False}
 (out/'VERIFICATION_SUMMARY.json').write_text(json.dumps(summary,indent=2)+'\n')
 (out/'SOURCE_MAP.json').write_text(json.dumps({n:{'working_source':'D1Bound5/'+n+'.lean','preserved_copy':str((out/(n+'.lean')).relative_to(root)),'sha256':guards['sources'][n],'status':'SEPARATELY_VERIFIED_NOT_ROOT_IMPORTED'} for n in targets},indent=2)+'\n')
 (out/'README.md').write_text('# Verified mixed retained bridge\n\nThe three named module copies match the working sources and passed the pinned builds, combined six-declaration type/axiom audit and three separate installed same-kernel replays. See VERIFICATION_SUMMARY.json and MATHEMATICS.md. This is not accepted-root integration or MainStatement completion.\n\nThe timestamped source/log/build files preserve all attempts. The first two mixed-gap attempts FAILED elaboration and are not accepted dependencies. Only the final hash in SOURCE_MAP.json is verified. MixedBridgeAudit.lean and checks-all.py were actually executed. The individual MixedSizesAudit/MixedFormsAudit/MixedGapAudit files and checks.py were prepared but not executed. Do not count them as extra audit successes.\n\nThe frozen manuscript, handoff and dependency pins were not modified. No agents, external services or Prove2Me were used. Automatic scheduling was not changed.\n')
 finish=f'# FINISH — {now}\n\nOutcome: COMPLETED_UNIT. Five prepared theorems and one parameter-row definition across CoherentRetainedMixedSizes, CoherentRetainedMixedForms and CoherentRetainedMixedGap are now separately verified. The mixed-gap proof needed an explicit expected local scalar type before final transitivity/simplification; no original statement or hypothesis changed.\n\nFor actual full-ring D(1)-tuple entries with 1<=A<=B<=S, B>=3, T>2ABS, C>3ABST, and AT>=H for one of the two manuscript rows H=32/48, the result derives the nonzero integral coherent form and the precise coefficient bound, hence C>A^2*T^5/S^2. The form lower bound and choice of auxiliary root are supplied internally, not assumed.\n\nAll three pinned builds, all six exact declaration types and transitive axioms (only propext, Classical.choice, Quot.sound), and three targeted installed SAME-kernel replays passed. The source scan covers {len(guards["sources"])} project modules in the exact imported closure. No fresh whole-root replay, clean-checkout build, independent final review or accepted-root integration is claimed. MainStatement remains UNPROVED.\n\nSources, failed attempts and evidence are preserved in research/continuations/{prefix}/. Private publication requires the subsequent separate Git calls and post-push comparison; this FINISH does not invent a commit/push receipt. The pre-existing Git index entry must remain unchanged. The initial denied administration calls are recorded in the conversation attachment, not claimed as executed Mac inspections. No automation was changed.\n'
 finish+='\nNext priority: inspect OrdinaryHeightEnvelope and its current unmet prerequisites in NEXT_DEPENDENCIES.json. No new proof for that target was launched.\n'
 (root/'records/runs'/(prefix+'-FINISH.md')).write_text(finish)
 (root/'records'/('mixed-retained-bridge-20261018.md')).write_text((out/'MATHEMATICS.md').read_text()+'\n## Verification status\n\n'+finish)
 inherited=[p.decode() for p in git('diff','--cached','--name-only','-z').split(b'\0') if p]
 inherited_blobs={p:sha(git('show',':'+p)) for p in inherited}
 (out/'INHERITED_INDEX.json').write_text(json.dumps(inherited_blobs,indent=2)+'\n')
 run_records=[root/'records/runs'/(p.stem.replace('-START','')+'-START.md') for n in targets for p in out.glob(n+'-*-START.json')]
 paths=[str(p.relative_to(root)) for p in out.iterdir() if p.is_file()]
 paths += [str(p.relative_to(root)) for p in run_records]
 paths += ['records/runs/'+prefix+'-build.py','records/runs/'+prefix+'-PROGRESS.md','records/runs/'+prefix+'-FINISH.md','records/mixed-retained-bridge-20261018.md']
 paths += [str((out/'STAGING_PATHS.txt').relative_to(root)),str((out/'STAGING_REVIEW.json').relative_to(root))]
 paths=sorted(set(paths));assert not set(paths)&set(inherited)
 (out/'STAGING_PATHS.txt').write_text('\n'.join(paths)+'\n')
 patterns=runpy.run_path(str(root/'scripts/git_sync_preflight.py'))['TOKEN_PATTERNS']
 hashes={}
 for rel in paths:
  if rel.endswith('/STAGING_REVIEW.json'):continue
  p=root/rel;assert p.is_file() and not p.is_symlink();data=p.read_bytes();assert len(data)<5*1024*1024
  assert not any(re.search(q,data.decode()) for q in patterns),'Credential-shaped content: '+rel
  hashes[rel]=sha(data)
 (out/'STAGING_REVIEW.json').write_text(json.dumps({'time':now,'head':git('rev-parse','HEAD').decode().strip(),'paths':paths,'hashes_except_this_record':hashes,'inherited_index':inherited_blobs,'commit_requirement':'Plain git commit --only with this explicit pathspec list. Leave inherited staged content untouched.'},indent=2)+'\n')
 print(json.dumps({'prepared_at':now,'status':'REVIEWED_SAVE_SCOPE','files':len(paths),'inherited_index':inherited_blobs,'source_closure_count':len(guards['sources'])}),flush=True)
