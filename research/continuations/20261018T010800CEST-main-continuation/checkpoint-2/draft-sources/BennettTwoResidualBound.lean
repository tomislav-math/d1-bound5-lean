import D1Bound5.BennettResidualBound
import D1Bound5.BennettTwoIntegralMatrix
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.FinCases

open Finset

namespace D1Bound5

/-- Exact cancellation of the clearing factor with the order-three-k zero.
This is the source of the manuscript's residual scale 4 delta^2/(AB C^2). -/
theorem bennett_two_residual_scale (A B C δ : ℝ)
    (hA : A ≠ 0) (hB : B ≠ 0) (hC : C ≠ 0) (k : ℕ) :
    (4 * (A * B) ^ 2 * C * δ ^ 2) ^ k * ((A * B * C)⁻¹) ^ (3 * k) =
      (4 * δ ^ 2 / (A * B * C ^ 2)) ^ k := by
  rw [pow_mul, ← mul_pow]
  congr 1
  field_simp
  <;> ring

/-- The actual integral two-anchor Q-matrix satisfies the manuscript's
Gamma residual bound. All factors are constructed entries; no approximation
or contour bound is provided as a hypothesis. -/
theorem bennettTwoClearedEntry_residual_norm_le
    (a b c : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) (hab : a ≠ b)
    (hAB : ‖a‖ ≤ ‖b‖) (hAC : 1 < ‖a‖ * ‖c‖)
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ‖∑ j, bennettTwoClearedEntry a b c k i j *
        (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)‖ ≤
      (4 * ‖a - b‖ ^ 2 / (‖a‖ * ‖b‖ * ‖c‖ ^ 2)) ^ k *
        (Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
          (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))) /
            (1 - 1 / (‖a‖ * ‖c‖)) ^ (2 * (k : ℝ) - 1 / 2) := by
  have hA : ‖a‖ ≠ 0 := norm_ne_zero_iff.mpr ha
  have hB : ‖b‖ ≠ 0 := norm_ne_zero_iff.mpr hb
  have hC : ‖c‖ ≠ 0 := norm_ne_zero_iff.mpr hc
  have hprod : 0 < ‖a‖ * ‖c‖ := lt_trans (by norm_num) hAC
  have hx : ‖(a * b * c)⁻¹‖ = (‖a‖ * ‖b‖ * ‖c‖)⁻¹ := by
    simp only [norm_inv, norm_mul]
  have hr : ‖b‖ * ‖(a * b * c)⁻¹‖ = 1 / (‖a‖ * ‖c‖) := by
    rw [hx]
    field_simp
    <;> ring
  have hradius : ‖b‖ * ‖(a * b * c)⁻¹‖ < 1 := by
    rw [hr]
    exact (div_lt_one hprod).mpr hAC
  have hnodes : ∀ j, ‖bennettTwoNodes a b j‖ ≤ ‖b‖ := by
    intro j
    fin_cases j
    · simpa only [bennettTwoNodes_zero, norm_zero] using norm_nonneg b
    · simp only [bennettTwoNodes_one, le_refl]
    · simpa only [bennettTwoNodes_two] using hAB
  have hbound := bennett_two_polynomial_residual_norm_le
    (bennettTwoNodes a b) (bennettTwoNodes_injective a b ha hb hab)
    k hk ‖b‖ ((a * b * c)⁻¹) i (norm_nonneg b) hnodes hradius
  let S : ℂ := (4 * (a * b) ^ 2 * c * (a - b) ^ 2) ^ k
  have hrow : (∑ j, bennettTwoClearedEntry a b c k i j *
        (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)) =
      S * ∑ j, (bennettPolynomialResidue univ (bennettTwoNodes a b) k
        (1 / 2 : ℂ) i j).eval ((a * b * c)⁻¹) *
          (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ) := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j hj
    rw [bennettTwoClearedEntry_eq_scaled_residue a b c ha hb hc]
    exact mul_assoc _ _ _
  have hscale : ‖S‖ * ‖(a * b * c)⁻¹‖ ^ (3 * k) =
      (4 * ‖a - b‖ ^ 2 / (‖a‖ * ‖b‖ * ‖c‖ ^ 2)) ^ k := by
    rw [hx]
    have hSnorm : ‖S‖ = (4 * (‖a‖ * ‖b‖) ^ 2 * ‖c‖ * ‖a - b‖ ^ 2) ^ k := by
      simp [S, norm_mul, norm_pow]
    rw [hSnorm]
    exact bennett_two_residual_scale ‖a‖ ‖b‖ ‖c‖ ‖a - b‖ hA hB hC k
  rw [hrow, norm_mul]
  calc
    _ ≤ ‖S‖ *
        ((Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
          (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))) *
            ‖(a * b * c)⁻¹‖ ^ (3 * k) /
              (1 - ‖b‖ * ‖(a * b * c)⁻¹‖) ^ (2 * (k : ℝ) - 1 / 2)) :=
      mul_le_mul_of_nonneg_left hbound (norm_nonneg S)
    _ = (‖S‖ * ‖(a * b * c)⁻¹‖ ^ (3 * k)) *
        (Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
          (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))) /
            (1 - 1 / (‖a‖ * ‖c‖)) ^ (2 * (k : ℝ) - 1 / 2) := by
      rw [hr]
      ring
    _ = _ := by rw [hscale]

end D1Bound5
