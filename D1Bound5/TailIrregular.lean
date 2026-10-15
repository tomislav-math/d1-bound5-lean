import D1Bound5.SmallTailAllData
import D1Bound5.SmallTailRange
import D1Bound5.TailAnalyticMain

open scoped NumberField
open Module

namespace D1Bound5

/-- The finite C<4 case of the tail lemma, transported through the proved
full integer-ring equivalence. This includes every imaginary quadratic field. -/
theorem IsD1Tuple.tail_irregular_of_lt_four
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hB : 3 ≤ ‖phi (t 1 : K)‖) (hC : ‖phi (t 2 : K)‖ < 4) :
    regularDefect (t 1) (t 2) (t 3) ≠ 0 := by
  intro hreg
  obtain ⟨tau,nu,htau,hpos,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  let s : Fin 4 → QuadInt tau nu := fun i => e.symm (t i)
  have hN (i : Fin 4) : ‖phi (t i : K)‖^2 = ((s i).norm : ℝ) := by
    simpa only [s, RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm (t i))
  have hnormle (i j : Fin 4) (hij : i ≤ j) : (s i).norm ≤ (s j).norm := by
    have hp := mul_nonneg (sub_nonneg.mpr (hmon hij))
      (add_nonneg (norm_nonneg (phi (t j : K))) (norm_nonneg (phi (t i : K))))
    have h : ((s i).norm : ℝ) ≤ ((s j).norm : ℝ) := by
      nlinarith only [hp,hN i,hN j]
    exact_mod_cast h
  have h9 : 9 ≤ (s 1).norm := by
    have h : (9 : ℝ) ≤ ((s 1).norm : ℝ) := by
      nlinarith only [hB,hN 1,sq_nonneg (‖phi (t 1 : K)‖-3)]
    exact_mod_cast h
  have h15 : (s 2).norm ≤ 15 := by
    have hp := mul_pos (sub_pos.mpr hC)
      (show 0 < 4+‖phi (t 2 : K)‖ by positivity)
    have hh : ((s 2).norm : ℝ) < 16 := by nlinarith only [hp,hN 2]
    have hi : (s 2).norm < 16 := by exact_mod_cast hh
    omega
  have hnz (i : Fin 4) : s i ≠ 0 := by
    intro hz
    apply ht.2.1 i
    apply e.symm.injective
    simpa only [map_zero] using hz
  have hne (i j : Fin 4) (hij : i ≠ j) : s i ≠ s j := by
    intro h
    exact hij (ht.1 (e.symm.injective h))
  have roots (i j : Fin 4) (hij : i ≠ j) :
      ∃ r : QuadInt tau nu, r*r = s i*s j+1 := by
    obtain ⟨r,hr⟩ := ht.2.2 i j hij
    refine ⟨e.symm r,?_⟩
    simpa only [map_mul,map_add,map_one] using congrArg e.symm hr
  have hreg' : regularDefect (s 1) (s 2) (s 3) = 0 := by
    simpa only [regularDefect,map_mul,map_add,map_sub,map_pow,map_ofNat,map_zero]
      using congrArg e.symm hreg
  exact small_tail_of_rectangular_certificates smallTailCheck_rectangular htau hpos
    (s 0) (s 1) (s 2) (s 3) (hnz 0) (hnz 3)
    (hne 0 1 (by decide)) (hne 0 2 (by decide)) (hne 0 3 (by decide))
    (hne 1 2 (by decide)) (hne 3 1 (by decide)) (hne 3 2 (by decide))
    (hnormle 0 1 (by decide)) h9 (hnormle 1 2 (by decide)) h15
    (hnormle 2 3 (by decide)) (roots 1 2 (by decide))
    (roots 0 1 (by decide)) (roots 0 2 (by decide)) (roots 0 3 (by decide)) hreg'

/-- Complete tail-irregularity and growth lemma, without the auxiliary
C>=4 restriction. Every zero-square, half-integral, and modulus-tie case remains. -/
theorem IsD1Tuple.tail_irregular_and_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hB : 3 ≤ ‖phi (t 1 : K)‖) :
    regularDefect (t 1) (t 2) (t 3) ≠ 0 ∧
      2*‖phi (t 1 : K)‖*‖phi (t 2 : K)‖ < ‖phi (t 3 : K)‖ := by
  by_cases hC : 4 ≤ ‖phi (t 2 : K)‖
  · exact IsD1Tuple.tail_irregular_and_growth_of_four_le hK phi t ht hmon hB hC
  · have hirr := IsD1Tuple.tail_irregular_of_lt_four hK phi t ht hmon hB (lt_of_not_ge hC)
    obtain ⟨r,hr⟩ := ht.2.2 1 2 (by decide)
    obtain ⟨s,hs⟩ := ht.2.2 1 3 (by decide)
    obtain ⟨v,hv⟩ := ht.2.2 2 3 (by decide)
    exact ⟨hirr, irregular_growth hK phi (t 1) (t 2) (t 3) r s v
      (by simpa only [pow_two] using hr) (by simpa only [pow_two] using hs)
      (by simpa only [pow_two] using hv) hirr hB
      (hmon (by decide : (1 : Fin 4) ≤ 2)) (hmon (by decide : (2 : Fin 4) ≤ 3))⟩

end D1Bound5
