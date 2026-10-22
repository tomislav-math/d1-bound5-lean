# Exact graph1 archive index recovery

## Finding and scope

The actual observation is pinned at SHA-256
`7a504cfd7e57d3bab283094cca4a3ba77afdf53d00f3ee88df09b67780064862`.
It records HEAD `7c5c5bb6239da37ce2fe5bdd4e733bd2bbc54311` and the
419-path staged snapshot. The original publication selected 392 content files
plus its selection manifest and staging list: exactly 394 research/records
paths. None is a canonical `D1Bound5/` source. The 25 additional index paths
are outside that reviewed selection. The available evidence does not identify
which action placed them in the index.

All 25 canonical paths are absent from HEAD. For each, the actual indexed and
working SHA-256 matches both its root-level archive snapshot and its candidate
under `research/continuations/20261022-graph1-closure/`. Both archived copies
are already in the original 394-path selection. A separate explicit
`git restore --staged --` of only those 25 paths therefore narrows the index
to the already-reviewed archive while preserving all working source bytes.
No move, deletion, proof change or reclassification is needed.

The index helper's failure is a hard failure of the original snapshot:
`A staged-tree proof source lacks a source fingerprint`. Its coverage check
requires every indexed canonical Lean source to occur in the indexed proof
manifest. Changing the helper or appending manifest rows is unnecessary for
this archive-only scope. Both manifest bytes and every other index entry are
preserved. This is an exact repair of the selection mismatch, followed by a
new ordinary exact-index review; the old failed snapshot is not accepted.

Graph1's actual endpoint evidence remains distinct from canonical-root
integration. The collector records 58 targets, 96 declarations, seven bound
audits and 58 targeted same-kernel replays, with 29 of 48 working endpoints.
The recovery preserves the endpoint's source, artifact, scope and inventory
evidence. Main theorem and canonical-root integration remain unproved.

## Guard and required separate actions

The guard runs only at:

`/Users/tp/Lean/D1Bound5/research/continuations/20261022-graph1-publication-recovery/recovery_guard.py`

Before starting, that new directory must contain exactly
`ACTUAL_INDEX_OBSERVATION.json` and `recovery_guard.py`. Do not upload this
review or the local path file into that directory before the guard starts.
The guard creates its own `UNSTAGE_PATHS.txt`, new OWNER and recovery records.
All recovery records are excluded from the current 394-path commit and may
be archived by the next separately reviewed publication.

1. Run the reviewed guard with no arguments. It acquires both existing project
   locks nonblocking, rejects live compiler/replay activity or an active prior
   owner, requires a serial paused driver, checks the exact observed index,
   existing selection and all pinned files, and revalidates the current
   endpoint/scoped receipts and source/artifact bytes. It emits `READY.json`.
2. In a separate plain Git call, unstage only the 25 literal paths in
   `UNSTAGE_PATHS.txt`. Do not stage any new files or regenerate the selection.
3. Separately run the unchanged exact-index helper and ordinary preflight.
   Save their successful actual JSON stdout, without wrappers, as
   `INDEX_REVIEW.json` and `PREFLIGHT.json` in the new recovery directory.
   Write each record completely before publishing its final filename.
4. Wait for `COMMIT_READY.json`. The guard requires the exact repaired full
   index, exactly 394 staged paths, unchanged archive bytes and both real
   passing review records. Only then perform the separately reviewed ordinary
   commit and non-forced private push.
5. After obtaining both actual command completions and checking the actual
   remote main/private visibility, save `POST_PUSH_RECEIPT.json` in the new
   recovery directory. Its existing receipt schema must contain
   `status: PRIVATE_PUSH_VERIFIED`, exit codes zero, the actual matching local
   and remote HEAD, repository, PRIVATE visibility, `selected_files: 394`,
   `selected_committed_blobs_match: true`, `staged_count: 0`, and false
   `main_theorem_complete`/`root_integration` flags.
6. Save a complete `RELEASE.json` containing
   `status: RELEASE_RECOVERY_AFTER_PRIVATE_PUSH` and
   `post_push_receipt_sha256` equal to the actual receipt's SHA-256. The guard
   verifies one ordinary child commit of the starting HEAD, the exact 394-path
   commit delta, the unchanged reviewed index tree with zero staged changes,
   the matching remote-tracking ref and post-push record, all original source
   and archive bytes, both original manifests, the old OWNER and all endpoint
   evidence. It then writes FINISH and marks only its own OWNER inactive.

The entire lock window is 240 seconds, including verification. Timeout,
signal, changed bytes, missing review records or a mismatch stops the guard
without a completion claim. It does not retry or repair anything. The guard
contains no Git mutation, compiler, driver import, network request or generic
shell command. Actual private remote verification remains the separate
operator action recorded in the post-push receipt.

## Local verification and limits

Python syntax was checked without running the runtime entry point. The actual
419/394/25 set equation and both archived copies of all 25 canonical files
were checked from the supplied authentic observation and selected-file map.
The exact index parser/serializer was checked on a small in-memory example
and rejected unmerged and symlink entries. No remote, Git or Lean execution
was performed by this local preparation. Runtime PASS is not claimed.

Relevant policy and implementation are the unchanged local snapshots of
`GIT_SYNC_POLICY.md`, `scripts/git_sync_index_review.py` (coverage check in
`IndexReview.inspect`) and `publication_guard.py` (selection and 240-second
lock holder). The actual selection evidence, rather than a general possible
selection route in that guard, determines this recovery's scope.
