# Reproduce the missing floor-row JSONs

`regenerate_missing_floors.py` recreates only the 48 frozen `rowNN.json`
inputs, using the existing pinned `generate_floor_witnesses.py` helper. It
does not change that helper or its original manifest. Local dry execution
reproduced all 48 byte counts and SHA256 values exactly: 13,161,503 bytes.

Transfer this small script beside the already transferred
`materialize_inputs.py` and `input_requirements.json`. The script hard-pins
their existing hashes. Its default mode computes and checks without writing.
The parent alone may run the following on the Mac, adding `--apply` when
ready to create the new directory:

```sh
python3 -B /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation/selected-scale-preparation/pair_selected_scale_next/regenerate_missing_floors.py \
  --search-root /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation \
  --search-root /Users/tp/Lean/D1Bound5/D1Bound5 \
  --output /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation/regenerated-selected-floor-rows \
  --apply
```

The destination must not exist. All 48 exact outputs must match both the
original manifest and the static requirements before the directory is
created. All writes are exclusive and confined to the new directory. The
new `regeneration_manifest.json` records source provenance and output hashes;
the original `manifest.json` is never written. On an I/O failure during
writing, the new directory may be partial; no old file is overwritten.

The helper executes only the exact pinned module bytes and does not call
their `main()` functions or create local-module bytecode caches. Parser
inputs are freshly verified immutable bytes, so existing source paths are
never passed through an unguarded later parser read.

After successful regeneration, rerun the original materializer against the
same two search roots. Its basename-and-hash inventory finds the new floor
JSONs anywhere beneath the continuation directory and can assemble all 134
inputs at their required relative paths. This script never starts the
materializer's copying stage or the selected-row generator.
