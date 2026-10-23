#!/usr/bin/env python3
"""Lightweight path/scheme guards only; never starts Lean or leanchecker."""
import importlib.util
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('final_kernel', HERE / 'final_kernel.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


def rejects(action, message):
    try:
        action()
    except ValueError as exc:
        assert message in str(exc), str(exc)
    else:
        raise AssertionError('Guard accepted forbidden configuration: ' + message)


def main():
    with tempfile.TemporaryDirectory(prefix='final-kernel-path-guards-') as temp:
        base = Path(temp)
        root = base / 'runtime'
        project = base / 'clean-checkout'
        build = base / 'clean-build/lib/lean'
        old_project = root / 'project'
        old_build = old_project / '.lake/build/lib/lean'
        other = base / 'other-artifacts'
        builtin = root / 'lean-4.33.1-linux/lib/lean'
        for directory in (root, project, build, old_build, other, builtin):
            directory.mkdir(parents=True)
        (build / 'D1Bound5').mkdir()
        (build / 'D1Bound5.olean').write_bytes(b'fixture root; not a Lean artifact')
        (build / 'D1Bound5/Example.olean').write_bytes(b'fixture child; not a Lean artifact')
        names = ['D1Bound5.Example', 'D1Bound5']
        roots = [str(build), str(builtin)]
        env = {'PATH': '/usr/bin', 'LEAN_PATH': ':'.join(roots),
               'LD_PRELOAD': str(root / 'proc_self_exe_compat.so')}
        check = lambda p=project, b=build, rs=roots, e=env: checker.validate_clean_paths(root, p, b, rs, e, names)
        check()
        rejects(lambda: check(p=old_project), 'clean checkout')
        rejects(lambda: check(b=old_build, rs=[str(old_build)]), 'clean checkout')
        rejects(lambda: check(rs=roots + [str(old_build)]), 'second/candidate')
        rejects(lambda: check(rs=[]), 'absent')
        rejects(lambda: check(rs=[str(build)]), 'builtin')
        rejects(lambda: checker.search_roots({'LEAN_PATH': 'relative/path'}), 'absolute')
        rejects(lambda: checker.search_roots({'LEAN_PATH': str(build) + ':'}), 'nonempty')
        (other / 'D1Bound5').mkdir()
        rejects(lambda: check(rs=roots + [str(other)]), 'second/candidate')
        rejects(lambda: check(e={**env, 'LD_PRELOAD': env['LD_PRELOAD'] + ':other.so'}), 'Only the reviewed')
        child = build / 'D1Bound5/Example.olean'
        child.unlink()
        outside = base / 'outside.olean'
        outside.write_bytes(b'not inside clean output')
        child.symlink_to(outside)
        rejects(check, 'exclusively to clean output')
        rejects(lambda: checker.validate({'schema': 2}), 'schema-3')
    with tempfile.TemporaryDirectory(prefix='final-kernel-receipt-guards-') as temp:
        base = Path(temp)
        project, build = base / 'source', base / 'build'
        artifacts = build / 'artifacts'
        project.mkdir()
        artifacts.mkdir(parents=True)
        env = {'PATH': '/usr/bin', 'LEAN_PATH': str(artifacts), 'LD_PRELOAD': 'fixture-only.so'}
        names = ['D1Bound5.Example', 'D1Bound5']
        deps = {names[0]: [], names[1]: [names[0]]}
        sources = {}
        for name in names:
            path = project / (name.replace('.', '/') + '.lean')
            path.parent.mkdir(exist_ok=True)
            path.write_text('fixture source only; never compiled\n')
            sources[str(path)] = checker.sha(path)
        manifest = base / 'source-manifest.json'
        checker.write(manifest, {'dependencies': deps})
        identity = {'source_root': str(project), 'build_dir': str(build), 'environment': env}
        identity_hash = hashlib.sha256(json.dumps(identity, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
        origin = {'identity': identity, 'identity_hash': identity_hash,
                  'initial_artifact_inventory': [], 'build_id': 'fixture-build'}
        checker.write(build / 'ORIGIN.json', origin)
        summary = {'status': 'FRESH_PROJECT_SOURCE_BUILD_PASS', 'identity_hash': identity_hash,
                   'build_id': origin['build_id'], 'fresh_project_origin': True,
                   'expected_modules': 2, 'completed_modules': 2, 'failed': [], 'active': [],
                   'waiting': [], 'compiled_this_invocation': names, 'validated_passes_from_prior_invocations': []}
        checker.write(build / 'SUMMARY.json', summary)
        accepted = {}
        for name in names:
            relative = name.replace('.', '/') + '.olean'
            artifact = artifacts / relative
            artifact.parent.mkdir(exist_ok=True)
            artifact.write_bytes(b'fixture only; not a real Lean artifact')
            receipt = build / 'attempts' / name / 'fixture' / 'receipt.json'
            receipt.parent.mkdir(parents=True)
            log = receipt.parent / 'compiler.log'
            log.write_text('fixture log\n')
            row = {'status': 'COMPILE_PASS', 'exit_code': 0, 'module': name,
                   'build_id': origin['build_id'], 'identity_hash': identity_hash,
                   'source_sha256': sources[str(project / (name.replace('.', '/') + '.lean'))],
                   'dependencies': {n: accepted[n] for n in deps[name]},
                   'artifact_bundle': {relative: checker.sha(artifact)}, 'log_sha256': checker.sha(log)}
            checker.write(receipt, row)
            accepted[name] = {'receipt_sha256': checker.sha(receipt), 'artifact_bundle': row['artifact_bundle']}
            checker.write(build / 'accepted' / (name.replace('.', '/') + '.json'),
                          {'receipt_path': str(receipt.relative_to(build)), 'receipt_sha256': checker.sha(receipt)})
        inventory = checker.artifact_inventory([str(artifacts)])
        check_receipts = lambda: checker.clean_build_evidence(project, artifacts, env, names, sources, inventory, manifest)
        pins, evidence = check_receipts()
        assert len(pins) == 8 and evidence['module_count'] == 2
        checker.write(build / 'ORIGIN.json', {**origin, 'initial_artifact_inventory': ['copied.olean']})
        rejects(check_receipts, 'empty-origin')
        checker.write(build / 'ORIGIN.json', origin)
        checker.write(build / 'SUMMARY.json', {**summary, 'completed_modules': 1})
        rejects(check_receipts, 'not complete')
        checker.write(build / 'SUMMARY.json', summary)
        last = build / 'attempts' / names[1] / 'fixture' / 'receipt.json'
        row = json.loads(last.read_text())
        checker.write(last, {**row, 'dependencies': {}})
        rejects(check_receipts, 'receipt hash')
        checker.write(build / 'accepted/D1Bound5.json',
                      {'receipt_path': str(last.relative_to(build)), 'receipt_sha256': checker.sha(last)})
        rejects(check_receipts, 'dependency chain')
    proc = subprocess.run([sys.executable, str(HERE / 'final_kernel.py'), 'freeze'],
                          text=True, capture_output=True)
    assert proc.returncode == 2 and 'freeze requires --manifest' in proc.stderr
    print(json.dumps({'status': 'PASS', 'scope': 'Temporary Python fixtures only; no Lean/checker launch',
                      'guards': ['clean checkout/output accepted', 'candidate source rejected',
                                 'candidate artifacts rejected', 'extra project artifact owner rejected',
                                 'missing selected output rejected', 'unreviewed preload rejected',
                                 'artifact symlink escape rejected', 'schema2 freeze rejected',
                                 'missing explicit freeze configuration rejected',
                                 'relative/empty search roots rejected', 'implicit builtin root must be frozen',
                                 'complete clean fixture receipt graph accepted',
                                 'nonempty origin and incomplete summary rejected',
                                 'tampered receipt and broken dependency chain rejected']}, indent=2))


if __name__ == '__main__':
    main()
