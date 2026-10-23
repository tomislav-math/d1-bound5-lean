# Historical artifact import

The Mac continuation Driver's existing acceptance ledger was consulted read-only. Candidate selection required matching the complete current local source closure, the historical closure fingerprint, and every original Mac artifact hash. The union of all candidate project dependencies was independently checked against the same ledger. No acceptance was inferred from artifact presence or timestamps.

The main export contains 2145 historically accepted modules, covering 2284 accepted dependency modules, with 3,173,844,120 bytes of Lean artifacts. The xz package is 575,714,908 bytes. Its SHA256 is `0f71d22ef94e9e7c4a4159cb54082e30d340d2063d299655a7353ca5af17f67a`; the exact embedded export manifest SHA256 is `e0eeab9e330e0bdadcb0ed4667e65441a68cd358959683c306fab053b15f069b`.

All current project sources use the legacy module format (no `module` header). Their logical constants are in the main `.olean`; build/ir C/object outputs are not proof-import inputs. The full original artifact manifests are retained as provenance. Mathlib/Lean's optional private/server/IR parts remain part of the final kernel input freeze.

`import_historical.py` has separate stage, install, and finalize actions. Staging checks the complete archive and every selected artifact hash, and rejects traversal/non-regular archive entries. Installation refuses existing files and active reservations; it checks exact source closures and original acceptance records. The base `.olean` is published last. Installed files are hardlinks to the verified staging copies, so these staging copies are not an independent immutable backup; the compressed package and original Mac files remain the recovery sources.

Finalization records current complete source/dependency/part/external-import hashes, exact original Mac acceptance, pinned toolchain/mathlib versions, and an export-manifest reference. Dependency existence alone does not confer acceptance: integration's provenance registry must independently validate each dependency's receipt. A process-local SHA256 cache is refreshed whenever device, inode, size, mtime, or ctime changes, with a before/after metadata guard around hashing.

The receipt status is `IMPORTED_HISTORICAL_ACCEPTANCE`. It is not a Linux recompilation or a fresh kernel replay. The final clean source build, original-type/allowed-axiom checks, and fresh integrated canonical-root kernel gate remain separate requirements. Transport checks and small importer tests do not constitute proof validation.

The ten-module canonical-root supplement uses the same format and guards. Seven have already been rebuilt locally and must not be overwritten; any supplement installation must select only the still-absent modules after reservation coordination.

Durable provenance lives under the existing private project's `research/continuations/20261023-parallel-offload/evidence/historical-transfer/`. Oversized original JSON manifests are preserved as ordered text parts, each below 4 MiB, with exact reconstruction hashes. Compressed/base64/compiled binary transport files are scratch and are excluded from Git evidence.
