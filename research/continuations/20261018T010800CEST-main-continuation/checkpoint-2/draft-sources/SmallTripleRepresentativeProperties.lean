import D1Bound5.SmallExtensionSymmetry

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem smallTripleExtensionProperty_of_list {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) (allowed : List (QuadInt tau nu))
    (hcomplete : ∀ z, ProperCommonExtension A z → z.norm ≤ 10^80 → z ∈ allowed)
    (hbound : ∀ z ∈ allowed, z.norm < 85^2)
    (hunique : ∀ z ∈ allowed, ∀ w ∈ allowed, z = w) :
    SmallTripleExtensionProperty A := by
  constructor
  · intro z hz hNz
    exact hbound z (hcomplete z hz hNz)
  · intro z w hz hw hNz hNw
    exact hunique z (hcomplete z hz hNz) w (hcomplete w hw hNw)

/-- Both finite-extension consequences for manuscript representative 1. -/
theorem smallTripleRepresentative_1_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_1, smallTripleAnchorB_1, smallTripleAnchorC_1} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_1
  · intro z hz hNz
    exact smallTripleExtension_1_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_1, QuadInt.norm_formula]
  · simp [smallTripleAllowed_1]

/-- Both finite-extension consequences for manuscript representative 2. -/
theorem smallTripleRepresentative_2_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_2, smallTripleAnchorB_2, smallTripleAnchorC_2} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_2
  · intro z hz hNz
    exact smallTripleExtension_2_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_2, QuadInt.norm_formula]
  · simp [smallTripleAllowed_2]

/-- Both finite-extension consequences for manuscript representative 3. -/
theorem smallTripleRepresentative_3_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_3, smallTripleAnchorB_3, smallTripleAnchorC_3} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_3
  · intro z hz hNz
    exact smallTripleExtension_3_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_3, QuadInt.norm_formula]
  · simp [smallTripleAllowed_3]

/-- Both finite-extension consequences for manuscript representative 4. -/
theorem smallTripleRepresentative_4_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_4, smallTripleAnchorB_4, smallTripleAnchorC_4} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_4
  · intro z hz hNz
    exact smallTripleExtension_4_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_4, QuadInt.norm_formula]
  · simp [smallTripleAllowed_4]

/-- Both finite-extension consequences for manuscript representative 5. -/
theorem smallTripleRepresentative_5_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_5, smallTripleAnchorB_5, smallTripleAnchorC_5} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_5
  · intro z hz hNz
    exact smallTripleExtension_5_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_5, QuadInt.norm_formula]
  · simp [smallTripleAllowed_5]

/-- Both finite-extension consequences for manuscript representative 6. -/
theorem smallTripleRepresentative_6_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_6, smallTripleAnchorB_6, smallTripleAnchorC_6} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_6
  · intro z hz hNz
    exact smallTripleExtension_6_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_6, QuadInt.norm_formula]
  · simp [smallTripleAllowed_6]

/-- Both finite-extension consequences for manuscript representative 7. -/
theorem smallTripleRepresentative_7_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_7, smallTripleAnchorB_7, smallTripleAnchorC_7} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_7
  · intro z hz hNz
    exact smallTripleExtension_7_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_7, QuadInt.norm_formula]
  · simp [smallTripleAllowed_7]

/-- Both finite-extension consequences for manuscript representative 8. -/
theorem smallTripleRepresentative_8_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_8, smallTripleAnchorB_8, smallTripleAnchorC_8} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_8
  · intro z hz hNz
    exact smallTripleExtension_8_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_8, QuadInt.norm_formula]
  · simp [smallTripleAllowed_8]

/-- Both finite-extension consequences for manuscript representative 9. -/
theorem smallTripleRepresentative_9_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_9, smallTripleAnchorB_9, smallTripleAnchorC_9} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_9
  · intro z hz hNz
    exact smallTripleExtension_9_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_9, QuadInt.norm_formula]
  · simp [smallTripleAllowed_9]

/-- Both finite-extension consequences for manuscript representative 10. -/
theorem smallTripleRepresentative_10_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {smallTripleAnchorA_10, smallTripleAnchorB_10, smallTripleAnchorC_10} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_10
  · intro z hz hNz
    exact smallTripleExtension_10_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_10, QuadInt.norm_formula]
  · simp [smallTripleAllowed_10]

end D1Bound5
