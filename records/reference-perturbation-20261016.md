# Quantitative stability of the four-by-four reference matrix

Status: Lean source elaboration in `exploration/ReferencePerturbationTrial.lean` passed with exit 0; integrated source build and acceptance checks are recorded separately when complete. This document does not assert the main theorem.

## Precise results

Let H = (J₄-I₄)/2, let K be its previously verified explicit inverse, and put E = F-H and Q = K E. The new source `D1Bound5/ReferencePerturbation.lean` proves:

1. `reference_perturbed_det_ne_zero`: `‖Q‖ < 1` implies `det F ≠ 0`.
2. `reference_perturbed_det_ne_zero_of_near`: `‖E‖ < 3*(128/8649)` implies `det F ≠ 0`.
3. `reference_perturbed_inverse_norm_lt`: `‖E‖ < 1/8` implies `‖F⁻¹‖ < 8/3` for the actual nonsingular matrix inverse.
4. `exists_signed_root_matrix_with_bounded_inverse`: under the exact ring-valued simultaneous-root hypotheses and all off-diagonal product moduli at least nine, there are one choice of complex roots and a symmetric choice of six integral signs retaining all pair square identities such that the normalized matrix is nonsingular and its inverse has operator norm strictly less than 8/3.

All inequalities are strict. The result is valid even when the commutative coefficient ring has zero divisors; nonsingularity is proved only after the ring homomorphism to C. No equal-modulus exclusion or nonzero-root assumption is introduced.

## Argument

The identity `K F = 1 + Q` is verified algebraically from `K H = I`. The general Banach-algebra result `isUnit_one_sub_of_norm_lt_one` applied to `-Q` gives invertibility of `I+Q` when `‖Q‖<1`. Taking determinants proves `det F ≠ 0` without assuming an inverse for F in advance.

If `‖E‖<1/8`, the previously formalized `‖K‖=2` gives `‖Q‖<1/4`. Multiplying `KF=I+Q` by the genuine nonsingular inverse produces `K=F⁻¹+QF⁻¹`. Thus `‖F⁻¹‖≤2+‖Q‖‖F⁻¹‖`. The strict inequality `‖Q‖<1/4` and positivity of `‖F⁻¹‖` yield `‖F⁻¹‖<8/3`. The final bridge applies the previously verified uniform sign-selection theorem.

## Scope and next dependency

This closes the nonsingularity and explicit inverse-operator-norm estimate for a matrix near H, in particular the norm estimate later used for `F_pre` in the five-entry Schur-complement argument. It does not prove the perturbative *upper* estimates `|det F|<hs³` or `‖adj F‖<hs²` needed for `lem:product-four`. The mixed-row spectral estimate for `A≥1,B≥3`, Bennett's all-orders identity, full finite-graph coverage, and final bound-five theorem remain open.
