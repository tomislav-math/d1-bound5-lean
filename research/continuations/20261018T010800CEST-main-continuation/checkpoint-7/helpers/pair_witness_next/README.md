# Optional witness-based pair closure

## Checkpoint 7 standalone compilation status

The root agent reported the following standalone kernel results on the pinned
project. These do not establish acceptance of the project root or main theorem.

| Module or certificate | Result |
| --- | --- |
| Generic supplied-root witness checker, `c3e5b89a...` | Passed, 32.3 s |
| Generic cached-residue checker, `8d305390...` | Passed, 78.69 s |
| Generic indexed-witness checker, `396e39b9...` | Passed, 31.97 s |
| Existing pilot vertex/phase and supplied-root data modules | Passed standalone |
| Cached pilot data, `8675170e...` | Passed, 66.5 s |
| Graph 41 unindexed witness closure, `99a249ea...` | Timed out after 603.88 s; no accepted proof |
| Graph 41 indexed closure, `aa955931...` | Passed, 78.1968 s |
| Graph 41 cached left/right class and combined triangle certificates | Pending |
| Selected Graph 41 integration and all-48 replacement architecture | Not compiled |

The indexed closure backend is now the supported staged choice. Full graph
acceptance still requires the cached class certificates and final integration.

`PairClosureWitness.lean` is an alternative certificate evaluator for the
existing `pairClosureBool`. It does not change the graph's vertex list, norm
bound, descent argument, or final exclusion theorem.

The input data are an anchor root `r0` and one `PairRootWitness` per vertex,
in the original vertex order. The checker verifies:

1. `r0*r0 = a*b+1`;
2. the list of witness vertices is exactly the original vertex list;
3. both supplied roots square to `a*z+1` and `b*z+1` at every vertex;
4. each of the two distinct signed mutations is outside the bound or belongs
   to the original vertex list.

The four choices of signs of the two vertex roots produce only two different
mutations. The sign of the anchor root is covered too. This follows by factoring
the difference of two squares and using the already accepted
`quadInt_mul_eq_zero` under positive discriminant. Zero roots cause no exception.

The computational checker contains no `rootCandidate`, `hasSquareRoot`, or
`Nat.sqrt`. Canonical roots occur only in the symbolic proof that the supplied
mutations cover both original deterministic neighbors. The final theorem
`pairClosureBool_of_witness_checked` has exactly the old Boolean closure
certificate as its conclusion, so existing graph consumers remain unchanged.
There is also `pairClosure_of_witness_checked` with the exact closure hypothesis
consumed by `pairClosure_complete_full_ring`.

The unindexed version was the initial optional performance fallback. It replaces
repeated square-root discovery with exact integer multiplication and retains
ordinary list membership searches. It does not optimize the seed search,
filtering, or triangle certificate.

Provenance: read the actual accepted `PairExtensionCore.lean` and
`PairExtensionComplete.lean` on the pinned project on 2026-10-18. In particular,
the sign-case proof follows the existing `mutate_eq_canonical` structure, while
the endpoint exactly matches the existing closure predicate.

Status: root reported kernel compilation of the generic
`PairClosureWitness.lean` (SHA `c3e5b89a...`) passed in 32.3 seconds.
Its unindexed Graph 41 certificate later timed out; the indexed certificate
passed as recorded above. This agent performed no compilation or remote writes.

Independent mathematical review by `article_audit` passed. Its Boolean API
finding was repaired using the inspected pinned-core theorem
`Bool.and_eq_true_iff` (`Init/Data/Bool.lean:176`).

## Graph 41 pilot

Run `python pair_witness_next/generate_graph41_witnesses.py` from the shared
workspace to reproduce the data and isolated certificate. The generator asserts
the frozen original source SHA, exact list-literal SHA, phase-source SHA, and
the SHA of the existing exact-root routine before computing any witnesses.
It reads the original closure list and asserts that the imported phase list is
literally identical. It never writes either original input.

The generated `SmallPairWitnessData41.lean` imports the separate
`SmallPairPhaseData41` module, uses its anchors and closure, and stores only the
two roots per vertex. `zipWith` attaches those roots to the existing closure
vertices, so the enormous vertex coordinates are not duplicated.

The Python diagnostics verified the anchor root `(-1,2)`, all 746 root equations
for 373 vertices, and all 1492 vertex-root sign combinations. Among the 746
distinct signed mutation checks, 745 are in the original closure and one is
outside the bound. These diagnostics are not the Lean proof.

`SmallPairWitnessClosure41.lean` contains the actual `decide +kernel` certificate
and `closure_checked_by_witness`, which concludes the unchanged
`pairClosureBool anchorA anchorB (10^1100) closure = true`. This unindexed attempt
timed out; its source and manifest are preserved. `graph41_witness_manifest.json` records all exact
input and output hashes, counts, and the ordered destination-index digest.

## Original Graph 41 endpoint

`prepare_graph41_integration.py` prepares
`integration/SmallPairGraphData41.lean` without installing it. The data
declarations remain byte-for-byte identical to the frozen original. All five
consumer theorem names and types remain unchanged. The seed, closure, filter,
and triangle proof bodies refer to the isolated pilot theorems; the cheap
vertex-count certificate remains unchanged. The generator asserts these
properties and records them in an integration manifest. This replacement is
ready only after all imported pilot certificates pass.

That original integration remains untouched as history. The selectable
`prepare_graph41_backend_integration.py --closure indexed --triangle cached`
produces `integration_indexed_cached/SmallPairGraphData41.lean`, SHA
`1f0a22aea04cdf19f5c1decf0dd2b81721b629d536403050711fcb9c3b79a5dd`.
It uses the accepted indexed closure and pending cached triangle, preserves
all original data and public theorem types, and needs no new data architecture.

## Reproducible all-48 exploration

`all48_input_fingerprints.json` freezes the 48 original source/closure-JSON/
graph-JSON triplets. `explore_all48.py` first checks all 144 hashes and the
exact-root routine hash, then parses the actual original Lean data, checks it
against the JSON, verifies all supplied roots and bounded mutations, and
prepares a BFS color mask from each existing exact-edge graph. The resulting
`all48_diagnostic_manifest.json` records per-row hashes, masks, and counts.

The exact Python diagnostics cover 37,003 closure vertices, 74,006 root
equations, and 74,006 signed mutations. Every bounded mutation is in the
unchanged vertex list. All 48 existing exact-edge graphs are bipartite.
The proposed two-color certificates would inspect 8,063,266 unordered
same-color pairs in total; the existing modular graphs have 68,640 same-color
survivors. These are diagnostic counts, not certified timings or Lean results.

The same module pattern therefore applies to all 48 rows: separate original
data, seed/filter certificates, supplied-root data and closure certificate,
two independent-class checks, and a proof-only endpoint replacement. Color
masks and generated roots remain untrusted inputs until the respective Lean
checkers prove them. The generic split theorem covers every vertex for any
mask; it does not rely on completeness of the JSON edge list. No other heavy
graph compilation has been queued and no original source was replaced.

## Cached modular residues

`PairCachedResidues.lean` is a separate, independently reviewed optimization
checker. A signature stores the two canonical coordinate residues for every
mask in the existing ordered sieve. The outer certificate checks each entire
signature once and checks that its vertex list is exactly the requested list.
It then runs the original ordered sieve using only those small cached values.
The huge integral product and original exact root test are needed only when
all cached masks accept a pair.

The generic proof establishes equality with the actual
`hasSquareRootFast sieve (x*y+1)` Boolean. Its final theorem concludes the
unchanged `pairIndependentBool sieve vertices = true`, with no new
discriminant, primality, mask-validity, or square-root assumption. Wrong
signature lengths, order, coordinates, and missing vertices cannot bypass
the outer validation. Repeated vertices keep the original equality guard.
The generic source SHA `8d305390...` is frozen after `article_audit`'s full
mathematical and pinned-API review, and passed standalone kernel compilation.

`generate_cached_pilot41.py` reproducibly creates only the Graph 41 pilot in
`cached_pilot41/`. It pins the original graph, existing pilot, sieve, exact-root
routine, and generic-source hashes. The data reuse the existing 372 vertices
and color mask, storing 18,600 small coordinate residues without copying the
huge vertex coordinates. Separate left and right `decide +kernel` certificates
allow comparison with the unmodified pilot checks.

Python checked the cached formula against the actual product residues at every
scanned mask. Each color class contains 186 vertices and 17,205 unordered
pairs. The left class has 884 exact-test fallbacks and the right class has 810;
all those fallbacks are nonsquares in the exact Python diagnostic. The
class kernel certificates remain pending. The cached data module itself passed.
No all-48 cached
data have been emitted.

`article_audit` independently parsed the emitted Lean pilot data and verified
all 372-by-25 residue pairs against the frozen vertex coordinates and original
moduli; it also checked the exact color-list coverage and zip-truncation guard.
Its review record is `audit_next/cached_pilot41_review.json`.

## Indexed closure pilot

`PairClosureIndexedWitness.lean` is owned by `crossblock`. It consumes the
existing root-witness list plus a separate list of destination pairs. A
`some i` destination checks equality with the actual original-list element at
that index; `none` checks that the mutation norm is strictly above the bound.
The two lists are traversed together and unequal lengths are rejected.

`generate_indexed_pilot41.py` emits the optional
`SmallPairIndexedClosure41.lean` against the unchanged existing root-data file.
It supplies 745 exact indices and one outside-bound marker. The first index
is the `r,s` mutation and the second is the `r,-s` mutation, matching the actual
accepted formula `a+b+(2ab+1)z+2r0rs`. The certificate still concludes the exact
old closure Boolean. Existing active pilot files are untouched.

The initially reviewed generic fingerprint `cf1974b8...` is retained in
`indexed_pilot41_manifest_cf1974.json`. The generator now pins the accepted
`396e39b9...` version, whose only compiler repair parenthesized a Boolean
expression. The emitted pilot source remained exactly `aa955931...` and passed.

## All-48 source staging architecture

`pair_staging.py` validates a requested row against all frozen source and JSON
hashes, reconstructs its supplied roots and destinations, and compares their
digests with the independent all-48 diagnostic manifest. It writes nothing.

`stage_all48_witnesses.py` uses that loader to prepare four installed modules
per row:

1. `SmallPairGraphInputsN`: the original public data-declaration block moved
   byte-for-byte, followed by shared root pairs, destination indices, and an
   untrusted color mask. Witnesses zip the original closure, so vertex
   coordinates are not copied again.
2. `SmallPairGraphArithmeticN`: the original seed, filter, and count theorem
   blocks unchanged, isolated from closure and graph arithmetic.
3. `SmallPairGraphClosureN`: choose exactly one small membership or indexed
   certificate backend. Both use the shared data and export the original
   closure theorem name and type.
4. `SmallPairGraphDataN`: optional plain or cached color assembly under the original
   module filename. It imports the other phases and exports the unchanged
   triangle theorem using the accepted independent-class adapter. The cached
   backend stores only small signatures and zips the original large-vertex
   list; its two class certificates validate exact signatures and coverage.

The generator defaults to row41. The two closure alternatives are stored in
separate staging directories with the same intended module filename; only one
may be installed. These are replacements of the original data owners, so old
and new data-owner modules must not be imported together.

Commands already executed locally:

```
python pair_witness_next/stage_all48_witnesses.py --rows 41 --emit-plain-assembly
python pair_witness_next/stage_all48_witnesses.py --rows all --dry-run --emit-plain-assembly
python pair_witness_next/stage_all48_witnesses.py --rows 41 --emit-cached-assembly
python pair_witness_next/stage_all48_witnesses.py --rows all --dry-run --emit-cached-assembly
```

Only row41 was emitted. The all-48 dry-run validated every source generation
and recorded hashes without emitting the full data. The installed design has
192 modules for 48 rows; retaining both alternate closure sources would stage
240 files, about 56.7 MB with plain colors or 65.2 MB with cached colors.
It does not create per-vertex or per-mask modules.
No staged replacements have been remotely installed or compiled.

## Portable reproduction without large data transfers

The staging generator accepts explicit `--input-dir`, `--sieve-dir`,
`--helper-dir`, `--manifest-dir`, `--root-routine`, and `--output-dir` paths.
`--source-only` reconstructs the roots, indices, and cached signatures directly
from exact SHA-pinned original Lean sources, so historical large JSON files
need not be copied. Their frozen hashes remain preserved as provenance; the
local full-input check still verifies them. Every reconstructed list digest
is also checked against the original independent diagnostic manifest.

Copy the two small Python files, the three frozen manifests, the existing
exact-root routine, and the expected output manifest to the staging machine.
The three generic Lean helper sources must be accessible at `--helper-dir`;
they are hash-checked. Existing original GraphData and sieve sources may be
copied on that machine into the input directories. A representative command is:

```
python stage_all48_witnesses.py --rows all --exclude-rows 41 \
  --emit-cached-assembly --source-only \
  --input-dir ORIGINAL_GRAPH_DATA --sieve-dir EXISTING_SIEVES \
  --helper-dir GENERIC_HELPERS --manifest-dir FROZEN_MANIFESTS \
  --root-routine generate_pair_closures.py --output-dir STAGED_OUTPUT \
  --expected-manifest manifest_all_cached_dry.json
```

`--expected-manifest` compares every generated source's SHA and byte count
before writing it. Use `--dry-run` first to write only its verification report.
Use `--rows 41` separately if that row is wanted; otherwise `--exclude-rows 41`
preserves its existing verified-pilot integration path. Install common inputs
and arithmetic, the indexed closure, and exactly one color assembly.

Local verification ran both the full historical-input mode and explicit-path
source-only mode over all 48 rows. The latter matched every one of the 240
potential emitted-source hashes against the former. Its report is
`portable_verification/manifest_all_cached_dry.json`. Only row 41 source files
were actually emitted; these diagnostics are not Lean compilation results.
