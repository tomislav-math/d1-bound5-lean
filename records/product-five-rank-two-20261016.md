# Product-five rank-two Schur-complement determinant identity

Date: 2026-10-16, local invocation 19:15–19:40 CEST.
Branch: main. Target: frozen v4 manuscript, Lemma `lem:product-five`, equation `(integrated-3)`.

## Mathematical content

For any complex 4x4 matrix F with det F != 0, vectors f,w in C^4,
and nonzero d in C, define G by
G_ij = F_ij - (w_i f_j + f_i w_j)/d - f_i f_j/d^2.

Let X=F^{-1}, h=f^T X w, k=w^T X f, p=f^T X f and q=w^T X w.
The new theorem proves
  det G = det F * (1-(k+h)/d+(k*h-p*q-p)/d^2).
No symmetry is needed for this more general identity.
If F^T=F, then X^T=X and h=k. Consequently the exact manuscript
identity follows:
  det G = det F * (1-2*h/d+(h^2-p*q-p)/d^2).

This is a bilinear complex determinant identity. Transposes are
algebraic transposes, not conjugate transposes. No positivity,
distinct-modulus or nonzero-square assumptions occur.

## Lean organization

`D1Bound5/ProductFiveRankTwo.lean` contains nine proved theorems:
`rankTwo_det_factor`, `rankTwo_det_entries`,
`productFive_update_entry`, `productFive_compressed_entry`,
`productFive_rankTwo_det_general`,
`symmetric_inverse_bilinear_swap`,
`productFive_rankTwo_det_symmetric`,
`productFiveSchur_eq`, `productFiveSchur_det`.

The proof reduces the 4x4 determinant to a 2x2 determinant by the
Weinstein-Aronszajn identity, computes all four 2x2 entries by
explicit finite sums, proves cancellation of the cubic denominator
terms, and then uses transpose symmetry for the manuscript formula.
The final theorem has exactly three mathematical hypotheses:
det F != 0, d != 0 and F^T=F.

## Verification performed

- Pinned integrated `lake build D1Bound5.ProductFiveRankTwo D1Bound5`:
  EXIT 0, 3030 jobs. Log `local-logs/product-five-rank-two-hourly18-build.log`.
- Dedicated exact-type and transitive axiom audit:
  EXIT 0 for all nine theorems, only propext, Classical.choice,
  Quot.sound. `local-logs/product-five-rank-two-hourly18-axioms.log`.
- Targeted installed same-kernel `leanchecker --verbose`:
  EXIT 0. `local-logs/product-five-rank-two-hourly18-replay.log`.
- Source/import audit: EXIT 0, 67 modules, 337 explicit theorems.
- Source/config hash manifest: EXIT 0, 70 paths.
  Verification-tool manifest: EXIT 0, 29 paths.
- Source SHA256:
  0cec92c96e51a0a3fbd94ad6a62d3e917e83332e75de37d2fd74599e197b4902.

The targeted replay uses the same installed Lean kernel, not an
independent implementation or external reviewer. No new clean
checkout or full-project kernel replay was performed.

## Important remaining obligations

The theorem only proves the rank-two determinant polynomial.
The actual five-entry `product-five` inequality D>3ABSC is NOT yet proved.
Next link the original scaled root matrix to
`det N=d^2 det G`, supply prefix invertibility and numerical
bounds for h,p,q and det F, prove ||G-H||<1/2, then use the integral
determinant lower bound to close product-five. The general Bennett
identity, large finite coverage/descent and final sextuple
exclusions also remain open. `MainStatement` is a proposition.
