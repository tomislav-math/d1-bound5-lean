# Selected-mask scaling preparation

This is a new, optional generator. Existing generators, accepted sources, and
the original 48 graph inputs are unchanged. Python diagnostics are not proofs;
all new Lean certificate declarations still require `decide +kernel`.

`prepare_selected_rows.py` supports all 48 models and performs no Lean build or
installation. By default it verifies all rows, prepares only row47 source
bytes in memory, and writes a small manifest. An explicit `--emit` writes the
requested source set into a **new** directory. `--expected-manifest` requires
exact reproduction before any output. `--workspace` selects a portable input
bundle root; no machine-specific input paths are stored in the manifest.

The all-row dry run checked all 8,063,266 same-color unordered pairs, reproduced
all 48 independently frozen packed-code digests, and reproduced the existing
row34 selected words and floors by exact literal comparison. All 28,614 floor
witnesses retain their original target, order, and value. Every floor inequality
is also rechecked. Structural rows are included in diagnostics but cannot be
selected for new raw-certificate emission.

## Preserved inputs and endpoints

- Original coordinate lists and closure bounds are read from SHA-pinned Lean
  sources, not from a presumed graph edge list.
- Each color class retains the original vertex order and original color mask.
- Every actual full tail is traversed; its first rejecting mask is chosen in the
  original 25-mask order. An omitted high zero digit never omits a tail pair.
- Tags31 retain the exact negative-integer guard or next frozen floor witness.
- Literal cache records use the original coordinates and canonical signatures.
  Lean separately checks their exact original split-list coverage and all
  signatures, then checks independence and assembles the full certificate.
- The accepted raw checker differs from the selected checker only through a
  proved literal Boolean equality. No mask validity or field assumption is
  removed from the original downstream theorem.
- Before preparing a row, the generator reconstructs the reviewed expanded
  scaffold and compares every source hash to the frozen all47 manifest. Seed,
  indexed closure, filter, count, and original declarations are then retained
  byte-for-byte. All five original public theorem signatures remain exact.

## Measured input sizes and next pilots

These are counts, not predictions of Lean runtime.

| Row | Model (tau, nu) | Color sizes | Pairs | Floor witnesses | Integer guards |
|---|---|---:|---:|---:|---:|
| 47 | (1,6) | 195 / 194 | 37,636 | 0 | 0 |
| 2 | (0,1) | 207 / 207 | 42,642 | 0 | 0 |
| 9 | (0,1) | 219 / 219 | 47,742 | 1,340 | 0 |
| 34 | (1,2) | 229 / 228 | 51,984 | 3 | 0 |
| 26 | (1,1) | 761 / 761 | 578,360 | 0 | 0 |

First use the separate raw34 wrapper to measure the arithmetic change against
the accepted selected34 computation. Then row47 is the smallest new
nonstructural pilot and isolates generalization to a different model without
floor work. Row2 checks the tau0 basis with no fallbacks. Row9 is a small floor
stress case. No full 41-row source batch is needed before those measurements.

For the 41 nonstructural rows, the exact inventory is 7,447,008 unordered pairs,
7,403,150 selected-mask rejections, 15,244 integer guards, and 28,614 floors.
The packed words occupy about 11.2 MB as decimal digits across all rows. A
per-row manifest/compilation schedule limits data intake and catches failures
before a full batch is prepared. The seven structural rows retain the existing
linear trace-zero backend.

The row47 pilot uses nine modules to separate data, closure, arithmetic, and the
two color computations. Once its source and kernel checks pass, whole namespace
bodies can be bundled using the already reviewed compact-staging approach,
without changing predicate arguments. For large rows, use full-tail chunks only
if actual measurements show a memory or deadline problem. The existing selected
chunk factorization preserves cross-boundary pairs; a raw-prefix analogue would
need its own kernel acceptance before use.

## Commands

```sh
python pair_selected_scale_next/prepare_selected_rows.py \
  --rows all --stage-rows 47 --output-dir pair_selected_scale_next/dry_inventory
```

After independent generator review, reproduce the exact manifest into a new
source directory with `--emit --expected-manifest ...`. The script refuses to
overwrite an existing output directory. Root remains the sole remote writer
and compiler.
