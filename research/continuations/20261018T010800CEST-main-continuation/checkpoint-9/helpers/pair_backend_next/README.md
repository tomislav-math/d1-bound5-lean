# Portable backend-aware graph staging

This new helper leaves all frozen cp7 scripts and accepted Lean modules
unchanged. It prepares replacements only; it never installs them or runs Lean.
The default pilots are rows16 and34. Row41 is excluded by default because its
separate integration belongs to the coordinator.

The full policy is fixed and validated against the actual source data:

- Structural trace-zero proof:16,22,27,31,32,37,41.
- Sparse floor certificates:1,6,8,9,11,12,15,17,23,24,30,33,34,40,43,46,48.
- Cached integer obstruction:the other24 rows.

The original public declaration block is copied byte for byte, exactly once,
to `SmallPairGraphInputsN`. Supplied roots and exact closure destinations are
in a separate `SmallPairGraphWitnessDataN`. Indexed closure has its own proof
module. The original seed, filter and count proof blocks are unchanged in
`SmallPairGraphArithmeticN`. All five original public theorem statement
strings are checked against the generated owners. `SmallPairGraphDataN`
imports arithmetic, closure and triangle owners, preserving the original
public API. Do not import old and replacement declaration owners together.

Each expensive left/right color certificate is a separate module and imports
neither arithmetic nor closure computations. CachedData contains only
supplied residues and their association with the original vertices. Sparse
floor data is reproduced byte for byte against its earlier frozen manifest.
No vertex or root search is repeated in the Lean color checker. Structural
rows require only the per-vertex trace certificate and actual generic
no-three theorem, without any color computations.

Local validation completed:

- Pilots16/34:16 modules,1,557,854 bytes, all preservation assertions pass.
- All47 selected rows (row41 excluded):422 modules,71,719,073 prospective
  bytes, exact full dry-run manifest in `all47_dry/manifest.json`.
- A second pilot run with every path explicit reproduced every source byte
  under `--expected-manifest`; no default filesystem layout was needed.
- Root square equations, both mutation destinations, source hashes, current
  masks, exhaustive sparse pair coverage, floor inequalities and cached
  signature order are checked locally. These are Python diagnostics. Actual
  kernel acceptance remains outstanding for the new concrete certificates.
- The independent article auditor read the full staging generator and
  replayed both pilots from their emitted sources:all51,984 row34 pairs,
  its three norm floors and11,425 cached residues; all552 row16 traces;
  both closure root equations and signed indexed destinations; and exact
  preservation of the declarations, five statement types and three original
  proof blocks. See `audit_next/backend_pilots_review.json` and its reproducer.

The remote run needs only small scripts/manifests, existing frozen original
Lean sources, and generic helper files. It does not need the large historical
JSON graphs or the21MB floor outputs. It regenerates closure roots from the
exact pinned Python routine, and floor data from frozen source coordinates
and current masks. Use a frozen original source directory: a directory of
already replaced `GraphData` aggregators will correctly fail the input hashes.

Portable invocation (replace these quoted paths with the actual locations):

```sh
python3 stage_pair_backends.py \
  --rows 16,34 \
  --input-dir "FROZEN_ORIGINAL_GRAPH_SOURCES" \
  --manifest-dir "CP7_INPUT_DIAGNOSTIC_SIEVE_MANIFESTS" \
  --sieve-dir "PROJECT_D1BOUND5_DIRECTORY" \
  --root-routine "generate_pair_closures.py" \
  --staging-helper "pair_staging.py" \
  --floor-generator "generate_floor_witnesses.py" \
  --floor-manifest "FROZEN_SPARSE_FLOOR_MANIFEST.json" \
  --helper-dir "PROJECT_D1BOUND5_DIRECTORY" \
  --source-pins "backend_source_pins.json" \
  --expected-manifest "PILOT_EXPECTED_MANIFEST.json" \
  --output-dir "NEW_STAGING_DIRECTORY"
```

For all47, use `--rows all` and `all47_dry/manifest.json` as the expected
manifest. Add `--dry-run` to write only the comparison report. All requested
rows and every expected source hash are verified before any Lean output is
written. The output directory must be separate from the accepted project.

Required small auxiliary inputs are the unmodified cp7 `pair_staging.py`,
`all48_input_fingerprints.json`, `all48_diagnostic_manifest.json`,
`cached_sieve_fingerprints.json`, the pinned `generate_pair_closures.py`, the
new `generate_floor_witnesses.py`, its `generated/manifest.json`, this staging
script, `backend_source_pins.json`, and the chosen expected staging manifest.
Generic proof source hashes are also checked; any later compiler repair must
be reviewed and reflected in the pin file before regeneration. Such a pin
update must not bypass the expected emitted-source comparison.

Compile the two pilots before broader intake. For row34 the color modules
can be checked independently of its closure module; all three supplied
nonreal norm floors are in the exact original color/tail order. No completed
main theorem or accepted-root change is claimed by this staging preparation.
