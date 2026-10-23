#!/usr/bin/env python3
"""Separate broad compatibility audit after the exact 118 clean checks.

The broad source stays outside the immutable candidate. Its fixed bytes are
elaborated with the exact clean environment and artifacts already accepted by
the 118-check audit. No project artifact is emitted and no kernel replay is
performed. This supplementary outcome does not change the final theorem gates.
"""
import argparse
import fcntl
import hashlib
import json
from pathlib import Path
import re
import signal
import subprocess
import sys
import time
import types

sys.dont_write_bytecode = True
HELPER_SHA = '6f2581bf0084f72447c007eb077bf2915590aac47dd6531abba636ed11d24f87'
BROAD_SHA = 'b97f8db3c51c98441c3733e8e9516830bebda9c85dd65197b871f079f0b4af61'
TARGET_NAMES = {'D1Bound5.MainStatement', 'D1Bound5.IsD1', 'D1Bound5.IsD1Tuple', 'D1Bound5.main_statement'}


def require(ok, message):
    if not ok: raise RuntimeError(message)


def sha(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''): h.update(chunk)
    return h.hexdigest()


def read(path): return json.loads(Path(path).read_text())


def save(path, value): Path(path).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def under(path, root):
    try: Path(path).resolve().relative_to(Path(root).resolve()); return True
    except ValueError: return False


def load_source(path, expected, name):
    path = Path(path).resolve()
    source = path.read_bytes()
    require(hashlib.sha256(source).hexdigest() == expected, 'Unreviewed audit helper source')
    module = types.ModuleType(name)
    module.__file__ = str(path)
    module.__package__ = ''
    exec(compile(source, str(path), 'exec', dont_inherit=True), module.__dict__)
    require(sha(path) == expected, 'Audit helper changed while loading')
    return module


def invocation(path, expected):
    require(sha(path) == expected, 'Reviewed exact-audit invocation changed')
    row = read(path)
    argv = row['argv']
    require(len(argv) >= 2 and len(argv[2:]) % 2 == 0, 'Malformed exact-audit invocation')
    opts = {}
    for key, value in zip(argv[2::2], argv[3::2]):
        require(key.startswith('--') and key not in opts and isinstance(value, str), 'Malformed/repeated audit option')
        opts[key] = value
    expected_keys = {'--source-root', '--artifact-root', '--build-dir', '--source-lock',
                     '--source-lock-sha256', '--runtime-lock', '--runtime-lock-sha256',
                     '--build-runner', '--integration-audit', '--target-audit',
                     '--expected-commit', '--expected-tree', '--out'}
    require(set(opts) == expected_keys, 'Unexpected/missing exact-audit invocation options')
    require(row['runner_sha256'] == HELPER_SHA and sha(argv[1]) == HELPER_SHA,
            'Exact-audit helper differs from reviewed source')
    return argparse.Namespace(**{k[2:].replace('-', '_'): v for k, v in opts.items()}), Path(argv[1]).resolve()


def verify_exact_audit(args, helper, fb):
    exact = Path(args.out).resolve()
    summary_path = exact/'SUMMARY.json'
    summary = read(summary_path)
    require(summary['status'] == 'CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS',
            'Exact 118 clean audits have not passed')
    require(summary['post_audit_all_input_hashes_equal'] is True and
            summary['accepted_fresh_project_modules'] == 4406, 'Exact clean audit guards incomplete')
    require(summary['source_lock_sha256'] == args.source_lock_sha256 and
            summary['runtime_lock_sha256'] == args.runtime_lock_sha256, 'Exact audit lock identity differs')
    frozen_path = exact/'INPUT_FREEZE.json'
    require(sha(frozen_path) == summary['input_freeze_sha256'], 'Exact audit input freeze changed')
    frozen = read(frozen_path)
    expected = [('FinalIntegrationAudit', 114, helper.INTEGRATION_SHA, args.integration_audit, 'ORIGINAL_TYPE_AXIOMS_PASS'),
                ('FinalTargetAudit', 4, helper.TARGET_SHA, args.target_audit, 'FINAL_TARGET_AXIOMS_PASS')]
    require(len(summary['audits']) == 2, 'Unexpected exact-audit results')
    evidence = {str(summary_path): sha(summary_path)}
    for result, (name, count, harness_sha, harness_path, marker) in zip(summary['audits'], expected):
        require(result['name'] == name and result['exit_code'] == 0 and
                result['expected_pass_markers'] == result['observed_pass_markers'] == count and
                result['audit_sha256'] == harness_sha, 'Exact-audit result mismatch')
        log = exact/(name+'.log')
        require(sha(log) == result['log_sha256'], 'Exact-audit log changed')
        require(log.read_text().count(marker) == count, 'Actual exact-audit log marker count differs')
        command = [frozen['lean'], '-j1', '-DautoImplicit=false', '-R',
                   str(Path(args.source_root).resolve()), str(Path(harness_path).resolve())]
        require(result['command'] == command, 'Recorded exact-audit command differs from frozen source/runtime')
        evidence[str(log)] = result['log_sha256']
    require(helper.freeze(args, fb) == frozen, 'Current clean inputs differ from exact-audited snapshot')
    evidence[str(frozen_path)] = summary['input_freeze_sha256']
    return frozen, evidence


def markers(text):
    lines = [line.strip() for line in text.splitlines()]
    public = [int(m.group(1)) for line in lines
              if (m := re.fullmatch(r'AXIOM_AUDIT_PASS: (\d+) project declarations', line))]
    broad = [int(m.group(1)) for line in lines
             if (m := re.fullmatch(r'BROAD_PROJECT_AXIOM_AUDIT_PASS (\d+) declarations', line))]
    targets = [m.group(1) for line in lines
               if (m := re.match(r'^FINAL_TARGET_AXIOMS_PASS (D1Bound5\.[^: ]+):', line))]
    individual = sum(line.startswith('AUDIT D1Bound5.') or line.startswith('AUDIT D1Bound5:') for line in lines)
    require(len(public) == len(broad) == 1 and public[0] > 0 and broad[0] >= public[0],
            'Missing/duplicate/inconsistent broad audit success markers')
    require(len(targets) == 4 and set(targets) == TARGET_NAMES, 'Independent target marker set differs')
    require(individual == public[0], 'Preserved per-declaration audit output count differs')
    return {'exported_project_declarations': public[0], 'including_private_declarations': broad[0],
            'independent_target_markers': len(targets), 'individual_exported_audit_lines': individual}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ['invocation', 'invocation-sha256', 'broad-audit', 'out']:
        ap.add_argument('--'+name, required=True)
    ap.add_argument('--timeout', type=int, default=1800)
    cli = ap.parse_args()
    require(cli.timeout > 0, 'Timeout must be positive')
    args, helper_path = invocation(cli.invocation, cli.invocation_sha256)
    broad, output = Path(cli.broad_audit).resolve(), Path(cli.out).resolve()
    require(sha(broad) == BROAD_SHA, 'Unreviewed broad compatibility audit source')
    require(not any(broad.parent.rglob('*.olean*')) and not any(broad.parent.rglob('*.ir')) and
            not any(broad.parent.rglob('*.ir.sig')), 'External broad source directory contains compiled artifacts')
    for root in [args.source_root, args.build_dir, args.out]:
        require(not under(output, root) and not under(broad, root),
                'Broad source/evidence must be outside immutable source/build/exact-audit output')
    require(not under(output, broad.parent), 'Broad evidence must be outside frozen audit source directory')
    require(not output.exists() or not any(output.iterdir()), 'Broad evidence directory must be empty')
    output.mkdir(parents=True, exist_ok=True)
    result = {'status': 'RUNNING', 'scope': 'SEPARATE_BROAD_COMPATIBILITY_ONLY',
              'main_theorem_complete': False, 'fresh_kernel_replay': 'SEPARATE_REQUIRED_GATE'}
    save(output/'SUMMARY.json', result)
    try:
        with (Path(args.build_dir)/'build.lock').open('r') as lock:
            fcntl.flock(lock.fileno(), fcntl.LOCK_SH | fcntl.LOCK_NB)
            helper = load_source(helper_path, HELPER_SHA, 'reviewed_clean_exact_audit_helper')
            fb = helper.load_builder(args.build_runner)
            before, evidence = verify_exact_audit(args, helper, fb)
            evidence.update({str(Path(cli.invocation).resolve()): cli.invocation_sha256,
                             str(helper_path): HELPER_SHA, str(broad): BROAD_SHA,
                             str(Path(__file__).resolve()): sha(__file__)})
            runtime = read(args.runtime_lock)
            require(sha(args.runtime_lock) == args.runtime_lock_sha256, 'Runtime lock changed before broad import check')
            for name in fb.imports(broad):
                chosen = fb.resolve_module([Path(args.artifact_root)] + runtime['external_paths'], name)
                require(chosen is not None and chosen.is_file(), 'Unresolved broad-audit import')
                if name == 'D1Bound5' or name.startswith('D1Bound5.'):
                    require(under(chosen, args.artifact_root), 'Broad audit resolves old project artifacts')
                else:
                    require(str(chosen) in runtime['files'], 'Broad audit resolves unpinned external import')
            save(output/'EVIDENCE_FREEZE.json', {'exact_audit_input_freeze_sha256':
                 sha(Path(args.out)/'INPUT_FREEZE.json'), 'files': evidence, 'command_root': str(broad.parent)})
            # -R selects only the external audit's own module name; project imports
            # resolve exclusively through the already frozen clean LEAN_PATH.
            command = [before['lean'], '-j1', '-DautoImplicit=false', '-R', str(broad.parent), str(broad)]
            start = time.monotonic()
            with (output/'Audit.log').open('w') as log:
                run = subprocess.run(command, cwd=args.source_root, env=before['environment'],
                                     stdout=log, stderr=subprocess.STDOUT, timeout=cli.timeout)
            result.update(command=command, exit_code=run.returncode, seconds=time.monotonic()-start,
                          broad_source_sha256=BROAD_SHA, log_sha256=sha(output/'Audit.log'))
            save(output/'SUMMARY.json', result)
            require(run.returncode == 0, 'Broad compatibility Lean audit failed')
            result['markers'] = markers((output/'Audit.log').read_text())
            require(helper.freeze(args, fb) == before, 'Clean audit inputs changed during broad compatibility check')
            require(all(sha(p) == h for p, h in evidence.items()), 'Frozen broad/exact-audit evidence changed')
            require(sha(output/'Audit.log') == result['log_sha256'], 'Broad audit log changed')
            result.update(status='CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS',
                          all_clean_source_artifact_runtime_git_and_evidence_guards_equal=True,
                          exact_audit_input_freeze_sha256=sha(Path(args.out)/'INPUT_FREEZE.json'))
            save(output/'SUMMARY.json', result)
            print('CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS; FINAL_FRESH_KERNEL_IS_SEPARATE', flush=True)
    except BaseException as error:
        result.update(status='FAILED_NO_BROAD_ACCEPTANCE', error=repr(error))
        save(output/'SUMMARY.json', result)
        raise


def terminate(signum, frame):
    # Raising through subprocess.run triggers its kill/reap exception cleanup;
    # the outer handler then persists FAILED_NO_BROAD_ACCEPTANCE evidence.
    raise InterruptedError('Broad audit interrupted by signal '+str(signum))


if __name__ == '__main__':
    signal.signal(signal.SIGTERM, terminate)
    main()
