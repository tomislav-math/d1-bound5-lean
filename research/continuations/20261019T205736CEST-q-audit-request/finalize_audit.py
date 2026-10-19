"""Preserve completed Q verification. No Git mutation or compiler launch."""
from pathlib import Path
from datetime import datetime
import fcntl,hashlib,json,re,shutil,subprocess
r=Path('/Users/tp/Lean/D1Bound5');o=Path(__file__).resolve().parent
old=r/'research/continuations/20261019T160406CEST-q-recovery';a=old/'audit'
w=r/'research/continuations/20261018T010800CEST-main-continuation'
sha=lambda b:hashlib.sha256(b).hexdigest()
def save(p,v):
    with p.open('x') as f:json.dump(v,f,indent=2);f.write('\n')
initial=json.loads((o/'INITIAL_STATE.json').read_text())
with (w/'continuation-driver.lock').open('r') as owner,(w/'continuation-intake.lock').open('r') as intake:
    fcntl.flock(owner,fcntl.LOCK_EX|fcntl.LOCK_NB);fcntl.flock(intake,fcntl.LOCK_EX|fcntl.LOCK_NB)
    state=json.loads((w/'continuation-active.json').read_text());assert not state['active'] and not state['protected_closure']
    assert not json.loads((a/'active-targeted-replay.json').read_text())['active']
    checks=json.loads((a/'TARGETED_REPLAY_RECEIPTS.json').read_text())
    assert len(checks)==5 and all(x['exit']==0 and not x['timed_out'] and x['guards_unchanged'] for x in checks)
    guards=json.loads((a/'TARGETED_REPLAY_GUARDS.json').read_text())
    for n,h in guards['project_sources'].items():assert sha((r/'D1Bound5'/(n+'.lean')).read_bytes())==h
    for p,h in {**guards['compiled_artifacts'],**guards['immutable_inputs']}.items():assert sha((r/p).read_bytes())==h
    for p,h in initial['audit_inputs'].items():assert sha((r/p).read_bytes())==h
    declarations=json.loads((a/'DECLARATIONS.json').read_text())
    log=(a/'analytic-type-axioms.log').read_text()
    assert log.count('ANALYTIC_AXIOMS_PASS')==len(declarations)==34
    assert 'error:' not in log.lower() and 'sorryAx' not in log
    for x in checks[1:]:
        text=(a/x['log']).read_text()
        assert 'replaying D1Bound5.' in text
    inherited={p:sha(subprocess.check_output(['git','show',':'+p],cwd=r)) for p in subprocess.check_output(['git','diff','--cached','--name-only','-z'],cwd=r,text=True).split('\0') if p}
    assert inherited==initial['inherited_staged']
    (o/'sources').mkdir();(o/'compile-evidence').mkdir()
    source_map={};builds=json.loads((old/'PARTIAL_COMPILATION_SUMMARY.json').read_text())['builds']
    assert len(builds)==8
    for row in builds:
        n=row['name'];s=r/'D1Bound5'/(n+'.lean');assert row['accepted_build'] and row['exit']==0 and not row['timed_out']
        assert sha(s.read_bytes())==row['source_sha256']==guards['project_sources'][n]
        for p,h in row['artifacts'].items():assert sha((r/p).read_bytes())==h
        dst=o/'sources'/s.name;shutil.copyfile(s,dst)
        source_map[n]={'source':str(s.relative_to(r)),'snapshot':str(dst.relative_to(r)),'sha256':sha(s.read_bytes())}
        src=Path(row['log']);assert src.is_file();shutil.copyfile(src,o/'compile-evidence'/(n+'-build.log'))
    save(o/'SOURCE_MAP.json',source_map);save(o/'COMPILE_RECEIPTS.json',builds)
    summary={'outcome':'COMPLETED_UNIT','time':datetime.now().astimezone().isoformat(),'scope':'Previously compiled finite Q family now passes the pending verification gates. No mathematical source was changed.','modules':[x['name'] for x in builds],'public_theorems':23,'definitions':11,'public_type_and_transitive_axiom_checks':34,'exact_original_endpoint_examples':3,'targeted_installed_same_kernel_replays':[x['label'] for x in checks[1:]],'new_proof_compilations':0,'recovered_current_guarded_builds':8,'project_source_closure':len(guards['project_sources']),'allowed_axioms':['propext','Classical.choice','Quot.sound'],'audit_directory':str(a.relative_to(r)),'audit_receipts':checks,'inherited_staging_preserved':len(inherited),'independent_review':False,'root_integrated':False,'main_statement_proved':False,'remaining':'Graph row26 endpoint, other finite graph rows and analytic branches, dependent three-small completion audits, accepted-root integration, independent final statement review and whole-project clean-checkout/kernel gates remain separate obligations.'}
    save(o/'VERIFICATION_SUMMARY.json',summary)
    record=r/'records/runs'/(o.name+'-FINISH.md')
    record.write_text('# FINISH\n\n'+summary['time']+'\n\nOutcome: COMPLETED_UNIT.\n\nThe exact pending finite-Q verification has completed. The eight unchanged current source modules have matching successful pinned compilation receipts. All 34 public declarations (23 theorems, 11 definitions) passed elaborated-type/transitive-axiom inspection, and the original determinant, full-ring inequality and closed-interval theorem were checked against explicit original-type examples. Four targeted installed SAME-kernel replays passed with 42 project-source dependencies and all compiled artifacts unchanged. Only propext, Classical.choice and Quot.sound occur transitively. No new mathematical proof source was changed, no independent review or clean-checkout validation is claimed, and MainStatement remains unproved.\n\nThe earlier combined-command refusal was reviewed and retained unchanged. The current explicit request was executed using an ordinary direct invocation of the reviewed audit through the same authorized tool, without permission changes or alternative access routes. The 547 inherited staged entries remain unchanged. Private synchronization of this new verification record is a separate stage.\n\nThe source and manuscript explanation identifies row26 as the 26th table case, the pair {(-3-sqrt(-3))/2,1} in the full Eisenstein ring, and identifies Q as the manuscript subsection Five linear rows on four fixed entries. The finite-Q audit is no longer an open obligation. The three dependent final-three-small modules still require their separate completion checks.\n')
    print('FINITE_Q_VERIFIED',summary['time'],'23 theorems,11 definitions,4 targeted replays,42 source modules')
