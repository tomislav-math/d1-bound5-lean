"""Isolated fixtures. Tests never connect to GitHub or use the user's checkout."""
import hashlib
import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from git_sync_index_review import IndexReview, ReviewError, MANIFESTS


class IndexTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.git('init', '-q')
        self.git('config', 'user.name', 'Test Fixture')
        self.git('config', 'user.email', 'fixture@example.invalid')
        self.put('D1Bound5.lean', 'import D1Bound5.Basic\n')
        self.put('D1Bound5/Basic.lean', 'theorem fixture : True := True.intro\n')
        self.put('scripts/BasicAudit.lean', 'import D1Bound5.Basic\n')
        self.put('records/check.md', 'fixture baseline\n')
        self.manifests()
        self.git('add', '--', 'D1Bound5.lean', 'D1Bound5/Basic.lean', 'scripts/BasicAudit.lean',
                 'records/check.md', *MANIFESTS)
        self.git('commit', '-qm', 'Initial isolated fixture')

    def tearDown(self):
        self.tmp.cleanup()

    def git(self, *args):
        return subprocess.check_output(['git', *args], cwd=self.root, stderr=subprocess.PIPE)

    def put(self, name, text):
        p = self.root / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)

    def manifests(self):
        for name, paths in zip(MANIFESTS, [('D1Bound5.lean', 'D1Bound5/Basic.lean'),
                                          ('scripts/BasicAudit.lean',)]):
            self.put(name, ''.join(hashlib.sha256((self.root / p).read_bytes()).hexdigest()
                                  + '  ' + p + '\n' for p in paths))

    def stage_note(self):
        self.put('records/note.md', 'Reviewed fixture note\n')
        self.git('add', '--', 'records/note.md')

    def test_unchanged_index(self):
        self.assertEqual(IndexReview(self.root).inspect()['status'], 'NO_STAGED_CHANGES')

    def test_note_staged(self):
        self.stage_note()
        self.assertEqual(IndexReview(self.root).inspect()['staged_paths'], ['records/note.md'])

    def test_newer_worktree_does_not_corrupt_old_index_review(self):
        self.stage_note()
        self.put('D1Bound5/Basic.lean', 'new uncommitted work\n')
        r = IndexReview(self.root).inspect()
        self.assertEqual(r['status'], 'INDEX_REVIEW_PASS')
        self.assertEqual(r['working_tree_differs_from_index'], ['D1Bound5/Basic.lean'])

    def test_worktree_manifest_cannot_mask_bad_staged_manifest(self):
        self.put('D1Bound5/Basic.lean', 'changed fixture proof\n')
        self.git('add', '--', 'D1Bound5/Basic.lean')
        self.manifests()  # deliberately not staged
        with self.assertRaisesRegex(ReviewError, 'INDEX_FINGERPRINT_MISMATCH'):
            IndexReview(self.root).inspect()

    def test_coherent_staged_source_and_manifest(self):
        self.put('D1Bound5/Basic.lean', 'changed fixture proof\n')
        self.manifests()
        self.git('add', '--', 'D1Bound5/Basic.lean', MANIFESTS[0])
        self.assertEqual(IndexReview(self.root).inspect()['status'], 'INDEX_REVIEW_PASS')

    def test_new_proof_needs_fingerprint(self):
        self.put('D1Bound5/New.lean', 'new fixture\n')
        self.git('add', '--', 'D1Bound5/New.lean')
        with self.assertRaisesRegex(ReviewError, 'lacks a source fingerprint'):
            IndexReview(self.root).inspect()

    def test_symlink_not_followed(self):
        p = self.root / 'research/link.txt'
        p.parent.mkdir()
        p.symlink_to('../records/check.md')
        self.git('add', '--', 'research/link.txt')
        with self.assertRaisesRegex(ReviewError, 'Non-regular indexed file'):
            IndexReview(self.root).inspect()

    def test_deletion_requires_review(self):
        self.git('rm', '-q', '--', 'records/check.md')
        with self.assertRaisesRegex(ReviewError, 'Deletion requires'):
            IndexReview(self.root).inspect()

    def test_token_shaped_fixture_withheld(self):
        self.put('records/note.md', 'ghp' + '_' + 'A' * 32)
        self.git('add', '--', 'records/note.md')
        with self.assertRaisesRegex(ReviewError, 'value withheld') as error:
            IndexReview(self.root).inspect()
        self.assertNotIn('A' * 32, str(error.exception))

    def test_path_escape_rejected(self):
        with self.assertRaisesRegex(ReviewError, 'Unsafe'):
            IndexReview.manifest_rows(('0' * 64 + '  ../outside\n').encode())

    def test_index_lock_untouched(self):
        lock = self.root / '.git/index.lock'
        lock.write_text('test lock')
        with self.assertRaisesRegex(ReviewError, 'locked'):
            IndexReview(self.root).inspect()
        self.assertEqual(lock.read_text(), 'test lock')

    def test_review_does_not_change_worktree_head_or_index(self):
        self.stage_note()
        before = self.git('rev-parse', 'HEAD'), (self.root / '.git/index').read_bytes(), self.git('status', '--porcelain')
        IndexReview(self.root).inspect()
        after = self.git('rev-parse', 'HEAD'), (self.root / '.git/index').read_bytes(), self.git('status', '--porcelain')
        self.assertEqual(before, after)


if __name__ == '__main__':
    unittest.main(verbosity=2)
