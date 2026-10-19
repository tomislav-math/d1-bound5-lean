import D1Bound5.OrdinaryLog10

namespace D1Bound5

/-- The common ordinary two-anchor envelope when both anchors have
modulus below three. -/
noncomputable def twoSmallHeightEnvelope (x : ℝ) : ℝ :=
  7*x+212/5+(4047/25)/(x-4)

theorem twoSmallHeightEnvelope_lt_389 (x : ℝ) (hlo : 8 ≤ x) (hhi : x ≤ 49) :
    twoSmallHeightEnvelope x < 389 := by
  have hx : 0 < x-4 := by linarith only [hlo]
  have hp := mul_nonneg (sub_nonneg.mpr hlo) (sub_nonneg.mpr hhi)
  have hnum : (4047/25 : ℝ) < (389-(7*x+212/5))*(x-4) := by
    nlinarith only [hp,hlo,hhi]
  have hd := (div_lt_iff₀ hx).2 hnum
  dsimp [twoSmallHeightEnvelope]
  linarith only [hd]

theorem twoSmallHeightEnvelope_lt_549 (x : ℝ) (hlo : 8 ≤ x) (hhi : x ≤ 72) :
    twoSmallHeightEnvelope x < 549 := by
  have hx : 0 < x-4 := by linarith only [hlo]
  have hp := mul_nonneg (sub_nonneg.mpr hlo) (sub_nonneg.mpr hhi)
  have hnum : (4047/25 : ℝ) < (549-(7*x+212/5))*(x-4) := by
    nlinarith only [hp,hlo,hhi]
  have hd := (div_lt_iff₀ hx).2 hnum
  dsimp [twoSmallHeightEnvelope]
  linarith only [hd]

/-- The two large-entry contradictions use only monotonicity of a
positive reciprocal, with exact rational endpoint margins. -/
theorem twoSmallHeightEnvelope_lt_eight_mul_sub_three
    (x : ℝ) (hx : 49 ≤ x) : twoSmallHeightEnvelope x < 8*x-3 := by
  have hr : (4047/25 : ℝ)/(x-4) ≤ (4047/25)/45 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith only [hx])
  dsimp [twoSmallHeightEnvelope]
  norm_num at hr
  linarith only [hr,hx]

theorem twoSmallHeightEnvelope_lt_eight_mul_sub_twenty_seven
    (x : ℝ) (hx : 72 ≤ x) : twoSmallHeightEnvelope x < 8*x-27 := by
  have hr : (4047/25 : ℝ)/(x-4) ≤ (4047/25)/68 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith only [hx])
  dsimp [twoSmallHeightEnvelope]
  norm_num at hr
  linarith only [hr,hx]

theorem twoSmallHeightEnvelope_lt_seven_mul_add_sixty
    (x : ℝ) (hx : 100 ≤ x) : twoSmallHeightEnvelope x < 7*x+60 := by
  have hr : (4047/25 : ℝ)/(x-4) ≤ (4047/25)/96 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith only [hx])
  dsimp [twoSmallHeightEnvelope]
  norm_num at hr
  linarith only [hr]

theorem ordinaryLog10_two_small_parameters :
    ordinaryLog10 1134 < (31/10 : ℝ) ∧
      -(9/10 : ℝ) < ordinaryLog10 (2/15) ∧
      ordinaryLog10 2277 < (17/5 : ℝ) := by
  have hH := ordinaryLog10_lt_of_pow_lt 1134 31 10 (by norm_num) (by norm_num)
  have hR := ordinaryLog10_lt_of_pow_lt (15/2) 9 10 (by norm_num) (by norm_num)
  have hU := ordinaryLog10_lt_of_pow_lt 2277 17 5 (by norm_num) (by norm_num)
  have hinv : ordinaryLog10 (2/15)+ordinaryLog10 (15/2) = 0 := by
    rw [← ordinaryLog10_mul (2/15) (15/2) (by norm_num) (by norm_num)]
    norm_num [ordinaryLog10]
  norm_num at hH hR hU
  exact ⟨by linarith only [hH],by linarith only [hR,hinv],by linarith only [hU]⟩

end D1Bound5
