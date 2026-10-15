import D1Bound5.SmallTailExplicit

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def tailDisk_0_1 : List (QuadInt 0 1) := [⟨-3,-2⟩, ⟨-3,-1⟩, ⟨-3,0⟩, ⟨-3,1⟩, ⟨-3,2⟩, ⟨-2,-3⟩, ⟨-2,-2⟩, ⟨-2,-1⟩, ⟨-2,0⟩, ⟨-2,1⟩, ⟨-2,2⟩, ⟨-2,3⟩, ⟨-1,-3⟩, ⟨-1,-2⟩, ⟨-1,-1⟩, ⟨-1,0⟩, ⟨-1,1⟩, ⟨-1,2⟩, ⟨-1,3⟩, ⟨0,-3⟩, ⟨0,-2⟩, ⟨0,-1⟩, ⟨0,0⟩, ⟨0,1⟩, ⟨0,2⟩, ⟨0,3⟩, ⟨1,-3⟩, ⟨1,-2⟩, ⟨1,-1⟩, ⟨1,0⟩, ⟨1,1⟩, ⟨1,2⟩, ⟨1,3⟩, ⟨2,-3⟩, ⟨2,-2⟩, ⟨2,-1⟩, ⟨2,0⟩, ⟨2,1⟩, ⟨2,2⟩, ⟨2,3⟩, ⟨3,-2⟩, ⟨3,-1⟩, ⟨3,0⟩, ⟨3,1⟩, ⟨3,2⟩]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_0_1_eq : disk 0 1 15 = tailDisk_0_1.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_0_1_checked : tailListBool tailDisk_0_1 = true := by
  decide +kernel

theorem smallTailExplicit_0_1 : SmallTailCheck 0 1 := by
  apply smallTailCheck_of_explicit_list tailDisk_0_1
  · intro z hz
    rw [tailDisk_0_1_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_0_1_checked

end D1Bound5
