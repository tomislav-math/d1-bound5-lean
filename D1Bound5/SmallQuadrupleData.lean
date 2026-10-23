import D1Bound5.SmallQuadrupleCheck
import Mathlib.Tactic.IntervalCases

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def smallDisk_0_1 : List (QuadInt 0 1) := [⟨-2,-2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨2,2⟩]

theorem smallDisk_0_1_eq : disk 0 1 8 = smallDisk_0_1.toFinset := by
  decide +kernel

theorem smallDisk_0_1_checked : smallQuadrupleListBool smallDisk_0_1 = true := by
  decide +kernel

theorem noSmallQuadruple_0_1 : NoSmallQuadruple 0 1 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_1
  · intro z hz
    rw [smallDisk_0_1_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_1_checked

def smallDisk_0_2 : List (QuadInt 0 2) := [⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩]

theorem smallDisk_0_2_eq : disk 0 2 8 = smallDisk_0_2.toFinset := by
  decide +kernel

theorem smallDisk_0_2_checked : smallQuadrupleListBool smallDisk_0_2 = true := by
  decide +kernel

theorem noSmallQuadruple_0_2 : NoSmallQuadruple 0 2 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_2
  · intro z hz
    rw [smallDisk_0_2_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_2_checked

def smallDisk_0_3 : List (QuadInt 0 3) := [⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩]

theorem smallDisk_0_3_eq : disk 0 3 8 = smallDisk_0_3.toFinset := by
  decide +kernel

theorem smallDisk_0_3_checked : smallQuadrupleListBool smallDisk_0_3 = true := by
  decide +kernel

theorem noSmallQuadruple_0_3 : NoSmallQuadruple 0 3 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_3
  · intro z hz
    rw [smallDisk_0_3_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_3_checked

def smallDisk_0_4 : List (QuadInt 0 4) := [⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩]

theorem smallDisk_0_4_eq : disk 0 4 8 = smallDisk_0_4.toFinset := by
  decide +kernel

theorem smallDisk_0_4_checked : smallQuadrupleListBool smallDisk_0_4 = true := by
  decide +kernel

theorem noSmallQuadruple_0_4 : NoSmallQuadruple 0 4 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_4
  · intro z hz
    rw [smallDisk_0_4_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_4_checked

def smallDisk_0_5 : List (QuadInt 0 5) := [⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩]

theorem smallDisk_0_5_eq : disk 0 5 8 = smallDisk_0_5.toFinset := by
  decide +kernel

theorem smallDisk_0_5_checked : smallQuadrupleListBool smallDisk_0_5 = true := by
  decide +kernel

theorem noSmallQuadruple_0_5 : NoSmallQuadruple 0 5 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_5
  · intro z hz
    rw [smallDisk_0_5_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_5_checked

def smallDisk_0_6 : List (QuadInt 0 6) := [⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩]

theorem smallDisk_0_6_eq : disk 0 6 8 = smallDisk_0_6.toFinset := by
  decide +kernel

theorem smallDisk_0_6_checked : smallQuadrupleListBool smallDisk_0_6 = true := by
  decide +kernel

theorem noSmallQuadruple_0_6 : NoSmallQuadruple 0 6 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_6
  · intro z hz
    rw [smallDisk_0_6_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_6_checked

def smallDisk_0_7 : List (QuadInt 0 7) := [⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩]

theorem smallDisk_0_7_eq : disk 0 7 8 = smallDisk_0_7.toFinset := by
  decide +kernel

theorem smallDisk_0_7_checked : smallQuadrupleListBool smallDisk_0_7 = true := by
  decide +kernel

theorem noSmallQuadruple_0_7 : NoSmallQuadruple 0 7 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_7
  · intro z hz
    rw [smallDisk_0_7_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_7_checked

def smallDisk_0_8 : List (QuadInt 0 8) := [⟨-2,0⟩, ⟨-1,0⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,0⟩, ⟨2,0⟩]

theorem smallDisk_0_8_eq : disk 0 8 8 = smallDisk_0_8.toFinset := by
  decide +kernel

theorem smallDisk_0_8_checked : smallQuadrupleListBool smallDisk_0_8 = true := by
  decide +kernel

theorem noSmallQuadruple_0_8 : NoSmallQuadruple 0 8 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_0_8
  · intro z hz
    rw [smallDisk_0_8_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_0_8_checked

def smallDisk_1_1 : List (QuadInt 1 1) := [⟨-3,1⟩, ⟨-3,2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-2,3⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨-1,3⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-3⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-3⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-2⟩, ⟨3,-1⟩]

theorem smallDisk_1_1_eq : disk 1 1 8 = smallDisk_1_1.toFinset := by
  decide +kernel

theorem smallDisk_1_1_checked : smallQuadrupleListBool smallDisk_1_1 = true := by
  decide +kernel

theorem noSmallQuadruple_1_1 : NoSmallQuadruple 1 1 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_1
  · intro z hz
    rw [smallDisk_1_1_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_1_checked

def smallDisk_1_2 : List (QuadInt 1 2) := [⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩]

theorem smallDisk_1_2_eq : disk 1 2 8 = smallDisk_1_2.toFinset := by
  decide +kernel

theorem smallDisk_1_2_checked : smallQuadrupleListBool smallDisk_1_2 = true := by
  decide +kernel

theorem noSmallQuadruple_1_2 : NoSmallQuadruple 1 2 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_2
  · intro z hz
    rw [smallDisk_1_2_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_2_checked

def smallDisk_1_3 : List (QuadInt 1 3) := [⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩]

theorem smallDisk_1_3_eq : disk 1 3 8 = smallDisk_1_3.toFinset := by
  decide +kernel

theorem smallDisk_1_3_checked : smallQuadrupleListBool smallDisk_1_3 = true := by
  decide +kernel

theorem noSmallQuadruple_1_3 : NoSmallQuadruple 1 3 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_3
  · intro z hz
    rw [smallDisk_1_3_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_3_checked

def smallDisk_1_4 : List (QuadInt 1 4) := [⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩]

theorem smallDisk_1_4_eq : disk 1 4 8 = smallDisk_1_4.toFinset := by
  decide +kernel

theorem smallDisk_1_4_checked : smallQuadrupleListBool smallDisk_1_4 = true := by
  decide +kernel

theorem noSmallQuadruple_1_4 : NoSmallQuadruple 1 4 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_4
  · intro z hz
    rw [smallDisk_1_4_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_4_checked

def smallDisk_1_5 : List (QuadInt 1 5) := [⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩]

theorem smallDisk_1_5_eq : disk 1 5 8 = smallDisk_1_5.toFinset := by
  decide +kernel

theorem smallDisk_1_5_checked : smallQuadrupleListBool smallDisk_1_5 = true := by
  decide +kernel

theorem noSmallQuadruple_1_5 : NoSmallQuadruple 1 5 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_5
  · intro z hz
    rw [smallDisk_1_5_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_5_checked

def smallDisk_1_6 : List (QuadInt 1 6) := [⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩]

theorem smallDisk_1_6_eq : disk 1 6 8 = smallDisk_1_6.toFinset := by
  decide +kernel

theorem smallDisk_1_6_checked : smallQuadrupleListBool smallDisk_1_6 = true := by
  decide +kernel

theorem noSmallQuadruple_1_6 : NoSmallQuadruple 1 6 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_6
  · intro z hz
    rw [smallDisk_1_6_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_6_checked

def smallDisk_1_7 : List (QuadInt 1 7) := [⟨-2,0⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨2,0⟩]

theorem smallDisk_1_7_eq : disk 1 7 8 = smallDisk_1_7.toFinset := by
  decide +kernel

theorem smallDisk_1_7_checked : smallQuadrupleListBool smallDisk_1_7 = true := by
  decide +kernel

theorem noSmallQuadruple_1_7 : NoSmallQuadruple 1 7 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_7
  · intro z hz
    rw [smallDisk_1_7_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_7_checked

def smallDisk_1_8 : List (QuadInt 1 8) := [⟨-2,0⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨2,0⟩]

theorem smallDisk_1_8_eq : disk 1 8 8 = smallDisk_1_8.toFinset := by
  decide +kernel

theorem smallDisk_1_8_checked : smallQuadrupleListBool smallDisk_1_8 = true := by
  decide +kernel

theorem noSmallQuadruple_1_8 : NoSmallQuadruple 1 8 := by
  apply noSmallQuadruple_of_explicit_list (by decide) smallDisk_1_8
  · intro z hz
    rw [smallDisk_1_8_eq, List.mem_toFinset] at hz
    exact hz
  · exact smallDisk_1_8_checked

/-- The complete sixteen-model rectangle. Nonmaximal orders are retained. -/
theorem noSmallQuadruple_rectangular {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8) :
    NoSmallQuadruple tau nu := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · exact noSmallQuadruple_0_1
    · exact noSmallQuadruple_0_2
    · exact noSmallQuadruple_0_3
    · exact noSmallQuadruple_0_4
    · exact noSmallQuadruple_0_5
    · exact noSmallQuadruple_0_6
    · exact noSmallQuadruple_0_7
    · exact noSmallQuadruple_0_8
  · interval_cases nu
    · exact noSmallQuadruple_1_1
    · exact noSmallQuadruple_1_2
    · exact noSmallQuadruple_1_3
    · exact noSmallQuadruple_1_4
    · exact noSmallQuadruple_1_5
    · exact noSmallQuadruple_1_6
    · exact noSmallQuadruple_1_7
    · exact noSmallQuadruple_1_8

end D1Bound5
