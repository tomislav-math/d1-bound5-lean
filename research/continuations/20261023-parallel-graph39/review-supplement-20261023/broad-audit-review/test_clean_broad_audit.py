#!/usr/bin/env python3
"""Lightweight broad-audit evidence/parser rejection checks; no Lean launches."""
import json
from pathlib import Path
import tempfile
import signal
import types
import clean_broad_audit as audit

HERE = Path(__file__).resolve().parent


def main():
    passed = []
    text = ('AUDIT D1Bound5.a: [propext]\nAUDIT D1Bound5.b: []\n'
            'AXIOM_AUDIT_PASS: 2 project declarations\n'
            'BROAD_PROJECT_AXIOM_AUDIT_PASS 3 declarations\n' +
            ''.join('FINAL_TARGET_AXIOMS_PASS '+n+': [propext, Classical.choice, Quot.sound]\n'
                    for n in sorted(audit.TARGET_NAMES)))
    assert audit.markers(text) == {'exported_project_declarations': 2, 'including_private_declarations': 3,
                                   'independent_target_markers': 4, 'individual_exported_audit_lines': 2}
    passed.append('exact_expected_marker_sets')
    def rejects(name, action, expected):
        try: action()
        except RuntimeError as error: assert expected in str(error), str(error)
        else: raise AssertionError('Guard accepted '+name)
        passed.append(name)
    rejects('missing_old_broad_marker', lambda:audit.markers(text.replace('AXIOM_AUDIT_PASS: 2 project declarations','')), 'broad audit success markers')
    rejects('duplicate_broad_success', lambda:audit.markers(text+'AXIOM_AUDIT_PASS: 2 project declarations\n'), 'broad audit success markers')
    rejects('private_count_below_exported', lambda:audit.markers(text.replace('PASS 3 declarations','PASS 1 declarations')), 'broad audit success markers')
    rejects('missing_preserved_individual_output', lambda:audit.markers(text.replace('AUDIT D1Bound5.a: [propext]\n','')), 'per-declaration audit output')
    rejects('wrong_target_marker', lambda:audit.markers(text.replace('D1Bound5.main_statement:', 'D1Bound5.wrong_statement:')), 'target marker set')
    rejects('duplicate_target_marker', lambda:audit.markers(text+'FINAL_TARGET_AXIOMS_PASS D1Bound5.main_statement: []\n'), 'target marker set')
    p=HERE/'CLEAN_AUDIT_INVOCATION.json';args,helper=audit.invocation(p,audit.sha(p))
    assert Path(args.artifact_root).name=='artifacts' and audit.sha(helper)==audit.HELPER_SHA
    passed.append('actual_prepared_invocation_read_only')
    with tempfile.TemporaryDirectory(prefix='broad-audit-invocation-tests-') as temp:
        q=Path(temp)/'invocation.json';original=audit.read(p)
        def write(row): audit.save(q,row);return audit.sha(q)
        changed=json.loads(json.dumps(original));changed['argv']+=['--trust','all']
        h=write(changed)
        rejects('unexpected_invocation_flag',lambda:audit.invocation(q,h),'Unexpected/missing')
        changed=json.loads(json.dumps(original));changed['argv']+=['--source-root','/other']
        h=write(changed)
        rejects('duplicate_invocation_flag',lambda:audit.invocation(q,h),'Malformed/repeated')
        h=write(original)
        rejects('invocation_hash_changed',lambda:audit.invocation(q,'0'*64),'invocation changed')
    try: audit.terminate(signal.SIGTERM,None)
    except InterruptedError: passed.append('sigterm_enters_exception_cleanup')
    else: raise AssertionError('SIGTERM handler must raise through subprocess cleanup')
    with tempfile.TemporaryDirectory(prefix='broad-exact-evidence-tests-') as temp:
        exact=Path(temp)
        args=types.SimpleNamespace(out=str(exact),source_root='/fixture/source',
             source_lock_sha256='a'*64,runtime_lock_sha256='b'*64,
             integration_audit='/fixture/source/FinalIntegrationAudit.lean',
             target_audit='/fixture/source/FinalTargetAudit.lean')
        frozen={'lean':'/fixture/toolchain/bin/lean'}
        helper=types.SimpleNamespace(INTEGRATION_SHA='c'*64,TARGET_SHA='d'*64,freeze=lambda a,b:frozen)
        audit.save(exact/'INPUT_FREEZE.json',frozen)
        summary={'status':'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS',
            'post_audit_all_input_hashes_equal':True,'accepted_fresh_project_modules':4406,
            'source_lock_sha256':args.source_lock_sha256,'runtime_lock_sha256':args.runtime_lock_sha256,
            'input_freeze_sha256':audit.sha(exact/'INPUT_FREEZE.json'),'audits':[]}
        for name,count,h,path,marker in [
            ('FinalIntegrationAudit',114,helper.INTEGRATION_SHA,args.integration_audit,'ORIGINAL_TYPE_AXIOMS_PASS'),
            ('FinalTargetAudit',4,helper.TARGET_SHA,args.target_audit,'FINAL_TARGET_AXIOMS_PASS')]:
            log=exact/(name+'.log');log.write_text((marker+' fixture\n')*count)
            summary['audits'].append({'name':name,'exit_code':0,'expected_pass_markers':count,
                'observed_pass_markers':count,'audit_sha256':h,'log_sha256':audit.sha(log),
                'command':[frozen['lean'],'-j1','-DautoImplicit=false','-R',args.source_root,path]})
        audit.save(exact/'SUMMARY.json',summary)
        audit.verify_exact_audit(args,helper,None)
        passed.append('consistent_exact_audit_evidence_fixture')
        log=exact/'FinalIntegrationAudit.log';original=log.read_text();log.write_text(original.replace('ORIGINAL_TYPE_AXIOMS_PASS','WRONG',1))
        summary['audits'][0]['log_sha256']=audit.sha(log);audit.save(exact/'SUMMARY.json',summary)
        rejects('forged_marker_counts_recounted',lambda:audit.verify_exact_audit(args,helper,None),'Actual exact-audit log marker count')
        log.write_text(original);summary['audits'][0]['log_sha256']=audit.sha(log)
        summary['audits'][0]['command'][0]='/fixture/unreviewed/compiler';audit.save(exact/'SUMMARY.json',summary)
        rejects('unexpected_recorded_exact_command',lambda:audit.verify_exact_audit(args,helper,None),'Recorded exact-audit command')
        summary['audits'][0]['command'][0]=frozen['lean'];audit.save(exact/'SUMMARY.json',summary)
        helper.freeze=lambda a,b:{'lean':'/changed/runtime/bin/lean'}
        rejects('changed_current_exact_snapshot',lambda:audit.verify_exact_audit(args,helper,None),'Current clean inputs differ')
    result={'status':'PASS','scope':'Marker and immutable invocation structural fixtures; no Lean/checker launched',
            'tests':passed,'runner_sha256':audit.sha(HERE/'clean_broad_audit.py'),
            'tests_sha256':audit.sha(Path(__file__))}
    audit.save(HERE/'CLEAN_BROAD_GUARD_TESTS.json',result)
    print(json.dumps(result,indent=2))


if __name__=='__main__':main()
