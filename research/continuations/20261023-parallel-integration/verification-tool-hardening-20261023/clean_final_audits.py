#!/usr/bin/env python3
"""Run the two immutable theorem audits against a completed source-only build.

This does not compile project modules, reuse candidate artifacts, or run the
installed kernel replayer. It reconstructs every fresh-build receipt chain,
checks the exact source/runtime locks, and freezes all inputs across two
sequential official Lean invocations. A separate fresh kernel replay remains
required. The build runner is imported only for its pinned read-only utilities.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import types

sys.dont_write_bytecode = True

INTEGRATION_SHA = '005f05312ef81f9a961e1c8adefb00b98e514cca3794adcc438118e4edf5d1ac'
TARGET_SHA = 'b21a0deae156faabd97ad38e87920a5f9f16700cad843c3e38e040c90aaa61d7'
BUILD_RUNNER_SHA = 'd2b952a6e59bcaf4a55d172bf64996bbc8ce3d661ca2972ff4018690d096dd66'
COMPLETE = {'FRESH_PROJECT_SOURCE_BUILD_PASS', 'PROJECT_SOURCE_BUILD_COMPLETE_RESUMED'}


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
    Path(path).write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def under(path, root):
    try:
        Path(path).resolve().relative_to(Path(root).resolve())
        return True
    except ValueError:
        return False


def load_builder(path):
    path = Path(path).resolve()
    source = path.read_bytes()
    require(hashlib.sha256(source).hexdigest() == BUILD_RUNNER_SHA, 'Unreviewed source-build utility module')
    # SourceFileLoader may read an existing timestamp-valid .pyc even when writes
    # are disabled. Execute the already verified bytes, never a bytecode cache.
    module = types.ModuleType('pinned_fresh_build_audit_utils')
    module.__file__ = str(path)
    module.__package__ = ''
    exec(compile(source, str(path), 'exec', dont_inherit=True), module.__dict__)
    require(sha(path) == BUILD_RUNNER_SHA, 'Build utility source changed during import')
    return module


def verify_git(source_root, expected_commit, expected_tree, selected):
    """Bind selected actual file bytes to the exact reviewed immutable Git tree."""
    src = Path(source_root).resolve()
    def git(*words):
        return subprocess.check_output(['git', '-C', str(src), *words], stderr=subprocess.PIPE)
    require(Path(git('rev-parse', '--show-toplevel').decode().strip()).resolve() == src,
            'Source root is not the exact Git checkout root')
    commit = git('rev-parse', 'HEAD').decode().strip()
    tree = git('rev-parse', 'HEAD^{tree}').decode().strip()
    require(commit == expected_commit and tree == expected_tree, 'Reviewed Git commit/tree changed')
    require(not git('status', '--porcelain=v1', '--untracked-files=all'), 'Clean Git checkout became dirty')
    algorithm = git('rev-parse', '--show-object-format').decode().strip()
    require(algorithm in ['sha1', 'sha256'], 'Unsupported Git object format')
    objects = {}
    for entry in git('ls-tree', '-r', '-z', 'HEAD').split(b'\0'):
        if not entry: continue
        metadata, name = entry.split(b'\t', 1)
        mode, kind, oid = metadata.decode().split()
        objects[name.decode()] = (mode, kind, oid)
    pinned = {}
    for relative in selected:
        p = src/relative
        require(not Path(relative).is_absolute() and '..' not in Path(relative).parts and
                under(p, src) and not p.is_symlink() and p.is_file(), 'Invalid selected Git file: ' + relative)
        require(relative in objects, 'Selected file is not committed: ' + relative)
        mode, kind, oid = objects[relative]
        require(mode in ['100644', '100755'] and kind == 'blob', 'Selected Git object is not a regular file')
        blob = p.read_bytes()
        actual = hashlib.new(algorithm, b'blob ' + str(len(blob)).encode() + b'\0' + blob).hexdigest()
        require(actual == oid, 'Selected file bytes differ from reviewed Git tree: ' + relative)
        pinned[relative] = oid
    require(git('rev-parse', 'HEAD').decode().strip() == commit and
            git('rev-parse', 'HEAD^{tree}').decode().strip() == tree,
            'Git commit/tree changed during capture')
    return {'commit': commit, 'tree': tree, 'object_format': algorithm,
            'clean_worktree': True, 'selected_committed_blobs': pinned}


def verify_receipts(fb, source_root, build_dir, artifacts, sl, origin, summary):
    """Read-only independent reconstruction of the fresh accepted-receipt DAG."""
    source_root, build_dir, artifacts = map(Path, [source_root, build_dir, artifacts])
    names = sl['topological_order']
    require(len(names) == len(set(names)) == sl['module_count'] == len(sl['sources']),
            'Source lock module count/order mismatch')
    require(set(names) == set(sl['sources']), 'Source lock order is incomplete')
    require(summary['status'] in COMPLETE, 'Source build summary is not complete')
    require(summary['completed_modules'] == summary['expected_modules'] == len(names),
            'Source build summary module count mismatch')
    require(summary['roots'] == sl['roots'], 'Source build summary roots mismatch')
    require(summary['fresh_project_origin'] is True, 'Source build lacks a fresh origin')
    require(not summary['active'] and not summary['failed'] and not summary['waiting'],
            'Source build still has active/failed/waiting modules')
    require(summary['build_id'] == origin['build_id'] and
            summary['identity_hash'] == origin['identity_hash'], 'Source build summary identity mismatch')
    require(origin['initial_artifact_inventory'] == [], 'Source build did not start empty')
    require(fb.digest(origin['identity']) == origin['identity_hash'], 'Origin identity digest mismatch')
    compiled = summary['compiled_this_invocation']
    reused = summary['validated_passes_from_prior_invocations']
    require(len(compiled) == len(set(compiled)) and len(reused) == len(set(reused)) and
            not set(compiled) & set(reused) and set(compiled) | set(reused) == set(names),
            'Build summary does not account for every module exactly once')
    files, accepted, bundles = {}, {}, {}
    for name in names:
        pointer = build_dir/'accepted'/fb.module_path(name, '.json')
        require(under(pointer, build_dir/'accepted') and pointer.is_file(), 'Missing accepted pointer: ' + name)
        files[str(pointer)] = sha(pointer)
        index = read(pointer)
        path = build_dir/index['receipt_path']
        require(under(path, build_dir/'attempts') and path.is_file(), 'Escaping/missing accepted receipt: ' + name)
        require(sha(path) == index['receipt_sha256'], 'Accepted receipt SHA mismatch: ' + name)
        row = read(path)
        require(row['status'] == 'COMPILE_PASS' and row['exit_code'] == 0,
                'Accepted receipt is not a successful compilation: ' + name)
        require(row['build_id'] == origin['build_id'] and row['identity_hash'] == origin['identity_hash'],
                'Foreign build receipt: ' + name)
        require(row['module'] == name and row['source_sha256'] == sl['sources'][name]['sha256'],
                'Receipt source mismatch: ' + name)
        deps = [d for d in sl['sources'][name]['imports'] if d in sl['sources']]
        require(all(d in accepted for d in deps), 'Unaccepted direct dependency: ' + name)
        expected_deps = {d: {'receipt_sha256': accepted[d]['receipt_sha256'],
                             'artifact_bundle': accepted[d]['artifact_bundle']} for d in deps}
        require(row['dependencies'] == expected_deps, 'Dependency receipt chain mismatch: ' + name)
        command = [origin['identity']['environment']['LEAN_SYSROOT'] + '/bin/lean',
                   '-j1', '-DautoImplicit=false', '-R', str(source_root), '-o',
                   str(path.parent/'stage'/fb.module_path(name, '.olean')),
                   str(source_root/fb.module_path(name))]
        require(row['command'] == command, 'Unexpected compiler command: ' + name)
        log = path.parent/'compiler.log'
        require(log.is_file() and sha(log) == row['log_sha256'], 'Compiler log SHA mismatch: ' + name)
        bundle = row['artifact_bundle']
        base = artifacts/fb.module_path(name, '.olean')
        require(base.is_file() and bundle, 'Missing compiled artifact: ' + name)
        actual = {str(p.relative_to(artifacts)) for p in fb.artifact_files(base)}
        require(actual == set(bundle), 'Artifact sidecar inventory mismatch: ' + name)
        for relative, expected in bundle.items():
            p = artifacts/relative
            require(not Path(relative).is_absolute() and '..' not in Path(relative).parts and
                    under(p, artifacts) and p.is_file(), 'Artifact escapes isolated output: ' + relative)
            require(sha(p) == expected, 'Artifact SHA mismatch: ' + relative)
            require(relative not in bundles, 'Overlapping module artifact bundles')
            files[str(p)] = expected
            bundles[relative] = expected
        files[str(path)], files[str(log)] = index['receipt_sha256'], row['log_sha256']
        accepted[name] = {'receipt_sha256': index['receipt_sha256'], 'artifact_bundle': bundle}
    actual_inventory = {str(p.relative_to(artifacts)) for p in artifacts.rglob('*') if p.is_file()}
    require(actual_inventory == set(bundles), 'Isolated build output has unaccepted/missing files')
    return {'files': files, 'accepted_modules': len(accepted),
            'accepted_receipt_chain_sha256': fb.digest(accepted), 'artifact_bundles_sha256': fb.digest(bundles)}


def freeze(args, fb):
    src, out, art = map(lambda x: Path(x).resolve(), [args.source_root, args.build_dir, args.artifact_root])
    require(art == out/'artifacts', 'Artifact root must be the isolated build/artifacts directory')
    require(not under(out, src) and not under(src, out), 'Clean source and output must be disjoint')
    require(sha(args.source_lock) == args.source_lock_sha256, 'Reviewed source lock SHA mismatch')
    require(sha(args.runtime_lock) == args.runtime_lock_sha256, 'Reviewed runtime lock SHA mismatch')
    require(sha(args.build_runner) == BUILD_RUNNER_SHA, 'Source build utility changed')
    sl, rt = read(args.source_lock), read(args.runtime_lock)
    require(sl['schema'] == rt['schema'] == 1, 'Unsupported source/runtime lock schema')
    require(sl['namespace'] == 'D1Bound5' and sl['roots'] == ['D1Bound5'] and sl['module_count'] == 4406,
            'Unexpected final canonical source scope')
    require(fb.source_lock(src, sl['roots'], sl['namespace']) == sl, 'Current sources differ from exact lock')
    require(not any(src.rglob('*.olean*')) and not any(src.rglob('*.ir')) and not any(src.rglob('*.ir.sig')),
            'Clean source checkout contains compiled artifacts')
    origin, summary = read(out/'ORIGIN.json'), read(out/'SUMMARY.json')
    env = fb.clean_environment(rt, art)
    identity = {'schema': 1, 'source_lock_sha256': args.source_lock_sha256,
                'runtime_lock_sha256': args.runtime_lock_sha256, 'runner_sha256': BUILD_RUNNER_SHA,
                'source_root': str(src), 'build_dir': str(out), 'environment': env,
                'lean_arguments': ['-j1', '-DautoImplicit=false', '-R', str(src)]}
    require(origin['identity'] == identity, 'Build origin does not match exact source/runtime/environment')
    for p in rt['external_paths']:
        root = Path(p)
        require(not (root/'D1Bound5').exists() and not (root/'D1Bound5.olean').exists(),
                'External runtime path shadows project modules')
    actual_runtime, _ = fb.inventory(rt['inventory_roots'])
    for p in rt.get('extra_files', []): actual_runtime[p] = sha(p)
    require(actual_runtime == rt['files'], 'Pinned runtime/cache inventory changed')
    harnesses = [(Path(args.integration_audit).resolve(), INTEGRATION_SHA),
                 (Path(args.target_audit).resolve(), TARGET_SHA)]
    for p, expected in harnesses:
        require(under(p, src) and p.is_file(), 'Immutable audit must be in clean candidate checkout')
        require(sha(p) == expected, 'Immutable audit harness SHA mismatch: ' + str(p))
        for dep in fb.imports(p):
            resolved = fb.resolve_module([art] + rt['external_paths'], dep)
            require(resolved is not None and resolved.is_file(), 'Unresolved audit import: ' + dep)
            if dep.startswith('D1Bound5.') or dep == 'D1Bound5':
                require(dep in sl['sources'] and under(resolved, art), 'Audit project import escapes clean output')
            else:
                require(str(resolved) in rt['files'], 'Unpinned audit external import: ' + dep)
    selected = {row['relative_path'] for row in sl['sources'].values()} | set(sl['auxiliary'])
    selected.update(str(p.relative_to(src)) for p, _ in harnesses)
    if under(args.build_runner, src): selected.add(str(Path(args.build_runner).resolve().relative_to(src)))
    git_identity = verify_git(src, args.expected_commit, args.expected_tree, selected)
    provenance = verify_receipts(fb, src, out, art, sl, origin, summary)
    files = provenance.pop('files')
    for p in [Path(args.source_lock).resolve(), Path(args.runtime_lock).resolve(),
              Path(args.build_runner).resolve(), Path(__file__).resolve(), out/'ORIGIN.json', out/'SUMMARY.json']:
        files[str(p)] = sha(p)
    for p, expected in harnesses: files[str(p)] = expected
    for name, row in sl['sources'].items(): files[str(src/row['relative_path'])] = row['sha256']
    for p, expected in sl['auxiliary'].items(): files[str(src/p)] = expected
    return {'schema': 1, 'source_root': str(src), 'build_dir': str(out), 'artifact_root': str(art),
            'source_lock_sha256': args.source_lock_sha256, 'runtime_lock_sha256': args.runtime_lock_sha256,
            'runtime_inventory_sha256': fb.digest(actual_runtime), 'runtime_file_count': len(actual_runtime),
            'build_id': origin['build_id'], 'identity_hash': origin['identity_hash'], 'lean': rt['lean'],
            'environment': env, 'git_identity': git_identity, 'files': files, **provenance}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    for name in ['source-root', 'artifact-root', 'build-dir', 'source-lock', 'source-lock-sha256',
                 'runtime-lock', 'runtime-lock-sha256', 'build-runner', 'integration-audit', 'target-audit',
                 'expected-commit', 'expected-tree', 'out']:
        ap.add_argument('--' + name, required=True)
    ap.add_argument('--timeout', type=int, default=900)
    ap.add_argument('--validate-only', action='store_true')
    args = ap.parse_args()
    output = Path(args.out).resolve()
    for p in [args.source_root, args.build_dir]:
        require(not under(output, p), 'Audit evidence must be outside source/build trees')
    require(not output.exists() or not any(output.iterdir()), 'Audit output directory must be empty')
    output.mkdir(parents=True, exist_ok=True)
    result = {'status': 'RUNNING', 'fresh_kernel_replay': 'REQUIRED_SEPARATE_GATE',
              'main_theorem_complete': False, 'audits': []}
    save(output/'SUMMARY.json', result)
    lock = None
    try:
        lock = (Path(args.build_dir)/'build.lock').open('r')
        fcntl.flock(lock.fileno(), fcntl.LOCK_SH | fcntl.LOCK_NB)
        fb = load_builder(args.build_runner)
        start = time.monotonic()
        before = freeze(args, fb)
        save(output/'INPUT_FREEZE.json', before)
        print('CLEAN_AUDIT_PREFLIGHT_PASS', before['accepted_modules'], 'FRESH_SOURCE_RECEIPTS', flush=True)
        if args.validate_only:
            result.update(status='INPUT_VALIDATION_ONLY_NO_LEAN_AUDIT', input_freeze_sha256=sha(output/'INPUT_FREEZE.json'))
            save(output/'SUMMARY.json', result)
            return
        for label, path, marker, count in [
                ('FinalIntegrationAudit', args.integration_audit, 'ORIGINAL_TYPE_AXIOMS_PASS', 114),
                ('FinalTargetAudit', args.target_audit, 'FINAL_TARGET_AXIOMS_PASS', 4)]:
            path = Path(path).resolve()
            require(sha(path) == before['files'][str(path)], 'Audit source changed before launch')
            command = [before['lean'], '-j1', '-DautoImplicit=false',
                       '-R', before['source_root'], str(path)]
            tick = time.monotonic()
            log_path = output/(label + '.log')
            with log_path.open('w') as log:
                run = subprocess.run(command, cwd=before['source_root'], env=before['environment'],
                                     stdout=log, stderr=subprocess.STDOUT, timeout=args.timeout)
            log = log_path.read_text()
            row = {'name': label, 'command': command, 'exit_code': run.returncode,
                   'seconds': time.monotonic()-tick, 'expected_pass_markers': count,
                   'observed_pass_markers': log.count(marker), 'log_sha256': sha(log_path),
                   'audit_sha256': sha(path)}
            result['audits'].append(row)
            save(output/'SUMMARY.json', result)
            require(run.returncode == 0 and row['observed_pass_markers'] == count,
                    'Immutable clean audit failed: ' + label)
            print(label, 'PASS', count, 'EXACT_TYPE_AXIOM_MARKERS', flush=True)
        after = freeze(args, fb)
        require(after == before, 'Clean audit inputs changed during Lean execution')
        for row in result['audits']:
            require(sha(output/(row['name']+'.log')) == row['log_sha256'], 'Audit log changed')
        result.update(status='CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS',
                      input_freeze_sha256=sha(output/'INPUT_FREEZE.json'),
                      source_lock_sha256=args.source_lock_sha256, runtime_lock_sha256=args.runtime_lock_sha256,
                      post_audit_all_input_hashes_equal=True, seconds=time.monotonic()-start,
                      accepted_fresh_project_modules=before['accepted_modules'])
        save(output/'SUMMARY.json', result)
        print('BOTH_CLEAN_IMMUTABLE_AUDITS_PASS; SEPARATE_FRESH_KERNEL_GATE_REQUIRED', flush=True)
    except BaseException as error:
        result.update(status='FAILED_NO_ACCEPTANCE', error=repr(error))
        save(output/'SUMMARY.json', result)
        raise
    finally:
        if lock is not None: lock.close()


if __name__ == '__main__':
    main()
