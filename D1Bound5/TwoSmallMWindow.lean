import D1Bound5.TwoSmallHeightScalar
import Mathlib.Tactic

namespace D1Bound5

/-- The actual M endpoints contain the simple power window throughout
the remaining two-small box. These are exact rational comparisons. -/
theorem two_small_M_window_contains
    (A B S C : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hS8 : S < (10 : ℝ)^8) (hC : 0 < C) :
    4*((8/9 : ℝ)*608^2)^2*B^6*S^16*C^5/(1-1/4000 : ℝ) ≤ (10 : ℝ)^143*C^5 ∧
      C^11/(10 : ℝ)^87 ≤ A^6*C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) := by
  have hA0 : 0 < A := by linarith only [hA]
  constructor
  · have hb6 : B^6 < (3 : ℝ)^6 := by gcongr
    have hs16 : S^16 < ((10 : ℝ)^8)^16 := by gcongr
    have hh := mul_lt_mul hb6 hs16.le (by positivity : 0 < S^16) (by norm_num : (0 : ℝ) ≤ 3^6)
    have hcoef : 4*((8/9 : ℝ)*608^2)^2*B^6*S^16/(1-1/4000 : ℝ) ≤ (10 : ℝ)^143 := by
      apply (div_le_iff₀ (by norm_num : (0 : ℝ) < 1-1/4000)).2
      norm_num at hh ⊢
      nlinarith only [hh]
    have hmul := mul_le_mul_of_nonneg_right hcoef (by positivity : 0 ≤ C^5)
    simpa only [div_mul_eq_mul_div] using hmul
  · have hb4 : B^4 < (3 : ℝ)^4 := by gcongr
    have hs10 : S^10 < ((10 : ℝ)^8)^10 := by gcongr
    have hh := mul_lt_mul hb4 hs10.le (by positivity : 0 < S^10) (by norm_num : (0 : ℝ) ≤ 3^4)
    have hden : 4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ) < (10 : ℝ)^87 := by
      norm_num at hh ⊢
      nlinarith only [hh]
    have hA6 : 1 ≤ A^6 := by calc
      1 = (1 : ℝ)^6 := by norm_num
      _ ≤ A^6 := by gcongr
    calc
      C^11/(10 : ℝ)^87 ≤ C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) :=
        div_le_div_of_nonneg_left (by positivity) (by positivity) hden.le
      _ ≤ _ := by
        apply div_le_div_of_nonneg_right _ (by positivity)
        have hmul := mul_le_mul_of_nonneg_right hA6 (by positivity : 0 ≤ C^11)
        simpa only [one_mul] using hmul

theorem two_small_M_window_brackets
    (C D : ℝ) (hC : (10 : ℝ)^100 ≤ C)
    (hlow : C^7/(10 : ℝ)^50 < D)
    (hhigh : ordinaryLog10 D < twoSmallHeightEnvelope (ordinaryLog10 C))
    (hD : 0 < D) :
    (10 : ℝ)^143*C^5 ≤ D ∧ D ≤ C^11/(10 : ℝ)^87 := by
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hC2 : (10 : ℝ)^200 ≤ C^2 := by
    have hh : ((10 : ℝ)^100)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hx : 100 ≤ ordinaryLog10 C := by
    have hh := ordinaryLog10_mono (by positivity : (0 : ℝ) < 10^100) hC
    simpa only [ordinaryLog10_pow,ordinaryLog10_ten,Nat.cast_ofNat,mul_one] using hh
  have hlog : ordinaryLog10 D < ordinaryLog10 ((10 : ℝ)^60*C^7) := by
    have hh := hhigh.trans (twoSmallHeightEnvelope_lt_seven_mul_add_sixty (ordinaryLog10 C) hx)
    rw [ordinaryLog10_mul _ _ (by positivity) (by positivity),ordinaryLog10_pow,
      ordinaryLog10_pow,ordinaryLog10_ten]
    norm_num
    linarith only [hh]
  have hupper : D < (10 : ℝ)^60*C^7 := by
    by_contra hbad
    have hh := ordinaryLog10_mono (by positivity : 0 < (10 : ℝ)^60*C^7) (le_of_not_gt hbad)
    linarith only [hlog,hh]
  constructor
  · apply le_of_lt
    apply lt_trans _ hlow
    apply (lt_div_iff₀ (by positivity : (0 : ℝ) < 10^50)).2
    have hh := mul_le_mul_of_nonneg_right hC2 (by positivity : 0 ≤ C^5)
    norm_num at hh ⊢
    nlinarith only [hh,pow_pos hC0 5]
  · apply le_of_lt
    apply lt_trans hupper
    apply (lt_div_iff₀ (by positivity : (0 : ℝ) < 10^87)).2
    have hC4 : (10 : ℝ)^400 ≤ C^4 := by
      have hh : ((10 : ℝ)^100)^4 ≤ C^4 := by gcongr
      simpa only [← pow_mul] using hh
    have hconst : (10 : ℝ)^147 < 10^400 :=
      pow_lt_pow_right₀ (by norm_num : (1 : ℝ) < 10) (by decide : 147 < 400)
    calc
      (10 : ℝ)^60*C^7*10^87 = (10 : ℝ)^147*C^7 := by rw [mul_right_comm, ← pow_add]
      _ < (10 : ℝ)^400*C^7 := mul_lt_mul_of_pos_right hconst (pow_pos hC0 7)
      _ ≤ C^4*C^7 := mul_le_mul_of_nonneg_right hC4 (by positivity)
      _ = C^11 := by rw [← pow_add]

end D1Bound5
