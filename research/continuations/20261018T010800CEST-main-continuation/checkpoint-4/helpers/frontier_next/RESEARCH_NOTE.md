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
`five-frontier-gaps`. The A<3 norm-dependent rows use the separate full chain described below.


# Small-A frontier table chain

Additional draft modules, in dependency order (not yet compiler-verified):
1. `FrontierCubicErrors`
2. `FrontierRootBounds`
3. `FrontierMixedCofactors`
4. `FrontierScalarReduction`
5. `FrontierTableNumeric`
6. `FrontierMixedDeterminant`
7. `FrontierTableTuple`
8. `FrontierNormRows`

The actual endpoint `IsD1Tuple.frontier_small_norm_growth` proves all five
rows with the exact stated constants 27/8, 3, 11/4, 29/10, 3. Its premises
are an actual ordered quadruple and first squared modulus <= 8; the five
conditional row conclusions separately require N(a)=1,2,3,4 or N(a)>=5
and the corresponding lower bound B>=8,4,3,3,3. Integral coordinate norm
is already identified with squared complex modulus by FullRingBridge.

For |x|>=5 the existing `exists_root_error_control` at c=7/8 gives
|e-1/2| < 32/(225|x|) < 1/(7|x|). All six root signs are selected in the
same original ring, retaining symmetry, diagonal entries and exact roots.
Let k=1/2+1/(7 alpha beta), l=1/2+1/(7 beta^2), K=k^2*l. Each cubic
cofactor product contains at least one later edge; the telescoping cubic
error about 1/8 is at most K-1/8. Thus diagonal cofactors have modulus
at most 2K, and off-diagonal cofactors at most 3K-1/4. The subtraction
of 1/4 uses the leading cubic cancellation, not a triangle bound alone.
Each disjoint-edge quartic product has one first and one later edge,
so |det F|<=9k^2*l^2. The perturbation norm is <1/10, proving F invertible.

The exact scaled rank-one determinant identity and integral determinant
lower bound give ABST<=2K sum(Ai^2)+(6K-1/2)sum(AiAj)+Q. Dividing by
A^2 B^2 S^2 and using A>=alpha,B,S>=beta gives the division-free scalar
inequality tau<=2K tau^2+LP tau+J. Existing irregular-tail growth and A<3
supply tau>2/3. The convex quadratic chord identity and exact rational
endpoint checks then exclude tau up to each row target. No missing
estimate is retained as a premise of the actual tuple theorem.
