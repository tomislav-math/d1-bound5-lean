#!/usr/bin/env python3
"""Provenance rejection tests using disposable non-Lean fixture artifacts."""
import copy
import json
from pathlib import Path
import tempfile
import clean_final_audits as audit

HERE = Path(__file__).resolve().parent
fb = audit.load_builder(HERE.parent/'fresh_project_build.py')


def fixture(base):
    src, out = base/'source', base/'build'
    art = out/'artifacts'
    (src/'Fixture').mkdir(parents=True)
    (src/'Fixture/Base.lean').write_text('def fixtureBase : Nat := 1\n')
    (src/'Fixture.lean').write_text('import Fixture.Base\ndef fixtureRoot : Nat := fixtureBase\n')
    sl = fb.source_lock(src, ['Fixture'], 'Fixture')
    origin = {'build_id': 'fixture-only-not-a-proof', 'initial_artifact_inventory': [],
              'identity': {'environment': {'LEAN_SYSROOT': '/fixture-toolchain'}}}
    origin['identity_hash'] = fb.digest(origin['identity'])
    summary = {'status': 'FRESH_PROJECT_SOURCE_BUILD_PASS', 'completed_modules': 2,
               'expected_modules': 2, 'roots': ['Fixture'], 'fresh_project_origin': True,
               'active': [], 'waiting': [], 'failed': [], 'build_id': origin['build_id'],
               'identity_hash': origin['identity_hash'], 'compiled_this_invocation': sl['topological_order'],
               'validated_passes_from_prior_invocations': []}
    accepted = {}
    for name in sl['topological_order']:
        attempt = out/'attempts'/name/'fixture-attempt'
        attempt.mkdir(parents=True)
        rel = fb.module_path(name, '.olean')
        target = art/rel
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text('NOT A LEAN ARTIFACT: ' + name)
        log = attempt/'compiler.log'
        log.write_text('NOT A COMPILER RUN: fixture only\n')
        deps = [d for d in sl['sources'][name]['imports'] if d in sl['sources']]
        row = {'module': name, 'status': 'COMPILE_PASS', 'exit_code': 0,
               'build_id': origin['build_id'], 'identity_hash': origin['identity_hash'],
               'source_sha256': sl['sources'][name]['sha256'], 'log_sha256': audit.sha(log),
               'dependencies': {d: accepted[d] for d in deps},
               'artifact_bundle': {str(rel): audit.sha(target)},
               'command': ['/fixture-toolchain/bin/lean', '-j1', '-DautoImplicit=false', '-R', str(src),
                           '-o', str(attempt/'stage'/rel), str(src/fb.module_path(name))]}
        receipt = attempt/'receipt.json'
        audit.save(receipt, row)
        pointer = out/'accepted'/fb.module_path(name, '.json')
        pointer.parent.mkdir(parents=True, exist_ok=True)
        audit.save(pointer, {'receipt_path': str(receipt.relative_to(out)), 'receipt_sha256': audit.sha(receipt)})
        accepted[name] = {'receipt_sha256': audit.sha(receipt), 'artifact_bundle': row['artifact_bundle']}
    return src, out, art, sl, origin, summary


def rewrite_root(out, transform):
    pointer = out/'accepted/Fixture.json'
    index = audit.read(pointer)
    p = out/index['receipt_path']
    row = audit.read(p)
    transform(row)
    audit.save(p, row)
    index['receipt_sha256'] = audit.sha(p)
    audit.save(pointer, index)


def main():
    passed = []
    with tempfile.TemporaryDirectory(prefix='clean-final-audit-tests-') as temp:
        base = Path(temp)
        def run(name, mutate=None, expected=None):
            args = list(fixture(base/name))
            if mutate: mutate(*args)
            try:
                result = audit.verify_receipts(fb, *args)
            except (RuntimeError, FileNotFoundError) as error:
                assert expected is not None and expected in str(error), (name, str(error), expected)
            else:
                assert expected is None, 'Unexpected acceptance: ' + name
                assert result['accepted_modules'] == 2
            passed.append(name)
        run('complete_fixture_chain')
        run('failed_compiler_receipt', lambda s,o,a,sl,orig,su: rewrite_root(o,lambda r:r.update(status='COMPILER_FAILED',exit_code=1)), 'not a successful compilation')
        run('foreign_origin', lambda s,o,a,sl,orig,su: rewrite_root(o,lambda r:r.update(build_id='foreign')), 'Foreign build receipt')
        run('stale_source_receipt', lambda s,o,a,sl,orig,su: rewrite_root(o,lambda r:r.update(source_sha256='0'*64)), 'Receipt source mismatch')
        run('missing_dependency_receipt', lambda s,o,a,sl,orig,su:(o/'accepted/Fixture/Base.json').unlink(), 'Missing accepted pointer')
        run('wrong_dependency_chain', lambda s,o,a,sl,orig,su:rewrite_root(o,lambda r:r.update(dependencies={})), 'Dependency receipt chain mismatch')
        run('changed_artifact', lambda s,o,a,sl,orig,su:(a/'Fixture.olean').write_text('changed'), 'Artifact SHA mismatch')
        run('extra_artifact', lambda s,o,a,sl,orig,su:(a/'Foreign.olean').write_text('unaccepted'), 'unaccepted/missing files')
        run('unexpected_compiler', lambda s,o,a,sl,orig,su:rewrite_root(o,lambda r:r.update(command=['unreviewed-compiler'])), 'Unexpected compiler command')
        run('changed_log', lambda s,o,a,sl,orig,su:(o/'attempts/Fixture/fixture-attempt/compiler.log').write_text('changed'), 'Compiler log SHA mismatch')
        run('unfinished_summary', lambda s,o,a,sl,orig,su:su.update(status='RUNNING'), 'summary is not complete')
        run('unaccounted_module', lambda s,o,a,sl,orig,su:su.update(compiled_this_invocation=['Fixture']), 'every module exactly once')
        run('nonempty_origin', lambda s,o,a,sl,orig,su:orig.update(initial_artifact_inventory=['old.olean']), 'did not start empty')
        run('artifact_symlink_escape', lambda s,o,a,sl,orig,su: ((a/'Fixture.olean').rename(o/'outside.olean'), (a/'Fixture.olean').symlink_to(o/'outside.olean')), 'escapes isolated output')
    # Also exercise the independent receipt parser on actual successful three-module
    # Lean smoke-build evidence, read-only. This does not rerun a compiler.
    smoke = HERE.parent/'fresh-real-smoke'
    genuine = audit.verify_receipts(fb, smoke/'source', smoke/'build', smoke/'build/artifacts',
                                    audit.read(smoke/'source-lock.json'), audit.read(smoke/'build/ORIGIN.json'),
                                    audit.read(smoke/'build/SUMMARY.json'))
    assert genuine['accepted_modules'] == 3
    passed.append('real_three_module_source_build_receipts_read_only')
    result = {'status': 'PASS', 'scope': 'Disposable structural fixtures plus read-only real smoke receipts; no Lean/checker launched',
              'tests': passed, 'runner_sha256': audit.sha(HERE/'clean_final_audits.py'),
              'tests_sha256': audit.sha(Path(__file__))}
    audit.save(HERE/'CLEAN_AUDIT_GUARD_TESTS.json', result)
    print(json.dumps(result, indent=2))


if __name__ == '__main__': main()
