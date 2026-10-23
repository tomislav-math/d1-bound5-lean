import D1Bound5.RetainedGapScalar

namespace D1Bound5

/-- The first summand of the actual four-anchor form is below one percent
after the retained five-entry growth has been established. -/
theorem retained_four_first_term_lt
    (A B S T C D Z : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hZ : 0 < Z)
    (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D)
    (hroot : (3999/4000 : ℝ)*C*D < Z^2) :
    13*B*S^2*T^3/Z < (1/100 : ℝ) := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := by linarith
  have hC0 : 0 < C := (by positivity : 0 < 16*B*S*T).trans hC
  have hC6 : (16*B*S*T)^6 < C^6 := by
    gcongr
  have hD' := (div_lt_iff₀ (pow_pos hS 2)).mp hD
  have hD'' := mul_lt_mul_of_pos_left hD'
    (by positivity : 0 < (3999/4000 : ℝ)*C)
  have hroot' := mul_lt_mul_of_pos_right hroot (pow_pos hS 2)
  have hC6' := mul_lt_mul_of_pos_left hC6
    (by positivity : 0 < (3999/4000 : ℝ)*A^2)
  have hbig : (3999/4000 : ℝ)*A^2*(16*B*S*T)^6 < Z^2*S^2 := by
    nlinarith only [hC6', hD'', hroot']
  have hAB : (729 : ℝ) ≤ A^2*B^4 := by
    calc
      (729 : ℝ) = 3^2*3^4 := by norm_num
      _ ≤ A^2*B^4 := by gcongr
  have hcoef : (10000*169 : ℝ) < (3999/4000 : ℝ)*16^6*(A^2*B^4) := by
    nlinarith only [hAB]
  have hcoef' := mul_lt_mul_of_pos_right hcoef
    (by positivity : 0 < B^2*S^6*T^6)
  have hsquare : (100*(13*B*S^2*T^3))^2 < Z^2 := by
    apply (mul_lt_mul_iff_of_pos_right (pow_pos hS 2)).mp
    nlinarith only [hcoef', hbig]
  have hlinear : 100*(13*B*S^2*T^3) < Z := by
    by_contra h
    have hh : Z ≤ 100*(13*B*S^2*T^3) := le_of_not_gt h
    have hp := mul_nonneg (sub_nonneg.mpr hh)
      (by positivity : 0 ≤ 100*(13*B*S^2*T^3)+Z)
    nlinarith only [hp, hsquare]
  apply (div_lt_iff₀ hZ).2
  nlinarith only [hlinear]

/-- Final retained-start scalar contradiction: the actual nonzero four-anchor
form forces the seventh-power terminal gap. Its assumptions are the concrete
form estimate and previously obtained fifth-power growth, not the conclusion. -/
theorem retained_four_start_scalar_gap
    (A B S T C D Z L : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hSC : S ≤ C) (hTC : T ≤ C)
    (hC1000 : 1000 < C) (hZ : 0 < Z)
    (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D)
    (hrootlo : (3999/4000 : ℝ)*C*D < Z^2)
    (hroothi : Z^2 ≤ C*D+1)
    (hL : 1 ≤ L)
    (hupper : L < 13*B*S^2*T^3/Z + (49/50 : ℝ)*S*T^2*Z/(A*C^4)) :
    A^2*C^7/(S^2*T^4) < D := by
  have hA0 : 0 < A := by linarith
  have hC0 : 0 < C := by linarith
  have hSn : S ≠ 0 := hS.ne'
  have hTn : T ≠ 0 := hT.ne'
  have hfirst := retained_four_first_term_lt A B S T C D Z
    hA hB hS hT hZ hC hD hrootlo
  have hsecond : (99/100 : ℝ) < (49/50 : ℝ)*S*T^2*Z/(A*C^4) := by
    linarith only [hL, hupper, hfirst]
  have hclean := (lt_div_iff₀ (by positivity : 0 < A*C^4)).mp hsecond
  let Y := A*C^4/(S*T^2)
  have hY : 0 < Y := by dsimp [Y]; positivity
  have hZlower : (99/98 : ℝ)*Y < Z := by
    dsimp [Y]
    rw [← mul_div_assoc]
    apply (div_lt_iff₀ (by positivity : 0 < S*T^2)).2
    nlinarith only [hclean]
  have hYC : C ≤ Y := by
    dsimp [Y]
    apply (le_div_iff₀ (by positivity : 0 < S*T^2)).2
    have hp : C*(S*T^2) ≤ C*(C*C^2) := by gcongr
    have hA1 : (1 : ℝ) ≤ A := by linarith
    have ha := mul_le_mul_of_nonneg_right hA1 (pow_nonneg hC0.le 4)
    nlinarith only [hp, ha]
  have hY1000 : 1000 < Y := hC1000.trans_le hYC
  have hYsquare : (1000000 : ℝ) < Y^2 := by
    nlinarith only [hY1000, sq_nonneg (Y-1000)]
  have hmargin : (1 : ℝ) < ((99/98 : ℝ)^2-1)*Y^2 := by
    nlinarith only [hYsquare]
  have hZsquare : (99/98 : ℝ)^2*Y^2 < Z^2 := by
    have hp := mul_pos (sub_pos.mpr hZlower)
      (by positivity : 0 < Z+(99/98 : ℝ)*Y)
    nlinarith only [hp]
  have hCD : Y^2 < C*D := by
    nlinarith only [hmargin, hZsquare, hroothi]
  apply (mul_lt_mul_iff_of_pos_left hC0).mp
  have heq : C*(A^2*C^7/(S^2*T^4)) = Y^2 := by
    dsimp [Y]
    field_simp [hSn, hTn]
  rw [heq]
  exact hCD

end D1Bound5
