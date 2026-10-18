import D1Bound5.SmallPairOrbitProperties

open scoped NumberField Classical
open Module

namespace D1Bound5
open QuadInt

/-- An arbitrary nondegenerate pair of small algebraic integers in an
imaginary quadratic full ring cannot have three mutually compatible proper
extensions in the closed annulus with radii 3 and 10^550. -/
theorem IsD1Tuple.small_pair_excludes_three_bounded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 2 → 𝓞 K) (ha : IsD1Tuple a)
    (hsmall : ∀ i, ‖phi (a i : K)‖ < 3)
    (hnondeg : a 0*a 1+1 ≠ 0)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hproper : ∀ i, ProperCommonExtension {a 0,a 1} (t i))
    (hlarge : ∀ i, 3 ≤ ‖phi (t i : K)‖)
    (hbound : ∀ i, ‖phi (t i : K)‖^2 ≤ (10 : ℝ)^1100) : False := by
  classical
  obtain ⟨tau, nu, e, hmodel, hrow⟩ :=
    IsD1Tuple.small_pair_classification hK phi a ha hsmall hnondeg
  have hproperty := smallPairTable_graph_property_full_ring hK phi e hmodel
    (pairCoordinates (e.symm (a 0)) (e.symm (a 1))) hrow
  rw [smallCoordinateSet_pair] at hproperty
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
  have hnorm (i : Fin 3) : ‖phi (t i : K)‖^2 = ((s i).norm : ℝ) := by
    simpa only [s, RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm (t i))
  apply hproperty s hst
  · intro i
    have h := ProperCommonExtension.map_equiv e.symm {a 0,a 1} (t i) (hproper i)
    simpa only [Finset.image_insert, Finset.image_singleton] using h
  · intro i
    have h := mul_self_le_mul_self (by norm_num : (0 : ℝ) ≤ 3) (hlarge i)
    have hreal : (9 : ℝ) ≤ ((s i).norm : ℝ) := by nlinarith only [h, hnorm i]
    exact_mod_cast hreal
  · intro i
    have h := hbound i
    rw [hnorm i] at h
    exact_mod_cast h

/-- The same complete finite exclusion with the radius stated directly. -/
theorem IsD1Tuple.small_pair_excludes_three_in_disk
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 2 → 𝓞 K) (ha : IsD1Tuple a)
    (hsmall : ∀ i, ‖phi (a i : K)‖ < 3)
    (hnondeg : a 0*a 1+1 ≠ 0)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hproper : ∀ i, ProperCommonExtension {a 0,a 1} (t i))
    (hlarge : ∀ i, 3 ≤ ‖phi (t i : K)‖)
    (hbound : ∀ i, ‖phi (t i : K)‖ ≤ (10 : ℝ)^550) : False := by
  apply IsD1Tuple.small_pair_excludes_three_bounded hK phi a ha hsmall hnondeg
    t ht hproper hlarge
  intro i
  calc
    ‖phi (t i : K)‖^2 = ‖phi (t i : K)‖*‖phi (t i : K)‖ := pow_two _
    _ ≤ (10 : ℝ)^550*(10 : ℝ)^550 :=
      mul_self_le_mul_self (_root_.norm_nonneg _) (hbound i)
    _ = (10 : ℝ)^1100 := by rw [← pow_add]

end D1Bound5
