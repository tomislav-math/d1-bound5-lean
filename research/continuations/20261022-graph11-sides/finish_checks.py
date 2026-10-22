"""Record completed graph11 side audits; never compile or claim the graph endpoint."""
from pathlib import Path
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import sys

O = Path(__file__).resolve().parent
PREPARE_SHA = '70291589163ff26ea091753bc6ef3f53fe94686ed5b2899e77fb7d693bcb072c'


def main():
    # Share the reviewed read-only validation functions, with their exact bytes pinned.
    path = O / 'prepare_checks.py'
    assert hashlib.sha256(path.read_bytes()).hexdigest() == PREPARE_SHA
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location('graph11_sides_prepare_helpers', path)
    checks = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = checks
    spec.loader.exec_module(checks)
    assert O == checks.C / '20261022-graph11-sides'
    assert len(sys.argv) == 2 and sys.argv[1] in checks.SCOPES
    scope = sys.argv[1]
    module, driver = checks.load_driver()
    with (checks.W / 'continuation-driver.lock').open('r+') as owner, \
            (checks.W / 'continuation-intake.lock').open('r+') as intake:
        for lock in (owner, intake):
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        checks.idle(driver)
        summary = checks.load(O / (scope + '-PREPARATION.json'))
        targets = summary['targets']
        assert targets == checks.SCOPES[scope] == checks.load(O / (scope + '-TARGETS.json'))
        assert summary['definitions'] == 0
        assert summary['theorems'] == summary['declarations'] == checks.DECLARATION_COUNTS[scope]
        assert summary['public_headers_exact'] is True
        assert summary['root_integration'] is False and summary['main_theorem_complete'] is False
        assert summary['whole_graph11_complete'] is False
        assert summary['audit'] == str((checks.U / ('pro-graph11-' + scope + '-audit')).relative_to(checks.R))
        assert not (O / (scope + '-PROOF_STATE.json')).exists()
        assert not (O / (scope + '-VERIFICATION_SUMMARY.json')).exists()
        source_map = checks.load(O / (scope + '-SOURCE_MAP.json'))
        evidence = checks.load(O / (scope + '-ACCEPTED_DEPENDENCY_EVIDENCE.json'))
        assert source_map['base_commit'] == summary['base_commit']
        assert len(source_map['sources']) == summary['source_closure_modules']
        latest = driver.latest()
        _, state, _ = checks.verify_bound_checks(
            scope, source_map['sources'], evidence, driver, module, latest)
        if scope != 'sides-pilot':
            reuse_path = O / (scope + '-PILOT_REUSE_EVIDENCE.json')
            assert summary['pilot_reuse_evidence'] == str(reuse_path.relative_to(checks.R))
            assert summary['pilot_reuse_evidence_sha256'] == checks.sha(reuse_path)
            assert checks.load(reuse_path) == checks.verify_pilots(driver, module, latest)
        for name, item in source_map['sources'].items():
            if name in targets:
                assert item['assurance'] == 'guarded_build_pass_current_audit_pending'
                assert item['payload_path'] == str((O / 'candidates' / (name + '.lean')).relative_to(checks.R))
                assert checks.sha(O / 'candidates' / (name + '.lean')) == item['sha256']
                item['assurance'] = checks.ASSURANCE
            elif name in checks.SCOPES['sides-pilot']:
                assert scope != 'sides-pilot'
                assert item['assurance'] == 'reused_scoped_verified_source_and_artifacts'
                assert item['payload_path'] == str((O / 'candidates' / (name + '.lean')).relative_to(checks.R))
        summary.update(status='SCOPED_VERIFICATION_PASS', utc=datetime.now(timezone.utc).isoformat(),
                       guarded_builds=len(targets), targeted_same_kernel_replays=len(targets),
                       proof_fingerprint=checks.fingerprint(state), whole_graph11_complete=False,
                       publication='PREPARED_NOT_YET_PUSHED')
        (O / (scope + '-SOURCE_MAP.json')).write_text(json.dumps(source_map, indent=2, sort_keys=True) + '\n')
        checks.put(O / (scope + '-PROOF_STATE.json'), state)
        checks.put(O / (scope + '-VERIFICATION_SUMMARY.json'), summary)
        print(json.dumps(summary), flush=True)


if __name__ == '__main__':
    main()
