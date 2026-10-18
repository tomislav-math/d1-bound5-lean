# Sharpened four-entry frontier: A >= 3

Stable drafts, not yet compiler-verified, in order:
1. `FrontierLargeCofactors.lean`
2. `FrontierLargeNumeric.lean`
3. `FrontierLargeTuple.lean`

Actual endpoint: `IsD1Tuple.frontier_large_growth` proves T > 3*A*B*S
for an ordered four-entry D(1)-tuple in the full imaginary quadratic
integer ring with A >= 3. This is genuinely a fourth-entry theorem.

The proof reuses, and strengthens the way we combine, the existing
verified estimates. The prior actual tuple theorem already gives
T > 2*A*B*S, hence T > 18*S and T >= 54. For the SAME signed integral
root matrix, its normalized error F has zero diagonal and all entries
within 128/8649 of 1/2. Existing exact cubic cofactor estimates give

- diagonal adjugate entries: modulus <= 1/4+23/1000 = 273/1000;
- off-diagonal adjugate entries: modulus <= 1/8+197/10000 = 1447/10000.

Rather than replacing the whole adjugate by its operator norm, retain
these entrywise bounds. Since the three smaller coordinates are <= T/18,

a^t adj(F) a <= [273/1000*(1+3/324)
                 +1447/10000*(6/18+6/324)]*T^2
               =88139/270000*T^2.

The exact rank-one determinant identity, det(F) modulus < 1/4, and
T >= 54 imply modulus(det(F+aa^t)) < T^2/3. The already-proved integral
scaled-root determinant lower bound is A*B*S*T. This gives T>3*A*B*S.
No new sign witness or unproved analytic/determinant premise is introduced.

This alternative finite proof covers the A>=3 branch of manuscript
`five-frontier-gaps`. The five A<3 norm-dependent rows are NOT proved by
these modules; their sharper parameters still require a separate argument.
