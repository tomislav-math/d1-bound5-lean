"""Finalize this independent three-small unit after actual proof checks.
Git operations are read-only. No compilation, source changes or trust resets.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, subprocess, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;aud=out/'audit'
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
def code(s):
    result=[];i=0;depth=0
    while i<len(s):
        if depth:
            if s.startswith('/-',i):depth+=1;i+=2
            elif s.startswith('-/',i):depth-=1;i+=2
            else:i+=1
        elif s.startswith('/-',i):depth=1;i+=2;result.append(' ')
        elif s.startswith('--',i):
            j=s.find('\n',i);i=len(s) if j<0 else j;result.append(' ')
        elif s[i]=='"':
            i+=1
            while i<len(s):
                if ord(s[i])==92:i+=2
                elif s[i]=='"':i+=1;break
                else:i+=1
            result.append(' ')
        else:result.append(s[i]);i+=1
    assert depth==0
    return ''.join(result)

targets=json.loads((out/'TARGETS.json').read_text());decls=json.loads((aud/'DECLARATIONS.json').read_text())
checks=json.loads((aud/'TARGETED_REPLAY_RECEIPTS.json').read_text())
assert json.loads((aud/'REPLAY_TARGETS.json').read_text())==targets
assert [x['label'] for x in checks]==['analytic-type-axioms']+[x+'-targeted-replay' for x in targets]
assert all(x['exit']==0 and x['guards_unchanged'] and not x['timed_out'] for x in checks)
assert not json.loads((aud/'active-targeted-replay.json').read_text())['active']
assert 'ANALYTIC_CHECKS_PASS' in (aud/'checks-console.log').read_text()
log=(aud/'analytic-type-axioms.log').read_text();assert not re.search(r'(^|\n).*\berror:',log)
axes=dict(re.findall(r'THREE_SMALL_AXIOMS_PASS (\S+): (\[[^\]]*\])',log));assert len(axes)==len(decls)
for x in decls:
    n=x['name'];assert n in axes and re.search(r'^@?'+re.escape(n)+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M)
    assert set(a.strip() for a in axes[n].strip('[]').split(',') if a.strip())<={'propext','Classical.choice','Quot.sound'}
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('three_small_finalize_driver',work/'continuation_driver_capacity.py');m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=m.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active['active'] and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot();assert unknown==[] and queue['max_parallel']==1 and queue['pause_after_current'] is True
    assert set(targets)<=accepted
    guard=json.loads((aud/'TARGETED_REPLAY_GUARDS.json').read_text());assert driver.manifest_matches(guard['compiled_artifacts']) and driver.manifest_matches(guard['immutable_inputs'])
    initial=json.loads((out/'INITIAL_STATE.json').read_text());inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
    index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert index==inherited and git('rev-parse','HEAD').decode().strip()==initial['head']
    assert git('branch','--show-current').decode().strip()=='main' and not git('diff','--name-only').strip()
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    coverage={}
    for n,h in guard['project_sources'].items():
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==h;s=code(p.read_text())
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),n
        assert not re.search(r'(^|\n)\s*(run_cmd|initialize|builtin_initialize|elab)\b',s),n
        imports=re.findall(r'^import\s+([^\n]+)',s,re.M);assert not any('research' in x or 'snapshot' in x for x in imports)
        assert not n.startswith('FiniteQ')
        coverage[n]={'sha256':h,'imports':imports,'bytes':p.stat().st_size}
    originals=json.loads((out/'ORIGINAL_HEADERS.json').read_text());headers={};source_map={};builds=[]
    canon=out/'verified';canon.mkdir()
    for n in targets:
        p=root/'D1Bound5'/(n+'.lean');s=p.read_text();old=originals[n]
        current=re.findall(r'^(?:@\[[^\n]*\]\s*)?theorem (.*?) := by',s,re.M|re.S)
        assert current==old['headers'],'Changed original theorem type: '+n
        headers[n]={'original_headers_unchanged':True,'theorems':len(current),'source_changed':sha(p)!=old['sha256']}
        key=m.fingerprint(driver.closure(n));row=next(x for x in reversed(driver.rows) if x['name']==n and x['fingerprint']==key)
        assert row['accepted_build'] and row['exit']==0 and row['closure_unchanged'] and row['shared_artifacts_unchanged'] and not row['timed_out'] and row['source_sha256']==sha(p)
        snap=canon/(n+'.lean');snap.write_bytes(p.read_bytes());save(canon/(n+'-BUILD_RECEIPT.json'),row);(canon/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes())
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snap.relative_to(root)),'sha256':sha(p),'status':'Compiled, exact-type/axiom audited and targeted installed same-kernel replayed. Not accepted-root integrated.'};builds.append(row)
    scope=json.loads((out/'AUDIT_SCOPE.json').read_text());assert scope['original_theorem_types']==sum(x['kind']=='theorem' for x in decls)
    save(out/'SOURCE_MAP.json',source_map);save(out/'SOURCE_IMPORT_REVIEW.json',{'count':len(coverage),'modules':coverage})
    save(out/'FINAL_HEADER_REVIEW.json',headers);save(out/'TYPE_AXIOM_SUMMARY.json',{'declarations':len(decls),'theorems':scope['original_theorem_types'],'per_declaration':axes,'replay_targets':targets})
    now=datetime.now().astimezone().isoformat()
    nextstate={}
    for n in ['ThreeSmallExclusion','ThreeSmallUpper','ThreeSmallWindows','SmallPairGraphs','AllLargeImpossible','MainTheorem']:
        if not (root/'D1Bound5'/(n+'.lean')).exists():continue
        cl=driver.closure(n);missing=sorted(set(cl)-accepted-{n});nextstate[n]={'compiled':n in accepted,'eligible':n in eligible,'missing_prerequisites':missing}
    save(out/'NEXT_DEPENDENCIES.json',nextstate)
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'public_theorems':scope['original_theorem_types'],'public_declarations':len(decls),'builds':builds,'checks':checks,'source_closure_count':len(coverage),'public_headers_unchanged':True,'modified_sources':[n for n,h in headers.items() if h['source_changed']],'new_extension_certificate_rows':[4,5,6,7,8,9],'small_triple_count':24,'representative_count':10,'full_ring_models':[[0,1],[0,2],[1,1],[1,2]],'bounded_extension_radius':'10^40','extension_modulus_strict_upper_bound':85,'endpoint':'IsD1Tuple.three_small_fifth_large','root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'Q_verification_unchanged':'Compiled-only; previous refused audit not retried','automations_modified':False}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — complete small-triple bounded extensions verified'
    paragraph='The complete 24-triple classification in the four full integer rings and all ten representative bounded-extension consequences are now connected. Six new seed/mutation-closure/filter certificate modules complete the radius 10^40 data. Formal symmetry transport, norm descent and its termination imply at most one proper common extension in that closed disk, always of modulus less than 85. Every actual ordered full-ring D(1) sextuple with third modulus below 3 consequently has fifth modulus above 10^40 and fourth modulus either below 85 or above 10^40. All fifteen modules passed current guarded pinned compilation, exact original theorem-type examples, transitive-axiom checks and fifteen targeted installed SAME-kernel replays. Original public statements, half-integral bases, zero square roots and modulus ties are retained. This independent unit does not repeat the previously refused Q audit. Q remains compiled-only. The final three-small analytic contradiction, other main branches, root integration and global final gates remain open. Evidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json.'
    for n in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/n;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned compiler/checker processes have collected terminal results. Failed attempts remain separately identified. Inherited staging and frozen v4 are unchanged. Private Git synchronization is a separate next stage, not established by this pre-commit record.\n')
    print('VERIFIED_THREE_SMALL_UNIT',now,'modules',len(targets),'theorems',scope['original_theorem_types'],'declarations',len(decls),'source_closure',len(coverage))
