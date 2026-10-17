import D1Bound5.ProductFourNumericalClosure
import Mathlib.Tactic.NormNum

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- Parameters of the mixed (A >= 1, B >= 3) product-four branch. -/
noncomputable def productFourMixedS : ℝ := 59 / 96
noncomputable def productFourMixedH : ℝ := 155 / 96

/-- The strict mixed-branch rational margin from manuscript v4. -/
theorem productFour_mixed_numeric :
    productFourMixedH * productFourMixedS^2 *
      ((13/12 : ℝ) + productFourMixedS/324) < 2/3 := by
  unfold productFourMixedH productFourMixedS
  norm_num

/-- Rank-one determinant inequality in the mixed branch. Both perturbative
upper bounds are explicit hypotheses, still requiring separate proofs. -/
theorem productFour_mixed_rankOne_numeric
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (D : ℝ) (hD : 18 < D) (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourMixedH * productFourMixedS^3)
    (hadj : ‖F.adjugate‖ < productFourMixedH * productFourMixedS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2) :
    ‖(F + Matrix.vecMulVec w w).det‖ < (2/3 : ℝ)*D^2 := by
  have hsum : 0 ≤ (∑ i, ‖w i‖^2) :=
    Finset.sum_nonneg (fun i _ => sq_nonneg _)
  have hcoef : 0 ≤ productFourMixedH * productFourMixedS^2 := by
    unfold productFourMixedH productFourMixedS
    positivity
  have hterm :
      ‖F.adjugate‖ * (∑ i, ‖w i‖^2) ≤
        productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) := by
    calc
      _ ≤ (productFourMixedH * productFourMixedS^2) * (∑ i, ‖w i‖^2) :=
        mul_le_mul_of_nonneg_right hadj.le hsum
      _ ≤ productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) :=
        mul_le_mul_of_nonneg_left hw hcoef
  have hn :
      productFourMixedH * productFourMixedS^3 +
        productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) <
        (2/3 : ℝ)*D^2 := by
    have hd2 : 324 < D^2 := by nlinarith
    unfold productFourMixedH productFourMixedS
    nlinarith only [hd2]
  have hbase := rankOneDeterminant_adjugate_norm_le F w hF
  linarith only [hbase, hdet, hterm, hn]

/-- Algebraic final step of the mixed branch, conditional on the
perturbative bounds and integral determinant lower bound. -/
theorem productFour_mixed_growth_from_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (A B C D : ℝ) (hD : 18 < D) (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourMixedH * productFourMixedS^3)
    (hadj : ‖F.adjugate‖ < productFourMixedH * productFourMixedS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2)
    (hlower : A*B*C*D ≤ ‖(F + Matrix.vecMulVec w w).det‖) :
    (3/2 : ℝ)*A*B*C < D := by
  have ht := productFour_mixed_rankOne_numeric F w D hD hF hdet hadj hw
  have hDpos : 0 < D := by linarith
  have hprod : ((3/2 : ℝ)*A*B*C)*D < D*D := by
    nlinarith only [hlower, ht]
  by_contra hbad
  have hmul := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hDpos.le
  nlinarith only [hprod, hmul]

end D1Bound5
