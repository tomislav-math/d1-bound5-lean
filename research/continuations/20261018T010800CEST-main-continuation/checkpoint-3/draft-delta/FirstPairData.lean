import D1Bound5.OneSmallFiniteCheck

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def firstPairOrbit (tau : ℤ) (row : (ℤ × ℤ) × (ℤ × ℤ)) :
    Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {row, ((-row.1.1,-row.1.2),(-row.2.1,-row.2.2)),
   ((row.1.1+tau*row.1.2,-row.1.2),(row.2.1+tau*row.2.2,-row.2.2)),
   ((-row.1.1-tau*row.1.2,row.1.2),(-row.2.1-tau*row.2.2,row.2.2))}

def firstPairs_0_1 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,-1),(-3,-1)), ((-1,-1),(1,3)), ((-1,0),(-2,-4)), ((-1,0),(-2,4)), ((-1,0),(4,-4)), ((-1,0),(4,4)), ((-1,0),(5,0)), ((-1,1),(-3,1)), ((-1,1),(1,-3)), ((0,-1),(-4,-4)), ((0,-1),(-4,2)), ((0,-1),(0,-5)), ((0,-1),(0,3)), ((0,-1),(4,-4)), ((0,-1),(4,2)), ((0,1),(-4,-2)), ((0,1),(-4,4)), ((0,1),(0,-3)), ((0,1),(0,5)), ((0,1),(4,-2)), ((0,1),(4,4)), ((1,-1),(-1,3)), ((1,-1),(3,-1)), ((1,0),(-5,0)), ((1,0),(-4,-4)), ((1,0),(-4,4)), ((1,0),(2,-4)), ((1,0),(2,4)), ((1,1),(-1,-3)), ((1,1),(3,1))]

def firstPairs_0_2 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(-1,-4)), ((-1,0),(-1,4)), ((-1,0),(2,-2)), ((-1,0),(2,2)), ((-1,0),(3,0)), ((1,0),(-3,0)), ((1,0),(-2,-2)), ((1,0),(-2,2)), ((1,0),(1,-4)), ((1,0),(1,4))]

def firstPairs_0_3 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(0,-4)), ((-1,0),(0,4)), ((-1,0),(3,-2)), ((-1,0),(3,2)), ((-1,0),(4,0)), ((1,0),(-4,0)), ((1,0),(-3,-2)), ((1,0),(-3,2)), ((1,0),(0,-4)), ((1,0),(0,4))]

def firstPairs_0_4 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(4,-2)), ((-1,0),(4,2)), ((-1,0),(5,0)), ((1,0),(-5,0)), ((1,0),(-4,-2)), ((1,0),(-4,2))]

def firstPairs_0_5 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(5,-2)), ((-1,0),(5,2)), ((-1,0),(6,0)), ((1,0),(-6,0)), ((1,0),(-5,-2)), ((1,0),(-5,2))]

def firstPairs_0_6 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(6,-2)), ((-1,0),(6,2)), ((-1,0),(7,0)), ((1,0),(-7,0)), ((1,0),(-6,-2)), ((1,0),(-6,2))]

def firstPairs_0_7 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  []

def firstPairs_0_8 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  []

def firstPairs_1_1 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(-7,5)), ((-1,0),(-4,8)), ((-1,0),(-2,-5)), ((-1,0),(1,4)), ((-1,0),(4,-8)), ((-1,0),(4,0)), ((-1,0),(5,-4)), ((-1,0),(6,3)), ((-1,0),(9,-3)), ((-1,1),(-8,4)), ((-1,1),(-5,-2)), ((-1,1),(-4,5)), ((-1,1),(-3,9)), ((-1,1),(0,-3)), ((-1,1),(0,4)), ((-1,1),(3,6)), ((-1,1),(4,1)), ((-1,1),(5,-7)), ((-1,1),(8,-4)), ((0,-1),(-7,2)), ((0,-1),(-4,-4)), ((0,-1),(-3,3)), ((0,-1),(-2,7)), ((0,-1),(1,-5)), ((0,-1),(4,-4)), ((0,-1),(4,4)), ((0,-1),(5,-1)), ((0,-1),(6,-9)), ((0,-1),(9,-6)), ((0,1),(-9,6)), ((0,1),(-6,9)), ((0,1),(-5,1)), ((0,1),(-4,-4)), ((0,1),(-4,4)), ((0,1),(-1,5)), ((0,1),(2,-7)), ((0,1),(3,-3)), ((0,1),(4,4)), ((0,1),(7,-2)), ((1,-1),(-8,4)), ((1,-1),(-5,7)), ((1,-1),(-4,-1)), ((1,-1),(-3,-6)), ((1,-1),(0,-4)), ((1,-1),(0,3)), ((1,-1),(3,-9)), ((1,-1),(4,-5)), ((1,-1),(5,2)), ((1,-1),(8,-4)), ((1,0),(-9,3)), ((1,0),(-6,-3)), ((1,0),(-5,4)), ((1,0),(-4,0)), ((1,0),(-4,8)), ((1,0),(-1,-4)), ((1,0),(2,5)), ((1,0),(4,-8)), ((1,0),(7,-5))]

def firstPairs_1_2 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(-6,5)), ((-1,0),(-1,-5)), ((-1,0),(-1,3)), ((-1,0),(2,-3)), ((1,0),(-2,3)), ((1,0),(1,-3)), ((1,0),(1,5)), ((1,0),(6,-5))]

def firstPairs_1_3 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(0,3)), ((-1,0),(3,-3)), ((-1,0),(3,1)), ((-1,0),(4,-1)), ((1,0),(-4,1)), ((1,0),(-3,-1)), ((1,0),(-3,3)), ((1,0),(0,-3))]

def firstPairs_1_4 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(1,3)), ((-1,0),(4,-3)), ((-1,0),(4,1)), ((-1,0),(5,-1)), ((1,0),(-5,1)), ((1,0),(-4,-1)), ((1,0),(-4,3)), ((1,0),(-1,-3))]

def firstPairs_1_5 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(2,3)), ((-1,0),(5,-3)), ((-1,0),(5,1)), ((-1,0),(6,-1)), ((1,0),(-6,1)), ((1,0),(-5,-1)), ((1,0),(-5,3)), ((1,0),(-2,-3))]

def firstPairs_1_6 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(6,1)), ((-1,0),(7,-1)), ((1,0),(-7,1)), ((1,0),(-6,-1))]

def firstPairs_1_7 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  [((-1,0),(7,1)), ((-1,0),(8,-1)), ((1,0),(-8,1)), ((1,0),(-7,-1))]

def firstPairs_1_8 : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  []

def firstPairTable (tau nu : ℤ) : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  if tau = 0 ∧ nu = 1 then firstPairs_0_1 else
  if tau = 0 ∧ nu = 2 then firstPairs_0_2 else
  if tau = 0 ∧ nu = 3 then firstPairs_0_3 else
  if tau = 0 ∧ nu = 4 then firstPairs_0_4 else
  if tau = 0 ∧ nu = 5 then firstPairs_0_5 else
  if tau = 0 ∧ nu = 6 then firstPairs_0_6 else
  if tau = 0 ∧ nu = 7 then firstPairs_0_7 else
  if tau = 0 ∧ nu = 8 then firstPairs_0_8 else
  if tau = 1 ∧ nu = 1 then firstPairs_1_1 else
  if tau = 1 ∧ nu = 2 then firstPairs_1_2 else
  if tau = 1 ∧ nu = 3 then firstPairs_1_3 else
  if tau = 1 ∧ nu = 4 then firstPairs_1_4 else
  if tau = 1 ∧ nu = 5 then firstPairs_1_5 else
  if tau = 1 ∧ nu = 6 then firstPairs_1_6 else
  if tau = 1 ∧ nu = 7 then firstPairs_1_7 else
  if tau = 1 ∧ nu = 8 then firstPairs_1_8 else
  []

def firstPairRepresentatives_0_1 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((0,1),(0,-3)), ((0,1),(0,5)), ((0,1),(4,-2)), ((0,1),(4,4)), ((1,0),(-5,0)), ((1,0),(-4,4)), ((1,0),(2,4)), ((1,1),(-1,-3)), ((1,1),(3,1))}

theorem firstPairTable_0_1_orbits :
    firstPairs_0_1.toFinset = firstPairRepresentatives_0_1.biUnion (firstPairOrbit 0) := by
  decide +kernel

def firstPairRepresentatives_0_2 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-3,0)), ((1,0),(-2,2)), ((1,0),(1,4))}

theorem firstPairTable_0_2_orbits :
    firstPairs_0_2.toFinset = firstPairRepresentatives_0_2.biUnion (firstPairOrbit 0) := by
  decide +kernel

def firstPairRepresentatives_0_5 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-6,0)), ((1,0),(-5,2))}

theorem firstPairTable_0_5_orbits :
    firstPairs_0_5.toFinset = firstPairRepresentatives_0_5.biUnion (firstPairOrbit 0) := by
  decide +kernel

def firstPairRepresentatives_0_6 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-7,0)), ((1,0),(-6,2))}

theorem firstPairTable_0_6_orbits :
    firstPairs_0_6.toFinset = firstPairRepresentatives_0_6.biUnion (firstPairOrbit 0) := by
  decide +kernel

def firstPairRepresentatives_1_1 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((0,1),(-9,6)), ((0,1),(-6,9)), ((0,1),(-5,1)), ((0,1),(-4,-4)), ((0,1),(-4,4)), ((0,1),(-1,5)), ((0,1),(2,-7)), ((0,1),(3,-3)), ((0,1),(4,4)), ((0,1),(7,-2)), ((1,0),(-9,3)), ((1,0),(-5,4)), ((1,0),(-4,0)), ((1,0),(-4,8)), ((1,0),(2,5))}

theorem firstPairTable_1_1_orbits :
    firstPairs_1_1.toFinset = firstPairRepresentatives_1_1.biUnion (firstPairOrbit 1) := by
  decide +kernel

def firstPairRepresentatives_1_2 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-2,3)), ((1,0),(1,5))}

theorem firstPairTable_1_2_orbits :
    firstPairs_1_2.toFinset = firstPairRepresentatives_1_2.biUnion (firstPairOrbit 1) := by
  decide +kernel

def firstPairRepresentatives_1_3 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-4,1)), ((1,0),(-3,3))}

theorem firstPairTable_1_3_orbits :
    firstPairs_1_3.toFinset = firstPairRepresentatives_1_3.biUnion (firstPairOrbit 1) := by
  decide +kernel

def firstPairRepresentatives_1_4 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-5,1)), ((1,0),(-4,3))}

theorem firstPairTable_1_4_orbits :
    firstPairs_1_4.toFinset = firstPairRepresentatives_1_4.biUnion (firstPairOrbit 1) := by
  decide +kernel

def firstPairRepresentatives_1_5 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-6,1)), ((1,0),(-5,3))}

theorem firstPairTable_1_5_orbits :
    firstPairs_1_5.toFinset = firstPairRepresentatives_1_5.biUnion (firstPairOrbit 1) := by
  decide +kernel

def firstPairRepresentatives_1_6 : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=
  {((1,0),(-7,1))}

theorem firstPairTable_1_6_orbits :
    firstPairs_1_6.toFinset = firstPairRepresentatives_1_6.biUnion (firstPairOrbit 1) := by
  decide +kernel

theorem firstPair_0_1_checked :
    firstPairClassifiedBool smallDisk_0_1 smallDisk_0_1 (firstPairTable 0 1) = true := by
  decide +kernel

theorem firstPair_classified_0_1
    (a b : QuadInt 0 1) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 1 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_1 smallDisk_0_1
    (firstPairTable 0 1) ?_ ?_ firstPair_0_1_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_1_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_2_checked :
    firstPairClassifiedBool smallDisk_0_2 smallDisk_0_2 (firstPairTable 0 2) = true := by
  decide +kernel

theorem firstPair_classified_0_2
    (a b : QuadInt 0 2) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 2 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_2 smallDisk_0_2
    (firstPairTable 0 2) ?_ ?_ firstPair_0_2_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_2_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_3_checked :
    firstPairClassifiedBool smallDisk_0_3 smallDisk_0_3 (firstPairTable 0 3) = true := by
  decide +kernel

theorem firstPair_classified_0_3
    (a b : QuadInt 0 3) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 3 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_3 smallDisk_0_3
    (firstPairTable 0 3) ?_ ?_ firstPair_0_3_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_3_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_4_checked :
    firstPairClassifiedBool smallDisk_0_4 smallDisk_0_4 (firstPairTable 0 4) = true := by
  decide +kernel

theorem firstPair_classified_0_4
    (a b : QuadInt 0 4) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 4 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_4 smallDisk_0_4
    (firstPairTable 0 4) ?_ ?_ firstPair_0_4_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_4_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_5_checked :
    firstPairClassifiedBool smallDisk_0_5 smallDisk_0_5 (firstPairTable 0 5) = true := by
  decide +kernel

theorem firstPair_classified_0_5
    (a b : QuadInt 0 5) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 5 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_5 smallDisk_0_5
    (firstPairTable 0 5) ?_ ?_ firstPair_0_5_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_5_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_6_checked :
    firstPairClassifiedBool smallDisk_0_6 smallDisk_0_6 (firstPairTable 0 6) = true := by
  decide +kernel

theorem firstPair_classified_0_6
    (a b : QuadInt 0 6) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 6 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_6 smallDisk_0_6
    (firstPairTable 0 6) ?_ ?_ firstPair_0_6_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_6_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_7_checked :
    firstPairClassifiedBool smallDisk_0_7 smallDisk_0_7 (firstPairTable 0 7) = true := by
  decide +kernel

theorem firstPair_classified_0_7
    (a b : QuadInt 0 7) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 7 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_7 smallDisk_0_7
    (firstPairTable 0 7) ?_ ?_ firstPair_0_7_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_7_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_0_8_checked :
    firstPairClassifiedBool smallDisk_0_8 smallDisk_0_8 (firstPairTable 0 8) = true := by
  decide +kernel

theorem firstPair_classified_0_8
    (a b : QuadInt 0 8) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 8 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_0_8 smallDisk_0_8
    (firstPairTable 0 8) ?_ ?_ firstPair_0_8_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_0_8_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_1_checked :
    firstPairClassifiedBool smallDisk_1_1 smallDisk_1_1 (firstPairTable 1 1) = true := by
  decide +kernel

theorem firstPair_classified_1_1
    (a b : QuadInt 1 1) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 1 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_1 smallDisk_1_1
    (firstPairTable 1 1) ?_ ?_ firstPair_1_1_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_1_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_2_checked :
    firstPairClassifiedBool smallDisk_1_2 smallDisk_1_2 (firstPairTable 1 2) = true := by
  decide +kernel

theorem firstPair_classified_1_2
    (a b : QuadInt 1 2) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 2 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_2 smallDisk_1_2
    (firstPairTable 1 2) ?_ ?_ firstPair_1_2_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_2_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_3_checked :
    firstPairClassifiedBool smallDisk_1_3 smallDisk_1_3 (firstPairTable 1 3) = true := by
  decide +kernel

theorem firstPair_classified_1_3
    (a b : QuadInt 1 3) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 3 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_3 smallDisk_1_3
    (firstPairTable 1 3) ?_ ?_ firstPair_1_3_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_3_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_4_checked :
    firstPairClassifiedBool smallDisk_1_4 smallDisk_1_4 (firstPairTable 1 4) = true := by
  decide +kernel

theorem firstPair_classified_1_4
    (a b : QuadInt 1 4) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 4 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_4 smallDisk_1_4
    (firstPairTable 1 4) ?_ ?_ firstPair_1_4_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_4_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_5_checked :
    firstPairClassifiedBool smallDisk_1_5 smallDisk_1_5 (firstPairTable 1 5) = true := by
  decide +kernel

theorem firstPair_classified_1_5
    (a b : QuadInt 1 5) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 5 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_5 smallDisk_1_5
    (firstPairTable 1 5) ?_ ?_ firstPair_1_5_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_5_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_6_checked :
    firstPairClassifiedBool smallDisk_1_6 smallDisk_1_6 (firstPairTable 1 6) = true := by
  decide +kernel

theorem firstPair_classified_1_6
    (a b : QuadInt 1 6) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 6 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_6 smallDisk_1_6
    (firstPairTable 1 6) ?_ ?_ firstPair_1_6_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_6_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_7_checked :
    firstPairClassifiedBool smallDisk_1_7 smallDisk_1_7 (firstPairTable 1 7) = true := by
  decide +kernel

theorem firstPair_classified_1_7
    (a b : QuadInt 1 7) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 7 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_7 smallDisk_1_7
    (firstPairTable 1 7) ?_ ?_ firstPair_1_7_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_7_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_1_8_checked :
    firstPairClassifiedBool smallDisk_1_8 smallDisk_1_8 (firstPairTable 1 8) = true := by
  decide +kernel

theorem firstPair_classified_1_8
    (a b : QuadInt 1 8) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 8 := by
  apply firstPairClassified_of_checked (by decide) smallDisk_1_8 smallDisk_1_8
    (firstPairTable 1 8) ?_ ?_ firstPair_1_8_checked a b hnorm hroot
  all_goals intro q hq; rw [smallDisk_1_8_eq, List.mem_toFinset] at hq; exact hq

theorem firstPair_classified_rectangular {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (a b : QuadInt tau nu) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable tau nu := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · exact firstPair_classified_0_1 a b hnorm hroot
    · exact firstPair_classified_0_2 a b hnorm hroot
    · exact firstPair_classified_0_3 a b hnorm hroot
    · exact firstPair_classified_0_4 a b hnorm hroot
    · exact firstPair_classified_0_5 a b hnorm hroot
    · exact firstPair_classified_0_6 a b hnorm hroot
    · exact firstPair_classified_0_7 a b hnorm hroot
    · exact firstPair_classified_0_8 a b hnorm hroot
  · interval_cases nu
    · exact firstPair_classified_1_1 a b hnorm hroot
    · exact firstPair_classified_1_2 a b hnorm hroot
    · exact firstPair_classified_1_3 a b hnorm hroot
    · exact firstPair_classified_1_4 a b hnorm hroot
    · exact firstPair_classified_1_5 a b hnorm hroot
    · exact firstPair_classified_1_6 a b hnorm hroot
    · exact firstPair_classified_1_7 a b hnorm hroot
    · exact firstPair_classified_1_8 a b hnorm hroot

end D1Bound5
