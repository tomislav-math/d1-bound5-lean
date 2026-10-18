import D1Bound5.SmallTripleOrbitProperties

open scoped NumberField Classical
open Module

namespace D1Bound5
open QuadInt

/-- Transfer both finite-extension consequences from integer coordinates
to the actual full ring through its proved ring equivalence. -/
theorem SmallTripleExtensionProperty.full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (A : Finset (QuadInt tau nu)) (hA : SmallTripleExtensionProperty A) :
    (∀ z : 𝓞 K, ProperCommonExtension (A.image e) z →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 → ‖phi (z : K)‖ < 85) ∧
    (∀ z w : 𝓞 K, ProperCommonExtension (A.image e) z →
      ProperCommonExtension (A.image e) w →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 →
      ‖phi (w : K)‖^2 ≤ (10 : ℝ)^80 → z = w) := by
  classical
  have himage : (A.image e).image e.symm = A := by
    simp [Finset.image_image, Function.comp_def]
  have hproper (z : 𝓞 K) (hz : ProperCommonExtension (A.image e) z) :
      ProperCommonExtension A (e.symm z) := by
    have h := ProperCommonExtension.map_equiv e.symm (A.image e) z hz
    rwa [himage] at h
  have hnorm (z : 𝓞 K) :
      ‖phi (z : K)‖^2 = ((e.symm z).norm : ℝ) := by
    simpa only [RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm z)
  have hbound (z : 𝓞 K) (hz : ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80) :
      (e.symm z).norm ≤ 10^80 := by
    rw [hnorm z] at hz
    exact_mod_cast hz
  constructor
  · intro z hz hNz
    have hN := hA.1 (e.symm z) (hproper z hz) (hbound z hNz)
    have hNr : ((e.symm z).norm : ℝ) < (85 : ℝ)^2 := by exact_mod_cast hN
    nlinarith only [hnorm z, hNr, _root_.norm_nonneg (phi (z : K))]
  · intro z w hz hw hNz hNw
    apply e.symm.injective
    exact hA.2 (e.symm z) (e.symm w) (hproper z hz) (hproper w hw)
      (hbound z hNz) (hbound w hNw)

/-- Every actual small D(1)-triple has at most one distinct nonzero further
common extension in the radius-10^40 disk. Every such extension has modulus
strictly less than 85. The classification, symmetries, finite certificates
and reversible descent are all supplied by proved dependencies. -/
theorem IsD1Tuple.small_triple_bounded_extensions
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3) :
    (∀ z : 𝓞 K, ProperCommonExtension {t 0,t 1,t 2} z →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 → ‖phi (z : K)‖ < 85) ∧
    (∀ z w : 𝓞 K, ProperCommonExtension {t 0,t 1,t 2} z →
      ProperCommonExtension {t 0,t 1,t 2} w →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 →
      ‖phi (w : K)‖^2 ≤ (10 : ℝ)^80 → z = w) := by
  classical
  obtain ⟨tau, nu, e, hmodel, hrow⟩ :=
    IsD1Tuple.small_triple_classification hK phi t ht hsmall
  have hproperty := smallTripleTable_extension_property_full_ring hK phi e hmodel
    (tripleCoordinates (e.symm (t 0)) (e.symm (t 1)) (e.symm (t 2))) hrow
  rw [smallCoordinateSet_triple] at hproperty
  have h := SmallTripleExtensionProperty.full_ring e phi
    {e.symm (t 0),e.symm (t 1),e.symm (t 2)} hproperty
  simpa only [Finset.image_insert, Finset.image_singleton, RingEquiv.apply_symm_apply] using h

end D1Bound5
