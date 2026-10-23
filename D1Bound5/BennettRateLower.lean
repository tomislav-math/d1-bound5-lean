import D1Bound5.BennettTwoResidualRate

namespace D1Bound5

/-- The exact elementary comparison underlying the paper's lower bound
for the two-anchor exponential rate. -/
theorem bennett_two_rate_scalar_lower (T : ℝ) (hT : 1000 ≤ T) :
    128 * T ^ 2 < 135 * (T - 1) ^ 2 := by
  have hp := mul_nonneg (sub_nonneg.mpr hT) (show 0 ≤ T by linarith only [hT])
  nlinarith only [hT, hp]

/-- The actual residual rate exceeds the manuscript's simpler quadratic
rate. Only the triangle-inequality bound on the node separation is used. -/
theorem bennettTwoResidualRate_lower (A B C δ : ℝ)
    (hA : 0 < A) (hB : 0 < B) (hδ : 0 < δ)
    (hAB : A ≤ B) (hδAB : δ ≤ A + B) (hAC : 1000 ≤ A * C) :
    2 * A * C ^ 2 / (5 * B) < bennettTwoResidualRate A B C δ := by
  have hδle : δ ≤ 2 * B := by linarith only [hAB, hδAB]
  have hδsq : δ ^ 2 ≤ 4 * B ^ 2 := by
    have hp := mul_nonneg (sub_nonneg.mpr hδle)
      (show 0 ≤ 2 * B + δ by positivity)
    nlinarith only [hp]
  have hden : 16 * A * δ ^ 2 ≤ 64 * A * B ^ 2 := by
    have hp := mul_le_mul_of_nonneg_left hδsq (show 0 ≤ 16 * A by positivity)
    nlinarith only [hp]
  have hmin : 27 * B * (A * C - 1) ^ 2 / (64 * A * B ^ 2) ≤
      bennettTwoResidualRate A B C δ := by
    unfold bennettTwoResidualRate
    exact div_le_div_of_nonneg_left (by positivity) (by positivity) hden
  apply lt_of_lt_of_le _ hmin
  apply (div_lt_div_iff₀ (show 0 < 5 * B by positivity)
    (show 0 < 64 * A * B ^ 2 by positivity)).mpr
  have hp := mul_lt_mul_of_pos_left (bennett_two_rate_scalar_lower (A * C) hAC)
    (show 0 < B ^ 2 by positivity)
  nlinarith only [hp]

/-- Instantiation with the actual anchor norms and their actual complex
separation. The separation estimate is derived by the triangle inequality. -/
theorem bennettTwoResidualRate_norm_lower (a b c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hAB : ‖a‖ ≤ ‖b‖) (hAC : 1000 ≤ ‖a‖ * ‖c‖) :
    2 * ‖a‖ * ‖c‖ ^ 2 / (5 * ‖b‖) <
      bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖ :=
  bennettTwoResidualRate_lower ‖a‖ ‖b‖ ‖c‖ ‖a - b‖
    (norm_pos_iff.mpr ha) (norm_pos_iff.mpr hb)
    (norm_pos_iff.mpr (sub_ne_zero.mpr hab)) hAB (norm_sub_le a b) hAC

end D1Bound5
