# Reviewed source preservation executable — prepared, not executed

This package prepares one reversible filesystem operation. It has not run on the canonical repository. Its test results concern disposable Linux repositories; the Mac no-replace API was inspected without moving a canonical file. Proof verification, source publication, Git operations and the portable verification entrypoint remain separate coordinator-owned actions.

The production CLI accepts only the frozen plan SHA256 `8d8412630d8f8b724599b89bd3ebfc7d4446d99de432ba40001e4c9d5df85b40` and inventory manifest SHA256 `c68e3d02eea98c09a5b878a2fa64d5ff1ebade34551e72464742d1e15feb207f`. The plan lists exactly 353 untracked helper sources, totalling 7,475,134 bytes. All are outside the selected 4,406-module final closure and absent from the 107-source HEAD/index maps. The exact original inventory contains 4,759 production Lean files, including the old umbrella; this operation does not install the new umbrella.

The only source operations are same-filesystem, no-overwrite renames from each explicit `planned_operations` entry to:

```text
research/continuations/20261023-final-source-preservation/obsolete-untracked/<original relative path>
```

There is no source deletion, content rewriting, copying over an existing file, discovered-file expansion, Git mutation or compiler invocation. Read-only enumeration verifies the complete production/archive file sets; it never generates mutation targets. Empty directories and journal/lock files remain after rollback.

## Preconditions and refreshed Git checkpoint

The coordinator first waits for the separately required clean source build, strict type/axiom audits, broad compatibility audit and official fresh replay, reviews this executor and its fixture evidence, and excludes other source/Git writers for the entire operation. Both the original 107 tracked source maps and all original source fingerprints must still match.

The old plan records historical HEAD `9b418359968913eb3e73beeee72ffa1ce953c9f1`. A later research-only commit does not authorize rewriting that frozen plan. Instead, obtain and review a new run checkpoint: the current HEAD and SHA256 of the exact raw bytes from `git ls-files --stage -z`. Supply these as `--reviewed-head` and `--reviewed-index-sha256`. The executor independently requires the unchanged 107 HEAD/index source maps and checks the full raw-index fingerprint repeatedly. A new HEAD is therefore permitted only when the refreshed reviewed identity and all pinned production conditions agree. Commit `1fe0adf1028af0e41ea578660c8d48875cde6588` was reported by the coordinator after the research-only archive; it is historical context, not an automatic execution baseline.

The three configuration files and `GIT_SYNC_POLICY.md` must retain the hashes recorded in the original plan. Every guarded source must retain its exact hash, size, mtime, inode and mode. The canonical root must remain `/Users/tp/Lean/D1Bound5`, branch `main`; the index must have no unmerged stages or `index.lock`. Production execution is restricted to the reviewed Mac platform.

## Read-only preflight

Use the final reviewed executor copy. The following paths assume this prepared package has been archived at the stated location. Set both reviewed Git values from the new checkpoint, not from an unreviewed value computed inline with execution.

```sh
D1_REPO=/Users/tp/Lean/D1Bound5
D1_TOOL="$D1_REPO/research/continuations/20261023-parallel-graphs-b/canonical-cleanup-executor-01/preserve_sources.py"
D1_INVENTORY="$D1_REPO/research/continuations/20261023-parallel-graphs-b/canonical-cleanup-inventory-01"
D1_SESSION="$D1_REPO/research/continuations/20261023-final-source-preservation/session-001"
D1_REVIEWED_HEAD=reviewed_current_head
D1_REVIEWED_INDEX_SHA=reviewed_raw_index_sha256
python3 "$D1_TOOL" preflight \
  --plan "$D1_INVENTORY/PREPARED_RELOCATION_PLAN.json" \
  --inventory-dir "$D1_INVENTORY" \
  --reviewed-head "$D1_REVIEWED_HEAD" \
  --reviewed-index-sha256 "$D1_REVIEWED_INDEX_SHA" \
  --session "$D1_SESSION"
```

Preflight requires an absent session and archive destination and writes nothing: no directories, locks, journal or result file. It emits `READ_ONLY_EXACT_PREFLIGHT_PASS_NO_MUTATION` only after the complete initial state passes. Capture its stdout separately if evidence is required; do not create the proposed session while capturing it.

## Coordinator execution, interrupted recovery and rollback

Only after the independent gates and review, repeat the same arguments with action `preserve` and add `--execute`. This is a prepared command recipe, not evidence that it was executed.

Execution first takes a shared no-follow lock at the archive parent's `preservation.lock`, then an exclusive per-session lock. It records the exact executor/plan/inventory/Git identity in `SESSION.json`. Each rename has an fsynced `intent` before it and an fsynced completion afterwards. The Mac backend is `renamex_np(..., RENAME_EXCL)` with no unsafe fallback; Linux's `renameat2(..., RENAME_NOREPLACE)` is used only by disposable fixtures. Both paths verify same-filesystem placement and fsync the source/destination directories.

After interruption, keep the original session, inputs, executor bytes and reviewed Git identity. Use `preserve --resume --execute` with the same arguments. An unmatched intent is resolved only when exactly one expected pathname exists with the original metadata and hash: source-only means not applied; destination-only means completed. Both paths, neither path, changed bytes or a changed identity stop for review. The journal is retained. Do not remove lock or journal files to bypass a refusal.

To restore the initial development layout before any separate publication edits, use `rollback --resume --execute` with that same session and arguments. It processes only completed moves in reverse order, using the same no-overwrite and journal rules. After the coordinator changes the umbrella, tools, Git state or source inventory, this original rollback deliberately refuses until a separate reviewed recovery procedure exists.

`PRESERVATION_ONLY_PASS` and `ROLLBACK_TO_DEVELOPMENT_LAYOUT_PASS` certify only the stated filesystem outcome. Both explicitly report no proof/publication claim and no Git mutation. Failure exits nonzero and leaves bytes and the available journal in place. Full source hashes are checked initially and finally; complete source metadata/file sets and Git state are checked around transitions, with each moved file hash checked before and after its rename.

## Concurrency scope and evidence

The shared/per-session locks exclude cooperating executor instances. Destination races are protected by the actual no-replace syscall. Source, Git and index races observed by the guards stop execution. Path-based checks do not claim resistance to a hostile process concurrently replacing directory components or tampering with lock files. Coordinator exclusion of other filesystem writers remains necessary; this is not a security boundary against an adversarial local user.

The fixture suite exercises real Linux no-replace calls in temporary Git repositories. Its acceptance is distinct from Mac execution and proof acceptance. Review the final fixture report, independent static review and package hashes together. Production execution and subsequent preservation/publication receipts remain pending.
