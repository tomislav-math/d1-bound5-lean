import D1Bound5.FirstPairFifteenExclusion
import D1Bound5.OneSmallSymmetry

namespace D1Bound5
open QuadInt

private theorem firstPairGeometry_normalize_of_orbits {tau nu : ℤ}
    (table : List ((ℤ × ℤ) × (ℤ × ℤ)))
    (reps : Finset ((ℤ × ℤ) × (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (firstPairOrbit tau))
    (hcover : reps ⊆ (firstPairGeometryRowsAt tau nu).toFinset)
    (a b : QuadInt tau nu) (hrow : firstPairCoordinates a b ∈ table) :
    ∃ g ∈ firstPairGeometryRows, g.tau=tau ∧ g.nu=nu ∧
      ∃ sgn conj : Bool,
        firstPairCoordinates (smallExtensionSymmetry sgn conj a)
          (smallExtensionSymmetry sgn conj b) = (g.a,g.b) := by
  have hmem : firstPairCoordinates a b ∈ reps.biUnion (firstPairOrbit tau) := by
    rw [←horbits]
    exact List.mem_toFinset.mpr hrow
  obtain ⟨rep,hrep,horbit⟩ := Finset.mem_biUnion.mp hmem
  obtain ⟨sgn,conj,heA,heB⟩ := firstPairOrbit_normalize a b rep horbit
  have hc : rep ∈ firstPairGeometryRowsAt tau nu := List.mem_toFinset.mp (hcover hrep)
  unfold firstPairGeometryRowsAt at hc
  obtain ⟨g,hg,hge⟩ := List.mem_map.mp hc
  obtain ⟨hg,hgm⟩ := List.mem_filter.mp hg
  have hgm' : g.tau=tau ∧ g.nu=nu := by simpa using hgm
  refine ⟨g,hg,hgm'.1,hgm'.2,sgn,conj,?_⟩
  rw [heA,heB]
  simpa only [firstPairCoordinates,firstPairRowA,firstPairRowB] using hge.symm

/-- Every classified nonrational first pair has one simultaneous sign
and conjugation normalization to a certified geometry row. -/
theorem firstPairTable_geometry_normalize {tau nu : ℤ}
    (hmodel : (tau,nu) ∈ smallPairModels) (a b : QuadInt tau nu)
    (hrow : firstPairCoordinates a b ∈ firstPairTable tau nu) :
    ∃ g ∈ firstPairGeometryRows, g.tau=tau ∧ g.nu=nu ∧
      ∃ sgn conj : Bool,
        firstPairCoordinates (smallExtensionSymmetry sgn conj a)
          (smallExtensionSymmetry sgn conj b) = (g.a,g.b) := by
  simp only [smallPairModels,Finset.mem_insert,Finset.mem_singleton,Prod.mk.injEq] at hmodel
  rcases hmodel with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ |
    ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ |
    ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact firstPairGeometry_normalize_of_orbits firstPairs_0_1
      firstPairRepresentatives_0_1 firstPairTable_0_1_orbits
      firstPairGeometryRowsAt_covers_0_1 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_0_2
      firstPairRepresentatives_0_2 firstPairTable_0_2_orbits
      firstPairGeometryRowsAt_covers_0_2 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_0_5
      firstPairRepresentatives_0_5 firstPairTable_0_5_orbits
      firstPairGeometryRowsAt_covers_0_5 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_0_6
      firstPairRepresentatives_0_6 firstPairTable_0_6_orbits
      firstPairGeometryRowsAt_covers_0_6 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_1
      firstPairRepresentatives_1_1 firstPairTable_1_1_orbits
      firstPairGeometryRowsAt_covers_1_1 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_2
      firstPairRepresentatives_1_2 firstPairTable_1_2_orbits
      firstPairGeometryRowsAt_covers_1_2 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_3
      firstPairRepresentatives_1_3 firstPairTable_1_3_orbits
      firstPairGeometryRowsAt_covers_1_3 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_4
      firstPairRepresentatives_1_4 firstPairTable_1_4_orbits
      firstPairGeometryRowsAt_covers_1_4 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_5
      firstPairRepresentatives_1_5 firstPairTable_1_5_orbits
      firstPairGeometryRowsAt_covers_1_5 a b (by simpa [firstPairTable] using hrow)
  · exact firstPairGeometry_normalize_of_orbits firstPairs_1_6
      firstPairRepresentatives_1_6 firstPairTable_1_6_orbits
      firstPairGeometryRowsAt_covers_1_6 a b (by simpa [firstPairTable] using hrow)
  · simp [firstPairTable,firstPairs_1_8] at hrow

end D1Bound5
