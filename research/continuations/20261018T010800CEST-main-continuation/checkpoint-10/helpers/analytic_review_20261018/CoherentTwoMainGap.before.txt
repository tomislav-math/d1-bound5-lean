import D1Bound5.CoherentTwoGap

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The two main size regimes already imply the analytic parameter
conditions used by the strong two-anchor gap. -/
theorem coherent_two_main_size_parameters
    (A B P Q : ℝ) (hA : 1 ≤ A) (hAB : A ≤ B) (hB : 3 ≤ B)
    (hP : 5 * B ≤ P) (hQ : 5 * A * B * P ≤ Q)
    (hlarge : 3 ≤ A ∨ 48 ≤ P) :
    32 ≤ A * P ∧ 10000 < P * Q := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := by linarith
  have hP15 : 15 ≤ P := by linarith
  have hP0 : 0 < P := by linarith
  have hPQ : 5 * (A * B) * P ^ 2 ≤ P * Q := by
    have h := mul_le_mul_of_nonneg_left hQ hP0.le
    nlinarith only [h]
  rcases hlarge with hA3 | hP48
  · have hAP45 : 45 ≤ A * P := by
      have h := mul_le_mul hA3 hP15 (by norm_num : (0 : ℝ) ≤ 15) hA0.le
      nlinarith only [h]
    have hAB9 : 9 ≤ A * B := by
      have h := mul_le_mul hA3 hB (by norm_num : (0 : ℝ) ≤ 3) hA0.le
      nlinarith only [h]
    have hP225 : 225 ≤ P ^ 2 := by nlinarith only [hP15, sq_nonneg (P-15)]
    have hprod := mul_le_mul hAB9 hP225 (by norm_num : (0 : ℝ) ≤ 225)
      (by positivity : 0 ≤ A * B)
    exact ⟨by linarith, by nlinarith only [hPQ, hprod]⟩
  · have hAP48 : 48 ≤ A * P := by
      have h := mul_le_mul hA hP48 (by norm_num : (0 : ℝ) ≤ 48) hA0.le
      nlinarith only [h]
    have hAB3 : 3 ≤ A * B := by
      have h := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 3) hA0.le
      nlinarith only [h]
    have hP2304 : 2304 ≤ P ^ 2 := by nlinarith only [hP48, sq_nonneg (P-48)]
    have hprod := mul_le_mul hAB3 hP2304 (by norm_num : (0 : ℝ) ≤ 2304)
      (by positivity : 0 ≤ A * B)
    exact ⟨by linarith, by nlinarith only [hPQ, hprod]⟩

/-- A branch-witness-free strong gap for actual tuple entries in the
two main size regimes.  All analytic size premises and the auxiliary
square root are supplied internally. -/
theorem full_ring_coherent_two_strong_gap_main
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {a b p q : 𝓞 K}
    (ha : a ∈ T) (hb : b ∈ T) (hp : p ∈ T) (hq : q ∈ T)
    (hab : a ≠ b) (hap : a ≠ p) (haq : a ≠ q)
    (hbp : b ≠ p) (hbq : b ≠ q) (hpq : p ≠ q)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hB : 3 ≤ ‖phi (b : K)‖) (hP : 5 * ‖phi (b : K)‖ ≤ ‖phi (p : K)‖)
    (hQ : 5 * ‖phi (a : K)‖ * ‖phi (b : K)‖ * ‖phi (p : K)‖ ≤ ‖phi (q : K)‖)
    (hlarge : 3 ≤ ‖phi (a : K)‖ ∨ 48 ≤ ‖phi (p : K)‖) :
    ‖phi (a : K)‖ ^ 2 * ‖phi (p : K)‖ ^ 3 <
      (10001 / 10000 : ℝ) * ‖phi (q : K)‖ := by
  have hA := one_le_norm_integer hK phi (hT.1 a ha)
  have hparams := coherent_two_main_size_parameters ‖phi (a : K)‖ ‖phi (b : K)‖
    ‖phi (p : K)‖ ‖phi (q : K)‖ hA hAB hB hP hQ hlarge
  let eta : ℂ := (phi (p : K) * phi (q : K)) ^ (1 / 2 : ℂ)
  have heta : eta ^ 2 = phi (p : K) * phi (q : K) :=
    coherent_cpow_half_sq _
  exact full_ring_coherent_two_strong_gap hK phi hT
    ha hb hp hq hab hap haq hbp hbq hpq eta heta
    hAB hB hP hparams.1 hQ hparams.2

end D1Bound5

