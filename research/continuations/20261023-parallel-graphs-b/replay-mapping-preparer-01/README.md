# Fixed recovery mapping preparer — research only

`prepare_replay_mapping.py` prepares an **unaccepted** manifest for the separately reviewed optional bridge829d6a30. It does not select that bridge, invoke Lean, create a freeze, launch a checker, mutate Git, or claim proof acceptance. The current full4,406-source build and exact118/broad audit outputs must already be terminal accepted for the fixed original build identity. No actual preparation invocation against those gates has been performed by this package.

The script fixes the original build/ORIGIN/source/runtime/candidate identities and the exact reviewed revision02 configuration/invocation hashes. Inputs retain their embedded historical paths. Source files are checked through the standalone retained4,411-file Git clone; the historical compile path remains unchanged in every original record and command. If an original workspace metadata file is absent, an exact byte copy under the already restored authoritative `/tmp` workspace may supply its bytes. A present mismatching original is refused rather than silently replaced.

Only three file-location arguments vary: the exact pinned829d helper and the two exact pinned source-policy records. The output must be a new canonical directory under `/tmp`, disjoint from the build/runtime/source/evidence roots and selected inputs. The helper is loaded directly from its SHA-verified source bytes; cached Python bytecode is not consulted. Main acquires a nonblocking shared lock on the original build lock, preventing concurrent cooperative builder writes.

Before writing, the preparer verifies terminal full-build scope and identity, current exact audit status/log hashes/114+4markers/original commands/input snapshot, current separate broad status/log hashes/actual public/private/target markers/original command/exact-audit binding, fixed metadata pins, and the retained clone's actual Git/blob identity. It copies the required historical metadata/helpers/locks and supporting configuration/inventory/environment bytes into the new directory. Old source paths map automatically to unchanged files in the retained clone; build artifacts/runtime remain at their original roots and are never copied.

This is intentionally **not** a second full artifact/runtime/accepted-receipt verifier. Those extensive guards belong to the mandatory later829d bridge freeze. `PREPARATION_RECEIPT.json` records that distinction explicitly. Successful metadata preparation cannot substitute for parent review of the exact manifest hash and the bridge's full validation.

Each new file uses exclusive creation and no-follow flags, with exact byte/hash checks and fsync of its file and parent directory. Input device/inode/size/timestamp/hash identities are rechecked after copying. New directories and their parent entries are fsynced. The original JSON bytes are never rewritten. Existing destinations are refused, and there is no resume, overwrite, cleanup or rollback operation. An interruption/failure preserves partial output and an attempted `FAILED_PREPARATION.json` record; the next attempt needs a separately selected new directory. A failed directory is not a completed mapping even if a manifest was written before a later failure.

The coordinator must exclude other writers to source, metadata and outputs; path-based operations do not claim protection against hostile concurrent directory-renaming attacks or hardware/filesystem durability failures. Output files are written with mode0444, but no operating-system immutable flag is imposed. Their continued identity is checked by the subsequent bridge and frozen hashes.

After the actual build/exact/broad gates, the parent may run a read-only inspection first (omit `--prepare`). It hashes metadata and inspects the retained Git clone but writes nothing:

```sh
python3 prepare_replay_mapping.py \
  --bridge-helper /tmp/d1bound5-optional-replay-source-bridge-20261023/final_kernel_bridge.py \
  --source-policy-report EXACT_RETAINED_POLICY_REPORT.json \
  --source-policy-manifest EXACT_RETAINED_POLICY_MANIFEST.json \
  --output /tmp/NEW_REVIEWED_RELOCATION_DIRECTORY
```

The two policy inputs must respectively have SHA46b5b3cdc7a4228a53a05b7e62cb0e549ad212b67282fbd2c0fa4cce97ac8b9b and SHAfa84386224dedc9b6a9a4fa76679b7bdaf1250cf1927e0ae59c170bc4eee9550. Copying these immutable source-only records ahead of time is independent of the pending proof gates. They remain source-only evidence.

A separately selected invocation with `--prepare` writes the new directory. `RELOCATION_MANIFEST.json` contains exact schema1 fields accepted by829d; `retained/` stores historical metadata copies; `support/` stores any additional reviewed helper/config/environment/inventory inputs. The receipt records actual read paths, historical path keys, source/copy hashes, directory-independent Git identity, and exact supporting paths. The emitted manifest SHA is **not self-authorizing**. Root must review it and the receipt, preserve the package durably, then separately choose any `freeze` command using829d and the recorded support paths. No command is automatically executed after preparation.

Synthetic tests patch production constants only inside their imported test module and use temporary fixtures. There is no fixture bypass in the CLI. All real-gate execution, final full-integrity validation, bridge selection and official fresh replay remain outside this preparation task.

Two inventory hashes have different meanings. The bridge manifest's `source_inventory_sha256` is the SHA256 of the final checker's canonical source/dependency inventory JSON, fixed to `fb9926544ba00591531c865e474c0ddeed92fcf67a7efc4f25e98814b7946931`. The root's earlier read-only4411-file clone review used the label `source_inventory_sha256` for a canonical-JSON relative-file-map digest beginning `a211341…`; that historical review remains unchanged. The preparer receipt explicitly names the two roles separately. Never put the clone-map digest into the bridge manifest's source-inventory-file field.
