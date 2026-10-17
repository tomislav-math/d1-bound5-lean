import D1Bound5.ProductFiveExactIdentity
import D1Bound5.MixedFourDetBound

open Matrix

namespace D1Bound5

/-- The exact rational determinant margin in the five-entry Schur argument.
All four bilinear quantities are complex, with no Hermitian assumptions. -/
theorem productFive_scalar_det_upper
    (a h p q d : ℂ) (hd : d ≠ 0)
    (ha : ‖a‖ ≤ (33/128 : ℝ))
    (hh : ‖h/d‖ ≤ (11/108 : ℝ))
    (hp : ‖p‖ ≤ (1 : ℝ))
    (hq : ‖q/d^2‖ ≤ (8/243 : ℝ))
    (hpd : ‖p/d^2‖ ≤ (1/2916 : ℝ)) :
    ‖a * (1 - 2*h/d + (h^2 - p*q - p)/d^2)‖ < (1/3 : ℝ) := by
  let x : ℂ := h/d
  let y : ℂ := q/d^2
  let z : ℂ := p/d^2
  have hx : ‖x‖ ≤ (11/108 : ℝ) := hh
  have hy : ‖y‖ ≤ (8/243 : ℝ) := hq
  have hz : ‖z‖ ≤ (1/2916 : ℝ) := hpd
  have heq : 1 - 2*h/d + (h^2 - p*q - p)/d^2 =
      (1 : ℂ) - 2*x + (x^2 - p*y - z) := by
    dsimp [x, y, z]
    field_simp [hd]
  have hnorm :
      ‖(1 : ℂ) - 2*x + (x^2 - p*y - z)‖ ≤
        1 + 2*‖x‖ + (‖x‖^2 + ‖p‖*‖y‖ + ‖z‖) := by
    calc
      _ ≤ ‖(1 : ℂ) - 2*x‖ + ‖x^2 - p*y - z‖ := norm_add_le _ _
      _ ≤ (‖(1 : ℂ)‖ + ‖(2 : ℂ)*x‖) +
            (‖x^2‖ + ‖p*y‖ + ‖z‖) := by
          have h1 := norm_sub_le (1 : ℂ) ((2 : ℂ)*x)
          have h2 := norm_sub_le (x^2-p*y) z
          have h3 := norm_sub_le (x^2) (p*y)
          linarith only [h1, h2, h3]
      _ = 1 + 2*‖x‖ + (‖x‖^2 + ‖p‖*‖y‖ + ‖z‖) := by
          norm_num [norm_mul, norm_pow]
  have hx2 : ‖x‖^2 ≤ (11/108 : ℝ)^2 := by
    have hpositive : 0 ≤ (11/108 : ℝ) + ‖x‖ := by positivity
    have hhx : 0 ≤ ((11/108 : ℝ)-‖x‖)*((11/108 : ℝ)+‖x‖) :=
      mul_nonneg (sub_nonneg.mpr hx) hpositive
    nlinarith only [hhx]
  have hpy : ‖p‖ * ‖y‖ ≤ (8/243 : ℝ) := by
    calc
      ‖p‖*‖y‖ ≤ 1*‖y‖ :=
        mul_le_mul_of_nonneg_right hp (norm_nonneg _)
      _ ≤ 1*(8/243 : ℝ) := by simpa using hy
      _ = 8/243 := by ring
  have htotal :
      ‖(1 : ℂ) - 2*x + (x^2 - p*y - z)‖ ≤
        1 + 11/54 + 505/11664 + 1/2916 := by
    nlinarith only [hnorm, hx, hx2, hpy, hz]
  rw [heq]
  calc
    ‖a * ((1 : ℂ) - 2*x + (x^2 - p*y - z))‖ =
        ‖a‖ * ‖(1 : ℂ) - 2*x + (x^2 - p*y - z)‖ := norm_mul _ _
    _ ≤ (33/128 : ℝ) * (1 + 11/54 + 505/11664 + 1/2916) := by
        calc
          _ ≤ (33/128 : ℝ) *
                ‖(1 : ℂ) - 2*x + (x^2 - p*y - z)‖ :=
                  mul_le_mul_of_nonneg_right ha (norm_nonneg _)
          _ ≤ _ := mul_le_mul_of_nonneg_left htotal (by norm_num)
    _ < (1/3 : ℝ) := by norm_num

/-- Apply the scalar margin to the actual rank-two Schur complement.
The remaining hypotheses are precisely the normalized analytic estimates. -/
theorem productFive_schur_det_upper_of_bilinear_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ)
    (hF : F.det ≠ 0) (hd : d ≠ 0)
    (hsym : Fᵀ = F)
    (ha : ‖F.det‖ ≤ (33/128 : ℝ))
    (hh : ‖(f ⬝ᵥ (F⁻¹ *ᵥ w))/d‖ ≤ (11/108 : ℝ))
    (hp : ‖f ⬝ᵥ (F⁻¹ *ᵥ f)‖ ≤ (1 : ℝ))
    (hq : ‖(w ⬝ᵥ (F⁻¹ *ᵥ w))/d^2‖ ≤ (8/243 : ℝ))
    (hpd : ‖(f ⬝ᵥ (F⁻¹ *ᵥ f))/d^2‖ ≤ (1/2916 : ℝ)) :
    ‖(productFiveSchur F f w d).det‖ < (1/3 : ℝ) := by
  rw [productFiveSchur_det F f w d hF hd hsym]
  exact productFive_scalar_det_upper F.det
    (f ⬝ᵥ (F⁻¹ *ᵥ w)) (f ⬝ᵥ (F⁻¹ *ᵥ f))
    (w ⬝ᵥ (F⁻¹ *ᵥ w)) d hd ha hh hp hq hpd

end D1Bound5
