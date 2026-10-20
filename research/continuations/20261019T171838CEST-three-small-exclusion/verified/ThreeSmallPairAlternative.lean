import D1Bound5.ThreeAnchorDetailedAlternative

open scoped NumberField
open Module

namespace D1Bound5

theorem three_small_pair_alternative_scalar
    (A B S P Q : ℝ) (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S) (hS : S < 3)
    (hP : 1000 ≤ P) (hPQ : P ≤ Q)
    (halt : (5*A*B*S*P^2 < Q ∧ Q < 15*A*B*S*P^2) ∨
      Q < 101*B^2*S^4/P ∨ A^2*P^5/(37*S^2) < Q) :
    (5*P^2 < Q ∧ Q < 405*P^2) ∨ P^5/400 < Q := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := hA0.trans_le hAB
  have hS0 : 0 < S := hB0.trans_le hBS
  have hB : 1 ≤ B := hA.trans hAB
  have hS1 : 1 ≤ S := hB.trans hBS
  have hA3 : A < 3 := (hAB.trans hBS).trans_lt hS
  have hB3 : B < 3 := hBS.trans_lt hS
  have hP0 : 0 < P := by linarith only [hP]
  rcases halt with hzero | hlow | hhigh
  · left
    have hAB1 : 1 ≤ A*B := by
      have hh := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 1) hA0.le
      simpa only [one_mul] using hh
    have hV : 1 ≤ A*B*S := by
      have hh := mul_le_mul hAB1 hS1 (by norm_num : (0 : ℝ) ≤ 1) (by positivity : 0 ≤ A*B)
      simpa only [one_mul] using hh
    have hV27 : A*B*S < 27 := by
      calc
        _ < (3 : ℝ)*3*3 := by gcongr
        _ = _ := by norm_num
    have hlo := mul_le_mul_of_nonneg_right hV (sq_nonneg P)
    have hhi := mul_lt_mul_of_pos_right hV27 (sq_pos_of_pos hP0)
    constructor <;> nlinarith only [hzero.1,hzero.2,hlo,hhi]
  · have hcoeff : B^2*S^4 < (3 : ℝ)^2*3^4 := by gcongr
    have hh := (lt_div_iff₀ hP0).1 hlow
    have hPQ' := mul_le_mul_of_nonneg_right hPQ hP0.le
    have hP2 : (1000 : ℝ)^2 ≤ P^2 := by gcongr
    norm_num at hcoeff hP2
    exact False.elim (by nlinarith only [hcoeff,hh,hPQ',hP2])
  · right
    have hA2 : 1 ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
    have hS2 : S^2 < (3 : ℝ)^2 := by gcongr
    have hcompare : P^5/400 < A^2*P^5/(37*S^2) := by
      apply (div_lt_div_iff₀ (by norm_num : (0 : ℝ) < 400) (by positivity)).2
      have hh := mul_lt_mul_of_pos_right hS2 (pow_pos hP0 5)
      have hh' := mul_le_mul_of_nonneg_right hA2 (by positivity : 0 ≤ P^5)
      nlinarith only [hh,hh',pow_pos hP0 5]
    exact hcompare.trans hhigh

/-- For three small anchors, every ordered pair of large extensions
lies either in the quadratic zero-form window or above a quintic gap.
The weaker coefficient1/400 avoids unnecessary numerical refinement. -/
theorem IsD1Tuple.three_small_pair_alternative
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (hP : 1000 ≤ ‖phi (a 3 : K)‖) :
    (5*‖phi (a 3 : K)‖^2 < ‖phi (a 4 : K)‖ ∧
      ‖phi (a 4 : K)‖ < 405*‖phi (a 3 : K)‖^2) ∨
      ‖phi (a 3 : K)‖^5/400 < ‖phi (a 4 : K)‖ := by
  have hA : 1 ≤ ‖phi (a 0 : K)‖ := one_le_norm_integer hK phi (ha.2.1 0)
  have hSP : 4*‖phi (a 2 : K)‖ ≤ ‖phi (a 3 : K)‖ := by linarith only [hS,hP]
  exact three_small_pair_alternative_scalar
    ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖ ‖phi (a 2 : K)‖ ‖phi (a 3 : K)‖ ‖phi (a 4 : K)‖
    hA (hmon (by decide)) (hmon (by decide)) hS hP (hmon (by decide))
    (ha.three_anchor_general_detailed_alternative hK phi a hmon hP hSP)

theorem three_small_pair_growth (P Q : ℝ) (hP : 1000 ≤ P)
    (halt : (5*P^2 < Q ∧ Q < 405*P^2) ∨ P^5/400 < Q) : 5*P^2 < Q := by
  rcases halt with h | h
  · exact h.1
  · have hP0 : 0 < P := by linarith only [hP]
    have hP3 : (1000 : ℝ)^3 ≤ P^3 := by gcongr
    have hh := mul_le_mul_of_nonneg_right hP3 (sq_nonneg P)
    norm_num at hh
    have hp : 0 < P^2 := sq_pos_of_pos hP0
    nlinarith only [h,hh,hp]

end D1Bound5
