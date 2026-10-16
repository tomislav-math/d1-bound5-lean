import D1Bound5.ScaledRootRankOneBound
import Mathlib.Tactic.NormNum

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- The exact rational parameters in the large-entry branch of
`lem:product-four`, with e = 128/8649. -/
noncomputable def productFourS : ℝ := 3139 / 5766

noncomputable def productFourH : ℝ := 8905 / 5766

/-- The numerical inequality at the end of the A >= 3 branch. -/
theorem productFour_numeric :
    productFourH * productFourS^2 *
      (1 + (3/36 : ℝ) + productFourS/324) < 1/2 := by
  unfold productFourH productFourS
  norm_num

/-- The rank-one determinant bound reduces the large-entry branch to
the two still-open perturbative determinant and adjugate estimates.
These estimates are assumptions here, not asserted as established. -/
theorem productFour_rankOne_numeric
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (D : ℝ) (hD : 18 < D)
    (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourH * productFourS^3)
    (hadj : ‖F.adjugate‖ < productFourH * productFourS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2) :
    ‖(F + Matrix.vecMulVec w w).det‖ < D^2 / 2 := by
  have hsum : 0 ≤ (∑ i, ‖w i‖^2) :=
    Finset.sum_nonneg (fun i _ => sq_nonneg _)
  have hcoef : 0 ≤ productFourH * productFourS^2 := by
    unfold productFourH productFourS
    positivity
  have hterm :
      ‖F.adjugate‖ * (∑ i, ‖w i‖^2) ≤
        productFourH * productFourS^2 * ((13/12 : ℝ) * D^2) := by
    calc
      _ ≤ (productFourH * productFourS^2) * (∑ i, ‖w i‖^2) :=
        mul_le_mul_of_nonneg_right hadj.le hsum
      _ ≤ productFourH * productFourS^2 * ((13/12 : ℝ) * D^2) :=
        mul_le_mul_of_nonneg_left hw hcoef
  have hn :
      productFourH * productFourS^3 +
        productFourH * productFourS^2 * ((13/12 : ℝ) * D^2) < D^2/2 := by
    have hd2 : 324 < D^2 := by nlinarith
    unfold productFourH productFourS
    nlinarith only [hd2]
  have hbase := rankOneDeterminant_adjugate_norm_le F w hF
  linarith only [hbase, hdet, hterm, hn]

/-- The final numerical implication D > 2ABC, conditional on the
integral determinant lower bound and the perturbative estimates. -/
theorem productFour_growth_from_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (A B C D : ℝ) (hD : 18 < D)
    (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourH * productFourS^3)
    (hadj : ‖F.adjugate‖ < productFourH * productFourS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2)
    (hlower : A*B*C*D ≤ ‖(F + Matrix.vecMulVec w w).det‖) :
    2*A*B*C < D := by
  have ht := productFour_rankOne_numeric F w D hD hF hdet hadj hw
  have hDpos : 0 < D := by linarith
  have hprod : (2*A*B*C)*D < D*D := by
    nlinarith only [hlower, ht]
  have hg : 2*A*B*C < D := by
    by_contra hbad
    have hmul := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hDpos.le
    nlinarith only [hprod, hmul]
  exact hg

end D1Bound5
