# Portable input bundle

This is an optional file copier for the already frozen `ec862156` selected-row
generator. It does not run the generator, Lean, Lake, Git, or a network client.
The parent agent alone runs it on the Mac.

`input_requirements.json` was prepared locally by parsing the generator's
literal `PINS` with `ast.literal_eval`, then reading the pinned backend source
map, original-source fingerprints, sieve fingerprints, floor-row manifest,
and `pair_staging.py`'s literal `ROUTINE_SHA`. Every listed file's local bytes
were checked against its existing expected SHA256. The generator itself is
also included, so its separately transferred small file can be copied to the
bundle. No generator was executed to discover requirements.

The bundle contains 134 files, totaling 48,660,960 bytes. Historical closure
and graph JSON are intentionally absent: `configure(source_only=True)` does
not read them. Floor Lean declarations are reconstructed and compared by
hash, not read. The optional external `--expected-manifest` argument should
point to the separately transferred reviewed manifest.

The requirements SHA256 is:

```
5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb
```

After transferring the small materializer, requirements JSON, and frozen
generator somewhere inside the continuation directory, first run this
read-only inventory (adjust the two small transferred file paths if needed):

```sh
python3 -B materialize_inputs.py \
  --requirements input_requirements.json \
  --requirements-sha256 5a15034bf8bad9a11647231e683f1006f5b4512c3f715a21269555273b6a85fb \
  --search-root /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation \
  --search-root /Users/tp/Lean/D1Bound5/D1Bound5 \
  --destination /Users/tp/Lean/D1Bound5/research/continuations/20261018T010800CEST-main-continuation/selected-scale-inputs
```

Add `--apply` to the same command only after the inventory is complete. It
repeats the inventory and then rereads and hashes every selected source before
creating anything. Missing inputs produce a complete missing-path/hash report
and exit status 2 without writes. Any preexisting destination, even an empty
directory or a symlink, is rejected. The destination's parent must already
exist. Never create the destination beforehand.

Candidate files must have the required basename, size, and SHA256. Historical
same-name versions are ignored when their hashes differ; multiple exact copies
are interchangeable and the selected source is recorded. All destination
paths are canonical relative paths, with duplicate and file/directory conflicts
rejected. Directory traversal and reads use no-follow descriptors, rejecting
symlink ancestors and nonregular files. Writes use exclusive creation only
within the new bundle. On an I/O failure during writing, the new bundle may be
partial and should be inspected; no existing path is overwritten or deleted.

`materialization_manifest.json` inside the new bundle records every chosen
source and expected hash. The entry point is then:

```
selected-scale-inputs/pair_selected_scale_next/prepare_selected_rows.py
```

Pass `--workspace .../selected-scale-inputs` and the reviewed generator's
other arguments. The materializer never starts this next step.

Local verification: ten dummy tests passed, covering exact copying, missing
inputs, wrong hashes, duplicate exact source copies, symlink files and
ancestors, post-inventory source changes, existing destinations, traversal,
conflicting requirements, and same basename with distinct pinned contents.
Read-only inventory of the actual local workspace found all 134 inputs with
zero missing files or rejected candidates. No Mac execution was performed.
