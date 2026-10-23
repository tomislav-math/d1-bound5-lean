import D1Bound5.SmallPairGraphSymmetry
import D1Bound5.SmallPairGraphs

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The full triangle exclusion for manuscript representative 1. -/
theorem smallPairRepresentative_1_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_1,smallPairB_1} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_1_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 2. -/
theorem smallPairRepresentative_2_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_2,smallPairB_2} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_2_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 3. -/
theorem smallPairRepresentative_3_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_3,smallPairB_3} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_3_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 4. -/
theorem smallPairRepresentative_4_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_4,smallPairB_4} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_4_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 5. -/
theorem smallPairRepresentative_5_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_5,smallPairB_5} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_5_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 6. -/
theorem smallPairRepresentative_6_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_6,smallPairB_6} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_6_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 7. -/
theorem smallPairRepresentative_7_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_7,smallPairB_7} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_7_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 8. -/
theorem smallPairRepresentative_8_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_8,smallPairB_8} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_8_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 9. -/
theorem smallPairRepresentative_9_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_9,smallPairB_9} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_9_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 10. -/
theorem smallPairRepresentative_10_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_10,smallPairB_10} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_10_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 11. -/
theorem smallPairRepresentative_11_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_11,smallPairB_11} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_11_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 12. -/
theorem smallPairRepresentative_12_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_12,smallPairB_12} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_12_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 13. -/
theorem smallPairRepresentative_13_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_13,smallPairB_13} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_13_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 14. -/
theorem smallPairRepresentative_14_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_14,smallPairB_14} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_14_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 15. -/
theorem smallPairRepresentative_15_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_15,smallPairB_15} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_15_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 16. -/
theorem smallPairRepresentative_16_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_16,smallPairB_16} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_16_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 17. -/
theorem smallPairRepresentative_17_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_17,smallPairB_17} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_17_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 18. -/
theorem smallPairRepresentative_18_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_18,smallPairB_18} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_18_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 19. -/
theorem smallPairRepresentative_19_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_19,smallPairB_19} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_19_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 20. -/
theorem smallPairRepresentative_20_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_20,smallPairB_20} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_20_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 21. -/
theorem smallPairRepresentative_21_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_21,smallPairB_21} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_21_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 22. -/
theorem smallPairRepresentative_22_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_22,smallPairB_22} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_22_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 23. -/
theorem smallPairRepresentative_23_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_23,smallPairB_23} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_23_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 24. -/
theorem smallPairRepresentative_24_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_24,smallPairB_24} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_24_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 25. -/
theorem smallPairRepresentative_25_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_25,smallPairB_25} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_25_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 26. -/
theorem smallPairRepresentative_26_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_26,smallPairB_26} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_26_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 27. -/
theorem smallPairRepresentative_27_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_27,smallPairB_27} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_27_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 28. -/
theorem smallPairRepresentative_28_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_28,smallPairB_28} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_28_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 29. -/
theorem smallPairRepresentative_29_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_29,smallPairB_29} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_29_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 30. -/
theorem smallPairRepresentative_30_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_30,smallPairB_30} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_30_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 31. -/
theorem smallPairRepresentative_31_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_31,smallPairB_31} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_31_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 32. -/
theorem smallPairRepresentative_32_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_32,smallPairB_32} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_32_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 33. -/
theorem smallPairRepresentative_33_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_33,smallPairB_33} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_33_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 34. -/
theorem smallPairRepresentative_34_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_34,smallPairB_34} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_34_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 35. -/
theorem smallPairRepresentative_35_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_35,smallPairB_35} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_35_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 36. -/
theorem smallPairRepresentative_36_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_36,smallPairB_36} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_36_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 37. -/
theorem smallPairRepresentative_37_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_37,smallPairB_37} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_37_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 38. -/
theorem smallPairRepresentative_38_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_38,smallPairB_38} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_38_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 39. -/
theorem smallPairRepresentative_39_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_39,smallPairB_39} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_39_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 40. -/
theorem smallPairRepresentative_40_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_40,smallPairB_40} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_40_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 41. -/
theorem smallPairRepresentative_41_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_41,smallPairB_41} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_41_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 42. -/
theorem smallPairRepresentative_42_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_42,smallPairB_42} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_42_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 43. -/
theorem smallPairRepresentative_43_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_43,smallPairB_43} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_43_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 44. -/
theorem smallPairRepresentative_44_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_44,smallPairB_44} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_44_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 45. -/
theorem smallPairRepresentative_45_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_45,smallPairB_45} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_45_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 46. -/
theorem smallPairRepresentative_46_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_46,smallPairB_46} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_46_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 47. -/
theorem smallPairRepresentative_47_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_47,smallPairB_47} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_47_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

/-- The full triangle exclusion for manuscript representative 48. -/
theorem smallPairRepresentative_48_graph_property
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K) :
    SmallPairGraphProperty {smallPairA_48,smallPairB_48} := by
  intro t ht hproper hlarge hbound
  refine smallPairGraph_48_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound ?_ ?_
  · intro j
    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩
  · intro j h
    exact (hproper j).2.1 (by simp [h])
  · intro j h
    exact (hproper j).2.1 (by simp [h])

end D1Bound5
