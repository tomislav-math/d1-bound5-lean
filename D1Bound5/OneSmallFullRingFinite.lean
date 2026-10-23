import D1Bound5.OneSmallOrbitRows

open scoped NumberField Classical
open Module

namespace D1Bound5
open QuadInt

/-- Complete actual-full-ring classification after the analytic first-pair
and third-entry size reductions. Only the rational pair remains separate. -/
theorem IsD1Tuple.one_small_first_triple_classification
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsize :
      (‖phi (t 0 : K)‖^2 = 1 ∧ 9 ≤ ‖phi (t 1 : K)‖^2 ∧ ‖phi (t 1 : K)‖^2 < 64) ∨
      (‖phi (t 0 : K)‖^2 = 2 ∧ 9 ≤ ‖phi (t 1 : K)‖^2 ∧ ‖phi (t 1 : K)‖^2 < 16))
    (hbound : ‖phi (t 2 : K)‖^2 < 225)
    (horder : ‖phi (t 1 : K)‖^2 ≤ ‖phi (t 2 : K)‖^2) :
    (t 0 = 1 ∧ t 1 = 3) ∨ (t 0 = -1 ∧ t 1 = -3) ∨
      ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
        (tau,nu) ∈ smallPairModels ∧
        OneSmallNormalizedThirdRows (e.symm (t 0)) (e.symm (t 1)) (e.symm (t 2)) := by
  classical
  obtain h | h | ⟨tau,nu,e,hmodel,hrow⟩ := full_first_pair_classification hK phi
    (t 0) (t 1) hsize (ht.2.2 0 1 (by decide))
  · exact Or.inl h
  · exact Or.inr (Or.inl h)
  right; right
  refine ⟨tau,nu,e,hmodel,?_⟩
  have hnorm (i : Fin 3) : ‖phi (t i : K)‖^2 = ((e.symm (t i)).norm : ℝ) := by
    simpa only [RingEquiv.apply_symm_apply] using norm_sq_full_ring_equiv e phi (e.symm (t i))
  apply firstPairTable_third_rows hmodel _ _ _ hrow
  · rw [hnorm 2] at hbound
    have hi : (e.symm (t 2)).norm < 225 := by exact_mod_cast hbound
    omega
  · rw [hnorm 1,hnorm 2] at horder
    exact_mod_cast horder
  · intro h
    exact (by decide : (2 : Fin 3) ≠ 0) (ht.1 (e.symm.injective h))
  · intro h
    exact (by decide : (2 : Fin 3) ≠ 1) (ht.1 (e.symm.injective h))
  · constructor
    · obtain ⟨q,hq⟩ := ht.2.2 0 2 (by decide)
      exact ⟨e.symm q,by simpa only [map_mul,map_add,map_one] using congrArg e.symm hq⟩
    · obtain ⟨q,hq⟩ := ht.2.2 1 2 (by decide)
      exact ⟨e.symm q,by simpa only [map_mul,map_add,map_one] using congrArg e.symm hq⟩

/-- Every bounded fourth-entry certificate transports to arbitrary actual
full-ring entries through the same sign/conjugation normalization used in
the complete first-triple classification. -/
theorem oneSmallRowMembership_full_ring_bound
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (sgn conj : Bool) (a b s z : 𝓞 K) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm a))
      (smallExtensionSymmetry sgn conj (e.symm b))
      (smallExtensionSymmetry sgn conj (e.symm s)) cutoff)
    (hz : ‖phi (z : K)‖^2 < (cutoff : ℝ))
    (ha : ∃ q : 𝓞 K, q*q = a*z+1) (hb : ∃ q : 𝓞 K, q*q = b*z+1)
    (hs : ∃ q : 𝓞 K, q*q = s*z+1) :
    ‖phi (z : K)‖^2 ≤ 4*‖phi (b : K)‖^2*‖phi (s : K)‖^2 := by
  classical
  let F : 𝓞 K → QuadInt tau nu := fun w => smallExtensionSymmetry sgn conj (e.symm w)
  have hnorm (w : 𝓞 K) : ‖phi (w : K)‖^2 = ((F w).norm : ℝ) := by
    simpa only [F,smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm w)
  have hroots (w : 𝓞 K) (h : ∃ q : 𝓞 K, q*q = w*z+1) :
      ∃ q : QuadInt tau nu, q*q = F w*F z+1 := by
    obtain ⟨q,hq⟩ := h
    apply oneSmallSymmetry_square sgn conj
    exact ⟨e.symm q,by simpa only [map_mul,map_add,map_one] using congrArg e.symm hq⟩
  have hz' : (F z).norm < cutoff := by
    rw [hnorm z] at hz
    exact_mod_cast hz
  let r : OneSmallTripleRow :=
    ⟨tau,nu,((F a).re,(F a).im),((F b).re,(F b).im),((F s).re,(F s).im),cutoff⟩
  have hr : r ∈ oneSmallFixedRows := hrow
  have hg := oneSmallFixedRows_bounded_growth r hr (F z) hz'
    (hroots a ha) (hroots b hb) (hroots s hs)
  have hreal : ((F z).norm : ℝ) ≤ 4*((F b).norm : ℝ)*((F s).norm : ℝ) := by
    exact_mod_cast hg
  rwa [← hnorm z,← hnorm b,← hnorm s] at hreal

/-- The finite complement contradicts the strict tail-growth lower bound
in every one of the 56 rows, including the two formerly exceptional rows. -/
theorem oneSmallRowMembership_full_ring_excludes_irregular_bound
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (sgn conj : Bool) (a b s z : 𝓞 K) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm a))
      (smallExtensionSymmetry sgn conj (e.symm b))
      (smallExtensionSymmetry sgn conj (e.symm s)) cutoff)
    (hz : ‖phi (z : K)‖^2 < (cutoff : ℝ))
    (ha : ∃ q : 𝓞 K, q*q = a*z+1) (hb : ∃ q : 𝓞 K, q*q = b*z+1)
    (hs : ∃ q : 𝓞 K, q*q = s*z+1)
    (hgrowth : 4*‖phi (b : K)‖^2*‖phi (s : K)‖^2 < ‖phi (z : K)‖^2) : False := by
  exact (not_le_of_gt hgrowth)
    (oneSmallRowMembership_full_ring_bound e phi sgn conj a b s z cutoff hrow hz ha hb hs)

end D1Bound5
