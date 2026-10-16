# Rank-one determinant estimate, 16 October 2026

## Mathematical scope

This proof unit supplies the rank-one determinant step of `lem:product-four` and the corresponding step needed later in `lem:product-five`. It does not claim either product lemma or the overall bound-five theorem.

For any complex 4-by-4 matrix F with nonzero determinant and any vector w in C^4, the proved statements are

- `det(F + w w^T) = det(F) (1 + w^T F^{-1} w)`.
- `|w^T G w| <= ||G||_2 sum_i |w_i|^2` for every complex G, without a Hermitian or symmetry hypothesis.
- `||adj(F)||_2 = |det(F)| ||F^{-1}||_2`.
- `|det(F + w w^T)| <= |det(F)| + ||adj(F)||_2 sum_i |w_i|^2`.

The transpose is algebraic, not conjugate. The bilinear estimate is correctly obtained from the Hermitian Cauchy-Schwarz inequality by conjugating one of the Euclidean vectors. The norm is the Euclidean L2 operator norm, not an entrywise max norm.

The matrix determinant lemma is applied only after `det F != 0`; this hypothesis is supplied in the A>=3 case by the existing `reference_perturbed_det_ne_zero_of_near` theorem. The new scalar norm inequality is then proved from the operator bound for matrix-vector multiplication. The adjugate relation follows from both nonsingular-inverse identities and `F * adj(F) = det(F) I`.

The bridge theorem `scaledRootMatrix_det_adjugate_norm_le` uses the exact polynomial identity `scaledRootMatrix u M = normalizedRootError a u M + a a^T`, so it does not require any root to be nonzero and introduces no assumptions on pairwise moduli or square roots. The nonsingularity of the normalized correction is explicit in its statement.

## Remaining dependencies

The essential bounds `|det F| < h s^3` and `||adj(F)||_2 < h s^2` from the reference-matrix perturbation remain open. Both the separate weighted `A>=1, B>=3` branch and the product-four numerical closure remain open. The arbitrary-order Bennett determinant, simultaneous approximations, complete descent and finite-graph coverage, and main theorem also remain open.

## Verification and provenance

Sources: `D1Bound5/RankOneDeterminantBound.lean`, `D1Bound5/ScaledRootRankOneBound.lean`. Verification script: `scripts/RankOneBoundAudit.lean`. Earlier exploratory failures, including a missing rank-one coefficient simplification and an incorrect side of additive monotonicity, are retained in `local-logs/rankone-trial-001.log` through `rankone-trial-006.log`, `rankone-norm-001.log`, `rankone-norm-002.log`, and `rankone-integrated-trial-001.log`. All failures were diagnosed and corrected without adding axioms.

Status: source files saved. Targeted integration, axiom audit, kernel replay and final source-control receipt must be recorded from their actual exit codes before treating this entire unit as accepted.
