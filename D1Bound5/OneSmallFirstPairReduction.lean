import D1Bound5.FiveRegionImpossible
import D1Bound5.NormCompatibility

open scoped NumberField
open Module

namespace D1Bound5

/-- The five unbounded regions give the manuscript first-pair reduction
in the actual full integer ring. Integrality of the squared complex
modulus is obtained from the proved algebraic norm identity. -/
theorem IsD1Tuple.one_small_first_pair_reduction
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : ‖phi (a 0 : K)‖ < 3) (hB : 3 ≤ ‖phi (a 1 : K)‖) :
    (Algebra.norm ℤ (a 0)=1 ∧ ‖phi (a 1 : K)‖ < 8) ∨
      (Algebra.norm ℤ (a 0)=2 ∧ ‖phi (a 1 : K)‖ < 4) := by
  let N : ℤ := Algebra.norm ℤ (a 0)
  have hnorm : ‖phi (a 0 : K)‖^2=(N : ℝ) := norm_sq_eq_absolute_norm hK phi (a 0)
  have hA1 := one_le_norm_integer hK phi (ha.2.1 0)
  have hN1 : 1 ≤ N := by
    have hh : (1 : ℝ) ≤ (N : ℝ) := by rw [← hnorm]; nlinarith only [hA1]
    exact_mod_cast hh
  have hN9 : N < 9 := by
    have hh : (N : ℝ) < 9 := by
      rw [← hnorm]
      nlinarith only [hA,hA1]
    exact_mod_cast hh
  have hN8 : ‖phi (a 0 : K)‖^2 ≤ 8 := by
    rw [hnorm]
    exact_mod_cast (show N ≤ 8 by omega)
  by_cases hNunit : N=1
  · by_cases hB8 : ‖phi (a 1 : K)‖ < 8
    · exact Or.inl ⟨hNunit,hB8⟩
    · exfalso
      apply ha.five_region_impossible hK phi a hmon 0 hN8
      rw [FiveRegionCase,if_neg (by decide : (0 : Fin 5) ≠ 4)]
      change ‖phi (a 0 : K)‖^2 = 1 ∧ 8 ≤ ‖phi (a 1 : K)‖
      exact ⟨by rw [hnorm,hNunit]; norm_num,le_of_not_gt hB8⟩
  by_cases hNtwo : N=2
  · by_cases hB4 : ‖phi (a 1 : K)‖ < 4
    · exact Or.inr ⟨hNtwo,hB4⟩
    · exfalso
      apply ha.five_region_impossible hK phi a hmon 1 hN8
      rw [FiveRegionCase,if_neg (by decide : (1 : Fin 5) ≠ 4)]
      change ‖phi (a 0 : K)‖^2 = 2 ∧ 4 ≤ ‖phi (a 1 : K)‖
      exact ⟨by rw [hnorm,hNtwo]; norm_num,le_of_not_gt hB4⟩
  by_cases hNthree : N=3
  · exfalso
    apply ha.five_region_impossible hK phi a hmon 2 hN8
    rw [FiveRegionCase,if_neg (by decide : (2 : Fin 5) ≠ 4)]
    change ‖phi (a 0 : K)‖^2 = 3 ∧ 3 ≤ ‖phi (a 1 : K)‖
    exact ⟨by rw [hnorm,hNthree]; norm_num,hB⟩
  by_cases hNfour : N=4
  · exfalso
    apply ha.five_region_impossible hK phi a hmon 3 hN8
    rw [FiveRegionCase,if_neg (by decide : (3 : Fin 5) ≠ 4)]
    change ‖phi (a 0 : K)‖^2 = 4 ∧ 3 ≤ ‖phi (a 1 : K)‖
    exact ⟨by rw [hnorm,hNfour]; norm_num,hB⟩
  exfalso
  apply ha.five_region_impossible hK phi a hmon 4 hN8
  norm_num [FiveRegionCase,fiveRegionMinNorm,fiveRegionMinB]
  refine ⟨?_,hB⟩
  rw [hnorm]
  exact_mod_cast (show 5 ≤ N by omega)

/-- Squared-modulus interface used by the finite first-pair classification. -/
theorem IsD1Tuple.one_small_first_pair_size
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : ‖phi (a 0 : K)‖ < 3) (hB : 3 ≤ ‖phi (a 1 : K)‖) :
    (‖phi (a 0 : K)‖^2=1 ∧ 9 ≤ ‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2 < 64) ∨
    (‖phi (a 0 : K)‖^2=2 ∧ 9 ≤ ‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2 < 16) := by
  have hlow : 9 ≤ ‖phi (a 1 : K)‖^2 := by nlinarith only [hB]
  obtain ⟨hn,hb⟩ | ⟨hn,hb⟩ := ha.one_small_first_pair_reduction hK phi a hmon hA hB
  · left
    refine ⟨?_,hlow,?_⟩
    · rw [norm_sq_eq_absolute_norm hK phi,hn]
      norm_num
    · nlinarith only [hb,hB]
  · right
    refine ⟨?_,hlow,?_⟩
    · rw [norm_sq_eq_absolute_norm hK phi,hn]
      norm_num
    · nlinarith only [hb,hB]

end D1Bound5
