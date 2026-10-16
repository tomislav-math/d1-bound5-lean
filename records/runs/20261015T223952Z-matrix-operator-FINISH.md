# FINISH — 4×4 normalized spectral perturbation bound

Observed start: 2026-10-15 22:39:52 UTC. Observed completion checkpoint: 2026-10-15 22:50:02 UTC (2026-10-16 00:50:02 CEST).
Outcome: COMPLETED_UNIT (the full bound-five theorem remains UNRESOLVED).

## Completed proof unit

Integrated the two previously developed modules `D1Bound5/MatrixOperatorNorm.lean` and `D1Bound5/RootMatrixOperatorBound.lean` into `D1Bound5.lean` and completed their actual validation. `four_zero_diagonal_operator_norm_lt` establishes `‖E‖ < 3*δ` for every complex 4×4 zero-diagonal matrix with `‖E i j‖ < δ` off the diagonal and `δ > 0`. Three perfect matchings partition all 12 ordered off-diagonal entries. `signed_root_matrix_operator_bound` and `exists_signed_root_matrix_operator_bound` transfer this to `‖normalizedRootError - halfOffDiagonal‖ < 3*(128/8649)`, with simultaneous integral symmetric signs and unchanged pairwise square identities.

## Actual commands and verification

- Targeted Lake build of both modules: exit 0, 2903 jobs.
- Source policy and import-coverage scan: exit 0, 42 modules, 228 explicit theorem declarations.
- Integrated root Lake build: exit 0, 3005 jobs.
- Targeted type/axiom audit: exit 0. Each of three exported theorem dependencies contains only propext, Classical.choice, Quot.sound. The elaborated theorem types are in the audit log.
- Installed `leanchecker --verbose` for MatrixOperatorNorm: exit 0.
- Installed `leanchecker --verbose` for RootMatrixOperatorBound: exit 0.
- Source and verification-script SHA256 manifests regenerated and checked successfully.

Raw logs: `local-logs/matrix-operator-targeted-20261015T2239.log`, `matrix-operator-source-20261015T2239.log`, `matrix-operator-integrated-20261015T2239.log`, `matrix-operator-axioms-20261015T2239.log`, and `matrix-operator-replay-{norm,root}-20261015T2239.log`. Kernel replay was limited to the two new modules, not the entire root. No independent external theorem review or fresh clean checkout was conducted.

## Remaining exact obligations

In `lem:product-four`, prove that singular values of `halfOffDiagonal` are `(3/2,1/2,1/2,1/2)`, establish perturbation bounds for determinant and adjugate (`|det F| < h*s^3`, `‖adj F‖ < h*s^2`), and then combine rank-one determinant and `1 ≤ |det M|` to obtain `D > 2ABC` for `A≥3`. Independently handle the mixed `A≥1,B≥3` weighted first row. Bennett's arbitrary-order identity, finite graph/Pell completeness and the full sextuple exclusions remain open.

## Preservation and repository status

Preserved pre-existing staged/unstaged proof work, private repository, frozen manuscript and toolchain. A routine private Git commit/push attempt, if permitted, will be recorded separately below. Source version in this run is identified by regenerated `records/proof-source-sha256.txt` and the successful build/audit logs. No automatic server mission or publication was authorized.

Repository update: The attempted Git staging operation was rejected by the remote tool. No commit or push was performed. The new checked files remain saved locally.
