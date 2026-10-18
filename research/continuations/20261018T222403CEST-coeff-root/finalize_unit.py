"""Finalize this unit after checks. No Git mutations or proof-source changes."""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, subprocess, sys
root=Path('/Users/tp/Lean/D1Bound5')
work=root/'research/continuations/20261018T010800CEST-main-continuation'
out=Path(__file__).resolve().parent
prefix='20261018T222403CEST-coeff-root'
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(name,value): (out/name).write_text(json.dumps(value,indent=2)+'\n')
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_coeff_root_final',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
 fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
 driver=mod.Driver(root,work)
 active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
 assert json.loads((out/'active-targeted-replay.json').read_text())['active'] is False
 declarations=json.loads((out/'DECLARATIONS.json').read_text());targets=list(declarations)
 checks=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text())
 assert len(checks)==len(targets)+1==7
 assert {a['label'] for a in checks}=={'coeff-root-type-axioms',*[t+'-targeted-replay' for t in targets]}
 assert all(a['exit']==0 and not a['timed_out'] and a['guards_unchanged'] for a in checks)
 audit=(out/'coeff-root-type-axioms.log').read_text();assert audit.count('COEFF_ROOT_AXIOMS_PASS')==17 and 'sorryAx' not in audit
 for names in declarations.values():
  for n in names: assert 'COEFF_ROOT_AXIOMS_PASS '+n+':' in audit
 queue,names,closures,accepted,unknown,eligible=driver.snapshot()
 assert not unknown and queue['max_parallel']==1 and queue['pause_after_current']
 assert all(t in accepted for t in targets)
 guards=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text())
 assert driver.manifest_matches(guards['compiled_artifacts']) and driver.manifest_matches(guards['immutable_inputs'])
 merged={}
 for t in targets: merged.update(closures[t])
 assert merged==guards['project_sources']
 assert all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in merged.items())
 summary={};reviews={}
 for t in targets:
  src=root/'D1Bound5'/(t+'.lean');before=(out/(t+'.before.lean')).read_text();after=src.read_text()
  assert src.read_bytes()==(out/(t+'.lean')).read_bytes()
  header=lambda s:re.findall(r'(?ms)^(?:private\s+)?theorem\s+.*?:= by',s)
  assert header(before)==header(after)
  receipt=json.loads((out/(t+'-BUILD_RECEIPT.json')).read_text())
  assert receipt['accepted_build'] and receipt['exit']==0 and receipt['closure_unchanged'] and receipt['shared_artifacts_unchanged'] and not receipt['timed_out']
  assert receipt['source_sha256']==sha(src) and receipt['fingerprint']==mod.fingerprint(closures[t])
  summary[t]={k:receipt[k] for k in ['source_sha256','fingerprint','exit','seconds']}
  reviews[t]={'original_public_and_private_headers_unchanged':True,'original_source_unchanged':before==after,'public_theorems':len(declarations[t]),'root_integrated':False}
  save(t+'-SOURCE_CLOSURE.json',closures[t])
 def strip_comments(s):
  res=[];i=0;depth=0
  while i<len(s):
   if s[i:i+2]=='/-':depth+=1;i+=2
   elif depth and s[i:i+2]=='-/':depth-=1;i+=2
   elif depth:i+=1
   elif s[i:i+2]=='--':
    j=s.find('\n',i);i=len(s) if j<0 else j
   else:res.append(s[i]);i+=1
  return ''.join(res)
 findings=[]
 for n in merged:
  text=strip_comments((root/'D1Bound5'/(n+'.lean')).read_text())
  for pat in [r'\b(?:sorry|admit|sorryAx|native_decide|axiom)\b',r'(?m)^\s*unsafe\s',r'debug\.skipKernelTC',r'Lean\.(?:addDecl|addAndCompile)',r'Lean\.ofReduce(?:Bool|Nat)',r'implemented_by']:
   if re.search(pat,text):findings.append({'module':n,'pattern':pat})
 assert not findings
 prefix_import='D1Bound5.';rootdeps=set();missing=[]
 def imports(p):
  found=[]
  for line in p.read_text().splitlines():
   m=re.match(r'\s*(?:(?:public|private)\s+)?import\s+(.+)',line)
   if m:found.extend(x[len(prefix_import):] for x in m[1].split() if x.startswith(prefix_import))
  return found
 def visit(n):
  if n in rootdeps:return
  rootdeps.add(n);p=root/'D1Bound5'/(n+'.lean')
  if not p.is_file():missing.append(n);return
  for v in imports(p):visit(v)
 for n in imports(root/'D1Bound5.lean'):visit(n)
 assert not missing and not(set(targets)&rootdeps)
 inherited=json.loads((out/'INHERITED_INDEX.json').read_text());actual_index={}
 for n in subprocess.check_output(['git','diff','--cached','--name-only','-z'],cwd=root,text=True).split('\0'):
  if n: actual_index[n]=hashlib.sha256(subprocess.check_output(['git','show',':'+n],cwd=root)).hexdigest()
 assert actual_index==inherited
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()=='0ef727d0b84ea578ccbeb92880c55b108c80ecac'
 assert not subprocess.check_output(['git','diff','--name-only'],cwd=root,text=True).strip()
 now=datetime.now().astimezone().isoformat();nextdeps={}
 for t in ['BennettWeightedHeight','BennettRootTransfer','FullRingOrdinaryHeight','UnitPairFirstExtensionBound']:
  pending=[n for n in closures[t] if n!=t and n not in accepted]
  nextdeps[t]={'accepted_current_build':t in accepted,'eligible':t in eligible,'unaccepted_dependencies':pending,'ready_prerequisites':[n for n in pending if n in eligible]}
 save('NEXT_DEPENDENCIES.json',{'time':now,'unknown':unknown,'targets':nextdeps})
 save('FINAL_SOURCE_REVIEW.json',{'time':now,'targets':reviews,'project_source_closure':merged,'forbidden_pattern_findings':findings,'root_imported_targets':[],'root_import_scan_missing':missing,'earlier_auxiliary_scan_error':'The invalid prefix-length root scan is retained in SOURCE_MAP_INVALID_ROOT_SCAN.json and is not used. This final traversal uses len(D1Bound5.).'})
 save('VERIFICATION_SUMMARY.json',{'outcome':'COMPLETED_UNIT','time':now,'targets':summary,'public_theorems':17,'private_helpers':1,'definitions':0,'checks':checks,'permitted_transitive_axioms':['propext','Classical.choice','Quot.sound'],'target_source_closure_size':len(merged),'all_original_headers_unchanged':True,'root_integrated':False,'fresh_whole_root_replay':False,'clean_checkout_build':False,'independent_review':False,'main_statement_proved':False,'scope':'Six current target builds, exact elaborated-type/transitive-axiom audit, and targeted replay in the installed same Lean kernel. Not final verification of the cardinality theorem.'})
 (out/'MATHEMATICS.md').write_text('''# Verified coefficient and root-error endpoints

For the actual cleared two-anchor Bennett entries and every integer k>=1, every row i, nonzero complex a,b,c with a!=b, |a|<=|b| and |a||c|>=1000, the checked theorem proves

    |Q[i,1]| < (42 |a|^2 |b| |c|)^k,
    |Q[i,2]| < (42 |b|^3 |c|)^k.

The proof bounds the exact finite cleared Taylor residue through convergent positive polynomial/pole generating functions. At radius 2 min(X,delta)/5, the triangle inequalities, positive denominator bounds and exact rational rounding give a strict base42. No bound on Q itself is an input. Equal moduli for distinct anchors remain allowed.

For a commutative source ring R, a ring map f:R->C and roots r^2=ac+1, v^2=ad+1, z^2=cd+1, assume f(a),f(c),f(z) nonzero, |f(a)||f(c)|>=1000 and 4|f(a)|<=|f(c)|. A checked theorem constructs s=rv or s=-rv in R such that

    |(1+1/(f(a)f(c)))^(1/2) - f(s)/(f(a)f(z))|
      < (3/2)|f(c)|/(|f(a)| |f(z)|^2).

The complex half-power is the same branch used in the constructed interpolation matrix. The sign is chosen once from the actual integral root product, independently of the matrix row and k. The generic statement does not require r or v nonzero. The nonzero z hypothesis must still be derived in the actual tuple application. The full integer ring is an allowed source ring, without unique factorization or a restricted integral basis.

The six modules contain seventeen original public theorems and one original private norm helper. Constants compiled unchanged. Five modules needed proof-body repairs, with all public/private headers unchanged. Failed trials and exact patches are preserved.

These endpoints close neither the weighted combined coefficient bound nor the full analytic residue bound/identification and all-order tuple inequality. The final full-ring height application, exhaustive finite checks/descent, accepted-root integration, fresh full-root verification and MainStatement remain open. The reviews here were performed by the same assistant. Targeted installed-kernel replay is not independent verification.
''')
 (out/'STATEMENT_REVIEW.md').write_text((out/'STATEMENT_REVIEW.md').read_text()+'\n## Final evidence\n\nAll six planned module builds, the exact seventeen-public-theorem type/transitive-axiom audit and six installed SAME-kernel target replays have now passed. Every original public and private header remains unchanged. The final corrected source/import review is FINAL_SOURCE_REVIEW.json. No fresh whole-root replay, independent review, clean checkout or accepted-root integration was performed.\n')
 (out/'README.md').write_text('''# Coefficient and signed-root continuation

Status: COMPLETED_UNIT, separately verified working dependencies. MainStatement is UNPROVED.

Read VERIFICATION_SUMMARY.json, MATHEMATICS.md and STATEMENT_REVIEW.md for exact scope. SOURCE_MAP.json maps the byte-identical preservation copies to canonical working sources. The copies here are not duplicate imports. The guarded driver build receipts, exact-type/axiom log, target replays, final source review and original failed trials/patches are retained. The initial auxiliary root scanner error is explicitly marked invalid and superseded by the corrected final traversal.

Next work is described in NEXT_DEPENDENCIES.json. No automations were changed. The inherited staged post-push receipt remains outside this unit's Git scope.
''')
 note='Six working modules now prove the actual Bennett base-42 bounds for both nonzero columns and the integral signed-root approximation with strict factor3/2. All 17 original public theorems and one private helper compiled; five modules needed proof-body-only repairs, with all original headers preserved. The exact public type/transitive-axiom audit and six targeted installed SAME-kernel replays passed, with only propext/Classical.choice/Quot.sound. The final source review covers '+str(len(merged))+' project dependencies. Root integration, the weighted combined bound, residual evaluation/rate, full-ring all-order conclusion, exhaustive finite checks and MainStatement remain open. Evidence: research/continuations/'+prefix+'/VERIFICATION_SUMMARY.json.'
 heading='## 18 October 2026 — Bennett coefficient bounds and signed-root approximation verified'
 for n in ['STATUS.md','records/open-obligations.md']:
  p=root/n;text=p.read_text();first,rest=text.split('\n',1);p.write_text(first+'\n\n'+heading+'\n\n'+note+'\n\n'+rest.lstrip('\n'))
 for n in ['records/paper-to-lean.md','records/build-record.md']:
  p=root/n;p.write_text(p.read_text().rstrip()+'\n\n'+heading+'\n\n'+note+'\n')
 (root/'records/runs'/(prefix+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT for six separately verified working modules and seventeen original public theorems (plus one original private helper). All guarded pinned builds, exact-type/transitive-axiom audit and six targeted installed SAME-kernel replays passed. Only propext, Classical.choice and Quot.sound occur. All original headers are unchanged. Meaningful failed proof attempts and the corrected auxiliary source-scan issue are preserved. No source-pins, frozen manuscript, accepted-root imports or automations were changed.\n\nThe strongest endpoints are the actual two-column height bounds with bases 42|a|^2|b||c| and 42|b|^3|c| at every k>=1, and a signed source-ring root product with the strict3/2 approximation error. The explicit nonzero and size conditions remain in the theorem types. The remaining weighted/residual/full-ring bridges and finite exclusions are not assumed away. MainStatement remains UNPROVED.\n\nNext ready work is BennettWeightedHeight and the residual dependencies in NEXT_DEPENDENCIES.json. Sources and complete receipts are preserved in research/continuations/'+prefix+'/. The local queue is paused between jobs, no owned compiler/checker remains, and the inherited staged receipt is unchanged. The following private Git publication requires separate actual calls and a later post-push receipt; this FINISH does not invent publication.\n')
 print('FINALIZED',now,json.dumps({'public_theorems':17,'target_modules':len(targets),'source_closure':len(merged),'main_statement_proved':False}))
 print('NEXT',json.dumps({t:{'eligible':v['eligible'],'missing':len(v['unaccepted_dependencies']),'ready':v['ready_prerequisites']} for t,v in nextdeps.items()}))
