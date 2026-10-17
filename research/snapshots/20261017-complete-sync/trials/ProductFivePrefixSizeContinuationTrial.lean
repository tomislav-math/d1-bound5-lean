import D1Bound5.ProductFiveSignedPrefixInverse

open Matrix
open scoped NumberField

namespace D1Bound5

/-- The first four ordered moduli are quadratically small relative to
the last one once the product-four growth bound applies. -/
theorem productFive_prefix_sq_lt_last_div_nine
    (a b c s d : ℝ)
    (ha : 0 ≤ a) (hab : a ≤ b) (hbc : b ≤ c) (hcs : c ≤ s)
    (hb : 3 ≤ b) (hlarge : 2*b*c*s < d) :
    a^2 + b^2 + c^2 + s^2 < (d/9)^2 := by
  have hc : 3 ≤ c := le_trans hb hbc
  have hs : 0 ≤ s := le_trans (by norm_num : (0:ℝ) ≤ 3) (le_trans hc hcs)
  have hb0 : 0 ≤ b := le_trans (by norm_num : (0:ℝ) ≤ 3) hb
  have hc0 : 0 ≤ c := le_trans (by norm_num : (0:ℝ) ≤ 3) hc
  have has : a ≤ s := hab.trans (hbc.trans hcs)
  have hbs : b ≤ s := hbc.trans hcs
  have hasq : a^2 ≤ s^2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr has) (add_nonneg ha hs)]
  have hbsq : b^2 ≤ s^2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr hbs) (add_nonneg hb0 hs)]
  have hcsq : c^2 ≤ s^2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr hcs) (add_nonneg hc0 hs)]
  have hbc9 : (9:ℝ) ≤ b*c := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hb) (sub_nonneg.mpr hc)]
  have h18 : 18*s < d := by
    have he : 18*s ≤ (2*b*c)*s :=
      mul_le_mul_of_nonneg_right (by nlinarith only [hbc9]) hs
    nlinarith only [he,hlarge]
  have htwo : 2*s < d/9 := by linarith only [h18]
  have hpositive : 0 < d/9 + 2*s := by linarith only [htwo, hs]
  have hsq : (2*s)^2 < (d/9)^2 := by
    have hprod := mul_pos (sub_pos.mpr htwo) hpositive
    nlinarith only [hprod]
  nlinarith only [hasq, hbsq, hcsq, hsq]

/-- The actual four complex entries satisfy the Euclidean norm estimate.
This uses only ordering and the proved product-four numerical growth input. -/
theorem productFive_prefix_l2_lt_last_div_nine
    (t : Fin 5 → ℂ)
    (hmon : Monotone (fun i => ‖t i‖))
    (hB : 3 ≤ ‖t 1‖)
    (hlarge : 2 * ‖t 1‖ * ‖t 2‖ * ‖t 3‖ < ‖t 4‖) :
    ‖(WithLp.toLp 2 (fivePrefixValues t) :
      EuclideanSpace ℂ (Fin 4))‖ < ‖t 4‖ / 9 := by
  have hab : ‖t 0‖ ≤ ‖t 1‖ := hmon (by decide)
  have hbc : ‖t 1‖ ≤ ‖t 2‖ := hmon (by decide)
  have hcs : ‖t 2‖ ≤ ‖t 3‖ := hmon (by decide)
  have hsq := productFive_prefix_sq_lt_last_div_nine
    (‖t 0‖) (‖t 1‖) (‖t 2‖) (‖t 3‖) (‖t 4‖)
    (norm_nonneg _) hab hbc hcs hB hlarge
  let w : EuclideanSpace ℂ (Fin 4) :=
    WithLp.toLp 2 (fivePrefixValues t)
  have hwsq : ‖w‖^2 =
      ‖t 0‖^2 + ‖t 1‖^2 + ‖t 2‖^2 + ‖t 3‖^2 := by
    rw [EuclideanSpace.norm_sq_eq w, Fin.sum_univ_four]
    rfl
  have hdpos : 0 < ‖t 4‖/9 := by
    have hpos : 0 ≤ 2 * ‖t 1‖ * ‖t 2‖ * ‖t 3‖ := by positivity
    linarith only [hlarge,hpos]
  have hn : 0 ≤ ‖w‖ := norm_nonneg _
  change ‖w‖ < ‖t 4‖/9
  nlinarith only [hwsq, hsq, hn, hdpos]

end D1Bound5

namespace D1Bound5

/-- Symmetry turns the cross form into one involving the controlled inverse
vector. All norms are Euclidean, while the dot product is complex bilinear. -/
theorem productFive_cross_div_norm_lt_11_108
    (F : Matrix (Fin 4) (Fin 4) ℂ) (v w : Fin 4 → ℂ) (d : ℂ)
    (hd : d ≠ 0) (hsym : Fᵀ = F)
    (hw : ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ <
      ‖d‖ / 9)
    (hFv : ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) :
      EuclideanSpace ℂ (Fin 4))‖ < (11/12 : ℝ)) :
    ‖(v ⬝ᵥ (F⁻¹ *ᵥ w))/d‖ < (11/108 : ℝ) := by
  have hdot := productFive_bilinear_l2_le w (F⁻¹ *ᵥ v)
  have hcross : ‖w ⬝ᵥ (F⁻¹ *ᵥ v)‖ <
      (11/108 : ℝ) * ‖d‖ := by
    calc
      ‖w ⬝ᵥ (F⁻¹ *ᵥ v)‖ ≤
          ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ *
            ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) :
              EuclideanSpace ℂ (Fin 4))‖ := hdot
      _ ≤ ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ *
            (11/12 : ℝ) :=
          mul_le_mul_of_nonneg_left hFv.le (norm_nonneg _)
      _ < (‖d‖/9) * (11/12 : ℝ) :=
          mul_lt_mul_of_pos_right hw (by norm_num)
      _ = (11/108 : ℝ) * ‖d‖ := by ring
  rw [← symmetric_inverse_bilinear_swap F v w hsym, norm_div]
  exact (div_lt_iff₀ (norm_pos_iff.mpr hd)).mpr hcross

end D1Bound5

#print axioms D1Bound5.productFive_prefix_sq_lt_last_div_nine
#print axioms D1Bound5.productFive_prefix_l2_lt_last_div_nine
#print axioms D1Bound5.productFive_cross_div_norm_lt_11_108
#check @D1Bound5.productFive_prefix_sq_lt_last_div_nine
#check @D1Bound5.productFive_prefix_l2_lt_last_div_nine
#check @D1Bound5.productFive_cross_div_norm_lt_11_108
