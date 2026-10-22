# Graph1 closure continuation

This directory prepares the next graph1 phase. The proposal generator and source inspector have run successfully on the actual remote inputs. The Lean targets in this phase have not been built or accepted by this local work.

## Source evidence and mathematical scope

The merged `SmallPairGraphData1.lean` has 2,195,796 bytes and SHA256 `b0bceb6340003eab18f64c436c6a4b70f1c8eb14a7d185892b2e4c314665a808`. Its eight preserved-body markers match eight available archived originals. The inspector reconstructs the merged file exactly, including each removed import prefix and every boundary whitespace byte.

The original closure, root-pair list, and indexed destinations each contain **720 rows**. Filtering gives **718 large vertices**. Raw left data contains 360 rows and raw right data contains 358 rows. Prefix proofs use the full 720-element vertex list with the original global destination indices; the witness and destination lists alone are dropped. Both mutation signs remain checked.

The proposal restores the eight archived modules, splits four large raw literal declarations into four modules, and introduces twelve prefix helpers and one coverage helper. All original literal definitions and public declaration headers are preserved exactly. The only changed original proof body is the first checked-closure theorem: it combines coverage, eleven 64-row prefixes, a final 16-row prefix, and the terminal drop at 720. The second theorem in that module is preserved byte for byte.

| Scope | Build targets | Definitions | Theorems | Declarations |
| --- | ---: | ---: | ---: | ---: |
| closure-pilot | 4 | 9 | 2 | 11 |
| closure-rest | 12 | 0 | 13 | 13 |
| assembly | 9 | 4 | 13 | 17 |
| This phase | 25 | 13 | 28 | 41 |

The original eight modules contain 28 public declarations: 13 definitions and 15 theorems. The thirteen additional theorem declarations belong to the reviewed prefix/coverage helpers. Assembly includes the original `smallPairNoTriangle_1_checked` theorem and the import-only `SmallPairGraphData1` facade.

The already generated proposal binds these actual remote outputs:

- `proposal/PLAN.json`: `0e901e4bf3712aaa018eb0df4df8edcf1297bc130d12ef22459fc44d932db728`.
- `proposal/PAYLOAD_SHA256.json`: `bfefaae9b2da8c223731636cf8019f520cf6ef7166234e6432f26c91f05665e5`.

## Binding actual completed prerequisites

`bind_inputs.py` is a research-only preparation step. It takes the reviewed current commit and queue SHA as explicit arguments. It checks both project locks, an idle compiler, an empty Git index, the pinned Lean/mathlib/driver/runner configuration, and the final `REVIEWED_SCRIPT_PINS.json` before creating new files.

It reconstructs the four completed graph1 prerequisite proof states: foundation, side pilot, left remainder, and right remainder. Each scope binds ten actual evidence files, their committed Git blobs, current source closures and artifacts, the exact type/axiom audit, and every kernel-replay receipt. The audit-runner binding's self-entry is included when comparing replay guards.

The helper constructs provenance from the four prerequisite source maps and the committed checkpoint source map. Additional committed source maps may be passed as repository-relative arguments, for example the actual graph25 assembly map. It verifies coverage of **every external module** needed by each candidate scope, including `PairClosureIndexedChunks`, and verifies each selected source blob and its accepted current artifacts. A missing external provenance entry causes a failure before either executable binding is written.

Only actual verified values are written to `INSTALL_BINDING.json`, `PROVENANCE_BINDING.json`, and `BINDING_EVIDENCE.json`. The install binding also contains the provenance binding's SHA. No unbound field or fabricated future commit is emitted.

## Execution gates

1. Root publishes the completed graph1 side scopes, reviews the resulting commit/queue state, and transfers the frozen scripts and reviewed hash manifest.
2. Root runs `bind_inputs.py REVIEWED_HEAD REVIEWED_QUEUE_SHA [EXTRA_MAP ...]`, checks the actual output bindings, and runs `installer.py` with the resulting install-binding SHA. The installer regenerates the candidate bytes from the pinned original inputs before any source or queue change.
3. Root runs `build_scope.py closure-pilot`. Four serial targets use the inner 240-second worker timeout. Root then prepares, runs, and finalizes the scope's exact-type/transitive-axiom audit and four kernel replays.
4. Root runs `build_scope.py closure-rest` only after the pilot's completed evidence passes reconstruction. It then audits thirteen declarations and replays all twelve targets.
5. Root runs `build_scope.py assembly` only after both prior closure scopes pass. It then audits seventeen declarations and replays all nine targets.
6. The endpoint collector must verify all seven graph1 scopes before any claim that graph1 is an accepted endpoint. The expected aggregate is 58 build targets, 96 declarations (32 definitions and 64 theorems), seven type/axiom audits, and 58 targeted kernel replays. A fresh endpoint inventory must establish the actual change from the prior 28 of 48 endpoints.

Both locks, one compiler, unchanged configuration and canonical root, exact source fingerprints, and exclusive output creation remain mandatory. An already attempted exact fingerprint cannot be retried. A stopped batch is preserved for review and cannot be resumed automatically. The controller drains an interrupted worker's compiler before it returns. No script claims root integration or completion of the main theorem.

The endpoint count measures working graph endpoints; it is not an overall percentage of the mathematical formalization.
