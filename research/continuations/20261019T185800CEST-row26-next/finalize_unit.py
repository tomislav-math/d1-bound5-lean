"""Finalize this exact graph proof unit after all checks. No Git mutations.
Working sources are preserved as reviewed snapshots, not silently root-integrated.
"""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,importlib.util,json,re,sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation';audit=out/'audit'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
def source_code(s):
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
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('finalize_row26',work/'continuation_driver_capacity.py')
mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
targets=json.loads((audit/'TARGETS.json').read_text());replays=json.loads((audit/'REPLAY_TARGETS.json').read_text())
checks=json.loads((audit/'TARGETED_REPLAY_RECEIPTS.json').read_text());decls=json.loads((audit/'DECLARATIONS.json').read_text())
assert len(targets)==88 and len(set(targets))==88 and replays==targets and len(decls)==88
assert [r['label'] for r in checks]==['analytic-type-axioms']+[n+'-targeted-replay' for n in replays]
assert all(r['exit']==0 and not r['timed_out'] and r['guards_unchanged'] for r in checks)
assert not json.loads((audit/'active-targeted-replay.json').read_text())['active']
assert 'ANALYTIC_CHECKS_PASS' in (audit/'checks-console.log').read_text()
log=(audit/'analytic-type-axioms.log').read_text();assert 'error:' not in log
axes=dict(re.findall(r'ANALYTIC_AXIOMS_PASS (\S+): (\[[^\]]*\])',log))
assert len(axes)==88
for decl in decls:
    name=decl['name'];assert name in axes
    assert set(x.strip() for x in axes[name].strip('[]').split(',') if x.strip())<={'propext','Classical.choice','Quot.sound'}
    assert re.search(r'^@?'+re.escape(name)+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M),name
original=json.loads((out/'ORIGINAL_PARENTS.json').read_text())
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    d=mod.Driver(root,work);active=json.loads(d.active_path.read_text())
    assert not active.get('active') and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=d.snapshot()
    assert not unknown and set(targets)<=accepted and q['max_parallel']==1 and q['pause_after_current'] is True
    guards=json.loads((audit/'TARGETED_REPLAY_GUARDS.json').read_text())
    assert d.manifest_matches(guards['compiled_artifacts']) and d.manifest_matches(guards['immutable_inputs'])
    assert sha(root/'D1Bound5/SmallPairLightData26.lean')=='5846a48684f6c85575a6bcb6b11c73f695438e75f50a0505e9d333ffa48b497d'
    assert sha(root/'D1Bound5/SmallPairLightAdaptiveData26.lean')=='8fcbf5018c5c1dbac57bbba6f0cec8a92e2243d8ef255c12bbada752b611c969'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    reviewed={};source_map={};builds=[];parent_headers={}
    for n,h in guards['project_sources'].items():
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==h
        code=source_code(p.read_text())
        assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',code),n
        assert not re.search(r'decide\s*\+native',code),n
        imports=re.findall(r'^import\s+([^\n]+)',code,re.M)
        assert not any('research' in x or 'snapshot' in x for x in imports)
        reviewed[n]={'sha256':h,'imports':imports}
    verified=out/'verified';verified.mkdir()
    for n in targets:
        folder=out/('parents' if n in original else 'parts')
        receipt=json.loads((folder/(n+'-BUILD_RECEIPT.json')).read_text())
        assert receipt['name']==n and receipt['exit']==0 and receipt['accepted_build'] and not receipt['timed_out']
        assert receipt['closure_unchanged'] and receipt['shared_artifacts_unchanged']
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==receipt['source_sha256']
        assert receipt['fingerprint']==mod.fingerprint(closures[n]) and d.manifest_matches(receipt['artifacts'])
        snapshot=verified/(n+'.lean');snapshot.write_bytes(p.read_bytes())
        save(verified/(n+'-BUILD_RECEIPT.json'),receipt)
        (verified/(n+'-build.log')).write_bytes((folder/(n+'-build.log')).read_bytes())
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snapshot.relative_to(root)),'sha256':sha(p),'status':'TYPE_AXIOM_AND_TARGETED_REPLAY_VERIFIED_NOT_ROOT_INTEGRATED'}
        builds.append(receipt)
        if n in original:
            header=p.read_text().split('theorem ',1)[1].split(' := by',1)[0]
            assert header==original[n]['header'];parent_headers[n]={'original_type_unchanged':True,'header':header}
    now=datetime.now().astimezone().isoformat()
    save(out/'SOURCE_MAP.json',source_map);save(out/'SOURCE_IMPORT_REVIEW.json',{'count':len(reviewed),'modules':reviewed})
    save(out/'FINAL_HEADER_REVIEW.json',parent_headers)
    summary={'time':now,'outcome':'COMPLETED_UNIT','original_parent_targets':list(original),'new_compilations':88,'new_leaf_helpers':84,'theorems_audited':88,'targeted_installed_same_kernel_replays':88,'source_closure_count':len(reviewed),'axioms':axes,'build_receipts':builds,'checks':checks,'original_data_unchanged':True,'all_cross_part_tails_preserved':True,'index_pairs_per_side':{'001':39943,'002':39975},'total_new_index_pairs':159836,'whole_row26_proved':False,'remaining_row26_blocks_per_side':['003','004','005','006','007'],'Q_audit_pending':True,'root_integrated':False,'main_statement_proved':False,'independent_final_review':False,'whole_root_clean_checkout':False,'automations_modified':False}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    text=('The four original row26 graph blocks001 and002 (left/right) are proved from 84 complete-tail numerical leaves. All 88 modules passed current guarded pinned compilation, exact theorem-type examples, transitive-axiom audit and 88 targeted installed SAME-kernel replays. Original parent statements and all cached coordinates, signatures, masks and floor witnesses are unchanged. The blocks cover 159836 index comparisons; exact list lengths and pair counts also passed kernel checks. Combined with the predecessor block000 this covers the first178 heads per side, not the remaining blocks003--007 or full graph closure. Q audit, other final branches, root integration, independent final review and clean-checkout gates remain open.')
    (out/'README.md').write_text('# Verified row26 blocks001 and002\n\n'+now+'\n\n'+text+'\n\nReviewed copies are in verified/. Working project files remain separate from accepted-root integration. See SOURCE_MAP.json, PARTITION_PLAN.json, FINAL_HEADER_REVIEW.json and audit/. Python preparation checks are evidence, not Lean proofs; the parent proofs use the kernel-checked prefix-concatenation identity. No compiled artifacts or frozen manuscript are uploaded.\n')
    (out/'MANUSCRIPT_ALIGNMENT.md').write_text('# Manuscript alignment\n\nThis unit changes only the granularity of four existing row26 independence certificates in the finite small-pair graph calculation. Every selected head is tested against its entire original suffix, so all cross-part index comparisons are preserved. The general prefix-add identity joins consecutive parts, including malformed-witness cases. The same original four propositions are proved. No field, vertex, sign, zero-square case, square test, certificate witness or radius is removed or changed. This unit alone does not prove descent completeness or whole graph triangle exclusion; the existing source bridges still remain mandatory.\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH\n\n'+now+'\n\nOutcome: COMPLETED_UNIT. '+text+'\n\nEvidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json. Private Git synchronization is a separate subsequent operation, not established by this record. The older blocked commit and Q audit were not repeated. Own child compiler/checker exits are recorded individually. The original parts terminal session became unavailable for collection, while all84 child exit-zero receipts and BOUNDED_BATCH_DRAINED84 were recovered; no shell exit code was invented and no batch was repeated.\n')
    print('VERIFIED_ROW26_FOUR_BLOCKS',now,'new_modules',len(targets),'source_closure',len(reviewed))
