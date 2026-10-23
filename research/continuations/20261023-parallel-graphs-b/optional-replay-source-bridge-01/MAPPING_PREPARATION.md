# Preparing a real relocation mapping after the gates

This is a recipe, not an executed relocation or an acceptance receipt. The full recovery build and its current exact 118 and broad audit results are prerequisites. No old successful run may substitute for the current build identity. Keep original e04 and all original logs/receipts/freezes unchanged.

1. Stop all source, artifact, runtime, and Git writers through the parent coordinator. Obtain the terminal complete build summary for the current unchanged ORIGIN/build ID. Confirm the exact audit summary is `CLEAN_SOURCE_BUILD_EXACT_TYPE_AXIOM_AUDITS_PASS` with 114+4 markers and the separate broad summary is `CLEAN_BROAD_COMPATIBILITY_AUDIT_PASS`, both tied to the same current build and artifact snapshot. Do not fill pending records with placeholders.
2. Select an existing standalone retained clone under `/tmp`. Independently verify the exact b4c81242dd9c9cee6966a1e08bce0f94c66f1491 commit and ee490da49ba30447d92745140f48c1ae3c34f263 tree, all 4,411 selected regular files and source lock b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c. The helper also performs these checks. A linked worktree, Git alternates, partial/shallow/promisor clone, symlink, external configuration include, or copied proof artifact is unsuitable. Do not change the original compile root or use a symlink to simulate it.
3. Make a new retained metadata directory under `/tmp` outside the clone, build, runtime and audit output directories. Copy each necessary historical metadata file byte-for-byte into a previously absent filename; verify its SHA against the corresponding historical record. Never overwrite a differing file. Do not copy proof artifacts or rewrite JSON embedded paths. Preserving an already retained `/tmp` file at its unchanged path is also allowed; its mapping is explicit and its bytes are pinned.
4. Define the nine role records below. Values in `records` are the original historical absolute filenames. Each role must have a `retained_files` row mapping that old filename to the actual retained filename and reviewed SHA. If one file is used in several evidence snapshots, its one mapping row is reused. Different historical files must not map to the same destination.

| Role | Historical record |
| --- | --- |
| exact_summary | Current exact audit SUMMARY.json |
| exact_input_freeze | Current exact audit INPUT_FREEZE.json |
| integration_log | That audit's FinalIntegrationAudit.log |
| target_log | That audit's FinalTargetAudit.log |
| broad_summary | Current separate broad audit SUMMARY.json |
| broad_evidence_freeze | That audit's EVIDENCE_FREEZE.json |
| broad_log | That audit's Audit.log |
| source_policy_report | Reviewed SOURCE_POLICY_REPORT.json, SHA46b5b3cd… |
| source_policy_manifest | Reviewed SOURCE_MANIFEST.json, SHAfa843862… |

5. Inspect every `files` entry in the unchanged exact INPUT_FREEZE and broad EVIDENCE_FREEZE. Entries below the original compile source root map automatically to the same relative file in the retained clone; do not add mapping rows for those. Entries belonging to the original unchanged build/runtime can retain their original paths only when they are also current core frozen pins. For every other old helper, builder, invocation, source/runtime lock, or evidence path, add a retained row with its historical expected hash. Even if a historical path is currently readable, do not leave a live dependency on the volatile workspace. All live freeze inputs must be under `/tmp`. Every explicit mapping row must be used; the helper rejects extras and destination collisions.
6. Construct a new manifest using the precise fields below. Hashes are computed from actual finalized files, not copied from a pending plan. The source inventory is the full canonical `source_closure`/`dependencies` JSON used by the final checker; the source-policy manifest is a separate role with its own exact shape. Keep their paths/hashes distinct. Original build provenance is read from the unchanged current ORIGIN; original source root is taken literally from its `identity.source_root`.

```python
# Recipe fragment only; ROOT/BUILD/LOCKS/INVENTORY/ROLES/MAPPINGS are explicit,
# separately reviewed paths and dictionaries prepared above. No default inputs.
origin = read(BUILD / 'ORIGIN.json')
data = {
    'schema': 1, 'kind': 'D1BOUND5_REPLAY_SOURCE_RELOCATION',
    'original_compile_root': origin['identity']['source_root'],
    'replay_source_root': str(RETAINED_SOURCE),
    'artifact_root': str(BUILD / 'artifacts'),
    'distribution_root': str(ROOT),
    'candidate_commit': 'b4c81242dd9c9cee6966a1e08bce0f94c66f1491',
    'candidate_tree': 'ee490da49ba30447d92745140f48c1ae3c34f263',
    'source_lock_sha256': sha(SOURCE_LOCK),
    'runtime_lock_sha256': sha(RUNTIME_LOCK),
    'source_inventory_sha256': sha(INVENTORY),
    'build_origin_sha256': sha(BUILD / 'ORIGIN.json'),
    'build_summary_sha256': sha(BUILD / 'SUMMARY.json'),
    'build_id': origin['build_id'],
    'build_identity_hash': origin['identity_hash'],
    'records': ROLES,
    'retained_files': MAPPINGS,
}
# MAPPINGS[original_absolute_path] = {'path': retained_absolute_path,
#                                   'sha256': historical_expected_sha256}
# Write to a new manifest filename; independently review exact bytes and SHA.
```

7. Independently review the completed manifest and selected helper SHA. Put the helper, full canonical inventory, source/runtime locks, reviewed lean environment JSON and manifest under retained `/tmp` paths. Only then may the parent choose a freeze-only command. The existing resource settings remain unchanged:

```sh
python3 RETAINED_HELPER freeze \
  --offload-root RETAINED_RUNTIME \
  --project-root RETAINED_SOURCE \
  --project-build-root UNCHANGED_BUILD/artifacts \
  --lean-env RETAINED_CLEAN_ENV.json \
  --source-lock RETAINED_SOURCE_LOCK.json \
  --runtime-lock RETAINED_RUNTIME_LOCK.json \
  --manifest RETAINED_CANONICAL_INVENTORY.json \
  --target D1Bound5 \
  --source-relocation-manifest REVIEWED_RELOCATION.json \
  --source-relocation-sha256 REVIEWED_RELOCATION_SHA256 \
  --freeze NEW_RELOCATION_FREEZE.json
```

8. Review the resulting schema-4 freeze: original compile root and unchanged receipt/argv identities remain historical; actual `cwd` and live source pins refer to the retained clone; all live pins are under `/tmp`; the original current build and both audit identities match. A successful freeze is only input validation. Preserve the exact manifest/helper/freeze plus original evidence durably before any chosen execution. No automatic launch follows.
9. The parent may separately select `run --mode fresh --target D1Bound5 --freeze NEW_RELOCATION_FREEZE.json --output NEW_OUTPUT --execute` with the reviewed 32 GiB virtual, 6 GiB sampled RSS, 1 GiB reserve and timeout parameters. Do not repeat relocation flags on run; their immutable context is already in the freeze. Do not run e04 or another helper concurrently: helper-local lockfiles are not a cross-version mutex. The output must still obtain actual official full-root `--fresh` exit 0, exact banner, no OOM delta and all post-input guards before a fresh replay PASS is claimed.

If any source, metadata, accepted pointer/receipt/log, artifact, runtime, Git or mapping check fails, preserve that failure and stop. Do not alter historical evidence to make the bridge agree, and do not silently select another candidate/build. An interrupted or refused optional bridge leaves the original separate gates and their statuses unchanged.
