# Final installation plan — prepared only

No canonical installation, preservation, Git mutation or proof verification was performed for this plan. Final source build, 118 exact checks, the separate broad audit and official fresh full-root replay must pass before the coordinator executes installation. Keep other source/Git writers excluded throughout preservation and installation.

The current checkpoint is HEAD `1fe0adf1028af0e41ea578660c8d48875cde6588`, branch `main`, empty staged diff and 107 tracked production sources. SHA256 of the exact output bytes of `git ls-files --stage -z` is `4964eff33829ea307976c7b13c7ea8ffa54370b43e9c8c8fbc54569919914999`. This is not the hash of `.git/index`. Refresh and review the checkpoint if HEAD or index changes before preservation; never rewrite the frozen historical plan.

## Exact inputs

```sh
D1_REPO=/Users/tp/Lean/D1Bound5
D1_PY=/Users/tp/.local/bin/python3.12
D1_B="$D1_REPO/research/continuations/20261023-parallel-graphs-b"
D1_EXEC="$D1_B/canonical-cleanup-executor-01/preserve_sources.py"
D1_INVENTORY="$D1_B/canonical-cleanup-inventory-01"
D1_V2="$D1_B/repository-verification-proposal-v2"
D1_FINAL="$D1_B/final-installation-plan-01"
D1_SESSION="$D1_REPO/research/continuations/20261023-final-source-preservation/session-001"
D1_WORK=/Users/tp/Lean/D1Bound5-final-install-work-20261023
D1_HEAD=1fe0adf1028af0e41ea578660c8d48875cde6588
D1_INDEX_SHA=4964eff33829ea307976c7b13c7ea8ffa54370b43e9c8c8fbc54569919914999
```

The work directory is outside the checkout. Use a new directory if the example already exists. `FINAL_INSTALL_MAP.json` is the explicit 25-target installation list, with exact before/after hashes and payload locations. No recursive directory copy is authorized by this plan; caches, transports, old compiler artifacts and unrelated research are excluded.

| Input | Exact identity |
|---|---|
| Preservation executor | `39e139cf55c34506a7ee0ea592d4e0bf89258bec1d2b0c1e1765dbfa7b1dc455` |
| Preservation plan | `8d8412630d8f8b724599b89bd3ebfc7d4446d99de432ba40001e4c9d5df85b40` |
| Original inventory manifest | `c68e3d02eea98c09a5b878a2fa64d5ff1ebade34551e72464742d1e15feb207f` |
| Frozen V2 package manifest | `e1cc35542d5b26939686ba98eb3bc7c4d075aadb7997a970f8c3ef3ceb62121d` |
| Explicit final installation map | `4708cf7a98e3b8c3de56c747a486524a7f912d015d06a737e6a40c21343dccfd` |

## Ordered execution after the gates

1. **Preserve the 353 extras first.** Check the executor/package identities and current HEAD/index. Run the read-only preflight below, inspect its PASS, then run the same invocation with action `preserve` and `--execute`. The executor checks all 4,759 original source fingerprints, the 107 tracked source maps, three configuration pins and Git policy. It moves only the 353 reviewed untracked sources to the fixed research archive. Require its final `PRESERVATION_ONLY_PASS`, moved/planned count 353 and unchanged Git identity. Decide any rollback now: its original rollback intentionally refuses after a guarded source/configuration/policy/executor/HEAD/index identity changes. Ordinary tool-file content alone is not an executor guard; the next phase changes the umbrella and therefore breaks the original source inventory. On interruption use the original session and the reviewed resume/rollback procedure; do not invent a new initial state.

```sh
"$D1_PY" "$D1_EXEC" preflight \
  --plan "$D1_INVENTORY/PREPARED_RELOCATION_PLAN.json" \
  --inventory-dir "$D1_INVENTORY" --reviewed-head "$D1_HEAD" \
  --reviewed-index-sha256 "$D1_INDEX_SHA" --session "$D1_SESSION"
```

The corresponding mutation command is exactly the same arguments with `preserve` replacing `preflight`, plus `--execute`. No executor invocation has been performed by this preparation.

2. **Install the exact umbrella.** Require current root SHA `33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2`. The prepared `D1Bound5.lean` retains every existing import and appends exactly `\nimport D1Bound5.MainTheorem\n`; its SHA is `a45a579195a0e787c3e1986e2e0ee671ca64fa82aa030d0c68908c1f61f5982d`. `UMBRELLA.diff` is the exact reviewed edit. Do not replace the umbrella with a MainTheorem-only root or change any other production source, including comments. The other 4,405 selected namespace files must remain byte-identical to the tested candidate.

3. **Install the explicit tool/history payloads.** Recheck every `before_sha256` in `FINAL_INSTALL_MAP.json`; null means the target must be absent, not permission to overwrite an unknown file. Install only its phase-3 rows: 18 `scripts/` files and four historical `records/` files. Payloads come from the frozen V2 package except the reconciled `scripts/verification/README.md` in this package. Preserve the existing Git policy and other 55 historical tool identities. `INSTALL_COPY_COMMANDS.txt` gives exact copies in phase order; it is a reviewed recipe, not an executed script. Existing target file modes should remain unchanged; new files are ordinary text files. The plain copy recipe is not atomic or self-guarding. Stop immediately after any failed/interrupted copy, classify each affected target against its recorded before/after hashes, and treat bytes matching neither as incomplete. Restore or resume only through a separately reviewed operation using the immutable payload or original Git bytes. Do not rerun preservation after the umbrella changes. This clarifies the earlier executor README's broad shorthand about tool changes; the exact executor guards are those listed in step 1.

4. **Install the two final manifests last.** The proof-source manifest remains exactly V2 SHA `af5813a4364be84328e0e67bc940f8388c6539b435eb180b7a1fa66857bbe80b` (4,406 production paths). The reconciled tools manifest is SHA `e03b9e0d129b7f3de828d978dcea444c3c42cf2e784d2a8b67d0705a0e264761` (75 paths). Its sole change from frozen V2 is the README hash, now `b7933056724c55d48f896c6b5c743ddd4efe9cb86612c32138b067cee0e88008`. `release_pins.json` stays unchanged; it lists required tools and configuration pins, while the tools manifest fingerprints the README bytes. The three configuration files remain covered in the tools manifest and release pins; they are intentionally no longer mixed into the production-only proof manifest. Historical manifests remain unchanged.

5. **Reconcile the installed source snapshot read-only.** Run the source-policy entrypoint and regenerate the path-independent source lock outside the checkout. Require exact status `SOURCE_POLICY_PASS_SOURCE_ONLY`, its 4,406-path manifest SHA `fa84386224dedc9b6a9a4fa76679b7bdaf1250cf1927e0ae59c170bc4eee9550`, and source-lock SHA `b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c`. A module count alone is insufficient. Verify every row in both installed SHA manifests, all 25 installation results and the three unchanged configuration pins.

```sh
"$D1_PY" "$D1_REPO/scripts/source_audit.py" \
  --project "$D1_REPO" --out "$D1_WORK/source-policy"
"$D1_PY" "$D1_REPO/scripts/fresh_project_build.py" prepare-source-lock \
  --source-root "$D1_REPO" --roots D1Bound5 \
  --out "$D1_WORK/source-lock.json"
```

The standard manifest preparer may independently regenerate the two proposals in an empty external directory, using the newly generated and reviewed source lock:

```sh
"$D1_PY" "$D1_REPO/scripts/verification/prepare_manifests.py" \
  --project "$D1_REPO" --source-lock "$D1_WORK/source-lock.json" \
  --source-lock-sha256 b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c \
  --prior-tools-manifest "$D1_REPO/records/verification-history/20261023/verification-tools.before.sha256.txt" \
  --updated-tool scripts/Audit.lean --updated-tool scripts/check.sh \
  --updated-tool scripts/source_audit.py --out "$D1_WORK/manifest-recheck"
```

Its outputs must equal the installed manifests exactly. This is fingerprint preparation, never new proof evidence.

6. **Write current documentation and the evidence mapping from actual receipts.** The top-level README/STATUS template is in `research/continuations/20261023-parallel-graph39/review-supplement-20261023/release-docs-proposal/`. Recheck its original-file hashes; retain the historical STATUS entries. Fill each source-policy/build/118-check/broad/fresh row only from its actual successful receipt and log hashes. Broad compatibility is separately required here even though the portable wrapper reports it as optional/not run. The production theorem is a uniform upper bound of five; do not claim a five-element example exists in every field. No further production-code edits are needed for status wording.

The identity bridge must explicitly relate the final 4,406 relative paths/hashes and three configuration pins to the tested local candidate commit `102905a54f1b4db67ed81dd9d2c01d4eb6fd97c2`. Preserve the candidate's actual runtime lock, build origin, receipt identities, source root, commit/tree and audit freeze as historical run identities. Equality of released sources does not relabel those receipts as a new run or prove the packaged `check.sh` was executed end-to-end. A later clone derives its own commit/tree, regenerates locks/runtime paths and starts an empty project build; resume applies only to the same frozen identity. The reconciled reproduction README already states this without a time-sensitive pending/completed build claim.

7. **Use existing private Git policy, with an explicit staged set.** Root owns these operations. Run the unchanged working-tree preflight only after the final manifests agree. Prepare an exact path list containing the selected production files, intended tools/history/manifests/docs, the preserved research sources and reviewed evidence; exclude transports, `.lake`, proof objects and unrelated work. Stage that list only, review the staged diff and run the unchanged exact-index helper. Each Git mutation remains a separate plain tool call; do not use `git add -A`. Verify staged and post-commit blobs against the final source/pin/tool maps, then non-forced push only to the existing private repository and verify remote HEAD plus PRIVATE visibility.

```sh
"$D1_PY" "$D1_REPO/scripts/git_sync_preflight.py"
"$D1_PY" "$D1_REPO/scripts/git_sync_index_review.py"
```

These are the read-only helper invocations; staging goes between them after successful preflight and explicit review. A final commit cannot embed its own future hash: record staged-source identity first, then the actual commit/tree/push receipt separately as permitted by policy.

## Ready before the proof gates finish

The exact 25-target map, root payload/patch, README reconciliation, derived tools manifest, preserved historical sources, executor with 55 passing fixtures and independent reviews, and top-level documentation template are ready for review. Hash checks, source/evidence export planning and the explicit publication path list can be prepared read-only. Final proof success fields, canonical preservation/installation, final source-policy reconciliation and all Git mutations remain unexecuted pending the coordinator's gates.
