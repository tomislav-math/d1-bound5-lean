import D1Bound5.FiveRegionParameters

namespace D1Bound5

/-- Exact distance envelope valid even when the two anchors are close.
The second maximum term handles the row whose cleared divisor is the
anchor rather than the anchor difference. -/
theorem finite_distance_max_norm_le_ratio (x y : ℂ) (r : ℝ) (n : ℕ)
    (hr : 0 ≤ r) (hn : 1 ≤ n) (hxy : ‖x‖ ≤ r*‖y‖) :
    max (‖x-y‖^n) (‖x‖*‖x-y‖^(n-1)) ≤ (1+r)^n*‖y‖^n := by
  have hbound : ‖x-y‖ ≤ (1+r)*‖y‖ := by
    have hh := norm_sub_le x y
    nlinarith only [hh,hxy]
  have hx : ‖x‖ ≤ (1+r)*‖y‖ := by nlinarith only [hxy,norm_nonneg y]
  have hbase : 0 ≤ (1+r)*‖y‖ := by positivity
  have hsum : 1+(n-1)=n := by omega
  apply max_le
  · simpa only [mul_pow] using pow_le_pow_left₀ (norm_nonneg (x-y)) hbound n
  · calc
      ‖x‖*‖x-y‖^(n-1) ≤ ((1+r)*‖y‖)*((1+r)*‖y‖)^(n-1) := by gcongr
      _ = ((1+r)*‖y‖)^n := by rw [← pow_succ']; congr 1; omega
      _ = (1+r)^n*‖y‖^n := mul_pow _ _ _

/-- All five finite residual rates are derived from actual anchor
moduli, with no lower bound on their separation. -/
theorem fiveRegion_distance_rates (region : Fin 5) (x y : ℂ)
    (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖) :
    (101/2560 : ℝ)*max (‖x-y‖^4) (‖x‖*‖x-y‖^3) ≤ fiveRegionN2Residual region*‖y‖^4 ∧
    (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤ fiveRegionN3Residual region*‖y‖^6 ∧
    (707/40960 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤ fiveRegionA3Residual region*‖y‖^6 ∧
    (6363/409600 : ℝ)*max (‖x-y‖^8) (‖x‖*‖x-y‖^7) ≤ fiveRegionA4Residual region*‖y‖^8 ∧
    (9999/2621440 : ℝ)*max (‖x-y‖^10) (‖x‖*‖x-y‖^9) ≤ fiveRegionA5Residual region*‖y‖^10 := by
  have hh (n : ℕ) (hn : 1 ≤ n) := finite_distance_max_norm_le_ratio x y
    (fiveRegionAnchorRatio region) n (fiveRegionAnchorRatio_nonneg region) hn hxy
  refine ⟨?_,?_,?_,?_,?_⟩
  · simpa only [fiveRegionN2Residual,mul_assoc] using
      mul_le_mul_of_nonneg_left (hh 4 (by decide)) (by norm_num : (0 : ℝ) ≤ 101/2560)
  · simpa only [fiveRegionN3Residual,mul_assoc] using
      mul_le_mul_of_nonneg_left (hh 6 (by decide)) (by norm_num : (0 : ℝ) ≤ 3535/409600)
  · simpa only [fiveRegionA3Residual,mul_assoc] using
      mul_le_mul_of_nonneg_left (hh 6 (by decide)) (by norm_num : (0 : ℝ) ≤ 707/40960)
  · simpa only [fiveRegionA4Residual,mul_assoc] using
      mul_le_mul_of_nonneg_left (hh 8 (by decide)) (by norm_num : (0 : ℝ) ≤ 6363/409600)
  · simpa only [fiveRegionA5Residual,mul_assoc] using
      mul_le_mul_of_nonneg_left (hh 10 (by decide)) (by norm_num : (0 : ℝ) ≤ 9999/2621440)

end D1Bound5
