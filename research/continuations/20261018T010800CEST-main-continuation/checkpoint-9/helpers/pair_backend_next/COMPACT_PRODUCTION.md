# Compact production staging

`stage_pair_compact.py` is a separate preparation helper. The reviewed expanded
generator, its expected manifests, and the already-intaken architectures for
rows16,34,41 are unchanged. Those three rows are excluded by default.

The remaining45 rows require165 modules instead of406:five structural rows
use one module each;40 nonstructural rows use four each. This removes241
separate Lean module invocations. It does not change any proof, data value,
certificate predicate or theorem argument.

For every row the compact helper first regenerates the reviewed expanded
sources and compares every hash with the frozen expanded manifest. It then
concatenates their complete namespace bodies verbatim, exactly once. Only
the import headers and owning files change. The ownership map and each
original body hash are recorded in the compact manifest.

Structural rows contain original declarations, supplied roots/destinations,
unchanged seed/filter/count proofs, indexed closure and the actual trace-zero
triangle proof in `SmallPairGraphDataN`.

Other rows contain data only in `SmallPairGraphInputsN`:the original
declarations, supplied roots/destinations, colors, cached residues and sparse
floor lists where needed. `SmallPairGraphLeftN` and `RightN` each import only
these row data and the generic checker. `SmallPairGraphDataN` owns the unchanged
seed/filter/count, indexed closure and triangle assembly proofs. The color
proofs never import the row's closure or arithmetic certificates.

The helper checks exact coverage of all old module bodies, unique public
theorem ownership, unchanged five public theorem types, absence of theorems
in nonstructural Inputs, and an acyclic new import graph. No original or
already-staged file is modified. Generated sources are optional replacements;
do not import the expanded and compact owners for the same row together.

Current diagnostic outputs:

- `compact_review_samples`:rows2(integer),8(floor),22(structural), nine
  concrete modules. These cover all three backend shapes for independent
  review; they have not been compiled.
- `compact45_dry/manifest.json`:all45 prospective compact source hashes,
  165 modules and70,148,288 source bytes. All406 expanded predecessor hashes
  matched their frozen expected values.
- `compact_pilots_2_22`:the requested initial production pilots, five modules
  and2,479,385 bytes, reproduced against the full compact expected manifest.
  The separate expanded row34 sparse pilot remains unchanged.

Independent source reviews passed. The article auditor parsed the actual
compact2/8/22 namespace blocks and reconstructed all25 predecessor modules
with independently supplied import lists:every old SHA and byte count matched
the frozen expanded manifest. Bennett independently checked all60 declaration
owners, balanced namespace scopes, absence of stale expanded imports and the
acyclic Inputs-only color dependency graph. These reviews are recorded in
`audit_next/compact_bodies_review.json` and
`audit_next/compact_namespace_import_review.json`. They are source reviews,
not compiler acceptance. Mac regeneration and concrete pilot builds remain
the coordinator's next gates.

Portable invocation uses the same explicit paths as the expanded helper,
with two additional inputs and the compact expected manifest:

```sh
python3 stage_pair_compact.py \
  --rows all \
  --exclude-rows 16,34,41 \
  --input-dir "FROZEN_ORIGINAL_GRAPH_SOURCES" \
  --manifest-dir "CP7_INPUT_DIAGNOSTIC_SIEVE_MANIFESTS" \
  --sieve-dir "PROJECT_D1BOUND5_DIRECTORY" \
  --root-routine "generate_pair_closures.py" \
  --staging-helper "pair_staging.py" \
  --floor-generator "generate_floor_witnesses.py" \
  --floor-manifest "FROZEN_SPARSE_FLOOR_MANIFEST.json" \
  --expanded-generator "stage_pair_backends.py" \
  --expanded-manifest "FROZEN_ALL47_EXPANDED_MANIFEST.json" \
  --helper-dir "PROJECT_D1BOUND5_DIRECTORY" \
  --source-pins "backend_source_pins.json" \
  --expected-manifest "COMPACT45_EXPECTED_MANIFEST.json" \
  --output-dir "NEW_COMPACT_STAGING_DIRECTORY"
```

Add `--dry-run` to write only the comparison report. Every requested row is
checked before any Lean output is written. A selected subset can be generated
against the full expected compact manifest. No71MB source transfer is needed:
the same small pinned scripts/manifests regenerate the data locally on the
Mac. No installation, compilation or main-theorem completion is claimed here.
