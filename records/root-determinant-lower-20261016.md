# Scaled root determinant: arithmetic lower bound

Date: 2026-10-16 (Europe/Zagreb).

This continuation addresses the arithmetic lower-bound interface in the
large-entry branch of `lem:product-four`. Its principal lemma works in
**every even finite dimension** and in the **full ring of integers** of
an arbitrary imaginary quadratic number field.

## Exact identity

Let `f : R →+* ℂ`, where `R` is any commutative ring. For a finite
index type `n`, a coefficient vector `a : n → R`, a matrix
`M : Matrix n n R`, and complex `u` with `u i ^ 2 = f (a i)`,
the normalized scaling gives

`‖det (scaledRootMatrix u (M.map f))‖ =
 (∏ i, ‖f (a i)‖) * ‖f (det M)‖`.

It follows from the already proved `scaledRootMatrix_det`, the product
of the square-root identities, commutation of determinant and ring maps,
and multiplicativity of the complex norm. Zero roots are allowed.

If `1 ≤ ‖f (det M)‖`, then
`∏ i, ‖f (a i)‖ ≤ ‖det (scaledRootMatrix u (M.map f))‖`.
The multiplicative nonnegative factor is proved directly.

For `R = 𝓞 K`, with `K` an imaginary quadratic field,
`finrank ℚ K = 2`, and `n` even, assume
`M i i = a i` and `(M i j)^2 = a i * a j + 1` for `i ≠ j`.
The existing unconditional theorem `even_root_matrix_one_le_norm`
provides exactly the determinant lower bound. Thus all assumptions
come from the original root-square relations; no nonzero-matrix-entry,
equal-modulus exclusion, choice of a proper suborder, or custom
mathematical axiom is added.

## Source

- `D1Bound5/RootDeterminantLower.lean` (root-integrated source).
- `scripts/RootDeterminantLowerAudit.lean` (theorem type and axiom checks).
- `exploration/RootDeterminantLowerTrial.lean` is the preserved trial source.

## Limits

This closes only the **arithmetic determinant lower-bound interface**.
A statement about ordered moduli `A B C D` must still identify the
finite product with the chosen four entries and connect the same
signed-root witness to the analytic determinant/adjugate inequalities,
nonvanishing and vector-size estimate. The weighted mixed branch
`A≥1, B≥3`, Bennett's all-orders identity, complete graph coverage,
and the main bound-five theorem are not claimed.

## Validation

The second targeted trial compilation passed exit 0 using pinned Lean
4.33.1. See `local-logs/root-det-lower-run10-02.log`.
Further integrated build/audit/replay and Git receipts are recorded in
the dated run and build records only when actually completed.
