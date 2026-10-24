# Status

The Lean formalization is complete. The theorem
`D1Bound5.main_statement : D1Bound5.MainStatement` proves that every finite
Diophantine $D(1)$ set of nonzero elements in the **full ring of integers** of
an imaginary quadratic field has cardinality at most five. This includes
integral bases with a half-integral element. Pair-square roots may be zero.

The [main theorem on Prove2Me](https://prove2.me/theorems/4bb5d407-713b-46ac-967d-97d7abf88598)
has status **Proved**.

The completed local verification comprises:

- A build of all 4,406 project modules from initially empty project outputs.
- 114 integration checks and four independent target checks of exact types and transitive axioms.
- A broad audit of 29,145 declarations, or 29,602 including private declarations.
- A successful fresh replay of the complete `D1Bound5` root through the installed Lean kernel.

The transitive axioms of the main theorem are `propext`, `Classical.choice`,
and `Quot.sound`. The audits found no `sorryAx`.

- [Local verification evidence](research/continuations/20261023-parallel-offload/evidence/final-kernel-plan/FINAL_CLOSEOUT_AUDIT.json)
- [Prove2Me completion record](research/continuations/20261024-prove2me-main-statement-proved/README.md)
- [Verification instructions](scripts/verification/README.md)
- [Documentation update and source comparison](records/documentation-update/README.md)
- [Development history](HISTORY.md)

Historical records describe the source snapshots and runs identified in those
records. The documentation update records the subsequent comment-only source
change and refreshed manifests.
