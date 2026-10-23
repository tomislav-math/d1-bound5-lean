# Incremental accepted-artifact checkpoints

Preparation only. This tool has not exported any real build. It does not run Lean, Git, a network transport, or extraction, and it does not modify the build, sources or runtime. It writes only a new snapshot directory or an exclusive arrival confirmation in the explicitly chosen durable destination. An accepted-module snapshot is recovery evidence; it is never a whole-build, theorem, audit or final-kernel acceptance claim.

`checkpoint_export.py` is standard-library Python 3.8+. Run the script directly with `python3 -B`; do not import it through a cached bytecode loader. The fixtures similarly execute the exact exporter source bytes with `compile`/`exec`, and check their hash before and after testing. Run `python3 -B test_checkpoint_export.py` for the synthetic fixtures. They never execute a compiler.

## Specification and original identity

Root must create and pin a new specification only after the recovery builder has created its original `ORIGIN.json`. `SPEC_TEMPLATE.json` is deliberately not runnable: fill its placeholders from the root-reviewed launch and original files. The new recovery build ID and identity are mandatory. Do not use an old build's origin, mutate the original origin, substitute locks, or reinterpret old artifacts under the new identity.

The specification pins original source/runtime-lock files, exact selected builder source, origin hash, source/build paths, and the new build and identity hashes. `extra_metadata` can pin additional immutable launch/source-origin/hints records by unique basename. Do not put the changing control file or current mutable SUMMARY in `extra_metadata`; such a file would deliberately fail the next batch's hash guard. The original immutable invocation START records are captured automatically for every selected module. No runtime binaries or external cache binaries are archived: the complete runtime lock and existing durable reproducibility records identify those separately.

All local roots, input paths and outputs must be canonical absolute paths without `..` or symlink ancestors. Resolve macOS temporary aliases before making fixture paths. The output must be disjoint from source, build, runtime inventory/search roots, runtime extra files, and all metadata/predecessor inputs. On the destination machine, original Linux path strings are preserved as foreign identities rather than resolved through macOS aliases.

## Prepare a bounded batch

After root explicitly authorizes the accepted pilot scope:

```text
python3 -B checkpoint_export.py prepare \
  --spec /absolute/reviewed/RECOVERY_CHECKPOINT_SPEC.json \
  --spec-sha256 ROOT_APPROVED_SPEC_HASH \
  --out /tmp/new-unique-checkpoint-batch-000001 \
  --max-modules 64 --max-bytes 536870912
```

The default batch limit is 50 modules; the allowed range is 1–100. `--max-bytes` caps the uncompressed original payload bytes, including metadata. `SNAPSHOT.json`, tar headers and compression framing add overhead, so this is not a strict archive-byte cap. An individual module exceeding the remaining cap is deferred; if no module fits, preparation fails rather than silently omitting part of its bundle. Root can choose a reviewed larger byte cap if necessary.

The tool takes a fixed snapshot of accepted-pointer names and visits them in the pinned topological order. It ignores active/unaccepted work and later arrivals. Each selected original pointer must name the precise immutable module/UUID receipt; receipts must be COMPILE_PASS/exit0 with matching build, source, command, identity, log and direct dependency hashes. Every original `.olean*` and `.ir*` bundle member listed in the receipt is copied byte-for-byte, along with the original source, accepted pointer, receipt and compiler log. Full origin, both locks, runner, specification, auxiliary source configuration and selected invocation START files appear in every batch. Sidecar membership, pointer bytes and every copied input are checked before/after copy and again after compression.

Only `batch.tar.gz` and `PREPARED.json` are transport candidates. A prepared snapshot explicitly says `PREPARED_NOT_DURABLE`. It is not enough to resume the full pilot-gated build.

## Root-owned transport and arrival

Transport is a separate root-reviewed operation. Copy the two files into a new Mac directory outside Git, for example `/Users/tp/Lean/D1Bound5ProofObjects/recovery-BUILD_ID/batch-000001`. Do not overwrite old files. Keep the exact local archive hash, archive byte count and prepared-sidecar hash from preparation independently pinned through the transport.

Run the exact reviewed exporter on the Mac:

```text
python3 -B /absolute/reviewed/checkpoint_export.py verify-arrival \
  --archive /absolute/durable/batch-000001/batch.tar.gz \
  --archive-sha256 ROOT_PINNED_ARCHIVE_HASH \
  --prepared /absolute/durable/batch-000001/PREPARED.json \
  --prepared-sha256 ROOT_PINNED_PREPARED_HASH \
  --destination /absolute/durable/batch-000001
```

The verifier checks the exact archive hash and length, rejects duplicate/escaping/nonregular tar members, checks the exact file set and every content hash without extracting, and independently checks original receipt/dependency identities. It rechecks the archive and sidecar after reading, fsyncs archive and sidecar, fsyncs the destination and full ancestor directory chain, and only then exclusively creates `DURABLE_BATCH.json`; the new directory entries are fsynced again. The caller is responsible for choosing the persistent Mac destination; the script cannot identify a storage service from a pathname.

Root must retain the original archive, prepared sidecar and confirmation. Copy the exact confirmed `DURABLE_BATCH.json` back to a new local metadata file and pin its hash. Later prepare and arrival commands both require `--previous PATH --previous-sha256 HASH`. Preparation refuses to advance from a merely prepared record, another specification, build, runner/runtime identity, or changed prior accepted pointer. The cumulative map and predecessor hash bind dependencies to prior durable batches. Do not remove or mutate any earlier batch: the newest confirmation is a chain reference, not a replacement for earlier artifact bytes.

## Recovery and limitations

Each batch contains complete original bytes for its selected accepted modules. Recovery must first inventory and independently reverify every retained batch, the predecessor chain, reviewed source/runner/runtime identities and the separately reproducible external runtime. Restore into an explicitly reviewed empty location with safe member handling; this tool intentionally does not extract or synthesize receipts. Same-identity resume requires the original absolute build/source/runtime layout and original origin. A different identity requires a new build and a new checkpoint chain.

The first 64-module pilot remains stopped/deferred until root verifies its actual remote batch and authorizes full resume. Checkpointing successful modules does not preserve failed or active attempts; those have a separate final diagnostic-export scope. It also does not replace the eventual terminal full-source build guard, exact-type/axiom audits, or official fresh kernel replay.

The first Mac fixture attempt was correctly rejected because the fixture used macOS's `/var` symlink alias. The fixture now resolves its temporary root; the exporter symlink guard was retained. Historical failed fixture log/report/source are preserved separately. Independent review then required canonical output confinement and full ancestor-directory fsync; both were implemented with focused regression fixtures before any real export.
