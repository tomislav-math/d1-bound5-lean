import D1Bound5.SmallQuadrupleData
import D1Bound5.RationalSquares
import D1Bound5.FullRingBridge
import D1Bound5.Sextuple
import Mathlib.Tactic.IntervalCases

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Among three distinct nonzero integers in [-2,2], two have product 2. -/
theorem three_small_integers_product_two (x y z : ℤ)
    (hxlo : -2 ≤ x) (hxhi : x ≤ 2) (hx0 : x ≠ 0)
    (hylo : -2 ≤ y) (hyhi : y ≤ 2) (hy0 : y ≠ 0)
    (hzlo : -2 ≤ z) (hzhi : z ≤ 2) (hz0 : z ≠ 0)
    (hxy : x ≠ y) (hxz : x ≠ z) (hyz : y ≠ z) :
    x*y = 2 ∨ x*z = 2 ∨ y*z = 2 := by
  interval_cases x <;> interval_cases y <;> interval_cases z <;>
    norm_num at *

/-- The rational integer three is not a square in any positive-discriminant
quadratic integer coordinate ring, including all half-integral models. -/
theorem three_not_square_quadInt {tau nu : ℤ}
    (hpos : 0 < discriminant tau nu) :
    ¬ ∃ r : QuadInt tau nu, r*r = 3 := by
  intro hr
  obtain ⟨n, hn⟩ := positive_integer_square_is_integer hpos (by norm_num : (0:ℤ)<3) hr
  have hlo : -2 ≤ n := by nlinarith [sq_nonneg (n+2)]
  have hhi : n ≤ 2 := by nlinarith [sq_nonneg (n-2)]
  interval_cases n <;> norm_num at hn

/-- Once the discriminant exceeds 32, every norm-eight entry is rational.
Already three distinct such nonzero entries cannot form a D(1)-triple. -/
theorem noSmallQuadruple_of_large_discriminant {tau nu : ℤ}
    (hlarge : 32 < discriminant tau nu) : NoSmallQuadruple tau nu := by
  intro t ht hnorm
  have hpos : 0 < discriminant tau nu := by omega
  have him (i : Fin 4) : (t i).im = 0 := by
    by_contra h
    have := discriminant_le_four_bound hpos (hnorm i) h
    omega
  have hcast (i : Fin 4) : t i = ((t i).re : QuadInt tau nu) := by
    apply QuadraticAlgebra.ext
    · simp
    · simpa only [QuadraticAlgebra.im_intCast] using him i
  have hb (i : Fin 4) : -2 ≤ (t i).re ∧ (t i).re ≤ 2 ∧ (t i).re ≠ 0 := by
    have hn := hnorm i
    rw [norm_formula, him i] at hn
    simp only [mul_zero, zero_mul, zero_pow (by decide : 2 ≠ 0), add_zero] at hn
    refine ⟨?_, ?_, ?_⟩
    · nlinarith [sq_nonneg ((t i).re+3)]
    · nlinarith [sq_nonneg ((t i).re-3)]
    · intro h
      apply ht.2.1 i
      rw [hcast i, h]
      simp
  have hne (i j : Fin 4) (hij : i ≠ j) : (t i).re ≠ (t j).re := by
    intro h
    apply hij
    apply ht.1
    rw [hcast i, hcast j, h]
  have hnot (i j : Fin 4) (hij : i ≠ j) (hp : (t i).re*(t j).re = 2) : False := by
    apply three_not_square_quadInt hpos
    obtain ⟨r, hr⟩ := ht.2.2 i j hij
    refine ⟨r, ?_⟩
    rw [hcast i, hcast j, ← Int.cast_mul, hp] at hr
    norm_num at hr
    exact hr
  rcases three_small_integers_product_two (t 0).re (t 1).re (t 2).re
    (hb 0).1 (hb 0).2.1 (hb 0).2.2
    (hb 1).1 (hb 1).2.1 (hb 1).2.2
    (hb 2).1 (hb 2).2.1 (hb 2).2.2
    (hne 0 1 (by decide)) (hne 0 2 (by decide)) (hne 1 2 (by decide)) with h | h | h
  · exact hnot 0 1 (by decide) h
  · exact hnot 0 2 (by decide) h
  · exact hnot 1 2 (by decide) h

/-- Complete coordinate-ring exclusion. The finite rectangle deliberately
includes nonmaximal orders, so no squarefree input is needed. -/
theorem noSmallQuadruple_normalized {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1)
    (hpos : 0 < discriminant tau nu) : NoSmallQuadruple tau nu := by
  by_cases hcut : discriminant tau nu ≤ 32
  · have hnu : 1 ≤ nu ∧ nu ≤ 8 := by
      rcases htau with rfl | rfl
      · simp only [discriminant, zero_pow (by decide : 2 ≠ 0), sub_zero] at hpos hcut
        omega
      · simp only [discriminant, one_pow] at hpos hcut
        omega
    exact noSmallQuadruple_rectangular htau hnu.1 hnu.2
  · exact noSmallQuadruple_of_large_discriminant (lt_of_not_ge hcut)

/-- The cardinality part of manuscript Lemma 7.12, in the actual full ring
of every imaginary quadratic field, with zero roots and modulus ties allowed. -/
theorem IsD1Tuple.not_four_small
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3) : False := by
  obtain ⟨tau, nu, htau, hpos, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  let s : Fin 4 → QuadInt tau nu := fun i => e.symm (t i)
  have hst : IsD1Tuple s := by
    refine ⟨e.symm.injective.comp ht.1, ?_, ?_⟩
    · intro i hz
      apply ht.2.1 i
      apply e.symm.injective
      simpa only [map_zero] using hz
    · intro i j hij
      obtain ⟨r, hr⟩ := ht.2.2 i j hij
      exact ⟨e.symm r, by simpa only [map_mul, map_add, map_one] using congrArg e.symm hr⟩
  apply noSmallQuadruple_normalized htau hpos s hst
  intro i
  have hN : ‖phi (t i : K)‖^2 = ((s i).norm : ℝ) := by
    simpa only [s, RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm (t i))
  have hproduct := mul_pos (sub_pos.mpr (hsmall i))
    (show (0 : ℝ) < 3+‖phi (t i : K)‖ by positivity)
  have hreal : ((s i).norm : ℝ) < 9 := by nlinarith only [hN, hproduct]
  have hint : (s i).norm < 9 := by exact_mod_cast hreal
  omega

/-- Every D(1)-tuple in a full imaginary quadratic integer ring has at most
three entries of modulus less than three. This does not assert the later
classification or extension lists in manuscript Lemma 7.12. -/
theorem IsD1.small_entries_card_le_three
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (A : Finset (𝓞 K)) (hA : IsD1 A) :
    (A.filter (fun (z : 𝓞 K) => ‖phi (z : K)‖ < 3)).card ≤ 3 := by
  classical
  by_contra hcard
  let S := A.filter (fun (z : 𝓞 K) => ‖phi (z : K)‖ < 3)
  have hfour : 4 ≤ S.card := by dsimp only [S]; omega
  obtain ⟨B, hBS, hB⟩ := Finset.exists_subset_card_eq hfour
  let e : Fin 4 ≃ B := (Fintype.equivFinOfCardEq (by simpa using hB)).symm
  let t : Fin 4 → 𝓞 K := fun i => (e i).val
  have hmem (i : Fin 4) : t i ∈ S := hBS (e i).property
  have hmemA (i : Fin 4) : t i ∈ A := (Finset.mem_filter.mp (hmem i)).1
  have ht : IsD1Tuple t := by
    have hinj : Function.Injective t := by
      intro i j h
      apply e.injective
      exact Subtype.ext h
    exact ⟨hinj, fun i => hA.1 _ (hmemA i),
      fun i j hij => hA.2 _ (hmemA i) _ (hmemA j) (fun h => hij (hinj h))⟩
  exact IsD1Tuple.not_four_small hK phi t ht
    (fun i => (Finset.mem_filter.mp (hmem i)).2)

end D1Bound5
