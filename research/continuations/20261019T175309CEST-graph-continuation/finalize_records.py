"""Finalize explicitly reviewed mixed-status proof work; all Git calls are read-only.
The final plan is supplied only after actual compiler/checker terminal results exist.
"""
from pathlib import Path
from datetime import datetime
import fcntl, hashlib, importlib.util, json, re, subprocess, sys
root=Path('/Users/tp/Lean/D1Bound5');out=Path(__file__).resolve().parent
work=root/'research/continuations/20261018T010800CEST-main-continuation'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):
    with p.open('x') as f:f.write(json.dumps(v,indent=2)+'\n')
def git(*a):return subprocess.run(['git',*a],cwd=root,capture_output=True,check=True).stdout
plan=json.loads((out/'FINAL_PLAN.json').read_text())
compiled=plan['compiled_targets'];verified=plan['verified_targets'];assert set(verified)<=set(compiled)
audit_records=[];axes={};audit_names=[]
for folder in plan['completed_audit_folders']:
    a=out/folder;names=json.loads((a/'TARGETS.json').read_text());replays=json.loads((a/'REPLAY_TARGETS.json').read_text())
    checks=json.loads((a/'TARGETED_REPLAY_RECEIPTS.json').read_text());decls=json.loads((a/'DECLARATIONS.json').read_text())
    assert [x['label'] for x in checks]==['analytic-type-axioms']+[n+'-targeted-replay' for n in replays]
    assert all(x['exit']==0 and x['guards_unchanged'] and not x['timed_out'] for x in checks)
    assert not json.loads((a/'active-targeted-replay.json').read_text())['active']
    assert 'ANALYTIC_CHECKS_PASS' in (a/'checks-console.log').read_text()
    log=(a/'analytic-type-axioms.log').read_text();assert 'error:' not in log
    ax=dict(re.findall(r'ANALYTIC_AXIOMS_PASS (\S+): (\[[^\]]*\])',log))
    assert len(ax)==len(decls)
    for d in decls:
        name=d['name'];assert name in ax
        assert set(x.strip() for x in ax[name].strip('[]').split(',') if x.strip())<={'propext','Classical.choice','Quot.sound'}
        assert re.search(r'^@?'+re.escape(name)+r'(?:\.\{[^}]+\})?(?=\s|:)',log,re.M),name
    assert not set(axes)&set(ax);axes.update(ax);audit_names+=names
    audit_records.append({'folder':folder,'targets':names,'declarations':len(decls),'checks':checks})
assert set(audit_names)==set(verified)
assert sha(work/'continuation_driver_capacity.py')=='df17ea85c25eb77c7413f339d7ac673f28d63ca93a761317312ebef8876068db'
spec=importlib.util.spec_from_file_location('current_finalize',work/'continuation_driver_capacity.py');mod=importlib.util.module_from_spec(spec);sys.modules[spec.name]=mod;spec.loader.exec_module(mod)
# Load the already reviewed comment-aware source scanner without executing its CLI.
scanner=(out/'prepare_wave.py').read_text().split("root=Path('/Users/tp/Lean/D1Bound5')")[0];env={};exec(compile(scanner,'reviewed_source_scanner','exec'),env);source_code=env['source_code']
with (work/'continuation-driver.lock').open('a+') as owner,(work/'continuation-intake.lock').open('a+') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    d=mod.Driver(root,work);active=json.loads(d.active_path.read_text());assert not active['active'] and not active.get('protected_closure')
    q,names,closures,accepted,unknown,eligible=d.snapshot();assert unknown==[] and q['max_parallel']==1 and q['pause_after_current'] is True
    assert set(compiled)<=accepted
    initial=json.loads((out/'INITIAL_STATE.json').read_text())
    assert git('rev-parse','HEAD').decode().strip()==initial['head'] and git('branch','--show-current').decode().strip()=='main'
    index={p:hashlib.sha256(git('show',':'+p)).hexdigest() for p in git('diff','--cached','--name-only','-z').decode().split('\0') if p};assert index==initial['inherited_index']
    tracked=json.loads((out/'TRACKED_AFTER_RECOVERY.json').read_text())
    assert set(git('diff','--name-only').decode().splitlines())==set(tracked)
    assert all(sha(root/n)==h for n,h in tracked.items()), 'Newer tracked work detected'
    assert sha(Path('/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex'))=='776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3'
    source_review={};source_map={};builds=[];all_guards={}
    for audit in audit_records:
        a=out/audit['folder'];g=json.loads((a/'TARGETED_REPLAY_GUARDS.json').read_text())
        assert d.manifest_matches(g['compiled_artifacts']) and d.manifest_matches(g['immutable_inputs'])
        for n,h in g['project_sources'].items():assert sha(root/'D1Bound5'/(n+'.lean'))==h
    for n in compiled:
        cl=d.closure(n)
        for dep,h in cl.items():
            p=root/'D1Bound5'/(dep+'.lean');assert sha(p)==h;s=source_code(p.read_text())
            assert not re.search(r'\b(sorry|admit|sorryAx|axiom|native_decide|unsafe|implemented_by)\b',s),dep
            imports=re.findall(r'^import\s+([^\n]+)',s,re.M);assert not any('research' in x or 'snapshot' in x for x in imports)
            source_review[dep]={'sha256':h,'imports':imports}
        fp=mod.fingerprint(cl);row=next(x for x in reversed(d.rows) if x['name']==n and x['fingerprint']==fp)
        assert row['exit']==0 and row['accepted_build'] and not row['timed_out'] and row['closure_unchanged'] and row['shared_artifacts_unchanged']
        p=root/'D1Bound5'/(n+'.lean');assert sha(p)==row['source_sha256'];all_guards.update(row['artifacts'])
        dest=out/('verified' if n in verified else 'compiled-only');dest.mkdir(exist_ok=True)
        snap=dest/(n+'.lean');assert not snap.exists();snap.write_bytes(p.read_bytes());save(dest/(n+'-BUILD_RECEIPT.json'),row);(dest/(n+'-build.log')).write_bytes(Path(row['log']).read_bytes())
        source_map[n]={'source':str(p.relative_to(root)),'snapshot':str(snap.relative_to(root)),'sha256':sha(p),'status':'TYPE_AXIOM_AND_TARGETED_REPLAY_VERIFIED' if n in verified else 'COMPILED_ONLY_Q_DEPENDENCY_AUDIT_PENDING'};builds.append(row)
    assert d.manifest_matches(all_guards)
    originals=json.loads((out/'ORIGINAL_HEADERS.json').read_text());headers={}
    for n,v in originals.items():
        s=(root/'D1Bound5'/(n+'.lean')).read_text();hs=re.findall(r'^(?:@\[[^\n]*\]\s*)?theorem (.*?) := by',s,re.M|re.S);assert hs==v['headers'],n;headers[n]={'unchanged':True,'theorems':len(hs)}
    now=datetime.now().astimezone().isoformat()
    save(out/'SOURCE_MAP.json',source_map);save(out/'SOURCE_IMPORT_REVIEW.json',{'count':len(source_review),'modules':source_review});save(out/'CURRENT_ARTIFACT_GUARDS.json',all_guards);save(out/'FINAL_HEADER_REVIEW.json',headers)
    summary={'time':now,'status':'COMPLETED_UNITS_WITH_EXPLICIT_PENDING_Q_AUDIT','compiled_targets':compiled,'verified_targets':verified,'compiled_only_targets':sorted(set(compiled)-set(verified)),'source_closure_count':len(source_review),'audits':audit_records,'public_axiom_sets':axes,'build_receipts':builds,'original_analytic_headers_unchanged':True,'Q_audit_pending':True,'root_integrated':False,'main_statement_proved':False,'independent_final_review':False,'whole_root_clean_checkout':False,'automations_modified':False}
    save(out/'VERIFICATION_SUMMARY.json',summary)
    text=plan['status_paragraph']+' Evidence: research/continuations/'+out.name+'/VERIFICATION_SUMMARY.json.'
    title=plan['status_title']
    for n in ['STATUS.md','records/open-obligations.md','records/paper-to-lean.md','records/build-record.md']:
        p=root/n;s=p.read_text();assert title not in s;p.write_text(s.rstrip()+'\n\n## '+title+'\n\n'+text+'\n')
    (root/'records/runs'/(out.name+'-FINISH.md')).write_text('# FINISH — '+now+'\n\nOutcome: COMPLETED_UNIT for the explicitly verified independent units; PARTIAL for the Q-dependent analytic endpoint. '+text+'\n\nAll owned compiler and checker terminal results have been collected. Preserved failed trials are not accepted dependencies. Frozen manuscript, pins, inherited index and accepted root are unchanged. Private synchronization is a separate subsequent step, not claimed in this pre-commit record.\n')
    print('FINAL_RECORDS_SAVED',now,'compiled',len(compiled),'verified',len(verified),'source_closure',len(source_review))
