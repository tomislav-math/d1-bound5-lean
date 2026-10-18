import D1Bound5.FirstPairGeometryData
import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5

/-- Exact equality of the pair and all five evaluated coefficient parameters.
No field equivalence or polynomial bound is inferred by this data link. -/
def FirstPairGeometryMatches (g : FirstPairGeometryRow) (r : OneSmallCutoffRow) : Prop :=
  g.tau=r.triple.tau ∧ g.nu=r.triple.nu ∧ g.a=r.triple.a ∧ g.b=r.triple.b ∧
  g.M2=r.M2 ∧ g.Mn=r.Mn ∧ g.M3=r.M3 ∧ g.M4=r.M4 ∧ g.M5=r.M5

instance (g : FirstPairGeometryRow) (r : OneSmallCutoffRow) :
    Decidable (FirstPairGeometryMatches g r) := by
  unfold FirstPairGeometryMatches
  infer_instance

set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem firstPairGeometryRow_0_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_0 r := by
  refine ⟨oneSmallCutoffRow_0,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_1_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_1 r := by
  refine ⟨oneSmallCutoffRow_3,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_2_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_2 r := by
  refine ⟨oneSmallCutoffRow_4,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_3_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_3 r := by
  refine ⟨oneSmallCutoffRow_6,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_4_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_4 r := by
  refine ⟨oneSmallCutoffRow_7,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_5_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_5 r := by
  refine ⟨oneSmallCutoffRow_9,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_6_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_6 r := by
  refine ⟨oneSmallCutoffRow_10,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_7_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_7 r := by
  refine ⟨oneSmallCutoffRow_11,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_8_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_8 r := by
  refine ⟨oneSmallCutoffRow_13,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_9_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_9 r := by
  refine ⟨oneSmallCutoffRow_14,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_10_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_10 r := by
  refine ⟨oneSmallCutoffRow_15,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_11_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_11 r := by
  refine ⟨oneSmallCutoffRow_16,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_12_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_12 r := by
  refine ⟨oneSmallCutoffRow_17,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_13_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_13 r := by
  refine ⟨oneSmallCutoffRow_18,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_14_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_14 r := by
  refine ⟨oneSmallCutoffRow_19,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_15_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_15 r := by
  refine ⟨oneSmallCutoffRow_20,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_16_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_16 r := by
  refine ⟨oneSmallCutoffRow_21,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_17_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_17 r := by
  refine ⟨oneSmallCutoffRow_23,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_18_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_18 r := by
  refine ⟨oneSmallCutoffRow_24,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_19_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_19 r := by
  refine ⟨oneSmallCutoffRow_25,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_20_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_20 r := by
  refine ⟨oneSmallCutoffRow_26,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_21_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_21 r := by
  refine ⟨oneSmallCutoffRow_28,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_22_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_22 r := by
  refine ⟨oneSmallCutoffRow_29,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_23_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_23 r := by
  refine ⟨oneSmallCutoffRow_31,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_24_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_24 r := by
  refine ⟨oneSmallCutoffRow_33,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_25_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_25 r := by
  refine ⟨oneSmallCutoffRow_34,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_26_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_26 r := by
  refine ⟨oneSmallCutoffRow_36,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_27_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_27 r := by
  refine ⟨oneSmallCutoffRow_37,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_28_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_28 r := by
  refine ⟨oneSmallCutoffRow_39,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_29_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_29 r := by
  refine ⟨oneSmallCutoffRow_40,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_30_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_30 r := by
  refine ⟨oneSmallCutoffRow_41,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_31_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_31 r := by
  refine ⟨oneSmallCutoffRow_42,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_32_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_32 r := by
  refine ⟨oneSmallCutoffRow_44,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_33_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_33 r := by
  refine ⟨oneSmallCutoffRow_45,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_34_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_34 r := by
  refine ⟨oneSmallCutoffRow_47,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_35_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_35 r := by
  refine ⟨oneSmallCutoffRow_48,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_36_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_36 r := by
  refine ⟨oneSmallCutoffRow_50,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_37_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_37 r := by
  refine ⟨oneSmallCutoffRow_51,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_38_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_38 r := by
  refine ⟨oneSmallCutoffRow_53,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_39_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_39 r := by
  refine ⟨oneSmallCutoffRow_55,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRow_40_has_fixed_row :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches firstPairGeometryRow_40 r := by
  refine ⟨oneSmallCutoffRow_56,?_,?_⟩
  · decide +kernel
  · decide +kernel

theorem firstPairGeometryRows_have_fixed_row (g : FirstPairGeometryRow)
    (hg : g ∈ firstPairGeometryRows) :
    ∃ r ∈ oneSmallCutoffRows, FirstPairGeometryMatches g r := by
  simp only [firstPairGeometryRows,List.mem_cons,List.mem_singleton] at hg
  rcases hg with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact firstPairGeometryRow_0_has_fixed_row
  · exact firstPairGeometryRow_1_has_fixed_row
  · exact firstPairGeometryRow_2_has_fixed_row
  · exact firstPairGeometryRow_3_has_fixed_row
  · exact firstPairGeometryRow_4_has_fixed_row
  · exact firstPairGeometryRow_5_has_fixed_row
  · exact firstPairGeometryRow_6_has_fixed_row
  · exact firstPairGeometryRow_7_has_fixed_row
  · exact firstPairGeometryRow_8_has_fixed_row
  · exact firstPairGeometryRow_9_has_fixed_row
  · exact firstPairGeometryRow_10_has_fixed_row
  · exact firstPairGeometryRow_11_has_fixed_row
  · exact firstPairGeometryRow_12_has_fixed_row
  · exact firstPairGeometryRow_13_has_fixed_row
  · exact firstPairGeometryRow_14_has_fixed_row
  · exact firstPairGeometryRow_15_has_fixed_row
  · exact firstPairGeometryRow_16_has_fixed_row
  · exact firstPairGeometryRow_17_has_fixed_row
  · exact firstPairGeometryRow_18_has_fixed_row
  · exact firstPairGeometryRow_19_has_fixed_row
  · exact firstPairGeometryRow_20_has_fixed_row
  · exact firstPairGeometryRow_21_has_fixed_row
  · exact firstPairGeometryRow_22_has_fixed_row
  · exact firstPairGeometryRow_23_has_fixed_row
  · exact firstPairGeometryRow_24_has_fixed_row
  · exact firstPairGeometryRow_25_has_fixed_row
  · exact firstPairGeometryRow_26_has_fixed_row
  · exact firstPairGeometryRow_27_has_fixed_row
  · exact firstPairGeometryRow_28_has_fixed_row
  · exact firstPairGeometryRow_29_has_fixed_row
  · exact firstPairGeometryRow_30_has_fixed_row
  · exact firstPairGeometryRow_31_has_fixed_row
  · exact firstPairGeometryRow_32_has_fixed_row
  · exact firstPairGeometryRow_33_has_fixed_row
  · exact firstPairGeometryRow_34_has_fixed_row
  · exact firstPairGeometryRow_35_has_fixed_row
  · exact firstPairGeometryRow_36_has_fixed_row
  · exact firstPairGeometryRow_37_has_fixed_row
  · exact firstPairGeometryRow_38_has_fixed_row
  · exact firstPairGeometryRow_39_has_fixed_row
  · exact firstPairGeometryRow_40_has_fixed_row

end D1Bound5
