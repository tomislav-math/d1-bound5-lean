# Private Git synchronization policy

Author request, 16 October 2026: upload all outstanding D1Bound5 work and
improve synchronization in future scheduled proof-development runs.
This policy does not override tool safety, confirmations, or later user instructions.

## Authorization and scope

Ordinary staging, local commits and non-forced pushes of reviewed D1Bound5
work are authorized during both manual and hourly invocations. The ONLY
destination is the author's PRIVATE `tomislav-math/d1-bound5-lean` repository.
Use the existing account and credentials without printing, copying or changing them.
Do not change permissions, publish, force-push, rebase, reset, or delete work.

Accepted proofs belong in `D1Bound5/` with verified root imports and existing
compilation, exact-statement and axiom checks. Preserve unfinished trials
separately under `research/` with their true status, never as accepted imports.
Keep `.lake`, proof objects, unrelated projects, credential stores and the
external frozen manuscript out of uploads. Review and scan selected text first.

## Per-run sequence

1. Inspect branch, HEAD, index, live compilers and newer run records.
   Do not change another active writer's files or staging area.
2. Check `git_sync_preflight.py` and run it with the user-local Python.
   It is READ-ONLY: it neither stages, commits, pushes nor changes permissions.
3. Stage only an explicit reviewed file set. Do not use `git add -A`.
   Recheck the staged diff, source fingerprints and absence of credentials.
4. Execute each Git mutation in a separate plain tool call, for example
   `git -C /Users/tp/Lean/D1Bound5 commit -m "<accurate checked unit>"`, then
   `git -C /Users/tp/Lean/D1Bound5 push origin main`.
   This is for transparent scope and diagnostics, not evasion of a refusal.
5. If a call returns a PID or call_id, obtain its final result rather than
   sending the same mutation again. A start acknowledgement is not completion.
6. After exit-zero push, compare local HEAD with `git ls-remote origin refs/heads/main`
   and verify PRIVATE visibility. Report the exact commit and remaining local work.
   Include FINISH/evidence records in the reviewed commit when practical; if a
   post-push receipt creates another local change, save it in a separate record commit.

## Failure classification

Distinguish `PRE_EXECUTION_DENIED` (exact tool refusal), `REMOTE_PROCESS_FAILED`
(actual Git stderr and exit code), `PROCESS_STATUS_UNKNOWN` and `PUSH_VERIFIED`.
Save UTC/local time, exact nonsensitive command, tool name, available request/call
identifier, returned sanitized message, local commit, expected destination and
remote state. Never invent a Git exit code when the command did not execute.

An explicit safety refusal must not be disguised or routed through another tool,
encoding, process or API to obtain the denied effect. A normal bounded retry is
appropriate only for a transient technical error or after a legitimate permission
resolution. Do not repeat denied calls blindly. Save locally and report the boundary.
A prior refusal does not mean every later, different authorized operation is denied.

Do not mark a fresh push as permanently fixing earlier denials. Current app
permissions are already Allow all actions, and GitHub permission is ADMIN;
OpenAI documents that these do not override separate safety protections.
Escalate recurring pre-execution denials with the exact evidence rather than
reinstalling Git, broadening access, or claiming a platform cause is known.

## 17 October 2026 — exact-index preparation review

A separate READ-ONLY helper is available as `scripts/git_sync_index_review.py`.
It verifies source/tool manifest bytes from the Git INDEX against the indexed
file blobs, checks manifest coverage, selected path scope and credential-like
content, confirms the fixed PRIVATE destination, and detects index/HEAD changes
during its inspection. It never stages, commits, pushes, refreshes fingerprints,
changes permissions or starts a background service.

Use it to distinguish an already reviewed staged snapshot from newer unfinished
working-tree edits. The original `git_sync_preflight.py` checks working-tree
fingerprints; retain it for validation of the current working-tree state.
An INDEX_REVIEW_PASS only describes the exact indexed snapshot. It does NOT
certify newer source edits, their compilation, theorem types, or kernel replay.
Matching build receipts and a review of the exact staged diff are still required.
If the old preflight fails solely on newer unstaged source, do not rewrite the
old manifest to claim that source was compiled; keep the snapshots distinct.
Any mismatch inside the INDEX itself is a hard failure for that snapshot.

The isolated 12-test suite is `scripts/test_git_sync_index_review.py`. It uses
temporary fixture repositories, never the project checkout or GitHub. It tests
staged-versus-working-tree divergence, mismatched and missing fingerprints,
symlinks, deletions, a synthetic credential pattern, path traversal, lock
preservation and absence of changes to the reviewed repository.

The ordinary publication calls remain separate and subject to all existing
checks. Do not route a previously denied operation through this helper or any
other wrapper. Respect concurrent proof workers and do not change their index.
This corrects local preparation semantics, not the cause of external tool
refusals. No permanent remedy for those refusals is claimed.
