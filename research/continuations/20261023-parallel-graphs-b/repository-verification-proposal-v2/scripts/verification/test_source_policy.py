#!/usr/bin/env python3
"""Small disposable source-policy fixtures; no compiler or project mutation."""
import copy
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

import source_policy as policy


class SourcePolicyTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='d1-source-policy-test-')
        self.root = Path(self.temp.name)
        (self.root / 'D1Bound5').mkdir()
        self.manifest = json.loads((policy.HERE / 'reviewed_source_policy.json').read_text())
        self.write('D1Bound5.lean', 'import D1Bound5.Base\n')
        self.write('D1Bound5/Base.lean', 'set_option autoImplicit false\ntheorem good : True := by trivial\n#print axioms good\n')

    def tearDown(self):
        self.temp.cleanup()

    def write(self, path, text):
        p = self.root / path
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)

    def report(self):
        return policy.audit(self.root, 'D1Bound5', self.manifest)

    def assert_pass(self):
        report = self.report()
        self.assertEqual(report['status'], 'SOURCE_POLICY_PASS_SOURCE_ONLY', report)
        return report

    def assert_fail(self):
        report = self.report()
        self.assertEqual(report['status'], 'SOURCE_POLICY_FAILED_NO_ACCEPTANCE', report)
        return report

    def test_plain_proof_and_ordinary_axioms_report(self):
        self.assertEqual(len(self.assert_pass()['ordinary_print_axioms']), 1)

    def test_nested_comments_are_inert(self):
        self.write('D1Bound5/Base.lean', '/- sorry /- axiom x : False -/ native_decide -/\n-- unsafe\ntheorem good : True := by trivial\n')
        self.assert_pass()

    def test_quote_character_cannot_mask_eval(self):
        self.write('D1Bound5/Base.lean', 'def a : Char := \'"\'\n#eval 1 + 1\ndef b : Char := \'"\'\n')
        report = self.assert_fail()
        self.assertTrue(any(row['token'] == '#eval' for row in report['unreviewed_findings']))

    def test_character_literals_and_identifier_apostrophes(self):
        self.write('D1Bound5/Base.lean', "def foo' : Char := '\"'\ndef foo'' : Char := '\\''\n"
                   "def α' : Char := '\\\\'\ndef foo₁' : Char := '\\x22'\ndef β' : Char := '\\u0022'\n")
        self.assert_pass()

    def test_standard_primed_sum_and_product_notation(self):
        self.write('D1Bound5/Base.lean', "def a := ∑' n : Nat, n\ndef b := ∏' n : Nat, n\n")
        self.assert_pass()
        self.write('D1Bound5/Base.lean', "def a := ∑' n : Nat, n\n#eval 1 + 1\n")
        self.assert_fail()

    def test_custom_token_declarations_cannot_change_lexer_assumptions(self):
        text = 'notation "∑" x => x\ndef a : Char := ∑\'"\'\n#eval 1 + 1\ndef b : Char := ∑\'"\'\n'
        self.write('D1Bound5/Base.lean', text)
        report = self.assert_fail()
        tokens = {row['token'] for row in report['unreviewed_findings']}
        self.assertIn('notation', tokens)
        self.assertIn('#eval', tokens)
        for token in ['syntax', 'infix', 'infixl', 'infixr', 'prefix', 'postfix']:
            with self.subTest(token=token):
                self.write('D1Bound5/Base.lean', token + ' "custom"\n')
                self.assert_fail()

    def test_identifier_prime_does_not_start_character_literal(self):
        text = "def foo' := \"'\"\n#eval 1 + 1\ndef bar' := \"'\"\n"
        self.write('D1Bound5/Base.lean', text)
        self.assert_fail()

    def test_escaped_identifier_quotes_cannot_mask_eval(self):
        self.write('D1Bound5/Base.lean', 'def «a"» := 1\n#eval 1 + 1\ndef «b"» := 2\n')
        self.assert_fail()

    def test_escaped_identifier_comment_markers_do_not_hide_code(self):
        self.write('D1Bound5/Base.lean', 'def «a--» := 1\n#eval 1 + 1\ndef «b/-» := 2\n')
        self.assert_fail()

    def test_zero_hash_raw_string_cannot_mask_eval(self):
        self.write('D1Bound5/Base.lean', 'def a := r"\\"\n#eval 1 + 1\ndef b := "ok"\n')
        self.assert_fail()

    def test_raw_string_prefix_is_not_an_identifier_suffix(self):
        self.write('D1Bound5/Base.lean', 'def ar"\\"" := 1\n#eval 1 + 1\n')
        self.assert_fail()

    def test_every_legacy_forbidden_token(self):
        for token in ['sorry', 'admit', 'sorryAx', 'axiom', 'unsafe', 'native_decide',
                      'implemented_by', 'extern', '+native', 'debug.skipKernelTC',
                      'Lean.ofReduce', 'Lean.ofReduceBool', '+ native', 'run_tac', 'run_cmd', 'run_elab']:
            with self.subTest(token=token):
                self.write('D1Bound5/Base.lean', 'example : True := by ' + token + '\n')
                self.assert_fail()

    def test_additional_environment_and_kernel_bypasses(self):
        for token in ['native_decide_term', 'setEnv', 'modifyEnv', 'addDecl', 'trustLevel',
                      'elab_rules', 'macro_rules', 'initialize', 'opaque']:
            with self.subTest(token=token):
                self.write('D1Bound5/Base.lean', token + '\n')
                self.assert_fail()

    def test_historic_forbidden_tokens_in_strings_remain_rejected(self):
        self.write('D1Bound5/Base.lean', 'def s := "native_decide"\n')
        self.assert_fail()

    def test_unreviewed_standard_tactic_import(self):
        self.write('D1Bound5/Base.lean', 'import Lean.Elab.Tactic.Omega\n')
        self.assert_fail()

    def test_reviewed_import_requires_exact_source_hash(self):
        text = 'import Lean.Elab.Tactic.Omega\n'
        self.write('D1Bound5/Base.lean', text)
        row = {'module': 'D1Bound5.Base', 'line': 1, 'category': 'meta_namespace_review',
               'token': 'Elab', 'source_line': text.strip(), 'source_sha256': policy.sha(text.encode()),
               'disposition': 'BENIGN_STANDARD_TACTIC_IMPORT'}
        self.manifest['reviewed_findings'].append(row)
        self.assert_pass()
        self.write('D1Bound5/Base.lean', text + '-- source changed\n')
        self.assert_fail()

    def test_manifest_cannot_allow_forbidden_axiom(self):
        text = 'axiom bad : False\n'
        self.write('D1Bound5/Base.lean', text)
        self.manifest['reviewed_findings'].append({'module': 'D1Bound5.Base', 'line': 1,
            'category': 'forbidden_proof_or_execution', 'token': 'axiom', 'source_line': text.strip(),
            'source_sha256': policy.sha(text.encode()), 'disposition': 'BENIGN_STANDARD_TACTIC_IMPORT'})
        self.assert_fail()

    def test_options_are_reviewed_exact_pairs(self):
        self.write('D1Bound5/Base.lean', 'set_option maxHeartbeats 0\nset_option maxRecDepth 100000\n')
        self.assert_pass()
        for text in ['set_option maxHeartbeats 123456\n', 'set_option autoImplicit true\n',
                     'set_option debug.skipKernelTC true\n', 'set_option unknown false\n',
                     'example := set_option debug.skipKernelTC true in 0\n']:
            with self.subTest(text=text):
                self.write('D1Bound5/Base.lean', text)
                self.assert_fail()

    def test_codegen_option_requires_exact_reviewed_occurrence(self):
        text = 'set_option compiler.extract_closed false\n'
        self.write('D1Bound5/Base.lean', text)
        self.assert_fail()
        self.manifest['reviewed_codegen_options'].append({'module': 'D1Bound5.Base', 'line': 1,
            'name': 'compiler.extract_closed', 'value': 'false', 'source_sha256': policy.sha(text.encode()),
            'disposition': 'BENIGN_CODE_GENERATION_OPTION'})
        self.assert_pass()
        self.write('D1Bound5/Base.lean', text + '\n')
        self.assert_fail()

    def test_unimported_production_source_rejected(self):
        self.write('D1Bound5/Unused.lean', 'theorem unused : True := by trivial\n')
        self.assertIn('Not imported by project root: D1Bound5.Unused', self.assert_fail()['errors'])

    def test_nested_production_modules_are_discovered(self):
        self.write('D1Bound5/Base.lean', 'import D1Bound5.Nested.Leaf\n')
        self.write('D1Bound5/Nested/Leaf.lean', 'theorem leaf : True := by trivial\n')
        self.assertEqual(self.assert_pass()['production_module_count'], 3)

    def test_missing_import_rejected(self):
        self.write('D1Bound5/Base.lean', 'import D1Bound5.Missing\n')
        self.assert_fail()

    def test_cycle_rejected(self):
        self.write('D1Bound5/Base.lean', 'import D1Bound5\n')
        self.assert_fail()

    def test_unterminated_comment_rejected(self):
        self.write('D1Bound5/Base.lean', '/- unfinished\n')
        self.assert_fail()

    def test_source_change_during_scan_rejected(self):
        original = Path.read_bytes
        reads = 0

        def mutate_on_second_read(path):
            nonlocal reads
            if path == self.root / 'D1Bound5/Base.lean':
                reads += 1
                if reads == 2:
                    path.write_text('-- changed during scan\n')
            return original(path)

        with mock.patch.object(Path, 'read_bytes', mutate_on_second_read):
            report = self.assert_fail()
        self.assertIn('D1Bound5.Base', report['source_changes_during_scan'])

    def test_source_escape_rejected(self):
        outside = self.root / 'outside.lean'
        outside.write_text('theorem outside : True := by trivial\n')
        path = self.root / 'D1Bound5/Escape.lean'
        path.symlink_to('/dev/null')
        self.assert_fail()

    def test_cli_rejects_unreviewed_findings_and_writes_source_only_report(self):
        self.write('D1Bound5/Base.lean', 'run_tac pure ()\n')
        output = self.root / 'evidence'
        run = subprocess.run([sys.executable, str(policy.HERE / 'source_policy.py'),
                              '--project', str(self.root), '--out', str(output)],
                             capture_output=True, text=True)
        self.assertNotEqual(run.returncode, 0)
        report = json.loads((output / 'SOURCE_POLICY_REPORT.json').read_text())
        self.assertTrue(report['source_only'])
        self.assertFalse(report['compiler_ran'])


if __name__ == '__main__':
    unittest.main()
