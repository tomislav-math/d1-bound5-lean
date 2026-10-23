# Verified source and evidence identity

The completed Linux verification tested recovery commit `b4c81242dd9c9cee6966a1e08bce0f94c66f1491`, tree `ee490da49ba30447d92745140f48c1ae3c34f263`. All **4,406 Lean source files** in this checkout match the archived source inventory byte for byte. The recovery candidate contains 4,411 tracked blobs; its verification source closure contains 4,406 Lean modules.

[Recovery origin](../research/continuations/20261023-parallel-integration/recovery-preparation-reviewed-20261023/RECOVERY_SOURCE_ORIGIN.json) · [Git-blob verification](../research/continuations/20261023-parallel-integration/recovery-preparation-reviewed-20261023/RECOVERY_GIT_BLOB_VERIFICATION.json) · [Source inventory](../research/continuations/20261023-parallel-integration/recovery-final-kernel-preparation-20261023/CANONICAL_SOURCE_INVENTORY.json)

| Completed gate | Recorded result | Evidence |
|---|---|---|
| Fresh project build | 4,406/4,406 modules; 104 compiled in the final invocation and 4,302 validated from earlier invocations; no failed/active modules | [Build summary](../research/continuations/20261023-final-verification-2225/clean-build/SUMMARY.json) |
| Exact type and axiom audits | 114 integration checks + 4 target checks; both processes exited 0 | [Exact-audit summary](../research/continuations/20261023-final-verification-2225/evidence/clean118/SUMMARY.json) |
| Broad declaration audit | 29,145 exported declarations; 29,602 including private declarations | [Broad-audit summary](../research/continuations/20261023-final-verification-2225/evidence/broad/SUMMARY.json) |
| Official fresh kernel replay | `leanchecker --verbose --fresh D1Bound5`; exit 0; 10,446.674 seconds; frozen inputs validated after replay | [Replay result](../research/continuations/20261023-parallel-offload/evidence/final-kernel-plan/run/RESULT.json) |
| Final closeout | `D1Bound5.main_statement` has the intended full-ring statement and only `propext`, `Classical.choice`, `Quot.sound` as transitive axioms | [Final closeout](../research/continuations/20261023-parallel-offload/evidence/final-kernel-plan/FINAL_CLOSEOUT_AUDIT.json) |

The stages share build ID `2c06f4e3f2014ea78ba92a0b48e5ad92` and identity hash `8f423712a4950a66821d8a82716de9c6e9cbc83ad175d3d54ff8ddf1d47eda39`. [The final freeze](../research/continuations/20261023-final-verification-2225/evidence/final-kernel/RECOVERY_FREEZE.json) pins 82,466 inputs, including 34,293 artifact hashes. [The persistence receipt](../research/continuations/20261023-parallel-offload/evidence/final-kernel-plan/run/PERSISTENCE_VERIFIED.json) records the exact saved replay result, raw log and memory observations. Earlier audit summaries retain their historical pending-final-gate fields; the later replay and closeout establish completion.

This bridge records the completed checks and a new source/evidence hash comparison. It makes no claim that the packaged `scripts/check.sh` route was executed for this closeout. The compact evidence set omits caches, compiled binaries, transport duplicates and individual historical build receipts. Their hashes remain in the freezes; raw Linux receipts would be required to repeat the historical provenance audit independently.

[Machine-readable bridge](FINAL_IDENTITY_BRIDGE.json) · [Preserved-file manifest](../research/continuations/20261023-github-closeout/FILES_TO_PRESERVE.json)
