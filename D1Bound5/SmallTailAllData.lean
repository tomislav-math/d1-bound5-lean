import D1Bound5.SmallTailData0_1
import D1Bound5.SmallTailModel15

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def tailDisk_0_2 : List (QuadInt 0 2) := [⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨2,2⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_2_eq : disk 0 2 15 = tailDisk_0_2.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_2_checked : tailListBool tailDisk_0_2 = true := by
  decide +kernel

theorem smallTailExplicit_0_2 : SmallTailCheck 0 2 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_2
  · intro z hz
    rw [tailDisk_0_2_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_2_checked

def tailDisk_0_3 : List (QuadInt 0 3) := [⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_3_eq : disk 0 3 15 = tailDisk_0_3.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_3_checked : tailListBool tailDisk_0_3 = true := by
  decide +kernel

theorem smallTailExplicit_0_3 : SmallTailCheck 0 3 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_3
  · intro z hz
    rw [tailDisk_0_3_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_3_checked

def tailDisk_0_4 : List (QuadInt 0 4) := [⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_4_eq : disk 0 4 15 = tailDisk_0_4.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_4_checked : tailListBool tailDisk_0_4 = true := by
  decide +kernel

theorem smallTailExplicit_0_4 : SmallTailCheck 0 4 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_4
  · intro z hz
    rw [tailDisk_0_4_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_4_checked

def tailDisk_0_5 : List (QuadInt 0 5) := [⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_5_eq : disk 0 5 15 = tailDisk_0_5.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_5_checked : tailListBool tailDisk_0_5 = true := by
  decide +kernel

theorem smallTailExplicit_0_5 : SmallTailCheck 0 5 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_5
  · intro z hz
    rw [tailDisk_0_5_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_5_checked

def tailDisk_0_6 : List (QuadInt 0 6) := [⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_6_eq : disk 0 6 15 = tailDisk_0_6.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_6_checked : tailListBool tailDisk_0_6 = true := by
  decide +kernel

theorem smallTailExplicit_0_6 : SmallTailCheck 0 6 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_6
  · intro z hz
    rw [tailDisk_0_6_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_6_checked

def tailDisk_0_7 : List (QuadInt 0 7) := [⟨-3,0⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_7_eq : disk 0 7 15 = tailDisk_0_7.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_7_checked : tailListBool tailDisk_0_7 = true := by
  decide +kernel

theorem smallTailExplicit_0_7 : SmallTailCheck 0 7 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_7
  · intro z hz
    rw [tailDisk_0_7_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_7_checked

def tailDisk_0_8 : List (QuadInt 0 8) := [⟨-3,0⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_8_eq : disk 0 8 15 = tailDisk_0_8.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_8_checked : tailListBool tailDisk_0_8 = true := by
  decide +kernel

theorem smallTailExplicit_0_8 : SmallTailCheck 0 8 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_8
  · intro z hz
    rw [tailDisk_0_8_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_8_checked

def tailDisk_0_9 : List (QuadInt 0 9) := [⟨-3,0⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_9_eq : disk 0 9 15 = tailDisk_0_9.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_9_checked : tailListBool tailDisk_0_9 = true := by
  decide +kernel

theorem smallTailExplicit_0_9 : SmallTailCheck 0 9 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_9
  · intro z hz
    rw [tailDisk_0_9_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_9_checked

def tailDisk_0_10 : List (QuadInt 0 10) := [⟨-3,0⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_10_eq : disk 0 10 15 = tailDisk_0_10.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_10_checked : tailListBool tailDisk_0_10 = true := by
  decide +kernel

theorem smallTailExplicit_0_10 : SmallTailCheck 0 10 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_10
  · intro z hz
    rw [tailDisk_0_10_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_10_checked

def tailDisk_0_11 : List (QuadInt 0 11) := [⟨-3,0⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_11_eq : disk 0 11 15 = tailDisk_0_11.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_11_checked : tailListBool tailDisk_0_11 = true := by
  decide +kernel

theorem smallTailExplicit_0_11 : SmallTailCheck 0 11 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_11
  · intro z hz
    rw [tailDisk_0_11_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_11_checked

def tailDisk_0_12 : List (QuadInt 0 12) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_12_eq : disk 0 12 15 = tailDisk_0_12.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_12_checked : tailListBool tailDisk_0_12 = true := by
  decide +kernel

theorem smallTailExplicit_0_12 : SmallTailCheck 0 12 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_12
  · intro z hz
    rw [tailDisk_0_12_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_12_checked

def tailDisk_0_13 : List (QuadInt 0 13) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_13_eq : disk 0 13 15 = tailDisk_0_13.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_13_checked : tailListBool tailDisk_0_13 = true := by
  decide +kernel

theorem smallTailExplicit_0_13 : SmallTailCheck 0 13 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_13
  · intro z hz
    rw [tailDisk_0_13_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_13_checked

def tailDisk_0_14 : List (QuadInt 0 14) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_14_eq : disk 0 14 15 = tailDisk_0_14.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_14_checked : tailListBool tailDisk_0_14 = true := by
  decide +kernel

theorem smallTailExplicit_0_14 : SmallTailCheck 0 14 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_14
  · intro z hz
    rw [tailDisk_0_14_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_14_checked

def tailDisk_1_1 : List (QuadInt 1 1) := [⟨-4,1⟩, ⟨-4,2⟩, ⟨-4,3⟩, ⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-3,2⟩, ⟨-3,3⟩, ⟨-3,4⟩, ⟨-2,-2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-2,3⟩, ⟨-2,4⟩, ⟨-1,-3⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨-1,3⟩, ⟨-1,4⟩, ⟨0,-3⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨0,3⟩, ⟨1,-4⟩, ⟨1,-3⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨1,3⟩, ⟨2,-4⟩, ⟨2,-3⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨2,2⟩, ⟨3,-4⟩, ⟨3,-3⟩, ⟨3,-2⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩, ⟨4,-3⟩, ⟨4,-2⟩, ⟨4,-1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_1_eq : disk 1 1 15 = tailDisk_1_1.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_1_checked : tailListBool tailDisk_1_1 = true := by
  decide +kernel

theorem smallTailExplicit_1_1 : SmallTailCheck 1 1 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_1
  · intro z hz
    rw [tailDisk_1_1_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_1_checked

def tailDisk_1_2 : List (QuadInt 1 2) := [⟨-4,1⟩, ⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-3,2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-2⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩, ⟨4,-1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_2_eq : disk 1 2 15 = tailDisk_1_2.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_2_checked : tailListBool tailDisk_1_2 = true := by
  decide +kernel

theorem smallTailExplicit_1_2 : SmallTailCheck 1 2 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_2
  · intro z hz
    rw [tailDisk_1_2_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_2_checked

def tailDisk_1_3 : List (QuadInt 1 3) := [⟨-4,1⟩, ⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-3,2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-2⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩, ⟨4,-1⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_3_eq : disk 1 3 15 = tailDisk_1_3.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_3_checked : tailListBool tailDisk_1_3 = true := by
  decide +kernel

theorem smallTailExplicit_1_3 : SmallTailCheck 1 3 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_3
  · intro z hz
    rw [tailDisk_1_3_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_3_checked

def tailDisk_1_4 : List (QuadInt 1 4) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_4_eq : disk 1 4 15 = tailDisk_1_4.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_4_checked : tailListBool tailDisk_1_4 = true := by
  decide +kernel

theorem smallTailExplicit_1_4 : SmallTailCheck 1 4 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_4
  · intro z hz
    rw [tailDisk_1_4_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_4_checked

def tailDisk_1_5 : List (QuadInt 1 5) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_5_eq : disk 1 5 15 = tailDisk_1_5.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_5_checked : tailListBool tailDisk_1_5 = true := by
  decide +kernel

theorem smallTailExplicit_1_5 : SmallTailCheck 1 5 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_5
  · intro z hz
    rw [tailDisk_1_5_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_5_checked

def tailDisk_1_6 : List (QuadInt 1 6) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_6_eq : disk 1 6 15 = tailDisk_1_6.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_6_checked : tailListBool tailDisk_1_6 = true := by
  decide +kernel

theorem smallTailExplicit_1_6 : SmallTailCheck 1 6 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_6
  · intro z hz
    rw [tailDisk_1_6_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_6_checked

def tailDisk_1_7 : List (QuadInt 1 7) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_7_eq : disk 1 7 15 = tailDisk_1_7.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_7_checked : tailListBool tailDisk_1_7 = true := by
  decide +kernel

theorem smallTailExplicit_1_7 : SmallTailCheck 1 7 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_7
  · intro z hz
    rw [tailDisk_1_7_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_7_checked

def tailDisk_1_8 : List (QuadInt 1 8) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_8_eq : disk 1 8 15 = tailDisk_1_8.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_8_checked : tailListBool tailDisk_1_8 = true := by
  decide +kernel

theorem smallTailExplicit_1_8 : SmallTailCheck 1 8 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_8
  · intro z hz
    rw [tailDisk_1_8_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_8_checked

def tailDisk_1_9 : List (QuadInt 1 9) := [⟨-3,0⟩, ⟨-3,1⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨3,-1⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_9_eq : disk 1 9 15 = tailDisk_1_9.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_9_checked : tailListBool tailDisk_1_9 = true := by
  decide +kernel

theorem smallTailExplicit_1_9 : SmallTailCheck 1 9 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_9
  · intro z hz
    rw [tailDisk_1_9_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_9_checked

def tailDisk_1_10 : List (QuadInt 1 10) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_10_eq : disk 1 10 15 = tailDisk_1_10.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_10_checked : tailListBool tailDisk_1_10 = true := by
  decide +kernel

theorem smallTailExplicit_1_10 : SmallTailCheck 1 10 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_10
  · intro z hz
    rw [tailDisk_1_10_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_10_checked

def tailDisk_1_11 : List (QuadInt 1 11) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_11_eq : disk 1 11 15 = tailDisk_1_11.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_11_checked : tailListBool tailDisk_1_11 = true := by
  decide +kernel

theorem smallTailExplicit_1_11 : SmallTailCheck 1 11 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_11
  · intro z hz
    rw [tailDisk_1_11_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_11_checked

def tailDisk_1_12 : List (QuadInt 1 12) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_12_eq : disk 1 12 15 = tailDisk_1_12.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_12_checked : tailListBool tailDisk_1_12 = true := by
  decide +kernel

theorem smallTailExplicit_1_12 : SmallTailCheck 1 12 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_12
  · intro z hz
    rw [tailDisk_1_12_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_12_checked

def tailDisk_1_13 : List (QuadInt 1 13) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_13_eq : disk 1 13 15 = tailDisk_1_13.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_13_checked : tailListBool tailDisk_1_13 = true := by
  decide +kernel

theorem smallTailExplicit_1_13 : SmallTailCheck 1 13 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_13
  · intro z hz
    rw [tailDisk_1_13_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_13_checked

def tailDisk_1_14 : List (QuadInt 1 14) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_14_eq : disk 1 14 15 = tailDisk_1_14.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_14_checked : tailListBool tailDisk_1_14 = true := by
  decide +kernel

theorem smallTailExplicit_1_14 : SmallTailCheck 1 14 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_14
  · intro z hz
    rw [tailDisk_1_14_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_14_checked

def tailDisk_1_15 : List (QuadInt 1 15) := [⟨-3,0⟩, ⟨-2,0⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨2,0⟩, ⟨3,0⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_1_15_eq : disk 1 15 15 = tailDisk_1_15.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_1_15_checked : tailListBool tailDisk_1_15 = true := by
  decide +kernel

theorem smallTailExplicit_1_15 : SmallTailCheck 1 15 := by
  apply smallTailCheck_of_explicit_list tailDisk_1_15
  · intro z hz
    rw [tailDisk_1_15_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_1_15_checked

/-- Complete finite certificate for the normalized parameter rectangle.
Every data equality and every exclusion above is checked by the kernel. -/
theorem smallTailCheck_rectangular (tau nu : ℤ)
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 15)
    (_hpos : 0 < discriminant tau nu) : SmallTailCheck tau nu := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · exact smallTailExplicit_0_1
    · exact smallTailExplicit_0_2
    · exact smallTailExplicit_0_3
    · exact smallTailExplicit_0_4
    · exact smallTailExplicit_0_5
    · exact smallTailExplicit_0_6
    · exact smallTailExplicit_0_7
    · exact smallTailExplicit_0_8
    · exact smallTailExplicit_0_9
    · exact smallTailExplicit_0_10
    · exact smallTailExplicit_0_11
    · exact smallTailExplicit_0_12
    · exact smallTailExplicit_0_13
    · exact smallTailExplicit_0_14
    · exact small_tail_015
  · interval_cases nu
    · exact smallTailExplicit_1_1
    · exact smallTailExplicit_1_2
    · exact smallTailExplicit_1_3
    · exact smallTailExplicit_1_4
    · exact smallTailExplicit_1_5
    · exact smallTailExplicit_1_6
    · exact smallTailExplicit_1_7
    · exact smallTailExplicit_1_8
    · exact smallTailExplicit_1_9
    · exact smallTailExplicit_1_10
    · exact smallTailExplicit_1_11
    · exact smallTailExplicit_1_12
    · exact smallTailExplicit_1_13
    · exact smallTailExplicit_1_14
    · exact smallTailExplicit_1_15

end D1Bound5
