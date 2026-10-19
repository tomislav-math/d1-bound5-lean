"""Finalize the numeric batch and repaired finite coverage after actual checks.
All Git calls are read-only. No queue, source, artifact or trust-baseline mutation.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,subprocess,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;a=out/'assembly-checks';c=out/'coverage-repair';work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*args):return subprocess.run(['git',*args],cwd=root,capture_output=True,check=True).stdout
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')

def strip_comments(s):
    ans=[];i=0;depth=0
    while i<len(s):
        if depth:
            if s.startswith('/-',i):depth+=1;i+=2
            elif s.startswith('-/',i):depth-=1;i+=2
            else:i+=1
        elif s.startswith('/-',i):depth=1;i+=2;ans.append(' ')
        elif s.startswith('--',i):
            k=s.find('\n',i);i=len(s) if k<0 else k;ans.append(' ')
        elif s[i]=='"':
            i+=1
            while i<len(s):
                if ord(s[i])==92:i+=2
                elif s[i]=='"':i+=1;break
                else:i+=1
            ans.append(' ')
        else:ans.append(s[i]);i+=1
    assert depth==0
    return ''.join(ans)

allnames=[];allaxes={};groups={};source_map={}
for folder,marker,group in [(out,'PELL_FINAL_AXIOMS_PASS','numeric'),(a,'PELL_ASSEMBLY_AXIOMS_PASS','assembly')]:
    names=json.loads((folder/'TARGETS.json').read_text());checks=json.loads((folder/'TARGETED_REPLAY_RECEIPTS.json').read_text());decls=json.loads((folder/'DECLARATIONS.json').read_text())
    assert len(checks)==len(names)+1 and [r['label'] for r in checks]==['pell-certificate-type-axioms']+[n+'-targeted-replay' for n in names]
    assert all(r['exit']==0 and r['guards_unchanged'] and not r['timed_out'] for r in checks)
    assert not json.loads((folder/'active-targeted-replay.json').read_text())['active']
    assert 'PELL_BATCH_CHECKS_PASS' in (folder/'checks-console.log').read_text()
    log=(folder/'pell-certificate-type-axioms.log').read_text();assert not re.search(r'(^|\n).*\berror:',log)
    axes=dict(re.findall(marker+r' (\S+): (\[[^\n]*\])',log));assert len(axes)==len(decls)
    for d in decls:
        assert d['name'] in axes and re.search(r'^'+re.escape(d['name'])+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M),'Missing exact type or axiom audit'
        assert set(v.strip() for v in axes[d['name']].strip('[]').split(',') if v.strip())<={'propext','Classical.choice','Quot.sound'}
    rows=[]
    for n in names:
        if group=='numeric':f=out
        elif n in ['PellLightAllMatchingCertificates','PellLightAllFiniteCertificates']:f=out/'joins'
        elif n in ['PellFiniteFieldCoverageData','PellFiniteFieldCoverageBlock00']:f=c/'pilot'
        elif n in ['PellFiniteFieldCoverageLight','PellFiniteFieldCoverageBlock01']:f=c/'light-pilot'
        elif n=='PellFiniteFields':f=c/'final-join'
        elif n=='PellUnitPairBounded':f=c/'endpoint-repair'
        else:f=c/'light-remaining'
        row=json.loads((f/(n+'-BUILD_RECEIPT.json')).read_text());assert row['name']==n and row['accepted_build'] and row['exit']==0 and row['closure_unchanged'] and row['shared_artifacts_unchanged'] and not row['timed_out']
        p=root/'D1Bound5'/(n+'.lean');snap=f/(n+'.lean');assert p.read_bytes()==snap.read_bytes() and sha(p)==row['source_sha256']
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snap.relative_to(root)),'sha256':sha(p),'status':'Separately compiled, exact-type/axiom audited and targeted SAME-kernel replayed; not accepted-root integrated'}
        rows.append(row)
    groups[group]={'targets':names,'declarations':len(decls),'theorems':sum(d['kind']=='theorem' for d in decls),'builds':rows,'checks':checks,'nonempty_axioms':{n:v for n,v in axes.items() if v!='[]'}}
    allnames+=names;allaxes.update(axes)
assert len(allnames)==46 and len(allaxes)==5308
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('pell_repaired_finalize',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=mod.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
    queue,names,closures,accepted,unknown,eligible=driver.snapshot();assert unknown==[] and queue['max_parallel']==1 and queue['pause_after_current'] is True
    assert all(n in accepted for n in allnames)
    guards={};artifacts={};immutable={}
    for folder in [out,a]:
        g=json.loads((folder/'TARGETED_REPLAY_GUARDS.json').read_text());assert driver.manifest_matches(g['compiled_artifacts']) and driver.manifest_matches(g['immutable_inputs'])
        for n,h in g['project_sources'].items():
            assert sha(root/'D1Bound5'/(n+'.lean'))==h and (n not in guards or guards[n]==h);guards[n]=h
        for p,h in g['compiled_artifacts'].items():
            assert p not in artifacts or artifacts[p]==h;artifacts[p]=h
        immutable.update(g['immutable_inputs'])
    inherited=json.loads((out/'INHERITED_INDEX.json').read_text());current={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert current==inherited and git('rev-parse','HEAD').decode().strip()==json.loads((out/'INITIAL_STATE.json').read_text())['head']
    assert not git('diff','--name-only').strip(),'Another writer changed tracked records'
    frozen=Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex');assert sha(frozen)=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    original=(c/'PellFiniteFields-before-partition.lean').read_text();actual=(root/'D1Bound5/PellFiniteFields.lean').read_text()
    for name in ['pellFieldCoverage_checked','pellFiniteCertificate_exists']:
        pat=r'^theorem '+name+r'(.*?) := by';assert re.search(pat,original,re.M|re.S).group(1)==re.search(pat,actual,re.M|re.S).group(1),'Original coverage statement changed'
    assert original[original.index('/-- All 1016'):]==actual[actual.index('/-- All 1016'):],'Certificate-existence proof changed'
    original_endpoint=(c/'PellUnitPairBounded-before-repair.lean').read_text()
    actual_endpoint=(root/'D1Bound5/PellUnitPairBounded.lean').read_text()
    for name in ['full_ring_unit_pair_pell_no_three_bounded','IsD1Tuple.unit_pair_fifth_large']:
        pat=r'^theorem '+re.escape(name)+r'(.*?) := by'
        assert re.search(pat,original_endpoint,re.M|re.S).group(1)==re.search(pat,actual_endpoint,re.M|re.S).group(1),'Original full-ring endpoint header changed'
    coverage={}
    for n,h in guards.items():
        p=root/'D1Bound5'/(n+'.lean');s=strip_comments(p.read_text())
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),'Disallowed source token in '+n
        imports=re.findall(r'^import\s+([^\n]+)',s,re.M);assert not any('research' in x or 'snapshot' in x for x in imports)
        coverage[n]={'sha256':h,'imports':imports,'bytes':p.stat().st_size}
    save(out/'COMPLETE_SOURCE_IMPORT_REVIEW.json',{'project_modules':coverage,'count':len(coverage),'scope':'Complete source closure of this finite endpoint, not a whole-root fresh replay'})
    save(out/'COMBINED_VERIFIED_GUARDS.json',{'project_sources':guards,'compiled_artifacts':artifacts,'immutable_inputs':immutable})
    (out/'SOURCE_MAP.json').write_text(json.dumps(source_map,indent=2)+'\n')
    nextstate={}
    for n in ['UnitPairFiniteReduction','UnitPairImpossible','TwoSmallLargeSBound','TwoSmallLargeTBound','TwoSmallFifthBound','BennettRateLower','FiniteRootApproximation']:
        cl=driver.closure(n);missing=sorted(set(cl)-accepted-{n});nextstate[n]={'accepted':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(missing),'missing_prerequisites':missing}
    save(out/'NEXT_DEPENDENCIES.json',nextstate)
    summary={'status':'COMPLETED_UNIT','time':datetime.now().astimezone().isoformat(),'targets':allnames,'groups':groups,'new_matching_fields':232,'new_matching_pairs':68229,'concrete_finite_certificates':1016,'nonempty_matching_certificates':409,'coverage_positions':1250,'coverage_blocks':25,'endpoint':'D1Bound5.IsD1Tuple.unit_pair_fifth_large','source_closure_count':len(guards),'numeric_sources_changed':False,'original_public_statements_changed':False,'coverage_proof_repaired':True,'new_coverage_support_modules':27,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False,'remaining_pell_bounded_endpoint_dependencies':sorted(set(driver.closure('PellUnitPairBounded'))-accepted)}
    assert summary['remaining_pell_bounded_endpoint_dependencies']==[]
    save(out/'TYPE_AXIOM_SUMMARY.json',{'per_declaration':allaxes,'scope':'All public declarations in the 46 newly checked modules; partition helpers do not count as extra completed paper results','allowed':['propext','Classical.choice','Quot.sound']})
    save(out/'VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — complete bounded Pell exclusion assembled'
    paragraph='The final 15 matching modules certify 232 further lists and all 68229 distinct-magnitude pairs. All 409 nonempty matching certificates are now connected to all 1016 continued-fraction certificates. The original 1250-case coverage statement timed out at 240 seconds and was repaired without changing its type: 25 blocks of 50 cases, a pure-Init parameter/factor projection, kernel-proved list equalities and a proved quotient/remainder join cover exactly the original range. The certificate-existence theorem is unchanged. PellUnitPairBounded now proves the bounded full-ring no-three theorem and C > 10^550 for the fifth entry of every actual ordered {-1,1} sextuple, with no additional field-list, completeness, analytic or root-nonvanishing premises. All 46 new/support modules passed pinned guarded compilation, exact public-type/transitive-axiom audits and targeted installed SAME-kernel replay. The analytic upper-bound branches, final unit-pair impossibility, other main cases, accepted-root integration and final MainStatement gates remain open. Evidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json.'
    for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/name;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH — '+summary['time']+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned compiler and checker processes have collected terminal results. The failed monolithic trial and the measured pilot are preserved. Private Git synchronization is a separate subsequent action, not established by this pre-commit record. The inherited staged receipt is unchanged. Both locks are released on exit; the serial queue remains paused between bounded batches.\n')
    print('COMPLETE_BOUNDED_PELL_ENDPOINT_VERIFIED',summary['time'],'source_modules',len(guards),'modules',len(allnames),'declarations',len(allaxes));print('NEXT',json.dumps({n:{k:v for k,v in r.items() if k!='missing_prerequisites'} for n,r in nextstate.items()}))
