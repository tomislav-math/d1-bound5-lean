import D1Bound5.FullRingDirectFour
import D1Bound5.TwoSmallLargeTBound

namespace D1Bound5

theorem two_small_large_C_V_parameters
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 1 ≤ B) (hB3 : B < 3)
    (hS : 3 ≤ S) (hST : S ≤ T) (hS8 : S < (10 : ℝ)^8) (hT8 : T < (10 : ℝ)^8)
    (hC : (10 : ℝ)^100 ≤ C) (hD : 2*S*T*C < D) :
    1000 ≤ C ∧ 4*T ≤ C ∧ 4*C ≤ D ∧
      32*B*S*T/A^3 ≤ C^2 ∧ 101*B^2*T^4/C < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS]
  have hT0 : 0 < T := hS0.trans_le hST
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hC2 : (10 : ℝ)^200 ≤ C^2 := by
    have hh : ((10 : ℝ)^100)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hST9 : 9 ≤ S*T := mul_le_mul hS (hS.trans hST) (by norm_num) hS0.le
  have hCD : 4*C ≤ D := by
    have hh := mul_le_mul_of_nonneg_right hST9 hC0.le
    nlinarith only [hh,hD,hC0]
  have hsize : 32*B*S*T/A^3 ≤ C^2 := by
    have hprod : B*S*T < 3*((10 : ℝ)^8)^2 := by gcongr
    have hA3 : 1 ≤ A^3 := by calc
      1 = (1 : ℝ)^3 := by norm_num
      _ ≤ A^3 := by gcongr
    have hh := mul_le_mul_of_nonneg_right hA3 (sq_nonneg C)
    apply (div_le_iff₀ (by positivity : 0 < A^3)).2
    norm_num at hprod hC2
    nlinarith only [hh,hprod,hC2]
  have hwindow : 101*B^2*T^4/C < D := by
    have hprod : B^2*T^4 < (3 : ℝ)^2*((10 : ℝ)^8)^4 := by gcongr
    have hsmall : 101*B^2*T^4/C < 1 := by
      apply (div_lt_iff₀ hC0).2
      norm_num at hprod hC
      nlinarith only [hprod,hC]
    norm_num at hC
    linarith only [hsmall,hCD,hC]
  refine ⟨?_,?_,hCD,hsize,hwindow⟩
  · norm_num at hC; linarith only [hC]
  · norm_num at hC hT8; linarith only [hC,hT8]

theorem two_small_large_C_direct_four_parameters
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hAB : A ≤ B) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hT : 0 < T) (hS8 : S < (10 : ℝ)^8) (hT8 : T < (10 : ℝ)^8)
    (hC : (10 : ℝ)^100 ≤ C) (hV : (2/5 : ℝ)*A^2*C^5/T^2 < D) :
    1000*C ≤ D ∧ 17*A*B*S*T*C^3 ≤ D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hA2 : 1 ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hT2 : T^2 < ((10 : ℝ)^8)^2 := by gcongr
  have hC2 : (10 : ℝ)^200 ≤ C^2 := by
    have hh : ((10 : ℝ)^100)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hD5 : C^5/(3*(10 : ℝ)^16) < D := by
    apply lt_trans _ hV
    apply (div_lt_div_iff₀ (by positivity) (sq_pos_of_pos hT)).2
    have hh := mul_lt_mul_of_pos_left hT2 (by positivity : 0 < C^5)
    have hh' := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ C^5)
    norm_num at hh
    nlinarith only [hh,hh',pow_pos hC0 5]
  have hbig : (10 : ℝ)^20*C^3 < D := by
    apply lt_trans _ hD5
    apply (lt_div_iff₀ (by positivity : (0 : ℝ) < 3*10^16)).2
    have hh := mul_le_mul_of_nonneg_right hC2 (by positivity : 0 ≤ C^3)
    norm_num at hh ⊢
    nlinarith only [hh,pow_pos hC0 3]
  constructor
  · have hh := mul_le_mul_of_nonneg_right hC2 hC0.le
    norm_num at hh hbig
    nlinarith only [hh,hbig,hC0]
  · have hprod : A*B*S*T < 9*((10 : ℝ)^8)^2 := by
      calc
        _ ≤ B*B*S*T := by gcongr
        _ < 3*3*((10 : ℝ)^8)*((10 : ℝ)^8) := by gcongr
        _ = _ := by ring
    have hh := mul_lt_mul_of_pos_right hprod (by positivity : 0 < C^3)
    norm_num at hh hbig
    nlinarith only [hh,hbig,pow_pos hC0 3]

/-- The actual direct-four inequality forces seventh-power terminal
growth in the remaining small-anchor box. -/
theorem two_small_large_C_seventh_power
    (A B S T C D Z : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hT : 0 < T) (hS8 : S < (10 : ℝ)^8) (hT8 : T < (10 : ℝ)^8)
    (hC : (10 : ℝ)^100 ≤ C) (hZ : 0 < Z) (hCZ : C/2 < Z)
    (hroot : Z^2 ≤ 2*C*D)
    (hform : 1 < 13*B*S^2*T^3/Z+49*S*T^2*Z/(50*A*C^4)) :
    C^7/(10 : ℝ)^50 < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hfirst : 13*B*S^2*T^3/Z < (1/2 : ℝ) := by
    have hcoeff : B*S^2*T^3 < 3*((10 : ℝ)^8)^5 := by
      calc
        _ < 3*((10 : ℝ)^8)^2*((10 : ℝ)^8)^3 := by gcongr
        _ = _ := by ring
    apply (div_lt_iff₀ hZ).2
    norm_num at hcoeff hC
    nlinarith only [hcoeff,hCZ,hC]
  have hsecond : (1/2 : ℝ) < 49*S*T^2*Z/(50*A*C^4) := by
    linarith only [hform,hfirst]
  have hcoeff : S*T^2 < ((10 : ℝ)^8)^3 := by
    calc
      _ < ((10 : ℝ)^8)*((10 : ℝ)^8)^2 := by gcongr
      _ = _ := by ring
  have hclear := (lt_div_iff₀ (by positivity : 0 < 50*A*C^4)).1 hsecond
  have hcoefZ := mul_lt_mul_of_pos_right hcoeff hZ
  have hAclear := mul_le_mul_of_nonneg_right hA (by positivity : 0 ≤ C^4)
  have hZlower : C^4 < 2*(10 : ℝ)^24*Z := by
    norm_num at hcoefZ
    nlinarith only [hclear,hcoefZ,hAclear,pow_pos hC0 4]
  have hsq : C^8 < 4*(10 : ℝ)^48*Z^2 := by
    have hh := mul_pos (sub_pos.mpr hZlower) (by positivity : 0 < 2*(10 : ℝ)^24*Z+C^4)
    norm_num at hh ⊢
    nlinarith only [hh]
  have hscaled := mul_le_mul_of_nonneg_left hroot (by positivity : (0 : ℝ) ≤ 4*10^48)
  have hD0 : 0 < D := by nlinarith only [hroot,sq_pos_of_pos hZ,hC0]
  apply (div_lt_iff₀ (by positivity : (0 : ℝ) < 10^50)).2
  apply (mul_lt_mul_iff_of_pos_left hC0).1
  norm_num at hsq hscaled ⊢
  nlinarith only [hsq,hscaled,mul_pos hC0 hD0]

end D1Bound5
