#!/usr/bin/env python3
"""Synthetic manifest-preparation tests; never compile or touch a real checkout."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import types
import unittest

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
prepare = types.ModuleType('prepare_manifests_under_test')
prepare.__file__ = str(HERE/'prepare_manifests.py')
SOURCE_BYTES = (HERE/'prepare_manifests.py').read_bytes()
exec(compile(SOURCE_BYTES, prepare.__file__, 'exec'), prepare.__dict__)


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, sort_keys=True, indent=2)+'\n')


class Fixture:
    def __init__(self, root):
        self.base = root
        self.project = root/'synthetic-project'
        self.out = root/'proposal'
        self.project.mkdir()
        contents = {
            'D1Bound5.lean': 'import D1Bound5.Base\n',
            'D1Bound5/Base.lean': '-- synthetic source fixture, never compiled\n',
            'lean-toolchain': 'leanprover/lean4:v4.33.1\n',
            'lakefile.lean': '-- synthetic package configuration\n',
            'lake-manifest.json': '{"synthetic":true}\n',
            'scripts/legacy.py': '# preserved historical script\n',
            'scripts/current.py': '# reviewed current script\n',
            'scripts/new_gate.py': '# newly required gate script\n'}
        for name, text in contents.items():
            p = self.project/name
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(text)
        self.config = {n: sha(self.project/n) for n in ['lean-toolchain', 'lakefile.lean', 'lake-manifest.json']}
        self.pins = {'expected_project_modules': 2,
                     'required_tools': ['scripts/current.py', 'scripts/new_gate.py'],
                     'configuration_sha256': self.config}
        self.pins_path = self.project/'scripts/verification/release_pins.json'
        write_json(self.pins_path, self.pins)
        self.lock = {'namespace': 'D1Bound5', 'roots': ['D1Bound5'], 'module_count': 2,
                     'auxiliary': self.config,
                     'sources': {n: {'relative_path': f, 'sha256': sha(self.project/f)}
                                 for n, f in [('D1Bound5', 'D1Bound5.lean'),
                                              ('D1Bound5.Base', 'D1Bound5/Base.lean')]}}
        self.lock_path = root/'reviewed-source-lock.json'
        write_json(self.lock_path, self.lock)
        self.prior = {n: sha(self.project/n) for n in ['scripts/legacy.py', 'scripts/current.py']}
        self.prior_path = root/'prior-tools.txt'
        self.write_prior()

    def write_prior(self):
        self.prior_path.write_text(''.join(h+'  '+n+'\n' for n, h in sorted(self.prior.items())))

    def run(self, updates=(), out=None, lock_hash=None):
        return prepare.prepare(self.project, self.lock_path, lock_hash or sha(self.lock_path),
                               self.prior_path, list(updates), out or self.out)

    def repository_snapshot(self):
        return {str(p.relative_to(self.project)): sha(p)
                for p in self.project.rglob('*') if p.is_file()}


class ManifestPreparation(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='manifest-proposal-selfcheck-')
        self.f = Fixture(Path(self.temp.name))

    def tearDown(self):
        self.temp.cleanup()

    def rejected(self, message, **kwargs):
        before = self.f.repository_snapshot()
        with self.assertRaisesRegex(RuntimeError, message):
            self.f.run(**kwargs)
        self.assertEqual(self.f.repository_snapshot(), before)
        self.assertFalse(self.f.out.exists())

    def test_preserves_old_tools_and_separates_configuration_from_proof_scope(self):
        before = self.f.repository_snapshot()
        report = self.f.run()
        proof = prepare.read_manifest(self.f.out/'proof-source-sha256.txt')
        tools = prepare.read_manifest(self.f.out/'verification-tools-sha256.txt')
        self.assertEqual(set(proof), {'D1Bound5.lean', 'D1Bound5/Base.lean'})
        for name, value in self.f.prior.items():
            self.assertEqual(tools[name], value)
        for name, value in self.f.config.items():
            self.assertEqual(tools[name], value)
            self.assertNotIn(name, proof)
        self.assertIn('scripts/new_gate.py', tools)
        self.assertIn('scripts/verification/release_pins.json', tools)
        self.assertEqual(report['status'], 'MANIFEST_PROPOSAL_ONLY_NOT_PROOF_ACCEPTANCE')
        self.assertEqual(report['production_modules'], 2)
        self.assertEqual(self.f.repository_snapshot(), before)
        self.assertEqual(report['output_sha256'], {
            'proof-source-sha256.txt': sha(self.f.out/'proof-source-sha256.txt'),
            'verification-tools-sha256.txt': sha(self.f.out/'verification-tools-sha256.txt')})

    def test_changed_historical_tool_requires_explicit_update(self):
        (self.f.project/'scripts/current.py').write_text('# intentional changed script\n')
        self.rejected('Unexpected historical tool change')

    def test_explicit_update_records_old_and_new_hash_without_dropping_old_rows(self):
        path = self.f.project/'scripts/current.py'
        old_hash = self.f.prior['scripts/current.py']
        path.write_text('# intentional changed script\n')
        report = self.f.run(updates=['scripts/current.py'])
        tools = prepare.read_manifest(self.f.out/'verification-tools-sha256.txt')
        self.assertEqual(tools['scripts/legacy.py'], self.f.prior['scripts/legacy.py'])
        self.assertEqual(tools['scripts/current.py'], sha(path))
        change = next(x for x in report['changed_or_added_tools'] if x['relative_path'] == 'scripts/current.py')
        self.assertEqual(change['before_sha256'], old_hash)
        self.assertEqual(change['after_sha256'], sha(path))

    def test_one_explicit_update_does_not_authorize_another_change(self):
        (self.f.project/'scripts/current.py').write_text('# allowed change\n')
        (self.f.project/'scripts/legacy.py').write_text('# unapproved change\n')
        self.rejected('Unexpected historical tool change', updates=['scripts/current.py'])

    def test_unknown_explicit_update_is_rejected(self):
        self.rejected('must already occur', updates=['scripts/new_gate.py'])

    def test_missing_historical_tool_cannot_disappear_silently(self):
        (self.f.project/'scripts/legacy.py').unlink()
        self.rejected('Missing or escaping file')

    def test_wrong_reviewed_source_lock_hash_is_rejected(self):
        self.rejected('Unreviewed source lock', lock_hash='0'*64)

    def test_changed_production_bytes_are_rejected(self):
        (self.f.project/'D1Bound5/Base.lean').write_text('-- unreviewed source\n')
        self.rejected('Changed production source')

    def test_disconnected_production_file_is_rejected(self):
        (self.f.project/'D1Bound5/Unimported.lean').write_text('-- disconnected synthetic source\n')
        self.rejected('missing or disconnected source files')

    def test_lock_and_release_configuration_pins_must_agree(self):
        self.f.pins['configuration_sha256'] = dict(self.f.config, **{'lean-toolchain': '0'*64})
        write_json(self.f.pins_path, self.f.pins)
        self.rejected('Configuration pin mismatch')

    def test_current_configuration_bytes_must_match_reviewed_pin(self):
        (self.f.project/'lean-toolchain').write_text('unreviewed-toolchain\n')
        self.rejected('Changed pinned configuration')

    def test_reviewed_release_module_count_is_binding(self):
        self.f.pins['expected_project_modules'] = 3
        write_json(self.f.pins_path, self.f.pins)
        self.rejected('Wrong release scope')

    def test_output_within_source_tree_is_rejected_without_writes(self):
        before = self.f.repository_snapshot()
        with self.assertRaisesRegex(RuntimeError, 'outside the source checkout'):
            self.f.run(out=self.f.project/'proposals')
        self.assertEqual(self.f.repository_snapshot(), before)
        self.assertFalse((self.f.project/'proposals').exists())

    def test_nonempty_output_directory_is_preserved_and_rejected(self):
        self.f.out.mkdir()
        sentinel = self.f.out/'retain.txt'
        sentinel.write_bytes(b'Existing evidence must survive.\n')
        with self.assertRaisesRegex(RuntimeError, 'Output directory must be empty'):
            self.f.run()
        self.assertEqual(list(self.f.out.iterdir()), [sentinel])
        self.assertEqual(sentinel.read_bytes(), b'Existing evidence must survive.\n')

    def test_escaping_prior_path_is_rejected(self):
        external = Path(self.temp.name)/'external.py'
        external.write_text('# must not become a repository tool\n')
        self.f.prior['../external.py'] = sha(external)
        self.f.write_prior()
        self.rejected('Unsafe relative path')

    def test_duplicate_prior_tool_rows_are_rejected(self):
        self.f.prior_path.write_text(self.f.prior_path.read_text()*2)
        self.rejected('Invalid or duplicate prior manifest row')


if __name__ == '__main__':
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(ManifestPreparation)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    print(json.dumps({'status': 'PASS_SYNTHETIC_MANIFEST_PREPARATION' if result.wasSuccessful() else 'FAIL',
                      'tests_run': result.testsRun,
                      'prepare_script_sha256_tested': hashlib.sha256(SOURCE_BYTES).hexdigest(),
                      'real_project_or_compiler_used': False,
                      'scope': 'Temporary synthetic repositories only; manifests remain proposals, not proof acceptance.'},
                     sort_keys=True, indent=2))
    sys.exit(0 if result.wasSuccessful() else 1)
