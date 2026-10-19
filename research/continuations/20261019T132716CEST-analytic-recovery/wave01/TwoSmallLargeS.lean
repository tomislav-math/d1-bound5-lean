import D1Bound5.TwoSmallTupleInputs

namespace D1Bound5

/-- Exact size checks for the separated V window when the third entry
is at least 10^8. The deliberately weaker C>ST/4 simplifies the scalar
closure without changing the final cutoff. -/
theorem two_small_large_S_parameters
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 1 ≤ B) (hB3 : B < 3)
    (hS : (10 : ℝ)^8 ≤ S) (hST : S ≤ T)
    (hC : (3/8 : ℝ)*A*S*T < C) (hD : 2*S*T*C < D)
    (hcross : A^3*B*T^3*C/(7*S) < D) :
    1000 ≤ C ∧ 4*T ≤ C ∧ 4*C ≤ D ∧
      32*B*S*T/A^3 ≤ C^2 ∧ 101*B^2*T^4/C < D := by
  have hS0 : 0 < S := by norm_num at hS; linarith only [hS]
  have hT0 : 0 < T := hS0.trans_le hST
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hA3 : 1 ≤ A^3 := by calc
    1 = (1 : ℝ)^3 := by norm_num
    _ ≤ A^3 := by gcongr
  have hprod : (10 : ℝ)^16 ≤ S*T := by
    have hh := mul_le_mul hS (hS.trans hST) (by positivity : (0 : ℝ) ≤ 10^8) hS0.le
    norm_num at hh ⊢
    exact hh
  have hC4 : S*T < 4*C := by
    have hh := mul_le_mul_of_nonneg_right hA (mul_nonneg hS0.le hT0.le)
    have hp := mul_pos hS0 hT0
    nlinarith only [hC,hh,hp]
  have hC0 : 0 < C := by nlinarith only [hC4,mul_pos hS0 hT0]
  have hCsq : S^2*T^2 < 16*C^2 := by
    have hh := mul_pos (sub_pos.mpr hC4) (by positivity : 0 < 4*C+S*T)
    nlinarith only [hh]
  have hSTC : 1000 ≤ C := by norm_num at hprod; nlinarith only [hprod,hC4]
  have hTC : 4*T ≤ C := by
    have hh := mul_le_mul_of_nonneg_right hS hT0.le
    norm_num at hh
    nlinarith only [hh,hC4,hT0]
  have hCD : 4*C ≤ D := by
    have hh := mul_le_mul_of_nonneg_right hprod hC0.le
    norm_num at hh
    nlinarith only [hh,hD,hC0]
  have hsize : 32*B*S*T/A^3 ≤ C^2 := by
    have hSTbig : 1536*S*T ≤ S^2*T^2 := by
      have hh := mul_le_mul_of_nonneg_right hprod (mul_nonneg hS0.le hT0.le)
      norm_num at hh
      nlinarith only [hh,mul_nonneg hS0.le hT0.le]
    have hBprod := mul_lt_mul_of_pos_right hB3 (mul_pos hS0 hT0)
    have hAC := mul_le_mul_of_nonneg_right hA3 (sq_nonneg C)
    apply (div_le_iff₀ (by positivity : 0 < A^3)).2
    nlinarith only [hCsq,hSTbig,hBprod,hAC]
  have hwindow : 101*B^2*T^4/C < D := by
    have hSTbig : 33936*S*T < S^2*T^2 := by
      have hh := mul_le_mul_of_nonneg_right hprod (mul_nonneg hS0.le hT0.le)
      norm_num at hh
      nlinarith only [hh,mul_pos hS0 hT0]
    have hBprod := mul_lt_mul_of_pos_right hB3 (mul_pos hS0 hT0)
    have hAC := mul_le_mul_of_nonneg_right hA3 (sq_nonneg C)
    have hcore : 707*B*S*T < A^3*C^2 := by
      nlinarith only [hSTbig,hBprod,hAC,hCsq]
    have hm := mul_lt_mul_of_pos_right hcore (by positivity : 0 < B*T^3)
    have hcompare : 101*B^2*T^4/C < A^3*B*T^3*C/(7*S) := by
      apply (div_lt_div_iff₀ hC0 (by positivity : 0 < 7*S)).2
      nlinarith only [hm]
    exact hcompare.trans hcross
  exact ⟨hSTC,hTC,hCD,hsize,hwindow⟩

/-- Once the V window is exited on its upper side, the eighth-power
growth follows by elementary positive-power comparisons. -/
theorem two_small_large_S_eighth_power
    (A S T C D : ℝ) (hA : 1 ≤ A) (hS : 0 < S) (hST : S ≤ T)
    (hC : (3/8 : ℝ)*A*S*T < C)
    (hV : (2/5 : ℝ)*A^2*C^5/T^2 < D) :
    S^8/(10 : ℝ)^4 < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hT : 0 < T := hS.trans_le hST
  have hC4 : S*T/4 < C := by
    have hh := mul_le_mul_of_nonneg_right hA (mul_nonneg hS.le hT.le)
    nlinarith only [hC,hh,mul_pos hS hT]
  have hC0 : 0 < C := (by positivity : 0 < S*T/4).trans hC4
  have hC5 : (S*T/4)^5 < C^5 := by gcongr
  have hA2 : (1 : ℝ) ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hmain : S^5*T^3/2560 < (2/5 : ℝ)*A^2*C^5/T^2 := by
    have hscaled := mul_lt_mul_of_pos_left hC5 (by norm_num : (0 : ℝ) < 2/5)
    have hscaled' := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ (2/5 : ℝ)*C^5)
    apply (lt_div_iff₀ (sq_pos_of_pos hT)).2
    nlinarith only [hscaled,hscaled']
  have hST3 : S^3 ≤ T^3 := by gcongr
  have hS8 : S^8 ≤ S^5*T^3 := by
    have hh := mul_le_mul_of_nonneg_left hST3 (by positivity : 0 ≤ S^5)
    nlinarith only [hh]
  have hsmall : S^8/(10 : ℝ)^4 < S^5*T^3/2560 := by
    norm_num
    nlinarith only [hS8,pow_pos hS 8]
  exact hsmall.trans (hmain.trans hV)

end D1Bound5
