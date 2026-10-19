import D1Bound5.SmallTripleData
import D1Bound5.SmallQuadruple
import D1Bound5.MaximalCoordinates
import Mathlib.Algebra.Group.Int.Units

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Above discriminant 32, even three small entries are impossible. -/
theorem noSmallTriple_of_large_discriminant {tau nu : ℤ}
    (hlarge : 32 < discriminant tau nu) : ∀ t : Fin 3 → QuadInt tau nu,
      IsD1Tuple t → (∀ i, (t i).norm ≤ 8) → False := by
  intro t ht hnorm
  have hpos : 0 < discriminant tau nu := by omega
  have him (i : Fin 3) : (t i).im = 0 := by
    by_contra h
    have := discriminant_le_four_bound hpos (hnorm i) h
    omega
  have hcast (i : Fin 3) : t i = ((t i).re : QuadInt tau nu) := by
    apply QuadraticAlgebra.ext
    · simp
    · simpa only [QuadraticAlgebra.im_intCast] using him i
  have hb (i : Fin 3) : -2 ≤ (t i).re ∧ (t i).re ≤ 2 ∧ (t i).re ≠ 0 := by
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
  have hne (i j : Fin 3) (hij : i ≠ j) : (t i).re ≠ (t j).re := by
    intro h
    apply hij
    apply ht.1
    rw [hcast i, hcast j, h]
  have hnot (i j : Fin 3) (hij : i ≠ j) (hp : (t i).re*(t j).re = 2) : False := by
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

/-- Complete classification over every positive normalized coordinate model. -/
theorem smallTriple_classified_normalized {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hpos : 0 < discriminant tau nu)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable tau nu := by
  by_cases hcut : discriminant tau nu ≤ 32
  · have hnu : 1 ≤ nu ∧ nu ≤ 8 := by
      rcases htau with rfl | rfl
      · simp only [discriminant, zero_pow (by decide : 2 ≠ 0), sub_zero] at hpos hcut
        omega
      · simp only [discriminant, one_pow] at hpos hcut
        omega
    exact smallTriple_classified_rectangular htau hnu.1 hnu.2 t ht hnorm
  · exact (noSmallTriple_of_large_discriminant (lt_of_not_ge hcut) t ht hnorm).elim

/-- Full-ring small-triple classification: precisely four coordinate models
are possible, and the unordered triple lies in the explicit 24-entry table.
The models are the full rings for d = 1, 2, 3, 7 respectively. -/
theorem IsD1Tuple.small_triple_classification
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3) :
    ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
      ((tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨
       (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2)) ∧
      tripleCoordinates (e.symm (t 0)) (e.symm (t 1)) (e.symm (t 2)) ∈
        smallTripleTable tau nu := by
  obtain ⟨tau, nu, htau, hpos, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  let s : Fin 3 → QuadInt tau nu := fun i => e.symm (t i)
  have hst : IsD1Tuple s := by
    refine ⟨e.symm.injective.comp ht.1, ?_, ?_⟩
    · intro i hz
      apply ht.2.1 i
      apply e.symm.injective
      simpa only [map_zero] using hz
    · intro i j hij
      obtain ⟨r, hr⟩ := ht.2.2 i j hij
      exact ⟨e.symm r, by simpa only [map_mul, map_add, map_one] using congrArg e.symm hr⟩
  have hnorm : ∀ i, (s i).norm ≤ 8 := by
    intro i
    have hN : ‖phi (t i : K)‖^2 = ((s i).norm : ℝ) := by
      simpa only [s, RingEquiv.apply_symm_apply] using
        norm_sq_full_ring_equiv e phi (e.symm (t i))
    have hproduct := mul_pos (sub_pos.mpr (hsmall i))
      (show (0 : ℝ) < 3+‖phi (t i : K)‖ by positivity)
    have hreal : ((s i).norm : ℝ) < 9 := by nlinarith only [hN, hproduct]
    have hint : (s i).norm < 9 := by exact_mod_cast hreal
    omega
  have hrow := smallTriple_classified_normalized htau hpos s hst hnorm
  refine ⟨tau, nu, e, ?_, hrow⟩
  rcases smallTripleTable_models hrow with h | h | h | h | h
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  · rcases h with ⟨rfl, rfl⟩
    have hsf := squarefree_trace_zero_parameter e hpos
    have hu : IsUnit (2 : ℤ) := hsf 2 (by norm_num)
    norm_num [Int.isUnit_iff] at hu
  · exact Or.inr (Or.inr (Or.inl h))
  · exact Or.inr (Or.inr (Or.inr h))

end D1Bound5
