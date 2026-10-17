# Exact-index preparation review, 17 October 2026

The author requested improvements to routine private saving, without support
reports. No report was sent and no external support action was taken.

Added `scripts/git_sync_index_review.py`, a read-only preparation helper, and
`scripts/test_git_sync_index_review.py`, an isolated fixture test suite.
The existing preflight and mathematical sources were not changed. A short
section documenting the helper was appended to GIT_SYNC_POLICY.md.

## Concrete defect addressed

The existing preflight reads source/tool manifests and their files from the
working tree, while reading selected upload paths from the Git index. Those
can represent different snapshots. Newer unstaged proof development may then
make a previously reviewed staged snapshot fail a working-tree fingerprint
check. Conversely, a corrected working-tree manifest does not establish that
the indexed manifest matches the indexed proof bytes.

The new helper checks the INDEX manifests against the INDEX blobs. It reports
newer working-tree differences separately, checks proof/audit coverage and
selected file scope, and rejects an actual index mismatch. It never repairs
hashes automatically or claims that matching fingerprints prove compilation.
It checks the fixed private destination through the already authenticated CLI.
It stops if HEAD or the index changed while being examined.

## Actual validation

Both files compiled as Python and passed 12 isolated tests in the container.
The transferred source hashes matched those exact tested files on the Mac:
- git_sync_index_review.py: d8f12bc24423ab2c159c01d6bf5a83ffa1a94a6f906584b6654e126e2da00bef
- test_git_sync_index_review.py: 6311be6cce64d0481fc3364e27578c797f5f95c421fe39378f62b32a1bc4fe08

The same 12 tests were then run with the Mac's user-local Python 3.12 and all
passed (1.613 seconds). Tests create disposable local fixture repositories;
they never target the project checkout and never connect to GitHub.

Actual project inspection returned INDEX_REVIEW_PASS, exit 0 at
2026-10-17T07:33:50Z. It checked 82 source and 43 tool fingerprints in the
indexed snapshot at HEAD 781dca45e5220a196cddfcdf29add8876a643c7a and the six
previously staged historical continuation files. It separately reported
D1Bound5.lean as differing in the working tree. The destination was verified
PRIVATE with ADMIN access. This is NOT a proof/build or upload receipt.

## Preserved boundaries

The proof worker that began at 09:19 CEST was active at initial inspection.
No source, proof manifest, staged file, branch or running process belonging to
that worker was modified. The old preflight remains unchanged. The new helper
and this record are saved locally but not staged or pushed in this invocation.
No commit/push effect is hidden in the new helper. No safety setting was changed.
The recurring external pre-execution refusals have not been diagnosed or fixed
by this local preparation improvement. Ordinary upload calls still require the
usual review, verified build evidence, concurrency checks and tool authorization.
