# Graph11 endpoint publication review

**Prepared local proposal; endpoint acceptance and publication are not claimed.**
Use `PLAN.json` with the reviewed publication guard in
`research/continuations/20261022-graph11-endpoint-publication` only after the
following actual results exist. The plan's handoff is prospective.

## Required gates before the handoff is written

1. All three closure scope summaries have `SCOPED_VERIFICATION_PASS`, complete
   bound type/axiom and targeted kernel-replay receipts, and unchanged current
   source, artifact and configuration fingerprints.
2. The seven-scope collector writes `ENDPOINT_VERIFICATION.json` with status
   `GRAPH11_WORKING_ENDPOINT_SCOPED_VERIFIED`, module `SmallPairGraphData11`,
   719 closure rows, 718 filtered vertices, 28 preserved original closure/assembly
   declarations, seven scope-evidence entries and 58 distinct targets. Its actual
   totals must agree with the table below. Require `root_integration = false`,
   `main_theorem_complete = false` and `whole_graph11_complete = true`.
3. Check the actual `proof_fingerprint` against the canonical JSON digest of
   `ENDPOINT_PROOF_STATE.json`, and its `proof_state_sha256` against that file's
   actual bytes. Read `source_closure_modules` from the collector. Neither value
   is predicted or substituted by this plan.
4. Run the read-only inventory collector after endpoint PASS and preserve its
   actual JSON stdout as
   `research/continuations/20261022-graph11-closure/ENDPOINT_INVENTORY.json`.
   Require status `CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH11_PASS`,
   `expected_transition_matches = true`, `accepted_endpoint_count = 28`,
   `remaining_endpoint_count = 20` and `unknown_modules = []`, with Graph11 as
   the sole added endpoint and no removed endpoint. Its remaining list must equal
   **1, 3, 4, 5, 6, 7, 8, 10, 14, 15, 19, 21, 23, 24, 28, 30, 36, 39, 43, 46**.
   Preserve the collector's actual field names and output; do not synthesize
   evidence from the expected list.
5. Verify the four inherited sides publication records against its actual
   successful push, reviewed index and released owner. No future commit hash is
   pinned in this proposal.

If any gate fails or remains pending, do not install the prospective handoff or
claim the 27-to-28 transition.

## Counts to verify against the actual collector

| Scope | Targets / guarded builds / targeted replays | Definitions | Theorems |
| --- | ---: | ---: | ---: |
| foundation | 7 | 19 | 4 |
| sides-pilot | 2 | 0 | 2 |
| left-rest | 12 | 0 | 15 |
| right-rest | 12 | 0 | 15 |
| closure-pilot | 4 | 9 | 2 |
| closure-rest | 12 | 0 | 13 |
| assembly | 9 | 4 | 13 |
| **Total: seven scopes** | **58** | **32** | **64** |

There are 96 declarations and seven exact original-type/transitive-axiom audits.
Only the final three scopes are new publication groups: 25 targets, 13
definitions and 28 theorems. Foundation and sides are separately committed.

## Publication boundary and records

The existing guard validates the three selected scoped audits, their current
transitive source/artifact provenance, configuration and proof-state bindings.
It holds both locks and requires idle proof ownership, an empty index and the
expected branch. It does not itself establish the endpoint-specific inventory
transition; the collector gates above supply that evidence.

The guard recursively archives the common closure run folder and the three
audit folders. This includes endpoint collector scripts and outputs, the saved
actual inventory, original/candidate sources, installation evidence and scoped
records. The four explicit extras archive only the preceding sides publication's
`POST_PUSH_RECEIPT.json`, `INDEX_REVIEW.json`, `OWNER.json` and `RELEASE.json`.
Do not add the foundation or sides scopes as new publication groups.

The continuation archive workflow preserves payload and audit snapshots; it
does not automatically integrate canonical project source paths. MainStatement
remains **UNPROVED**, canonical-root integration remains false/unverified, and no
overall progress percentage is claimed.

Keep historical scoped summaries unchanged, including their earlier
`whole_graph11_complete = false` and publication fields. Keep the new endpoint
evidence at `PREPARED_NOT_YET_PUSHED` in its proof commit. Only an actual successful
push supports a subsequent receipt containing the real commit, push result and
read-back remote HEAD. That receipt and the completed owner/release records must
be archived in a later record commit or publication.

This local preparation ran no remote command, compiler, kernel checker or Git
operation and performed no publication.

