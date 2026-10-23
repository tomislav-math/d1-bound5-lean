#!/usr/bin/env python3
"""Non-Lean fixtures only; never import or execute the audit scripts."""
import hashlib
import json
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import time

BASE = Path(__file__).resolve().parent
OBSERVER = BASE / 'measure_invocation.py'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    reports = []
    (BASE / 'observations').mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='fixture-', dir=BASE / 'observations') as temp:
        root = Path(temp)
        fixtures = root / 'inputs'
        fixtures.mkdir()
        fixture = fixtures / 'fixture.py'
        fixture.write_text('''import json, os, pathlib, subprocess, sys, time
if sys.argv[1] == "allocation":
    child = [sys.executable, "-c", "a=bytearray(8*1024*1024);a[0]=1"]
    subprocess.run(child, check=True)
    pathlib.Path(sys.argv[2]).write_text(json.dumps({"cwd": os.getcwd(), "sentinel": os.environ.get("OBSERVATION_FIXTURE_SENTINEL"), "argv":sys.argv}))
    sys.exit(7)
if sys.argv[1] == "signal":
    pathlib.Path(sys.argv[2]).write_text("ready")
    time.sleep(20)
''')
        observation = root / 'observed.json'
        invocation = fixtures / 'invocation.json'

        def command(mode, out_name):
            row = {'argv': [sys.executable, str(fixture), mode, str(observation)],
                   'runner_sha256': sha(fixture)}
            invocation.write_text(json.dumps(row))
            return [sys.executable, str(OBSERVER), '--invocation', str(invocation),
                    '--invocation-sha256', sha(invocation), '--out', str(root / out_name)]

        dry = command('allocation', 'dry')
        run = subprocess.run(dry, text=True, capture_output=True)
        assert run.returncode == 0 and not (root / 'dry').exists() and not observation.exists()
        assert json.loads(run.stdout)['status'] == 'PREPARED_NOT_EXECUTED'
        reports.append({'case': 'dry_run_never_launches_fixture', 'pass': True})

        bad = list(dry)
        bad[bad.index('--invocation-sha256') + 1] = '0' * 64
        run = subprocess.run(bad + ['--execute'], text=True, capture_output=True)
        assert run.returncode != 0 and not observation.exists()
        reports.append({'case': 'wrong_invocation_hash_rejected_before_exec', 'pass': True})

        import os
        env = os.environ.copy()
        env['OBSERVATION_FIXTURE_SENTINEL'] = 'unchanged-fixture-value'
        run = subprocess.run(command('allocation', 'allocation') + ['--execute'],
                             cwd=root, env=env, text=True, capture_output=True)
        assert run.returncode == 7, run.stderr
        row = json.loads((root / 'allocation' / 'RESOURCE_USAGE.json').read_text())
        observed = json.loads(observation.read_text())
        assert observed['cwd'] == str(root)
        assert observed['sentinel'] == 'unchanged-fixture-value'
        assert row['argv'] == json.loads(invocation.read_text())['argv']
        assert row['child_exit_code'] == 7 and row['wait4_rusage']['ru_maxrss'] > 8192
        assert row['invocation_unchanged'] and row['runner_unchanged'] and row['observer_unchanged']
        assert row['proof_acceptance'] == 'NOT_ASSESSED_BY_OBSERVER'
        reports.append({'case': 'argv_cwd_env_exit_and_waited_descendant_rusage', 'pass': True,
                        'raw_rusage': row['wait4_rusage'], 'wall_seconds': row['wall_seconds']})

        observation.unlink()
        child = subprocess.Popen(command('signal', 'signal') + ['--execute'],
                                 stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        deadline = time.monotonic() + 5
        while not observation.exists() and time.monotonic() < deadline:
            time.sleep(0.02)
        assert observation.exists(), 'Fixture failed to become ready'
        child.send_signal(signal.SIGTERM)
        stdout, stderr = child.communicate(timeout=5)
        assert child.returncode == 143, (stdout, stderr, child.returncode)
        row = json.loads((root / 'signal' / 'RESOURCE_USAGE.json').read_text())
        assert row['child_exit_code'] == -signal.SIGTERM
        assert row['forwarded_signals'][0]['signal'] == signal.SIGTERM
        reports.append({'case': 'owned_child_signal_forwarded_reaped_and_recorded', 'pass': True})

        fault_driver = fixtures / 'fault_driver.py'
        fault_driver.write_text('''import importlib.util, os, sys
spec=importlib.util.spec_from_file_location("observer",sys.argv[1])
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
real_wait4=os.wait4
calls=0
def fault_once(*args):
    global calls
    calls+=1
    if calls==1:raise RuntimeError("fixture-only injected wait4 failure")
    return real_wait4(*args)
os.wait4=fault_once
sys.argv=[sys.argv[1]]+sys.argv[2:]
module.main()
''')
        fault_command = command('signal', 'failure')
        run = subprocess.run([sys.executable, str(fault_driver), str(OBSERVER)] + fault_command[2:] + ['--execute'],
                             text=True, capture_output=True, timeout=10)
        assert run.returncode != 0
        row = json.loads((root / 'failure' / 'ERROR.json').read_text())
        assert row['status'] == 'RESOURCE_OBSERVATION_INCOMPLETE'
        assert row['owned_child_cleanup']['status'] == 'OWNED_CHILD_REAPED'
        reports.append({'case': 'injected_exception_terminates_and_reaps_only_owned_child', 'pass': True})
    report = {'status': 'PASS_NON_LEAN_FIXTURES_ONLY', 'observer_sha256': sha(OBSERVER),
              'tests_sha256': sha(__file__), 'no_lean_or_audit_execution': True, 'cases': reports}
    (BASE / 'VALIDATION.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
