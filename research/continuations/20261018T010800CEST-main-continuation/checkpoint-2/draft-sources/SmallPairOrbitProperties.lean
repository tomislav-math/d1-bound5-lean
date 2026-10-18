import D1Bound5.SmallPairRepresentativeProperties

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem smallPairProperty_of_table_orbits {tau nu : ℤ}
    (table : List (Finset (ℤ × ℤ))) (reps : Finset (Finset (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (smallTripleOrbit tau))
    (hreps : ∀ row ∈ reps, SmallPairGraphProperty (smallCoordinateSet tau nu row))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ table) :
    SmallPairGraphProperty (smallCoordinateSet tau nu row) := by
  have h : row ∈ reps.biUnion (smallTripleOrbit tau) := by
    rw [← horbits]
    exact List.mem_toFinset.mpr hrow
  obtain ⟨rep, hrep, horbit⟩ := Finset.mem_biUnion.mp h
  exact smallPairGraphProperty_of_orbit rep row (hreps rep hrep) horbit

theorem smallPairTable_0_1_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 1) :
    SmallPairGraphProperty (smallCoordinateSet 0 1 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_0_1
    smallPairRepresentatives_0_1 smallPairTable_0_1_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_0_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · have heq : smallCoordinateSet 0 1 {(-2,-2),(-2,2)} =
        {smallPairA_1,smallPairB_1} := by decide
    rw [heq]
    exact smallPairRepresentative_1_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-2),(0,-2)} =
        {smallPairA_2,smallPairB_2} := by decide
    rw [heq]
    exact smallPairRepresentative_2_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-2),(2,0)} =
        {smallPairA_3,smallPairB_3} := by decide
    rw [heq]
    exact smallPairRepresentative_3_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-1),(0,-1)} =
        {smallPairA_4,smallPairB_4} := by decide
    rw [heq]
    exact smallPairRepresentative_4_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-1),(0,2)} =
        {smallPairA_5,smallPairB_5} := by decide
    rw [heq]
    exact smallPairRepresentative_5_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-1),(2,-1)} =
        {smallPairA_6,smallPairB_6} := by decide
    rw [heq]
    exact smallPairRepresentative_6_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,0),(-1,-2)} =
        {smallPairA_7,smallPairB_7} := by decide
    rw [heq]
    exact smallPairRepresentative_7_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,0),(1,0)} =
        {smallPairA_8,smallPairB_8} := by decide
    rw [heq]
    exact smallPairRepresentative_8_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-1,-2),(1,-2)} =
        {smallPairA_9,smallPairB_9} := by decide
    rw [heq]
    exact smallPairRepresentative_9_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-1,-2),(1,0)} =
        {smallPairA_10,smallPairB_10} := by decide
    rw [heq]
    exact smallPairRepresentative_10_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-1,-1),(1,-1)} =
        {smallPairA_11,smallPairB_11} := by decide
    rw [heq]
    exact smallPairRepresentative_11_graph_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(0,-2),(0,-1)} =
        {smallPairA_12,smallPairB_12} := by decide
    rw [heq]
    exact smallPairRepresentative_12_graph_property hK phi e

theorem smallPairTable_0_2_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 2) :
    SmallPairGraphProperty (smallCoordinateSet 0 2 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_0_2
    smallPairRepresentatives_0_2 smallPairTable_0_2_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_0_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl
  · have heq : smallCoordinateSet 0 2 {(-2,-1),(0,-1)} =
        {smallPairA_13,smallPairB_13} := by decide
    rw [heq]
    exact smallPairRepresentative_13_graph_property hK phi e
  · have heq : smallCoordinateSet 0 2 {(-2,0),(1,-1)} =
        {smallPairA_14,smallPairB_14} := by decide
    rw [heq]
    exact smallPairRepresentative_14_graph_property hK phi e
  · have heq : smallCoordinateSet 0 2 {(-1,-1),(-1,1)} =
        {smallPairA_15,smallPairB_15} := by decide
    rw [heq]
    exact smallPairRepresentative_15_graph_property hK phi e
  · have heq : smallCoordinateSet 0 2 {(-1,-1),(1,-1)} =
        {smallPairA_16,smallPairB_16} := by decide
    rw [heq]
    exact smallPairRepresentative_16_graph_property hK phi e
  · have heq : smallCoordinateSet 0 2 {(0,-2),(0,2)} =
        {smallPairA_17,smallPairB_17} := by decide
    rw [heq]
    exact smallPairRepresentative_17_graph_property hK phi e

theorem smallPairTable_0_5_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 5) :
    SmallPairGraphProperty (smallCoordinateSet 0 5 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_0_5
    smallPairRepresentatives_0_5 smallPairTable_0_5_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_0_5, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 0 5 {(-1,-1),(1,-1)} =
        {smallPairA_31,smallPairB_31} := by decide
    rw [heq]
    exact smallPairRepresentative_31_graph_property hK phi e

theorem smallPairTable_0_6_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 6) :
    SmallPairGraphProperty (smallCoordinateSet 0 6 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_0_6
    smallPairRepresentatives_0_6 smallPairTable_0_6_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_0_6, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 0 6 {(-1,-1),(1,-1)} =
        {smallPairA_32,smallPairB_32} := by decide
    rw [heq]
    exact smallPairRepresentative_32_graph_property hK phi e

theorem smallPairTable_1_1_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 1) :
    SmallPairGraphProperty (smallCoordinateSet 1 1 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_1
    smallPairRepresentatives_1_1 smallPairTable_1_1_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · have heq : smallCoordinateSet 1 1 {(-2,-1),(0,-1)} =
        {smallPairA_18,smallPairB_18} := by decide
    rw [heq]
    exact smallPairRepresentative_18_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-2,-1),(1,1)} =
        {smallPairA_19,smallPairB_19} := by decide
    rw [heq]
    exact smallPairRepresentative_19_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-2),(1,-2)} =
        {smallPairA_20,smallPairB_20} := by decide
    rw [heq]
    exact smallPairRepresentative_20_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-2),(0,1)} =
        {smallPairA_21,smallPairB_21} := by decide
    rw [heq]
    exact smallPairRepresentative_21_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-2,0),(2,0)} =
        {smallPairA_22,smallPairB_22} := by decide
    rw [heq]
    exact smallPairRepresentative_22_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(-2,1)} =
        {smallPairA_23,smallPairB_23} := by decide
    rw [heq]
    exact smallPairRepresentative_23_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(2,-3)} =
        {smallPairA_24,smallPairB_24} := by decide
    rw [heq]
    exact smallPairRepresentative_24_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(1,-1)} =
        {smallPairA_25,smallPairB_25} := by decide
    rw [heq]
    exact smallPairRepresentative_25_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(1,0)} =
        {smallPairA_26,smallPairB_26} := by decide
    rw [heq]
    exact smallPairRepresentative_26_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(0,-2),(2,-2)} =
        {smallPairA_27,smallPairB_27} := by decide
    rw [heq]
    exact smallPairRepresentative_27_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,0),(1,-3)} =
        {smallPairA_28,smallPairB_28} := by decide
    rw [heq]
    exact smallPairRepresentative_28_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(0,-1),(1,-2)} =
        {smallPairA_29,smallPairB_29} := by decide
    rw [heq]
    exact smallPairRepresentative_29_graph_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(1,-2),(-1,2)} =
        {smallPairA_30,smallPairB_30} := by decide
    rw [heq]
    exact smallPairRepresentative_30_graph_property hK phi e

theorem smallPairTable_1_2_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 2) :
    SmallPairGraphProperty (smallCoordinateSet 1 2 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_2
    smallPairRepresentatives_1_2 smallPairTable_1_2_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(-3,1)} =
        {smallPairA_33,smallPairB_33} := by decide
    rw [heq]
    exact smallPairRepresentative_33_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(0,-1)} =
        {smallPairA_34,smallPairB_34} := by decide
    rw [heq]
    exact smallPairRepresentative_34_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(-1,2)} =
        {smallPairA_35,smallPairB_35} := by decide
    rw [heq]
    exact smallPairRepresentative_35_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(1,0)} =
        {smallPairA_36,smallPairB_36} := by decide
    rw [heq]
    exact smallPairRepresentative_36_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(3,-1)} =
        {smallPairA_37,smallPairB_37} := by decide
    rw [heq]
    exact smallPairRepresentative_37_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-1,-1),(1,-1)} =
        {smallPairA_38,smallPairB_38} := by decide
    rw [heq]
    exact smallPairRepresentative_38_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-1,-1),(1,1)} =
        {smallPairA_39,smallPairB_39} := by decide
    rw [heq]
    exact smallPairRepresentative_39_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(0,-2),(-2,2)} =
        {smallPairA_40,smallPairB_40} := by decide
    rw [heq]
    exact smallPairRepresentative_40_graph_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(0,-2),(2,-2)} =
        {smallPairA_41,smallPairB_41} := by decide
    rw [heq]
    exact smallPairRepresentative_41_graph_property hK phi e

theorem smallPairTable_1_3_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 3) :
    SmallPairGraphProperty (smallCoordinateSet 1 3 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_3
    smallPairRepresentatives_1_3 smallPairTable_1_3_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_3, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · have heq : smallCoordinateSet 1 3 {(-1,-1),(1,-1)} =
        {smallPairA_42,smallPairB_42} := by decide
    rw [heq]
    exact smallPairRepresentative_42_graph_property hK phi e
  · have heq : smallCoordinateSet 1 3 {(0,-1),(-1,1)} =
        {smallPairA_43,smallPairB_43} := by decide
    rw [heq]
    exact smallPairRepresentative_43_graph_property hK phi e

theorem smallPairTable_1_4_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 4) :
    SmallPairGraphProperty (smallCoordinateSet 1 4 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_4
    smallPairRepresentatives_1_4 smallPairTable_1_4_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_4, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 1 4 {(-1,-1),(1,-1)} =
        {smallPairA_44,smallPairB_44} := by decide
    rw [heq]
    exact smallPairRepresentative_44_graph_property hK phi e

theorem smallPairTable_1_5_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 5) :
    SmallPairGraphProperty (smallCoordinateSet 1 5 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_5
    smallPairRepresentatives_1_5 smallPairTable_1_5_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_5, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 1 5 {(-1,-1),(1,-1)} =
        {smallPairA_45,smallPairB_45} := by decide
    rw [heq]
    exact smallPairRepresentative_45_graph_property hK phi e

theorem smallPairTable_1_6_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 6) :
    SmallPairGraphProperty (smallCoordinateSet 1 6 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_6
    smallPairRepresentatives_1_6 smallPairTable_1_6_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_6, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · have heq : smallCoordinateSet 1 6 {(-1,-1),(-2,1)} =
        {smallPairA_46,smallPairB_46} := by decide
    rw [heq]
    exact smallPairRepresentative_46_graph_property hK phi e
  · have heq : smallCoordinateSet 1 6 {(-1,-1),(1,-1)} =
        {smallPairA_47,smallPairB_47} := by decide
    rw [heq]
    exact smallPairRepresentative_47_graph_property hK phi e

theorem smallPairTable_1_8_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 8) :
    SmallPairGraphProperty (smallCoordinateSet 1 8 row) := by
  apply smallPairProperty_of_table_orbits smallPairs_1_8
    smallPairRepresentatives_1_8 smallPairTable_1_8_orbits ?_ row
    (by simpa [smallPairTable] using hrow)
  intro rep hrep
  simp only [smallPairRepresentatives_1_8, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 1 8 {(0,-1),(-1,1)} =
        {smallPairA_48,smallPairB_48} := by decide
    rw [heq]
    exact smallPairRepresentative_48_graph_property hK phi e

/-- Every table row inherits its representative triangle exclusion. -/
theorem smallPairTable_graph_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau,nu) ∈ smallPairModels)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable tau nu) :
    SmallPairGraphProperty (smallCoordinateSet tau nu row) := by
  simp only [smallPairModels, Finset.mem_insert, Finset.mem_singleton, Prod.mk.injEq] at hmodel
  rcases hmodel with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact smallPairTable_0_1_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_0_2_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_0_5_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_0_6_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_1_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_2_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_3_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_4_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_5_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_6_graph_property_full_ring hK phi e row hrow
  · exact smallPairTable_1_8_graph_property_full_ring hK phi e row hrow

end D1Bound5
