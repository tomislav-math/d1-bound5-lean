# Prospective graph46 endpoint publication

**Local proposal only. Graph46 endpoint completion and publication are not
claimed.** This plan targets
`research/continuations/20261022-graph46-endpoint-publication/` and uses the
unchanged generic publication guard at SHA-256
`5fe302954cb12639298c085d8fc34a7fa84a3236144650aecd1ec94e4e52b99c`
(6,046 bytes).

The generic guard reads `purpose`, `groups`, `extra`, and `handoff`. It does
not enforce `status`, `expected_review`, or `handoff_application`, run the
endpoint collectors, or validate the contents of extra endpoint JSON files.
Root must complete the gates below before invoking it. The guard writes the
handoff before checking extra paths, so a missing endpoint file cannot be
used as a substitute for the prior endpoint gate.

## Required actual endpoint evidence

All seven scopes must have actual `SCOPED_VERIFICATION_PASS` summaries,
matching proof states, successful bound exact-type/transitive-axiom audits,
successful targeted installed same-kernel replays, and unchanged current
sources, accepted artifacts and configuration. All guarded target builds and
replays retain the existing 240-second cap. Prior failed exact fingerprints,
original sources and historical records remain intact.

| Scope | Guarded builds and targeted replays | Definitions | Theorems |
| --- | ---: | ---: | ---: |
| foundation | 7 | 19 | 4 |
| sides-pilot | 2 | 0 | 2 |
| left-rest | 12 | 0 | 15 |
| right-rest | 12 | 0 | 15 |
| closure-pilot | 4 | 9 | 2 |
| closure-rest | 12 | 0 | 13 |
| assembly | 9 | 4 | 13 |
| **Seven-scope total** | **58** | **32** | **64** |

These are 96 distinct declarations and seven type/axiom audits. The three new
publication groups contain 25 targets and 41 declarations: 13 definitions and
28 theorems. The four earlier scopes remain reused verified dependencies and
are not counted again as new publication work.

The actual endpoint collector must then write
`20261022-graph46-closure/ENDPOINT_VERIFICATION.json` and
`ENDPOINT_PROOF_STATE.json`. Require the status
`GRAPH46_WORKING_ENDPOINT_SCOPED_VERIFIED`, module `SmallPairGraphData46`, all
seven scopes and exact totals above. Check the recorded proof-state byte hash
against the exact file, and the proof fingerprint against the canonical JSON
digest used by the collector. Read the source-closure size and all measured
fingerprints from the real outputs. No predicted fingerprint, source-closure
size or successful receipt is supplied by this plan.

The source result must preserve model `(1, 6)`, all 719 closure, root-pair and
destination rows, 718 filtered vertices, all 28 original closure/assembly
declarations, and the exact four raw literal bodies. The twelve closure
prefixes are eleven blocks of 64 plus a final block of 15 at offset 704. All
lookups retain the original global destination list and both mutation signs.
The original graph46 triangle statement is unchanged. Endpoint completion
requires `whole_graph46_complete: true`, while `root_integration` and
`main_theorem_complete` remain false.

## Actual inventory and the conditional 30/48 figure

After the actual endpoint collector succeeds, run the reviewed read-only
inventory and preserve its successful real JSON stdout as:

```text
research/continuations/20261022-graph46-closure/CURRENT_ENDPOINT_INVENTORY.json
```

Do not manufacture that file from this plan or reuse graph1's older inventory
filename. Require status `CURRENT_WORKING_ENDPOINT_INVENTORY_AFTER_GRAPH46_PASS`,
matching endpoint summary/proof-state hashes and proof fingerprint, the exact
seven-scope totals, current driver acceptance, `added_endpoints: [46]`,
`removed_endpoints: []`, `expected_transition_matches: true`, no unknown
modules, paused serial operation, and the collector's read-only/no-Git/no-
compiler flags.

The previous accepted set must equal the actual baseline in the closure
installation binding; the current and remaining sets must be disjoint and
cover the actual 48-endpoint universe. Counts must equal the corresponding
list lengths. **Use 30/48 only when the actual inventory also records 29
previous accepted endpoints, 30 current accepted endpoints, 48 total and 18
remaining.** The transition flag alone does not establish those numbers: it
compares with whichever real baseline was bound. If actual counts differ,
derive the handoff from that evidence and review the resulting text before
publication. Endpoint counts are not an overall formalization percentage.

## Preceding publication evidence and explicit extras

The actual successful private sides publication, its released owner and
current committed evidence must agree with the bound closure prerequisites.
Its publication directory is `20261022-graph46-sides-publication`. The eleven
known or explicitly expected files are prospective extras, each of which must
actually exist before guard invocation:

| Files | Purpose |
| --- | --- |
| `POST_PUSH_RECEIPT.json`, `OWNER.json`, `RELEASE.json` | Preserve the actual preceding publication's post-push and release evidence |
| `SELECTED_FILES_SHA256.json`, `STAGING_PATHS.txt` | Preserve and check the exact preceding selection |
| `GIT_PREFLIGHT.json`, `VERIFIED_UNITS.json` | Preserve and check its standard preflight and verified-unit records |
| `SELECTED_REVIEW.json`, `INDEX_REVIEW.json`, `PREFLIGHT.json`, `WHITESPACE_REVIEW.json` | Preserve the four actual post-selection reviews using the filenames confirmed by root |

The four selection/preflight/unit files are normally already committed in the
sides publication. Root has confirmed the four post-selection review names
from the actual foundation publication and expects the same names for the
sides publication. Naming these future sides files does not assert their
existence, contents or successful status. The unchanged guard intersects
selection with actual changed or untracked files, so unchanged committed
extras are checked without being republished. No additional review filename
is guessed.

The remaining three explicit extras are the actual endpoint verification,
proof-state and `CURRENT_ENDPOINT_INVENTORY.json` files in the closure run.
They are also included by recursive closure selection; the guard deduplicates
paths. Explicit inclusion makes their required identities unambiguous. The
prospective plan has fourteen explicit extras in total.

Foundation `POST_PUSH_RECEIPT.json`, `OWNER.json`, `RELEASE.json`, and the four
actual post-selection reviews named above are already required extras of the
preceding sides plan. Before endpoint publication, verify that their actual
bound bytes are present in the sides archive/current HEAD. They need not be
staged again. If actual committed coverage is missing, retain the files and
review an exact plan revision adding only the missing known foundation paths
before invoking the guard. Do not silently treat a missing post-record as
archived.

The endpoint publication's own future OWNER, RELEASE and POST_PUSH_RECEIPT are
not preselected or fabricated. The guard creates its actual owner; a real
commit, non-forced private push, remote-head readback and exact committed-blob
checks must succeed before a truthful post-push receipt is written. Preserve
historical scope and publication status fields instead of rewriting them.

## Exact staging and archive boundary

The only groups are `closure-pilot`, `closure-rest`, and `assembly` from
`20261022-graph46-closure`, with their matching graph46 audits. Recursive scope
and audit selection, preparation-bound paths, and the explicit extras all
contribute to the actual generated selection. The plan alone does not predict
the final selected path count.

Review `SELECTED_FILES_SHA256.json` and `STAGING_PATHS.txt` before the separate
ordinary Git calls. The staging list must equal the selected-map keys plus
the two selection files themselves, without duplicates. After staging that
exact list, compare the entire staged path set and every staged blob with the
reviewed selection. There must be no extra canonical `D1Bound5/` paths,
compiled binaries, unrelated trials, or silent source promotion. Retain the
unchanged index-helper and private-preflight checks. Preserve the guard's
UTF-8, no-NUL, maximum-five-MiB, forbidden-binary and credential-pattern gates.
Record actual whitespace findings without rewriting proven source bytes.

A mismatched index is a failed snapshot requiring its own review. The graph1
recovery is historical evidence of one explicitly reviewed correction; it is
not permission to broaden future selection, change policy/proof manifests or
automatically repeat that recovery. No Git operation is performed by this
local plan.

## Historical continuity and mathematical scope

Graph1's actual research archive was privately pushed at
`2e18bda519a42f28f2e7c1ef409e610e0a9ce75f`: 394 archive paths and 25 preserved
canonical working sources with matching snapshots. Its old timed-out owner
and separate successful recovery records retain their true statuses. The
foundation publication plan already preserves those recovery records; this
endpoint plan does not recast them as graph46 results.

Graph43 remains distinct. Its earlier raw-data build is research evidence.
Later `TRIAL12_BUILD_RESULT.json` and `TRIAL12_AUDIT_RESULT.json` under the
graph43 pilot record a successful isolated 12-head trial, exact-type/axiom
audit and installed-kernel replay. Those results are not guarded driver
acceptance and do not complete graph43 or establish a graph43 endpoint.

The intended theorem remains that every finite D(1)-set of distinct nonzero
elements of the **full ring of integers O_K of every imaginary quadratic
number field** has cardinality at most five. Half-integral bases, tied moduli
and zero pair-square roots remain allowed. MainTheorem, canonical-root
integration and final integrated verification remain open. No mathematical
assumption or overall-completion percentage is introduced.
