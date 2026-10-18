import D1Bound5.ThreeAnchorAlternative
import D1Bound5.TwoSmallLargeSBound

namespace D1Bound5

theorem two_small_large_T_lower_window_impossible
    (B S T C : ℝ) (hB : 0 < B) (hB3 : B < 3) (hS : 0 < S)
    (hS8 : S < (10 : ℝ)^8) (hT : (10 : ℝ)^72 ≤ T) (hTC : T ≤ C) :
    ¬ C < 101*B^2*S^4/T := by
  have hB2 : B^2 < (3 : ℝ)^2 := by gcongr
  have hS4 : S^4 < ((10 : ℝ)^8)^4 := by gcongr
  have hnum : 101*B^2*S^4 < (10 : ℝ)^72 := by
    have hh := mul_lt_mul hB2 hS4 (by positivity : 0 < S^4) (by norm_num : (0 : ℝ) ≤ 3^2)
    norm_num at hh ⊢
    nlinarith only [hh]
  have hT0 : 0 < T := by norm_num at hT; linarith only [hT]
  have hbound : 101*B^2*S^4/T < 1 := by
    apply (div_lt_iff₀ hT0).2
    simpa only [one_mul] using hnum.trans_le hT
  intro hbad
  norm_num at hT
  linarith only [hbad,hbound,hTC,hT]

theorem two_small_large_T_quadratic_parameters
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 1 ≤ B) (hB3 : B < 3)
    (hS : 3 ≤ S) (hT : (10 : ℝ)^72 ≤ T)
    (hC : 5*A*B*S*T^2 < C) (hD : 2*S*T*C < D) :
    1000 ≤ C ∧ 4*T ≤ C ∧ 4*C ≤ D ∧
      32*B*S*T/A^3 ≤ C^2 ∧ 101*B^2*T^4/C < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS]
  have hT0 : 0 < T := by norm_num at hT; linarith only [hT]
  have hAB : 1 ≤ A*B := by
    have hh := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 1) hA0.le
    simpa only [one_mul] using hh
  have hCsmall : 5*S*T^2 < C := by
    have hh := mul_le_mul_of_nonneg_right hAB (by positivity : 0 ≤ 5*S*T^2)
    nlinarith only [hh,hC]
  have hC0 : 0 < C := by nlinarith only [hCsmall,mul_pos hS0 (sq_pos_of_pos hT0)]
  have hST : 3*(10 : ℝ)^72 ≤ S*T :=
    mul_le_mul hS hT (by positivity) hS0.le
  have hST2 : 3*((10 : ℝ)^72)^2 ≤ S*T^2 := by gcongr
  have hCsq : 25*S^2*T^4 < C^2 := by
    have hh := mul_pos (sub_pos.mpr hCsmall) (by positivity : 0 < C+5*S*T^2)
    nlinarith only [hh]
  have hC1000 : 1000 ≤ C := by norm_num at hST2; nlinarith only [hST2,hCsmall]
  have h4TC : 4*T ≤ C := by
    have hh := mul_le_mul_of_nonneg_right hST hT0.le
    norm_num at hh
    nlinarith only [hh,hCsmall,hT0]
  have h4CD : 4*C ≤ D := by
    have hh := mul_le_mul_of_nonneg_right hST hC0.le
    norm_num at hh
    nlinarith only [hh,hD,hC0]
  have hA3 : 1 ≤ A^3 := by calc
    1 = (1 : ℝ)^3 := by norm_num
    _ ≤ A^3 := by gcongr
  have hsize : 32*B*S*T/A^3 ≤ C^2 := by
    have hT3 : (10 : ℝ)^216 ≤ T^3 := by
      have hh : ((10 : ℝ)^72)^3 ≤ T^3 := by gcongr
      norm_num at hh ⊢
      exact hh
    have hST3 : 3*(10 : ℝ)^216 ≤ S*T^3 := mul_le_mul hS hT3 (by positivity) hS0.le
    have hh := mul_le_mul_of_nonneg_right hST3 (mul_nonneg hS0.le hT0.le)
    have hBprod := mul_lt_mul_of_pos_right hB3 (mul_pos hS0 hT0)
    have hAC := mul_le_mul_of_nonneg_right hA3 (sq_nonneg C)
    apply (div_le_iff₀ (by positivity : 0 < A^3)).2
    norm_num at hh
    nlinarith only [hh,hBprod,hAC,hCsq,mul_nonneg hS0.le hT0.le]
  have hwindow : 101*B^2*T^4/C < D := by
    have hSTbig : 100 ≤ S*T := by norm_num at hST; linarith only [hST]
    have hS2 : 9 ≤ S^2 := by nlinarith only [hS,sq_nonneg (S-3)]
    have hB2 : B^2 < (3 : ℝ)^2 := by gcongr
    have hcscaled := mul_lt_mul_of_pos_left hCsq (by positivity : 0 < 2*S*T)
    have hbig := mul_le_mul hSTbig hS2 (by norm_num : (0 : ℝ) ≤ 9) (by positivity : 0 ≤ S*T)
    have hbig' := mul_le_mul_of_nonneg_right hbig (by positivity : 0 ≤ T^4)
    have hBscaled := mul_lt_mul_of_pos_right hB2 (by positivity : 0 < T^4)
    have hdscaled := mul_lt_mul_of_pos_right hD hC0
    apply (div_lt_iff₀ hC0).2
    nlinarith only [hcscaled,hbig',hBscaled,hdscaled,pow_pos hT0 4]
  exact ⟨hC1000,h4TC,h4CD,hsize,hwindow⟩

theorem two_small_large_T_quadratic_eighth
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 1 ≤ B) (hS : 3 ≤ S) (hT : 0 < T)
    (hC : 5*A*B*S*T^2 < C) (hV : (2/5 : ℝ)*A^2*C^5/T^2 < D) :
    T^8 < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS]
  have hAB : 1 ≤ A*B := by
    have hh := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 1) hA0.le
    simpa only [one_mul] using hh
  have hCsmall : 5*S*T^2 < C := by
    have hh := mul_le_mul_of_nonneg_right hAB (by positivity : 0 ≤ 5*S*T^2)
    nlinarith only [hh,hC]
  have hC0 : 0 < C := (by positivity : 0 < 5*S*T^2).trans hCsmall
  have hc5 : (5*S*T^2)^5 < C^5 := by gcongr
  have hA2 : (1 : ℝ) ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hscaled := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ C^5)
  have hs5 : (3 : ℝ)^5 ≤ S^5 := by gcongr
  have hsprod := mul_le_mul_of_nonneg_right hs5 (by positivity : 0 ≤ T^10)
  have hcompare : T^8 < (2/5 : ℝ)*A^2*C^5/T^2 := by
    apply (lt_div_iff₀ (sq_pos_of_pos hT)).2
    nlinarith only [hc5,hscaled,hsprod,pow_pos hT 10]
  exact hcompare.trans hV

theorem two_small_large_T_quintic_eighth
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 1 ≤ B) (hS : 0 < S)
    (hS8 : S < (10 : ℝ)^8) (hT : 0 < T)
    (hC : A^2*T^5/(37*S^2) < C) (hcross : A^3*B*T^3*C/(7*S) < D) :
    T^8/(10 : ℝ)^27 < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hC0 : 0 < C := (by positivity : 0 < A^2*T^5/(37*S^2)).trans hC
  have hA2 : (1 : ℝ) ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hA3 : 1 ≤ A^3 := by calc
    1 = (1 : ℝ)^3 := by norm_num
    _ ≤ A^3 := by gcongr
  have hA3B : 1 ≤ A^3*B := by
    have hh := mul_le_mul hA3 hB (by norm_num : (0 : ℝ) ≤ 1) (by positivity : 0 ≤ A^3)
    simpa only [one_mul] using hh
  have hCweak : T^5/(37*S^2) < C := by
    apply lt_of_le_of_lt _ hC
    apply div_le_div_of_nonneg_right _ (by positivity)
    have hh := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ T^5)
    simpa only [one_mul] using hh
  have hcrossweak : T^3*C/(7*S) < D := by
    apply lt_of_le_of_lt _ hcross
    apply div_le_div_of_nonneg_right _ (by positivity)
    have hh := mul_le_mul_of_nonneg_right hA3B (by positivity : 0 ≤ T^3*C)
    nlinarith only [hh]
  have hproduct : T^8/(259*S^3) < D := by
    calc
      _ = (T^3/(7*S))*(T^5/(37*S^2)) := by field_simp; ring
      _ < (T^3/(7*S))*C := mul_lt_mul_of_pos_left hCweak (by positivity)
      _ = T^3*C/(7*S) := by ring
      _ < D := hcrossweak
  have hS3 : S^3 < ((10 : ℝ)^8)^3 := by gcongr
  have hden : 259*S^3 < (10 : ℝ)^27 := by norm_num at hS3 ⊢; nlinarith only [hS3]
  exact (div_lt_div_of_pos_left (pow_pos hT 8) (by positivity : 0 < 259*S^3) hden).trans hproduct

end D1Bound5
