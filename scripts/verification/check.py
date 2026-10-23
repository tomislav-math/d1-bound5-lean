#!/usr/bin/env python3
"""Verify a clean committed project checkout without importing old project artifacts.

Source policy, fresh compilation, exact type/axiom audits and official fresh
kernel replay have separate outcomes. Without --replay the final gate remains
pending and this program exits 3. This program never mutates Git or downloads.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time
import types

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[2]


def require(ok, message):
    if not ok:
        raise RuntimeError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def read(path):
    return json.loads(Path(path).read_text())


def save(path, value):
    Path(path).write_text(json.dumps(value, sort_keys=True, indent=2) + '\n')


def under(path, root):
    try:
        Path(path).resolve().relative_to(Path(root).resolve())
        return True
    except ValueError:
        return False


def manifest(path):
    result = {}
    for line in Path(path).read_text().splitlines():
        if not line.strip():
            continue
        digest, name = line.split(None, 1)
        name = name.lstrip('*')
        require(len(digest) == 64 and all(c in '0123456789abcdef' for c in digest), 'Invalid manifest SHA256')
        p = Path(name)
        require(not p.is_absolute() and '..' not in p.parts and name not in result, 'Invalid manifest path')
        result[name] = digest
    require(result, 'Empty manifest: ' + str(path))
    return result


def git(*args):
    return subprocess.check_output(['git', '-C', str(ROOT), *args], stderr=subprocess.PIPE)


def validate_repository(source_lock):
    pins = read(ROOT/'scripts/verification/release_pins.json')
    proof = manifest(ROOT/'records/proof-source-sha256.txt')
    selected = {row['relative_path']: row['sha256'] for row in source_lock['sources'].values()}
    require(proof == selected, 'Production manifest differs from the exact source lock')
    require(source_lock['namespace'] == 'D1Bound5' and source_lock['roots'] == ['D1Bound5'], 'Wrong canonical root')
    require(source_lock['module_count'] == pins['expected_project_modules'], 'Wrong reviewed release scope')
    tools = manifest(ROOT/'records/verification-tools-sha256.txt')
    required_tools = set(pins['required_tools']) | set(pins['configuration_sha256'])
    require(required_tools <= set(tools), 'Required gate/configuration file absent from tools manifest')
    for name, digest in pins['configuration_sha256'].items():
        require(tools[name] == digest, 'Configuration pin differs from tool manifest: ' + name)
    selected.update({name: tools[name] for name in required_tools})
    selected['scripts/verification/release_pins.json'] = sha(ROOT/'scripts/verification/release_pins.json')
    selected['records/proof-source-sha256.txt'] = sha(ROOT/'records/proof-source-sha256.txt')
    selected['records/verification-tools-sha256.txt'] = sha(ROOT/'records/verification-tools-sha256.txt')
    tracked = set(git('ls-files', '-z').decode().split('\0'))
    require(set(selected) <= tracked, 'Verification requires committed production/gate files')
    for name, expected in selected.items():
        p = ROOT/name
        require(under(p, ROOT) and not p.is_symlink() and p.is_file(), 'Missing/escaping selected file: ' + name)
        require(sha(p) == expected, 'Current file differs from reviewed manifest: ' + name)
        require(hashlib.sha256(git('show', 'HEAD:' + name)).hexdigest() == expected,
                'Selected file differs from committed HEAD: ' + name)
    return {'commit': git('rev-parse', 'HEAD').decode().strip(),
            'tree': git('rev-parse', 'HEAD^{tree}').decode().strip(),
            'selected_files': selected, 'production_scope': source_lock['module_count'],
            'selected_files_match_commit': True, 'release_pins': pins}


def run_command(command, log_path, cwd, env=None, timeout=None):
    process = None
    start = time.monotonic()
    try:
        with Path(log_path).open('w') as log:
            process = subprocess.Popen(command, cwd=cwd, env=env, stdout=log,
                                       stderr=subprocess.STDOUT, start_new_session=True)
            code = process.wait(timeout=timeout)
        return {'command': command, 'exit_code': code, 'seconds': time.monotonic()-start,
                'log_sha256': sha(log_path)}
    except BaseException:
        if process is not None and process.poll() is None:
            try:
                os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
            try:
                # The fresh builder handles SIGTERM by terminating its own Lean
                # process groups, with a five-second escalation grace period.
                process.wait(timeout=20)
            except subprocess.TimeoutExpired:
                try:
                    os.killpg(process.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                process.wait()
        raise


def import_file(path, name, expected_sha256):
    path = Path(path).resolve()
    source = path.read_bytes()
    require(hashlib.sha256(source).hexdigest() == expected_sha256, 'Helper source differs from committed input')
    module = types.ModuleType(name)
    module.__file__ = str(path)
    # Execute exactly the reviewed bytes; a timestamp-valid .pyc is not an input.
    exec(compile(source, str(path), 'exec'), module.__dict__)
    require(sha(path) == expected_sha256, 'Helper source changed while loading')
    return module


def audit_arguments(args, committed):
    return argparse.Namespace(source_root=str(ROOT), artifact_root=str(Path(args.build_dir)/'artifacts'),
        build_dir=args.build_dir, source_lock=args.source_lock, source_lock_sha256=args.source_lock_sha256,
        runtime_lock=args.runtime_lock, runtime_lock_sha256=args.runtime_lock_sha256,
        build_runner=str(ROOT/'scripts/fresh_project_build.py'),
        integration_audit=str(ROOT/'scripts/verification/FinalIntegrationAudit.lean'),
        target_audit=str(ROOT/'scripts/verification/FinalTargetAudit.lean'),
        expected_commit=committed['commit'], expected_tree=committed['tree'])


def run(args):
    out = Path(args.evidence_dir).resolve()
    build = Path(args.build_dir).resolve()
    require(not under(out, ROOT) and not under(out, build) and not under(build, out),
            'Evidence, source and build directories must be separate')
    require(not out.exists() or not any(out.iterdir()), 'Use a new empty evidence directory for every invocation')
    out.mkdir(parents=True, exist_ok=True)
    result = {'status': 'RUNNING', 'source_policy': 'PENDING', 'fresh_source_build': 'PENDING',
              'exact_type_axiom_audits': 'PENDING', 'official_fresh_kernel_replay': 'PENDING',
              'optional_broad_compatibility_audit': 'NOT_RUN_PENDING_SEPARATE_GATE',
              'complete_verification': False, 'steps': []}
    save(out/'SUMMARY.json', result)
    try:
        require(sha(args.source_lock) == args.source_lock_sha256, 'Source lock SHA mismatch')
        require(sha(args.runtime_lock) == args.runtime_lock_sha256, 'Runtime lock SHA mismatch')
        source_lock = read(args.source_lock)
        frozen = validate_repository(source_lock)
        save(out/'COMMITTED_INPUTS.json', frozen)
        py = sys.executable
        policy = ROOT/'scripts/verification/source_policy.py'
        row = run_command([py, str(policy), '--project', str(ROOT), '--out', str(out/'source-policy')],
                          out/'source-policy.log', str(ROOT))
        result['steps'].append(row)
        require(row['exit_code'] == 0, 'Source policy has unresolved or forbidden findings')
        policy_report = read(out/'source-policy/SOURCE_POLICY_REPORT.json')
        require(policy_report['status'] == 'SOURCE_POLICY_PASS_SOURCE_ONLY',
                'Source policy did not accept exact reviewed findings')
        policy_sources = read(out/'source-policy/SOURCE_MANIFEST.json')
        expected_policy_sources = {name: {key: row[key] for key in ['relative_path', 'bytes', 'sha256']}
                                   for name, row in source_lock['sources'].items()}
        require(policy_sources == expected_policy_sources, 'Source policy scanned a different source snapshot')
        result['source_policy'] = 'SOURCE_POLICY_PASS_SOURCE_ONLY'
        save(out/'SUMMARY.json', result)
        command = [py, str(ROOT/'scripts/fresh_project_build.py'), 'run', '--source-root', str(ROOT),
            '--build-dir', str(build), '--source-lock', args.source_lock,
            '--source-lock-sha256', args.source_lock_sha256, '--runtime-lock', args.runtime_lock,
            '--runtime-lock-sha256', args.runtime_lock_sha256, '--expected-modules', str(source_lock['module_count']),
            '--jobs', str(args.jobs), '--timeout', str(args.build_timeout)]
        if args.resume:
            command.append('--resume')
        if args.hints:
            command += ['--hints', args.hints]
        row = run_command(command, out/'build.log', str(ROOT))
        result['steps'].append(row)
        require(row['exit_code'] == 0, 'Fresh source build failed or remains incomplete')
        build_summary = read(build/'SUMMARY.json')
        require(build_summary['status'] in ['FRESH_PROJECT_SOURCE_BUILD_PASS', 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'],
                'Build summary is not complete')
        result['fresh_source_build'] = build_summary['status']
        save(out/'SUMMARY.json', result)
        audit_args = audit_arguments(args, frozen)
        command = [py, str(ROOT/'scripts/verification/clean_final_audits.py')]
        for key, value in vars(audit_args).items():
            command += ['--' + key.replace('_', '-'), value]
        command += ['--out', str(out/'audits'), '--timeout', str(args.audit_timeout)]
        row = run_command(command, out/'audits.log', str(ROOT))
        result['steps'].append(row)
        require(row['exit_code'] == 0, 'Exact type/transitive-axiom audits failed')
        audits = read(out/'audits/SUMMARY.json')
        require(audits['status'] == 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS', 'Audit summary is incomplete')
        result['exact_type_axiom_audits'] = audits['status']
        save(out/'SUMMARY.json', result)
        helper_name = 'scripts/verification/clean_final_audits.py'
        helper = import_file(ROOT/helper_name, 'clean_audit_freeze', frozen['selected_files'][helper_name])
        fb = helper.load_builder(audit_args.build_runner)
        audited_freeze_path = out/'audits/INPUT_FREEZE.json'
        require(sha(audited_freeze_path) == audits['input_freeze_sha256'], 'Audited input freeze hash changed')
        audited_freeze = read(audited_freeze_path)
        with (build/'build.lock').open('r') as lock:
            fcntl.flock(lock.fileno(), fcntl.LOCK_SH | fcntl.LOCK_NB)
            before = helper.freeze(audit_args, fb)
            require(before == audited_freeze, 'Current inputs differ from the exact type/axiom-audited snapshot')
            if not args.replay:
                require(validate_repository(source_lock) == frozen, 'Committed input changed during verification')
                result['status'] = 'SOURCE_BUILD_AND_AUDITS_PASS_FRESH_REPLAY_PENDING'
                save(out/'SUMMARY.json', result)
                print(result['status'])
                return 3
            save(out/'KERNEL_INPUT_FREEZE.json', before)
            runtime = read(args.runtime_lock)
            checker = str(Path(runtime['toolchain'])/'bin/leanchecker')
            require(checker in runtime['files'] and sha(checker) == runtime['files'][checker], 'Unpinned installed checker')
            environment = dict(before['environment'])
            environment['LEAN_NUM_THREADS'] = '0'
            command = [checker, '--verbose', '--fresh', 'D1Bound5']
            row = run_command(command, out/'fresh-kernel.log', str(ROOT), environment, args.replay_timeout)
            row['environment'] = environment
            result['steps'].append(row)
            require(row['exit_code'] == 0, 'Official fresh replay failed')
            replay_lines = [line.strip() for line in (out/'fresh-kernel.log').read_text().splitlines()
                            if line.strip().startswith('replaying ')]
            require(replay_lines == ['replaying D1Bound5 with --fresh'], 'Unexpected replay target/scope')
            require(helper.freeze(audit_args, fb) == before, 'Frozen replay inputs changed')
        require(validate_repository(source_lock) == frozen, 'Committed input changed during verification')
        result.update(status='COMPLETE_VERIFICATION_PASS', official_fresh_kernel_replay='PASS_OFFICIAL_FRESH_D1Bound5',
                      complete_verification=True)
        save(out/'SUMMARY.json', result)
        print(result['status'])
        return 0
    except BaseException as error:
        result.update(status='FAILED_OR_INTERRUPTED_NO_COMPLETE_ACCEPTANCE', error=repr(error))
        save(out/'SUMMARY.json', result)
        raise


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ['source-lock', 'source-lock-sha256', 'runtime-lock', 'runtime-lock-sha256', 'build-dir', 'evidence-dir']:
        ap.add_argument('--' + name, required=True)
    ap.add_argument('--jobs', type=int, choices=range(1, 8), default=4)
    ap.add_argument('--resume', action='store_true')
    ap.add_argument('--replay', action='store_true', help='Run the separate official fresh root kernel gate')
    ap.add_argument('--hints')
    ap.add_argument('--build-timeout', type=int, default=1200, help='Per-module compiler timeout; scheduling hints may override it')
    ap.add_argument('--audit-timeout', type=int, default=900)
    ap.add_argument('--replay-timeout', type=int, default=14400)
    args = ap.parse_args()
    require(args.build_timeout > 0 and args.audit_timeout > 0 and args.replay_timeout > 0, 'Timeouts must be positive')
    for name in ['source_lock', 'runtime_lock', 'build_dir', 'evidence_dir']:
        setattr(args, name, str(Path(getattr(args, name)).resolve()))
    return run(args)


if __name__ == '__main__':
    def terminate(signum, frame):
        raise KeyboardInterrupt('Termination signal ' + str(signum))
    signal.signal(signal.SIGTERM, terminate)
    try:
        sys.exit(main())
    except (Exception, KeyboardInterrupt) as error:
        print('VERIFICATION_FAILED:', repr(error), file=sys.stderr)
        sys.exit(1)
