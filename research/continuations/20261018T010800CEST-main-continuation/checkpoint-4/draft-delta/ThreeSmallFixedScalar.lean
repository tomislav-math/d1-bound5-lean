import D1Bound5.ThreeSmallLargeExtensions
import D1Bound5.FiniteQInterval

namespace D1Bound5

theorem three_small_fixed_V_parameters
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hS3 : S < 3) (hT : 0 < T) (hT85 : T < 85)
    (hC : (10 : ℝ)^40 ≤ C) (hD : 5*C^2 < D) :
    1000 ≤ C ∧ 4*T ≤ C ∧ 4*C ≤ D ∧
      32*B*S*T/A^3 ≤ C^2 ∧ 101*B^2*T^4/C < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hC2 : (10 : ℝ)^80 ≤ C^2 := by
    have hh : ((10 : ℝ)^40)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hC1000 : 1000 ≤ C := by norm_num at hC; linarith only [hC]
  have h4TC : 4*T ≤ C := by linarith only [hT85,hC1000]
  have h4CD : 4*C ≤ D := by nlinarith only [hD,hC1000,sq_nonneg (C-1000)]
  have hsize : 32*B*S*T/A^3 ≤ C^2 := by
    have hprod : B*S*T < (3 : ℝ)*3*85 := by gcongr
    have hA3 : 1 ≤ A^3 := by calc
      1 = (1 : ℝ)^3 := by norm_num
      _ ≤ A^3 := by gcongr
    have hh := mul_le_mul_of_nonneg_right hA3 (sq_nonneg C)
    apply (div_le_iff₀ (by positivity : 0 < A^3)).2
    norm_num at hprod hC2
    nlinarith only [hprod,hC2,hh]
  have hwindow : 101*B^2*T^4/C < D := by
    have hprod : B^2*T^4 < (3 : ℝ)^2*85^4 := by gcongr
    have hlow : 101*B^2*T^4/C < 1 := by
      apply (div_lt_iff₀ hC0).2
      norm_num at hprod hC
      nlinarith only [hprod,hC]
    nlinarith only [hlow,h4CD,hC1000]
  exact ⟨hC1000,h4TC,h4CD,hsize,hwindow⟩

theorem three_small_fixed_V_growth
    (A T C D : ℝ) (hA : 1 ≤ A) (hT : 0 < T) (hT85 : T < 85)
    (hC : (10 : ℝ)^40 ≤ C) (hV : (2/5 : ℝ)*A^2*C^5/T^2 < D) :
    (10 : ℝ)^38*C^3 < D := by
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hA2 : 1 ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hT2 : T^2 < (85 : ℝ)^2 := by gcongr
  have hD5 : C^5/20000 < D := by
    apply lt_trans _ hV
    apply (div_lt_div_iff₀ (by norm_num : (0 : ℝ) < 20000) (sq_pos_of_pos hT)).2
    have hh := mul_lt_mul_of_pos_right hT2 (by positivity : 0 < C^5)
    have hh' := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ C^5)
    nlinarith only [hh,hh',pow_pos hC0 5]
  have hC2 : (10 : ℝ)^80 ≤ C^2 := by
    have hh : ((10 : ℝ)^40)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hh := mul_le_mul_of_nonneg_right hC2 (by positivity : 0 ≤ C^3)
  norm_num at hh
  have hlow : (10 : ℝ)^38*C^3 < C^5/20000 := by
    norm_num
    nlinarith only [hh,pow_pos hC0 3]
  exact hlow.trans hD5

theorem three_small_fixed_upper_and_overlap (C D : ℝ) (hC : (10 : ℝ)^40 ≤ C)
    (hD : D < (10 : ℝ)^60*C^7) :
    D < C^11/(10 : ℝ)^22 ∧ (10 : ℝ)^40*C^5 ≤ C^7/(10 : ℝ)^29 := by
  have hC0 : 0 < C := by norm_num at hC; linarith only [hC]
  have hC4 : (10 : ℝ)^160 ≤ C^4 := by
    have hh : ((10 : ℝ)^40)^4 ≤ C^4 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hC2 : (10 : ℝ)^80 ≤ C^2 := by
    have hh : ((10 : ℝ)^40)^2 ≤ C^2 := by gcongr
    norm_num at hh ⊢
    exact hh
  constructor
  · apply lt_trans hD
    apply (lt_div_iff₀ (by positivity : (0 : ℝ) < 10^22)).2
    have hh := mul_le_mul_of_nonneg_right hC4 (by positivity : 0 ≤ C^7)
    norm_num at hh ⊢
    nlinarith only [hh,pow_pos hC0 7]
  · apply (le_div_iff₀ (by positivity : (0 : ℝ) < 10^29)).2
    have hh := mul_le_mul_of_nonneg_right hC2 (by positivity : 0 ≤ C^5)
    norm_num at hh ⊢
    nlinarith only [hh,pow_nonneg hC0.le 5]

theorem three_small_fixed_M_window_contains
    (A B S C : ℝ) (hA : 1 ≤ A) (hB : 0 < B) (hB3 : B < 3)
    (hS : 0 < S) (hS3 : S < 3) (hC : 0 < C) :
    4*((8/9 : ℝ)*608^2)^2*B^6*S^16*C^5/(1-1/4000 : ℝ) ≤ (10 : ℝ)^40*C^5 ∧
      C^11/(10 : ℝ)^22 ≤ A^6*C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) := by
  constructor
  · have hp : B^6*S^16 < (3 : ℝ)^22 := by
      calc
        _ < (3 : ℝ)^6*3^16 := by gcongr
        _ = _ := by norm_num
    have hh := mul_lt_mul_of_pos_right hp (by positivity : 0 < C^5)
    apply (div_le_iff₀ (by norm_num : (0 : ℝ) < 1-1/4000)).2
    norm_num at hh ⊢
    nlinarith only [hh,pow_nonneg hC.le 5]
  · have hp : B^4*S^10 < (3 : ℝ)^14 := by
      calc
        _ < (3 : ℝ)^4*3^10 := by gcongr
        _ = _ := by norm_num
    have hd : 4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ) ≤ (10 : ℝ)^22 := by
      norm_num at hp ⊢
      nlinarith only [hp]
    have hA6 : 1 ≤ A^6 := by calc
      1 = (1 : ℝ)^6 := by norm_num
      _ ≤ A^6 := by gcongr
    calc
      _ ≤ C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) :=
        div_le_div_of_nonneg_left (by positivity) (by positivity) hd
      _ ≤ _ := by
        apply div_le_div_of_nonneg_right _ (by positivity)
        have hh := mul_le_mul_of_nonneg_right hA6 (by positivity : 0 ≤ C^11)
        simpa only [one_mul] using hh

theorem three_small_fixed_Q_window_contains (C : ℝ) (hC : 0 < C) :
    4*55^2*85^6*C^3/(1-1/4000 : ℝ) ≤ (10 : ℝ)^38*C^3 ∧
      C^7/(10 : ℝ)^29 ≤ C^7/(9*85^2*(1+1/4000 : ℝ)) := by
  constructor
  · apply (div_le_iff₀ (by norm_num : (0 : ℝ) < 1-1/4000)).2
    norm_num
    nlinarith only [pow_nonneg hC.le 3]
  · exact div_le_div_of_nonneg_left (by positivity) (by norm_num) (by norm_num)

end D1Bound5
