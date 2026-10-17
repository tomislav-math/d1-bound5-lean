import D1Bound5.ProductFiveSignedPrefixInverse
import D1Bound5.ProductFiveDetNumeric

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- The quadratic bilinear form involving the first-four-entry vector is
small relative to the square of the last entry. Neither the matrix nor its
inverse is assumed Hermitian. -/
theorem productFive_quadratic_q_div_norm_lt
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ) (d : ℂ)
    (hd : d ≠ 0)
    (hnear : ‖F - halfOffDiagonal‖ < (1/8 : ℝ))
    (hw : ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ < ‖d‖ / 9) :
    ‖(w ⬝ᵥ (F⁻¹ *ᵥ w))/d^2‖ < (8/243 : ℝ) := by
  let x : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 w
  have hn : 0 ≤ ‖x‖ := norm_nonneg _
  have hdpos : 0 < ‖d‖ := norm_pos_iff.mpr hd
  have hInv : ‖F⁻¹‖ < (8/3 : ℝ) :=
    reference_perturbed_inverse_norm_lt F hnear
  have hv : ‖(WithLp.toLp 2 (F⁻¹ *ᵥ w) :
      EuclideanSpace ℂ (Fin 4))‖ ≤ ‖F⁻¹‖ * ‖x‖ := by
    exact Matrix.l2_opNorm_mulVec F⁻¹ x
  have hq : ‖w ⬝ᵥ (F⁻¹ *ᵥ w)‖ ≤ ‖F⁻¹‖ * ‖x‖^2 := by
    calc
      _ ≤ ‖x‖ * ‖(WithLp.toLp 2 (F⁻¹ *ᵥ w) :
              EuclideanSpace ℂ (Fin 4))‖ :=
        productFive_bilinear_l2_le w (F⁻¹ *ᵥ w)
      _ ≤ ‖x‖ * (‖F⁻¹‖ * ‖x‖) :=
        mul_le_mul_of_nonneg_left hv hn
      _ = ‖F⁻¹‖ * ‖x‖^2 := by ring
  have hsq : ‖x‖^2 < (‖d‖/9)^2 := by
    have hp := mul_pos (sub_pos.mpr hw)
      (by linarith only [hw, hn, hdpos] : 0 < ‖d‖/9 + ‖x‖)
    nlinarith only [hp]
  have hbound : ‖w ⬝ᵥ (F⁻¹ *ᵥ w)‖ < ‖d‖^2 * (8/243 : ℝ) := by
    calc
      _ ≤ ‖F⁻¹‖ * ‖x‖^2 := hq
      _ ≤ (8/3 : ℝ) * ‖x‖^2 :=
        mul_le_mul_of_nonneg_right hInv.le (sq_nonneg _)
      _ < (8/3 : ℝ) * (‖d‖/9)^2 :=
        mul_lt_mul_of_pos_left hsq (by norm_num)
      _ = ‖d‖^2 * (8/243 : ℝ) := by ring
  rw [norm_div, norm_pow]
  apply (div_lt_iff₀ (pow_pos hdpos 2)).mpr
  simpa [mul_comm] using hbound

/-- If the last modulus is at least 54, the normalized p-form is smaller
than the exact rational threshold used in the determinant identity. -/
theorem productFive_p_div_sq_norm_lt
    (p d : ℂ) (hp : ‖p‖ < 1) (hd : 54 ≤ ‖d‖) :
    ‖p/d^2‖ < (1/2916 : ℝ) := by
  have hdpos : 0 < ‖d‖ := by linarith
  have hdsq : (2916 : ℝ) ≤ ‖d‖^2 := by
    have hn := sq_nonneg (‖d‖ - 54)
    nlinarith only [hn, hd]
  rw [norm_div, norm_pow]
  apply (div_lt_iff₀ (pow_pos hdpos 2)).mpr
  calc
    ‖p‖ < 1 := hp
    _ ≤ (1/2916 : ℝ) * ‖d‖^2 := by nlinarith only [hdsq]

end D1Bound5
