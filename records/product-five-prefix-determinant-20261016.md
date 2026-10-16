# Sharper mixed four-by-four determinant for product-five

Date: 2026-10-16. Manuscript reference: `lem:product-five`, equation for the symmetric prefix determinant. Starting imported theorem: `mixedPairProduct_nearQuarter` in `MixedFourDetBound.lean`.

For pair products P=xw, Q=yv, R=zu, each satisfying |P-1/4|, |Q-1/4|, |R-1/4| < epsilon=7/192, put a=P-1/4, b=Q-1/4, c=R-1/4. Exact algebra gives

    P^2+Q^2+R^2-2(PQ+PR+QR)
    = -3/16 - (a+b+c)/2 + [a^2+b^2+c^2-2(ab+ac+bc)].

The six quadratic monomials have total weighted coefficient 3+6=9, so the bracket has absolute value at most 9 epsilon^2. The linear term has absolute value at most 3 epsilon/2. Therefore

    |det F| <= 3/16 + 3*(7/192)/2 + 9*(7/192)^2
            = 1041/4096 < 33/128,

with exact strict margin 15/4096. This works for asymmetric first-row/later-row perturbations (1/18 and 1/64), covers all complex phases, and requires neither nonsingularity nor nonzero off-diagonal entries. The former quadratic majorant had coefficient 13 and was too weak to establish 33/128.

Proof source: `exploration/ProductFivePrefixDetTrial.lean`; integration subject to successful pinned compilation, transitive axiom audit, targeted kernel replay, source/import coverage and hash checks. No unconditional product-five conclusion is claimed: the selected quintuple matrix, inverse estimates, final-column norms, and full Schur determinant/proximity inequalities remain open.

## Checked result and reproducibility

Four root-imported Lean theorems proved, including the genuine matrix-index theorem `mixed_zero_four_det_norm_lt_33_128`. Isolated corrected trial and integrated pinned target/root build both EXIT 0 (3036 jobs in latter). Dedicated exact-type/transitive axiom audit EXIT 0 with only the standard three permitted axioms. Installed same-kernel targeted `leanchecker` replay EXIT 0. Source/import audit EXIT 0 (73/355). Two hash manifest checks EXIT 0 (76/35). See `records/build-record.md` and `local-logs/product-five-prefix-hourly23-*`. No independent reviewer or clean-checkout replay.

The strict `<33/128` matrix determinant estimate is proved for all symmetric complex four-by-four matrices satisfying the specified six normalized entry conditions, with no nonzero square-root assumption. The specific signed original-ring five-entry construction and remaining analytic Schur conditions have NOT yet been proved. This is one verified bounded dependency of `lem:product-five`.
