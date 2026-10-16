# Product-five quantitative Schur determinant margin

Date: 2026-10-16. Frozen manuscript v4, Lemma `lem:product-five`, equation `integrated-3`. New Lean module: `D1Bound5/ProductFiveDetNumeric.lean`; trial: `exploration/ProductFiveDetNumericTrial22.lean`.

## Mathematics

For complex a,h,p,q,d with d nonzero, put x=h/d, y=q/d² and z=p/d². The exact algebraic identity is

  1 - 2h/d + (h²-pq-p)/d² = 1 - 2x + (x²-py-z).

If |a| <= 33/128, |x| <= 11/108, |p| <= 1, |y| <= 8/243 and |z| <= 1/2916, then the triangle inequality gives

  |1 - 2x + x² - py - z|
  <= 1 + 2|x| + |x|² + |p| |y| + |z|
  <= 1 + 11/54 + 505/11664 + 1/2916.

The exact upper bound for |a| times the last quantity is 160039/497664, strictly below 1/3 by 5849/497664. Lean proves this with norm inequalities, explicit square/product inequalities, and exact rational arithmetic.

The matrix corollary substitutes a=det F, h=fᵀ F⁻¹ w, p=fᵀ F⁻¹ f and q=wᵀ F⁻¹ w, using the previously verified rank-two determinant identity for the Schur complement. F is symmetric, det F is nonzero, and d is nonzero. The bilinear forms are ordinary transpose forms, with no complex conjugation. No excluded zero-square or equal-modulus cases are introduced; hypotheses remain explicitly conditional.

## Scope and next dependency

This unit closes the final *numeric conversion* from normalized bounds to |det G|<1/3. It does not yet establish these normalized bounds from an actual ordered five-tuple. That requires the frozen manuscript's prefix matrix perturbation/inverse bound, last-column deviations, d>18C, C>=3, and the four bilinear estimates. The separate ||G-H||<1/2 estimate is also still open at the tuple level. The existing full-ring arithmetic endpoint already proves D>3ABSC from those two Schur estimates.

The global bound-five theorem remains UNPROVED. No claims of finite-search completeness, Bennett arbitrary-order identity, independent external review, or clean checkout.

## Verification

Isolated trial01 EXIT 1 (redundant tactic and unsupported simplification lemma); corrected isolated trial02 EXIT 0. Integrated target+root Lake build EXIT 0 (3035 jobs), log `local-logs/product-five-numeric-hourly22-build.log`. Dedicated exact-type/transitive axiom audit, targeted leanchecker replay, source/import audit, manifest checks and Git receipts must be recorded only after actual completion.

## Completed checks

Pinned Lake integrated target/root build EXIT 0 (3035 jobs). Dedicated two-theorem exact-type and transitive axiom audit EXIT 0 (only propext, Classical.choice, Quot.sound). Installed same-kernel targeted leanchecker replay EXIT 0. Root source/import scan EXIT 0 (72 modules, 351 theorems). Both SHA-256 manifest checks EXIT 0 (75/34 paths). Actual logs `local-logs/product-five-numeric-hourly22-*`. No clean checkout or independent external referee.
