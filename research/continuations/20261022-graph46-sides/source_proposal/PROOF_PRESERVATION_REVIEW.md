# Graph 46 side proof proposal

Status: **prepared locally; not compiled, replayed, installed, or accepted**.

This proposal uses the actual graph 46 sources collected in
`graph46_inspection/SOURCE_INSPECTION.json`, SHA-256
`f2d3955f2af8d40917f33e1697a825c786fb8a8f2a2f09720628f5a0cc0b2b54`.
The six small source files were materialized from that observation's full text
and checked against its byte lengths and SHA-256 values. The raw literal data
were not retrieved locally; their dimensions below come from that pinned source
observation. The observation reports a stable read and matching original archive
bodies, and explicitly makes no proof acceptance claim.

## Observed inputs and selected partitions

Both original scalar definitions use `QuadInt 1 6`; the four original side
theorem headers use the same parameters. The left and right data were inspected
independently. Their cached coordinate sequences match their respective vertex
sequences in the observation, and both sides have 25-entry cached signatures.

| Side | Vertices, cached entries, rows | Original block | Global head interval | Helper head counts |
| --- | ---: | --- | --- | --- |
| Left | 360 each | 000 | 0–136 | 16, 20, 22, 24, 26, 29 |
| Left | 360 each | 001 | 137–359 | 34, 42, 56, 91 |
| Right | 358 each | 000 | 0–137 | 16, 20, 22, 24, 26, 30 |
| Right | 358 each | 001 | 138–357 | 34, 42, 56, 88 |

This retains the reviewed graph 1 partition strategy and its original parent
boundaries, using the actual graph 46 statements. The first helper on each side
has 16 heads. The largest helper covers 7,035 potential unordered pairs on either
side. This is a structural count, not an estimate of compiler or replay time.

The source dimensions do not establish equal computational cost. In particular,
graph 46 uses model parameters `(1, 6)`, and its right witness-row literal is
618,321 bytes, compared with 350,635 bytes on the left. Actual graph 46 pilot
measurements must be reviewed before using either remainder. The inherited
maximum is 240 seconds per target; this source generator neither runs nor
enforces a build timeout.

## Why the original obligations are preserved

Each helper checks `pairLightSelectedFloorPrefixBool` on a consecutive head
interval. For a local offset `d`, both inputs are the original parent inputs
after `.drop d`. Neither input is truncated with `.take`. Therefore each head
continues to use its entire remaining cached tail, including entries belonging
to later helpers and the next original parent block.

Let `F(n, C, R)` denote the original prefix Boolean with the fixed graph 46 model
and sieve. The existing generic theorem
`pairLightSelectedFloorPrefixBool_of_add` combines proofs of `F(m, C, R)` and
`F(n, C.drop m, R.drop m)` into a proof of `F(m+n, C, R)`. The proposed parents
apply that theorem successively from the last helper to the first. The proof
uses `List.drop_drop` and `Nat.reduceAdd` to identify consecutive dropped tails,
and `List.drop_zero` to recover the original parent inputs. The generic lemma
is parameterized by both integer model parameters; the proposal does not
specialize a graph 1 certificate to a different model.

The four public parent theorem headers are preserved byte for byte. Their
original comments, namespace, options, and closing suffix remain; the changes
add helper/concatenation imports and replace the single large kernel decision
with the concatenation proof. Every helper keeps `decide +kernel`. The generic
concatenation dependency and all new helpers still require the actual accepted
dependency evidence and checks supplied by the later runtime workflow.

The two final side wrappers are retained byte for byte and are present only as
original snapshots in this payload. Their eight theorems continue to connect
the original coverage and signature checks, the two original parent prefixes,
the final empty tail, and the original side certificate. This proposal does not
alter their statements or proofs, or any literal data definition.

## Independent local coverage review

`review_sources.py` parses the actual emitted helper statements, rather than
using their reported pair totals as its source of truth. It obtains original
block offsets and side sizes from the pinned observation, enumerates every
`(i, j)` with `i < j` for each emitted head and its complete remaining tail, checks
that no pair occurs twice, and compares the resulting sets with all unordered
pairs in the original side.

| Quantity | Left | Right |
| --- | ---: | ---: |
| Heads covered exactly once | 360 | 358 |
| Helpers | 10 | 10 |
| Unordered pairs retained | 64,620 | 63,903 |
| Pairs across helper boundaries | 56,015 | 55,536 |
| Pairs across the original block boundary | 30,551 | 30,360 |

The two side sets contain **128,523 pairs in total**. Cross-boundary counts are
subsets of these totals. The local review also verifies the payload file map,
all six input/source snapshots, the four public parent headers, the original
wrapper bytes, the matching cache/row offsets, all helper imports in the
parents, and the absence of `.take`, `sorry`, new axioms, and `native_decide`.
These checks establish the proposed source transformation and interval
coverage. They do not establish the truth of the Lean certificates.

## Deliverables and future verification

The payload contains **20 helpers, 4 replacement parents, and snapshots of the
2 unchanged wrappers**. The nominal build order includes 26 target modules and
32 theorems. Its three future scopes contain:

| Scope | Targets | Theorems |
| --- | ---: | ---: |
| Side pilots | 2 | 2 |
| Remaining left side, including original wrapper | 12 | 15 |
| Remaining right side, including original wrapper | 12 | 15 |

`payload/PLAN.json` leaves the foundation commit unset and labels the binding
as requiring actual completed graph 46 foundation evidence. No HEAD, queue,
configuration, accepted-state fingerprint, compilation receipt, or replay
receipt has been invented. A later installer must bind the current state and
the actual completed foundation before using the proposal. Both side pilots
must pass bounded builds, the required type/axiom checks, and kernel replay;
their actual timings must then justify proceeding to the remainders. The
existing serial execution, driver/runner rules, both locks, 240-second cap, and
exact-fingerprint retry restrictions remain applicable to that future work.

No source in graph 1 or the foundation workflow was changed. No Lean process,
Git action, network request, remote command, or project installation was run for
this proposal. The graph 46 endpoint, root integration, and the main theorem
remain unproved by this work.

Frozen payload manifest SHA-256:
`0a5f79888d094e6111fa6279bc14d72a784981734fe93735dc8c57f62308b3e3`.

The local result is recorded in `LOCAL_SOURCE_REVIEW.json`. Reproduction uses
the supplied six-source manifest and the pinned observation:

```sh
python3 -B graph46_sides_proposal/generate.py --sources graph46_sides_proposal/ORIGINAL_SOURCE_PATHS.json
python3 -B graph46_sides_proposal/review_sources.py
```

Both commands retain already existing identical outputs and refuse conflicting
bytes. Their output is restricted to this local proposal directory.
