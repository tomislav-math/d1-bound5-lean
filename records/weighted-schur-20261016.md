# Weighted Schur bound for the mixed product-four branch

## Formal statement and proof

The module `D1Bound5/WeightedSchur.lean` contains four declarations:

1. `weightedCS_four_row`: finite weighted Cauchy--Schwarz for nonnegative real row coefficients, strictly positive weights and an arbitrary real input vector.
2. `weightedSchur_four_energy`: for symmetric nonnegative real B, weights w_i>0 and c>=0 satisfying (B w)_i <= c w_i, the sum of squared output coordinates is at most c^2 times the input squared norm.
3. `weightedSchur_four_opNorm`: if a complex 4x4 E is entrywise dominated by such a real B, its *Euclidean L2 operator norm* is <=c. E itself need not be symmetric or Hermitian.
4. `mixedFour_operator_norm_le`: for zero-diagonal E with |E_ij|<1/18 on pairs meeting index zero, and |E_ij|<1/64 on the remaining off-diagonal positions, ||E||_2<=11/96.

The energy proof uses weighted Cauchy--Schwarz rowwise:
  (sum_j B_ij |x_j|)^2 <= (sum_j B_ij w_j) (sum_j B_ij |x_j|^2/w_j).
After applying the row certificate and summing over i, symmetry of B turns column weighted sums into row sums, yielding <=c^2 sum_j |x_j|^2. The complex operator-norm transfer uses norm_sum_le, norm_mul and the EuclideanSpace norm-square identity. No eigenvalue assertions or non-kernel numerical computations occur in the proof.

The exact majorant/weight certificate is already established in `WeightedRowCertificate.lean`: w=(3/2,1,1,1), c=11/96, first-row sum=1/6<11/64, every later-row sum=11/96. Consequently the weighted Schur argument applies even when the complex perturbation matrix is nonsymmetric.

## Scope

This closes only the mixed perturbation **operator-norm** estimate, a genuine dependency for the manuscript's A>=1,B>=3 branch of `lem:product-four`. The required determinant/cofactor perturbation bounds, arithmetic assembly for D>(3/2)ABC, product-five, arbitrary-order Bennett identity, certified finite descent and the main bound-five theorem remain open. There is no hidden additional hypothesis, use of native_decide or intended new mathematical axiom.

## Evidence

Trial file `exploration/WeightedSchurTrial.lean` elaborated with exit 0, `local-logs/weighted-schur-opnorm-02.log` (after repairing one missing equivalence elaboration context). Byte-identical root source SHA256: 0740899bda0b97ce5440dc1a326c7e0aa61aa178424db90f7d296c6acdfafdf8. The integrated build, transitive axiom audit, kernel replay and source/tool hash checks must be reported from their actual completed results, not inferred from this note.
