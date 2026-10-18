import D1Bound5.SmallPairClassificationData
import D1Bound5.MaximalCoordinates
import Mathlib.Algebra.Group.Int.Units

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The eleven full-ring models represented by the48nondegenerate pair rows. -/
def smallPairModels : Finset (ℤ × ℤ) :=
  {(0,1), (0,2), (0,5), (0,6),
   (1,1), (1,2), (1,3), (1,4), (1,5), (1,6), (1,8)}

/-- Maximality excludes the five extraneous coordinate orders in the finite
rectangle. It is used only here, after complete finite-order classification. -/
theorem full_small_pair_model_allowed
    {K : Type*} [Field K] [NumberField K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (htau : tau = 0 ∨ tau = 1) (hd : 0 < discriminant tau nu)
    (hlo : 1 ≤ nu) (hhi : nu ≤ 8) : (tau,nu) ∈ smallPairModels := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · decide
    · decide
    · have h := trace_zero_parameter_not_three_mod_four e
      norm_num at h
    · have h := squarefree_trace_zero_parameter e hd
      have hu : IsUnit (2 : ℤ) := h 2 (by decide)
      norm_num [Int.isUnit_iff] at hu
    · decide
    · decide
    · have h := trace_zero_parameter_not_three_mod_four e
      norm_num at h
    · have h := squarefree_trace_zero_parameter e hd
      have hu : IsUnit (2 : ℤ) := h 2 (by decide)
      norm_num [Int.isUnit_iff] at hu
  · interval_cases nu
    · decide
    · decide
    · decide
    · decide
    · decide
    · decide
    · have h := squarefree_trace_one_discriminant e hd
      have h27 : Squarefree (27 : ℤ) := by simpa [discriminant] using h
      have hu : IsUnit (3 : ℤ) := h27 3 (by decide)
      norm_num [Int.isUnit_iff] at hu
    · decide

/-- Every nondegenerate compatible pair of small actual algebraic integers
belongs to one of the48explicit sign/conjugation orbits. The finite tables
are complete and maximality has removed all extra coordinate orders. -/
theorem IsD1Tuple.small_pair_classification
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 2 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3)
    (hnondeg : t 0*t 1+1 ≠ 0) :
    ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
      (tau,nu) ∈ smallPairModels ∧
      pairCoordinates (e.symm (t 0)) (e.symm (t 1)) ∈ smallPairTable tau nu := by
  obtain ⟨tau, nu, htau, hpos, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  let s : Fin 2 → QuadInt tau nu := fun i => e.symm (t i)
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
  have hne : s 0 ≠ s 1 := fun h => (by decide : (0 : Fin 2) ≠ 1) (hst.1 h)
  have hnondegS : s 0*s 1+1 ≠ 0 := by
    intro h
    apply hnondeg
    apply e.symm.injective
    simpa only [map_mul, map_add, map_one, map_zero] using h
  have hroot := hst.2.2 0 1 (by decide)
  have hp := nondegenerate_small_pair_parameter_bound htau hpos (s 0) (s 1)
    (hst.2.1 0) (hst.2.1 1) hne (hnorm 0) (hnorm 1) hroot hnondegS
  refine ⟨tau, nu, e, full_small_pair_model_allowed e htau hpos hp.2.1 hp.2.2, ?_⟩
  exact smallPair_classified_rectangular htau hp.2.1 hp.2.2 (s 0) (s 1)
    (hst.2.1 0) (hst.2.1 1) hne hroot hnondegS (hnorm 0) (hnorm 1)

end D1Bound5
