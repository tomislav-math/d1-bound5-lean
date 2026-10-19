import D1Bound5.SmallTripleRepresentativeProperties

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem smallTripleProperty_of_table_orbits {tau nu : ℤ}
    (table : List (Finset (ℤ × ℤ))) (reps : Finset (Finset (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (smallTripleOrbit tau))
    (hreps : ∀ row ∈ reps, SmallTripleExtensionProperty (smallCoordinateSet tau nu row))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ table) :
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row) := by
  have h : row ∈ reps.biUnion (smallTripleOrbit tau) := by
    rw [← horbits]
    exact List.mem_toFinset.mpr hrow
  obtain ⟨rep, hrep, horbit⟩ := Finset.mem_biUnion.mp h
  exact smallTripleExtensionProperty_of_orbit rep row (hreps rep hrep) horbit

theorem smallTripleTable_0_1_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 0 1) :
    SmallTripleExtensionProperty (smallCoordinateSet 0 1 row) := by
  apply smallTripleProperty_of_table_orbits smallTriples_0_1
    smallTripleRepresentatives_0_1 smallTripleTable_orbits.1 ?_ row
    (by simpa [smallTripleTable] using hrow)
  intro rep hrep
  simp only [smallTripleRepresentatives_0_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl
  · have heq : smallCoordinateSet 0 1 {(-2,-2),(-2,2),(2,0)} =
        {smallTripleAnchorA_1, smallTripleAnchorB_1, smallTripleAnchorC_1} := by decide
    rw [heq]
    exact smallTripleRepresentative_1_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-1),(0,-1),(2,-1)} =
        {smallTripleAnchorA_2, smallTripleAnchorB_2, smallTripleAnchorC_2} := by decide
    rw [heq]
    exact smallTripleRepresentative_2_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,-1),(0,2),(2,-1)} =
        {smallTripleAnchorA_3, smallTripleAnchorB_3, smallTripleAnchorC_3} := by decide
    rw [heq]
    exact smallTripleRepresentative_3_property hK phi e
  · have heq : smallCoordinateSet 0 1 {(-2,0),(-1,-2),(1,0)} =
        {smallTripleAnchorA_4, smallTripleAnchorB_4, smallTripleAnchorC_4} := by decide
    rw [heq]
    exact smallTripleRepresentative_4_property hK phi e

theorem smallTripleTable_0_2_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 0 2) :
    SmallTripleExtensionProperty (smallCoordinateSet 0 2 row) := by
  apply smallTripleProperty_of_table_orbits smallTriples_0_2
    smallTripleRepresentatives_0_2 smallTripleTable_orbits.2.1 ?_ row
    (by simpa [smallTripleTable] using hrow)
  intro rep hrep
  simp only [smallTripleRepresentatives_0_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · have heq : smallCoordinateSet 0 2 {(-2,0),(1,-1),(1,1)} =
        {smallTripleAnchorA_5, smallTripleAnchorB_5, smallTripleAnchorC_5} := by decide
    rw [heq]
    exact smallTripleRepresentative_5_property hK phi e

theorem smallTripleTable_1_1_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 1 1) :
    SmallTripleExtensionProperty (smallCoordinateSet 1 1 row) := by
  apply smallTripleProperty_of_table_orbits smallTriples_1_1
    smallTripleRepresentatives_1_1 smallTripleTable_orbits.2.2.1 ?_ row
    (by simpa [smallTripleTable] using hrow)
  intro rep hrep
  simp only [smallTripleRepresentatives_1_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(-2,1),(1,0)} =
        {smallTripleAnchorA_6, smallTripleAnchorB_6, smallTripleAnchorC_6} := by decide
    rw [heq]
    exact smallTripleRepresentative_6_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(-1,-1),(2,-3),(1,0)} =
        {smallTripleAnchorA_7, smallTripleAnchorB_7, smallTripleAnchorC_7} := by decide
    rw [heq]
    exact smallTripleRepresentative_7_property hK phi e
  · have heq : smallCoordinateSet 1 1 {(0,-1),(1,-2),(1,-1)} =
        {smallTripleAnchorA_8, smallTripleAnchorB_8, smallTripleAnchorC_8} := by decide
    rw [heq]
    exact smallTripleRepresentative_8_property hK phi e

theorem smallTripleTable_1_2_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 1 2) :
    SmallTripleExtensionProperty (smallCoordinateSet 1 2 row) := by
  apply smallTripleProperty_of_table_orbits smallTriples_1_2
    smallTripleRepresentatives_1_2 smallTripleTable_orbits.2.2.2 ?_ row
    (by simpa [smallTripleTable] using hrow)
  intro rep hrep
  simp only [smallTripleRepresentatives_1_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(-3,1),(1,0)} =
        {smallTripleAnchorA_9, smallTripleAnchorB_9, smallTripleAnchorC_9} := by decide
    rw [heq]
    exact smallTripleRepresentative_9_property hK phi e
  · have heq : smallCoordinateSet 1 2 {(-2,-1),(-1,2),(3,-1)} =
        {smallTripleAnchorA_10, smallTripleAnchorB_10, smallTripleAnchorC_10} := by decide
    rw [heq]
    exact smallTripleRepresentative_10_property hK phi e

/-- All 24 coordinate triples inherit the representative extension theorem;
no ordering or unproved symmetry convention is imposed on the input row. -/
theorem smallTripleTable_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨
      (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable tau nu) :
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row) := by
  rcases hmodel with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact smallTripleTable_0_1_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_0_2_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_1_1_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_1_2_extension_property_full_ring hK phi e row hrow

end D1Bound5
