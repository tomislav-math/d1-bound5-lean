"""Finalize the exact matching batch only after all compiler/audit results pass.
All Git calls are read-only. No queue, proof source, or trusted-baseline edits.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, subprocess, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent;tag=out.name
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
def save(name,data):
    with (out/name).open('x') as f:f.write(json.dumps(data,indent=2)+'\n')
targets=json.loads((out/'TARGETS.json').read_text())
review=json.loads((out/'PRE_BUILD_SOURCE_REVIEW.json').read_text())
rows=json.loads((out/'BATCH_RESULTS.json').read_text())
checks=json.loads((out/'TARGETED_REPLAY_RECEIPTS.json').read_text())
assert [r['name'] for r in rows]==targets
assert [r['label'] for r in checks]==['pell-certificate-type-axioms']+[t+'-targeted-replay' for t in targets]
assert all(r['accepted_build'] and r['exit']==0 and r['closure_unchanged'] and r['shared_artifacts_unchanged'] and not r['timed_out'] for r in rows)
assert all(r['exit']==0 and r['guards_unchanged'] and not r['timed_out'] for r in checks)
assert not json.loads((out/'active-targeted-replay.json').read_text())['active']
assert 'PELL_BATCH_CHECKS_PASS' in (out/'checks-console.log').read_text()
collected=json.loads((out/'COLLECTED_PROCESS_RESULTS.json').read_text())
assert collected['build']['exit']==0 and collected['audit_and_replays']['exit']==0
log=(out/'pell-certificate-type-axioms.log').read_text()
assert not re.search(r'(^|\n).*\berror:',log)
decls=json.loads((out/'DECLARATIONS.json').read_text())
ax=dict(re.findall(r'PELL_MATCHING_AXIOMS_PASS (\S+): (\[[^\n]*\])',log))
assert set(ax)=={d['name'] for d in decls}
for d in decls:
    assert re.search(r'^'+re.escape(d['name'])+r'\s*:',log,re.M),'Missing elaborated type: '+d['name']
    assert all(a.strip() in ['propext','Classical.choice','Quot.sound'] for a in ax[d['name']].strip('[]').split(',') if a.strip())
nt=sum(d['kind']=='theorem' for d in decls);nd=sum(d['kind']=='def' for d in decls)
assert (out/'PellCertificateAudit.lean').read_text().count('example : ')==nt
scope=json.loads((out/'CERTIFICATE_SCOPE.json').read_text())
fields=[f['d'] for v in scope.values() for f in v]
assert len(fields)==len(set(fields))
pairs=sum(f['unordered_pairs'] for v in scope.values() for f in v)
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('d1_finalize_matching',work/'continuation_driver_capacity.py')
m=importlib.util.module_from_spec(spec);sys.modules[spec.name]=m;spec.loader.exec_module(m)
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    driver=m.Driver(root,work);active=json.loads(driver.active_path.read_text());assert not active.get('active') and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=driver.snapshot();assert not unknown and q['max_parallel']==1 and q['pause_after_current'] is True
    assert all(t in accepted for t in targets)
    guard=json.loads((out/'TARGETED_REPLAY_GUARDS.json').read_text())
    assert all(sha(root/'D1Bound5'/(n+'.lean'))==h for n,h in guard['project_sources'].items())
    assert driver.manifest_matches(guard['compiled_artifacts']) and driver.manifest_matches(guard['immutable_inputs'])
    initial=json.loads((out/'INITIAL_STATE.json').read_text());assert git('rev-parse','HEAD').decode().strip()==initial['head']
    inherited=json.loads((out/'INHERITED_INDEX.json').read_text())
    current={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p}
    assert current==inherited and not git('diff','--name-only').strip(),'Other writer changed tracked state'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    sm=json.loads((out/'SOURCE_MAP.json').read_text())
    for t in targets:
        assert sha(root/sm[t]['source'])==sha(root/sm[t]['snapshot'])==review[t]['sha256']
        sm[t]['status']='Separately compiled, exact-type/axiom audited and targeted SAME-kernel replayed; not accepted-root integrated'
    (out/'SOURCE_MAP.json').write_text(json.dumps(sm,indent=2)+'\n')
    nonempty={n:a for n,a in ax.items() if a!='[]'}
    save('TYPE_AXIOM_SUMMARY.json',{'per_declaration':ax,'nonempty_axioms':nonempty,'exact_type_examples':nt,'declaration_count':len(decls),'all_targeted_replays_passed':True})
    remaining=sorted(set(closures['PellUnitPairBounded'])-accepted)
    numeric=[n for n in remaining if re.fullmatch(r'PellLight(MatchingField|MatchingData|PrefixData)\d+',n)]
    joins=[n for n in remaining if n not in numeric]
    next_names=numeric[:]+joins
    nxt={n:{'accepted':n in accepted,'eligible':n in eligible,'missing_prerequisite_count':len(set(closures[n])-accepted-{n})} for n in next_names}
    save('NEXT_DEPENDENCIES.json',nxt)
    save('FINAL_REMAINING_SCOPE.json',{'remaining_pell_computational_modules':numeric,'remaining_pell_join_modules':joins,'numerical_count':len(numeric),'join_count':len(joins),'unknown':unknown,'module_counts_are_not_a_completion_percentage':True})
    now=datetime.now().astimezone().isoformat()
    summary={'status':'COMPLETED_UNIT','time':now,'targets':targets,'new_matching_fields':fields,'matching_field_count':len(fields),'matching_pairs':pairs,'original_theorems':nt,'data_definitions':nd,'builds':rows,'checks':checks,'axioms_nonempty':nonempty,'project_source_closure_count':len(guard['project_sources']),'mathematical_sources_changed':False,'root_integrated':False,'main_statement_proved':False,'independent_review':False,'whole_root_clean_checkout':False,'automations_modified':False,'remaining_pell_computational_modules':len(numeric),'remaining_pell_join_modules':len(joins),'collected_processes':collected}
    save('VERIFICATION_SUMMARY.json',summary)
    title='19 October 2026 — 149 further Pell matching fields verified'
    paragraph=f'{len(targets)} unchanged prepared modules certify all {pairs} unordered distinct-magnitude pairs in {len(fields)} additional field lists. These are the remaining 21 individual field modules and MatchingData4--11. All {nt} original theorems and {nd} data definitions passed pinned compilation, explicit exact-type examples, transitive-axiom audit and {len(targets)} targeted installed SAME-kernel replays. Sources and compiled artifacts remained unchanged. The frozen-v4 enumeration range and both sign cases are preserved. {len(numeric)} Pell computational modules and {len(joins)} join/coverage/endpoint modules remain. This is not aggregate full-ring exclusion, accepted-root integration, independent review, clean-checkout validation or a proof of MainStatement. Evidence: research/continuations/'+tag+'/VERIFICATION_SUMMARY.json.'
    for name in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/name;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+paragraph+'\n')
    (out/'README.md').write_text('# Verified Pell matching batch\n\n'+paragraph+'\n\nThe working files remain inherited untracked sources. Byte-identical reviewed copies and source maps are preserved here. START/PROGRESS/FINISH records and exact compiler/checker logs distinguish this unit from later root integration.\n')
    with (root/'records/runs'/(tag+'-FINISH.md')).open('x') as f:
        f.write('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT. '+paragraph+'\n\nAll owned compilers and checker processes have collected terminal results. Both locks are released on exit; the serial queue remains paused between batches. The inherited staged record is unchanged. Ordinary reviewed Git commit and private push are still separate pending actions at the time of this record.\n')
    print('VERIFIED_UNIT',now,'fields',len(fields),'pairs',pairs,'theorems',nt,'definitions',nd,'axiom_nonempty_count',len(nonempty),flush=True)
    print('REMAINING_NUMERIC',numeric,'JOINS',joins,flush=True)
