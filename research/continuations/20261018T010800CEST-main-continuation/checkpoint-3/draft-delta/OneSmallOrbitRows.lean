import D1Bound5.OneSmallSymmetry

namespace D1Bound5
open QuadInt

theorem firstPairTable_0_1_third_rows (a b s : QuadInt 0 1)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 1)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_0_1
    firstPairRepresentatives_0_1 firstPairTable_0_1_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_0_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact oneSmallThirdRows_0_complete
  · exact oneSmallThirdRows_1_complete
  · exact oneSmallThirdRows_2_complete
  · exact oneSmallThirdRows_3_complete
  · exact oneSmallThirdRows_4_complete
  · exact oneSmallThirdRows_5_complete
  · exact oneSmallThirdRows_6_complete
  · exact oneSmallThirdRows_38_complete
  · exact oneSmallThirdRows_39_complete

theorem firstPairTable_0_2_third_rows (a b s : QuadInt 0 2)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 2)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_0_2
    firstPairRepresentatives_0_2 firstPairTable_0_2_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_0_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl
  · exact oneSmallThirdRows_7_complete
  · exact oneSmallThirdRows_8_complete
  · exact oneSmallThirdRows_9_complete

theorem firstPairTable_0_5_third_rows (a b s : QuadInt 0 5)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 5)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_0_5
    firstPairRepresentatives_0_5 firstPairTable_0_5_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_0_5, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_25_complete
  · exact oneSmallThirdRows_26_complete

theorem firstPairTable_0_6_third_rows (a b s : QuadInt 0 6)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 6)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_0_6
    firstPairRepresentatives_0_6 firstPairTable_0_6_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_0_6, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_27_complete
  · exact oneSmallThirdRows_28_complete

theorem firstPairTable_1_1_third_rows (a b s : QuadInt 1 1)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 1)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_1
    firstPairRepresentatives_1_1 firstPairTable_1_1_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_1, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact oneSmallThirdRows_10_complete
  · exact oneSmallThirdRows_11_complete
  · exact oneSmallThirdRows_12_complete
  · exact oneSmallThirdRows_13_complete
  · exact oneSmallThirdRows_14_complete
  · exact oneSmallThirdRows_15_complete
  · exact oneSmallThirdRows_16_complete
  · exact oneSmallThirdRows_17_complete
  · exact oneSmallThirdRows_18_complete
  · exact oneSmallThirdRows_19_complete
  · exact oneSmallThirdRows_20_complete
  · exact oneSmallThirdRows_21_complete
  · exact oneSmallThirdRows_22_complete
  · exact oneSmallThirdRows_23_complete
  · exact oneSmallThirdRows_24_complete

theorem firstPairTable_1_2_third_rows (a b s : QuadInt 1 2)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 2)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_2
    firstPairRepresentatives_1_2 firstPairTable_1_2_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_2, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_29_complete
  · exact oneSmallThirdRows_30_complete

theorem firstPairTable_1_3_third_rows (a b s : QuadInt 1 3)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 3)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_3
    firstPairRepresentatives_1_3 firstPairTable_1_3_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_3, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_31_complete
  · exact oneSmallThirdRows_32_complete

theorem firstPairTable_1_4_third_rows (a b s : QuadInt 1 4)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 4)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_4
    firstPairRepresentatives_1_4 firstPairTable_1_4_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_4, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_33_complete
  · exact oneSmallThirdRows_34_complete

theorem firstPairTable_1_5_third_rows (a b s : QuadInt 1 5)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 5)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_5
    firstPairRepresentatives_1_5 firstPairTable_1_5_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_5, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl | rfl
  · exact oneSmallThirdRows_35_complete
  · exact oneSmallThirdRows_36_complete

theorem firstPairTable_1_6_third_rows (a b s : QuadInt 1 6)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 6)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  apply oneSmallThirdRows_of_table_orbits firstPairs_1_6
    firstPairRepresentatives_1_6 firstPairTable_1_6_orbits ?_ a b s
    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair
  intro rep hrep
  simp only [firstPairRepresentatives_1_6, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with rfl
  · exact oneSmallThirdRows_37_complete

theorem firstPairTable_third_rows {tau nu : ℤ}
    (hmodel : (tau,nu) ∈ smallPairModels) (a b s : QuadInt tau nu)
    (hrow : firstPairCoordinates a b ∈ firstPairTable tau nu)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  simp only [smallPairModels, Finset.mem_insert, Finset.mem_singleton, Prod.mk.injEq] at hmodel
  rcases hmodel with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact firstPairTable_0_1_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_0_2_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_0_5_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_0_6_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_1_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_2_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_3_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_4_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_5_third_rows a b s hrow hbound horder ha hb hpair
  · exact firstPairTable_1_6_third_rows a b s hrow hbound horder ha hb hpair
  · simp [firstPairTable,firstPairs_1_8] at hrow

end D1Bound5
