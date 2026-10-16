# Mixed adjugate proof: exact scalar bounds and one signed-root matrix

Date: 2026-10-16. Project: D1Bound5, private main branch.
Status: mathematical proof modules built individually with pinned Lean 4.33.1; final integrated gate is separately recorded in build-record.md and the dated run FINISH.

## New unconditional complex estimates

Let F be a complex symmetric zero-diagonal 4x4 matrix. Assume its first-row off-diagonal entries are within 1/18 of 1/2 and its remaining three independent entries are within 1/64 of 1/2. Then

  ||adj F||_2 < (155/96)*(59/96)^2.

No invertibility assumption is required. The 16 cofactor entries are covered by the already proved full symmetricFour_adjugate_formula, not merely a sample of coordinates.

The fresh generic scalar lemmas work with fully independent real radii. For three half-unit perturbations of magnitudes <=a,b,c, respectively, the diagonal cubic error is bounded by
  2*a*(1/2+b)*(1/2+c) + b*(1/2+c) + c/2.
For the six-variable off-diagonal expression w^2*x-w*z*u-w*y*v+1/8, the general upper bound is
  (rx+rz+ru+ry+rv)/4
    + rw*(rx+(rz+ru+ry+rv)/2)
    + (rw^2+rz*ru+ry*rv)/2
    + rw*(rx*rw+rz*ru+ry*rv).
These hold over the complex numbers by exact polynomial cancellation, triangle inequalities and multiplicativity of the norm, and do not rely on numerical samples.

Specialization produces all four strict prototype bounds:
  diagonal (0,0): 3169/131072 < 1/40;
  positive diagonal: 59/864 < 7/100;
  first-row off-diagonal: 215/4096 < 53/1000;
  positive off-diagonal: 3/64 < 47/1000.
The explicitly symmetric entrywise majorant for adj(F)-adj(H) has row sums 184/1000 and 217/1000 (three times), where H=(J-I)/2. Weighted Schur and ||adj(H)||_2=3/8 give
  ||adj(F)||_2 <= 3/8+217/1000=74/125 < (155/96)*(59/96)^2.

## Original-ring and sign consistency

The new mixed_signed_root_adjugate_upper transfers this estimate to normalizedRootError associated with a ring-valued symmetric root matrix satisfying MixedSignedEntryGood. Its companion mixed_signed_root_det_and_adjugate_upper combines the existing determinant estimate ||det F||<3/10 with this adjugate estimate for THE SAME ring-valued sign matrix S and the same complex square roots u.

The existing existence theorem exists_mixed_symmetric_root_matrix_with_roots supplies the admissible S and u under the first-row modulus >=3 and lower-block modulus >=9 assumptions. An integrated existential closure and the final product-four size theorem are not yet claimed.

## Files and scope

New project source modules:
  D1Bound5/MixedAdjugateScalarBound.lean (six theorem declarations)
  D1Bound5/MixedAdjugateEnvelope.lean (three row/envelope lemmas and one norm theorem)
  D1Bound5/MixedFourAdjugateBound.lean (two unconditional matrix theorems)
  D1Bound5/MixedSignedRootAdjugate.lean (two original-ring/combined theorems).
Dedicated exact-type/transitive axiom audit: scripts/MixedAdjugateIntegrationAudit.lean.

The frozen manuscript, mathematical target, full ring of integers, zero squares and ties remain unchanged. The main bound-five theorem remains UNPROVED. Next substantive mathematical step: connect the same-sign bounds, rank-one determinant inequality and lower determinant bound to actual ordered D(1) quadruples in the mixed A>=1,B>=3 branch. Bennett's arbitrary-order identity, product-five estimates and final certified exclusions remain open.
