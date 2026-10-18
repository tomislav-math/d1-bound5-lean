import D1Bound5.SmallPairClassificationCheck
import D1Bound5.SmallTripleData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def smallPairs_0_1 : List (Finset (ℤ × ℤ)) := [
  {(-2,-2), (-2,2)},
  {(-2,-2), (0,-2)},
  {(-2,-2), (2,0)},
  {(-2,-1), (0,-1)},
  {(-2,-1), (0,2)},
  {(-2,-1), (2,-1)},
  {(-2,0), (-1,-2)},
  {(-2,0), (-1,2)},
  {(-2,0), (1,0)},
  {(-2,0), (2,-2)},
  {(-2,0), (2,2)},
  {(-2,1), (0,-2)},
  {(-2,1), (0,1)},
  {(-2,1), (2,1)},
  {(-2,2), (0,2)},
  {(-2,2), (2,0)},
  {(-1,-2), (1,-2)},
  {(-1,-2), (1,0)},
  {(-1,-1), (1,-1)},
  {(-1,0), (1,-2)},
  {(-1,0), (1,2)},
  {(-1,0), (2,0)},
  {(-1,1), (1,1)},
  {(-1,2), (1,0)},
  {(-1,2), (1,2)},
  {(0,-2), (0,-1)},
  {(0,-2), (2,-2)},
  {(0,-2), (2,1)},
  {(0,-1), (2,-1)},
  {(0,1), (0,2)},
  {(0,1), (2,1)},
  {(0,2), (2,-1)},
  {(0,2), (2,2)},
  {(1,-2), (2,0)},
  {(1,2), (2,0)},
  {(2,-2), (2,2)}
]

def smallPairs_0_2 : List (Finset (ℤ × ℤ)) := [
  {(-2,-1), (0,-1)},
  {(-2,0), (1,-1)},
  {(-2,0), (1,1)},
  {(-2,1), (0,1)},
  {(-1,-1), (-1,1)},
  {(-1,-1), (1,-1)},
  {(-1,-1), (2,0)},
  {(-1,1), (1,1)},
  {(-1,1), (2,0)},
  {(0,-2), (0,2)},
  {(0,-1), (2,-1)},
  {(0,1), (2,1)},
  {(1,-1), (1,1)}
]

def smallPairs_0_3 : List (Finset (ℤ × ℤ)) := [
  {(-2,-1), (0,-1)},
  {(-2,0), (2,0)},
  {(-2,1), (0,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (0,1)},
  {(0,-1), (2,-1)},
  {(0,1), (2,1)}
]

def smallPairs_0_4 : List (Finset (ℤ × ℤ)) := [
  {(-2,-1), (-2,1)},
  {(-2,-1), (0,-1)},
  {(-2,-1), (2,0)},
  {(-2,0), (2,-1)},
  {(-2,0), (2,1)},
  {(-2,1), (0,1)},
  {(-2,1), (2,0)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (2,-1)},
  {(0,1), (2,1)},
  {(2,-1), (2,1)}
]

def smallPairs_0_5 : List (Finset (ℤ × ℤ)) := [
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)}
]

def smallPairs_0_6 : List (Finset (ℤ × ℤ)) := [
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)}
]

def smallPairs_0_7 : List (Finset (ℤ × ℤ)) := [
  {(-1,-1), (-1,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(1,-1), (1,1)}
]

def smallPairs_0_8 : List (Finset (ℤ × ℤ)) := [
  {(0,-1), (0,1)}
]

def smallPairs_1_1 : List (Finset (ℤ × ℤ)) := [
  {(-3,1), (-1,1)},
  {(-3,1), (2,-1)},
  {(-3,2), (-1,2)},
  {(-3,2), (1,-1)},
  {(-2,-1), (0,-1)},
  {(-2,-1), (1,1)},
  {(-2,0), (2,0)},
  {(-2,1), (-1,-1)},
  {(-2,1), (-1,3)},
  {(-2,1), (0,1)},
  {(-2,1), (1,0)},
  {(-2,1), (3,-1)},
  {(-2,2), (0,2)},
  {(-2,3), (-1,0)},
  {(-2,3), (1,1)},
  {(-1,-2), (0,1)},
  {(-1,-2), (1,-2)},
  {(-1,-1), (1,-1)},
  {(-1,-1), (1,0)},
  {(-1,-1), (2,-3)},
  {(-1,-1), (2,1)},
  {(-1,0), (1,-3)},
  {(-1,0), (1,1)},
  {(-1,0), (2,-1)},
  {(-1,1), (-1,2)},
  {(-1,1), (1,1)},
  {(-1,1), (3,-2)},
  {(-1,2), (0,1)},
  {(-1,2), (1,-2)},
  {(-1,2), (1,2)},
  {(-1,3), (1,0)},
  {(0,-2), (2,-2)},
  {(0,-1), (1,-2)},
  {(0,-1), (1,2)},
  {(0,-1), (2,-1)},
  {(0,1), (2,1)},
  {(1,-3), (2,-1)},
  {(1,-2), (1,-1)},
  {(1,-2), (3,-2)},
  {(1,-1), (3,-1)},
  {(1,0), (2,-3)},
  {(1,1), (2,-1)}
]

def smallPairs_1_2 : List (Finset (ℤ × ℤ)) := [
  {(-3,1), (-2,-1)},
  {(-3,1), (-1,1)},
  {(-3,1), (1,-2)},
  {(-3,1), (1,0)},
  {(-3,1), (2,1)},
  {(-2,-1), (-1,2)},
  {(-2,-1), (0,-1)},
  {(-2,-1), (1,0)},
  {(-2,-1), (3,-1)},
  {(-2,1), (0,1)},
  {(-2,1), (2,-1)},
  {(-2,2), (0,-2)},
  {(-2,2), (0,2)},
  {(-1,-1), (1,-1)},
  {(-1,-1), (1,1)},
  {(-1,0), (2,1)},
  {(-1,0), (3,-1)},
  {(-1,1), (1,1)},
  {(-1,2), (3,-1)},
  {(0,-2), (2,-2)},
  {(0,-1), (2,-1)},
  {(0,1), (2,1)},
  {(0,2), (2,-2)},
  {(1,-2), (2,1)},
  {(1,-1), (3,-1)},
  {(2,1), (3,-1)}
]

def smallPairs_1_3 : List (Finset (ℤ × ℤ)) := [
  {(-2,1), (0,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (0,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (2,-1)},
  {(0,1), (1,-1)}
]

def smallPairs_1_4 : List (Finset (ℤ × ℤ)) := [
  {(-2,1), (0,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (2,-1)}
]

def smallPairs_1_5 : List (Finset (ℤ × ℤ)) := [
  {(-2,1), (0,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (2,-1)}
]

def smallPairs_1_6 : List (Finset (ℤ × ℤ)) := [
  {(-2,1), (-1,-1)},
  {(-2,1), (0,1)},
  {(-1,-1), (1,-1)},
  {(-1,1), (1,1)},
  {(0,-1), (2,-1)},
  {(1,1), (2,-1)}
]

def smallPairs_1_7 : List (Finset (ℤ × ℤ)) := [

]

def smallPairs_1_8 : List (Finset (ℤ × ℤ)) := [
  {(-1,1), (0,-1)},
  {(0,1), (1,-1)}
]

def smallPairTable (tau nu : ℤ) : List (Finset (ℤ × ℤ)) :=
  if tau = 0 ∧ nu = 1 then smallPairs_0_1 else
  if tau = 0 ∧ nu = 2 then smallPairs_0_2 else
  if tau = 0 ∧ nu = 3 then smallPairs_0_3 else
  if tau = 0 ∧ nu = 4 then smallPairs_0_4 else
  if tau = 0 ∧ nu = 5 then smallPairs_0_5 else
  if tau = 0 ∧ nu = 6 then smallPairs_0_6 else
  if tau = 0 ∧ nu = 7 then smallPairs_0_7 else
  if tau = 0 ∧ nu = 8 then smallPairs_0_8 else
  if tau = 1 ∧ nu = 1 then smallPairs_1_1 else
  if tau = 1 ∧ nu = 2 then smallPairs_1_2 else
  if tau = 1 ∧ nu = 3 then smallPairs_1_3 else
  if tau = 1 ∧ nu = 4 then smallPairs_1_4 else
  if tau = 1 ∧ nu = 5 then smallPairs_1_5 else
  if tau = 1 ∧ nu = 6 then smallPairs_1_6 else
  if tau = 1 ∧ nu = 7 then smallPairs_1_7 else
  if tau = 1 ∧ nu = 8 then smallPairs_1_8 else
  []

def smallPairRepresentatives_0_1 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-2), (-2,2)}, {(-2,-2), (0,-2)}, {(-2,-2), (2,0)}, {(-2,-1), (0,-1)}, {(-2,-1), (0,2)}, {(-2,-1), (2,-1)}, {(-2,0), (-1,-2)}, {(-2,0), (1,0)}, {(-1,-2), (1,-2)}, {(-1,-2), (1,0)}, {(-1,-1), (1,-1)}, {(0,-2), (0,-1)}}

theorem smallPairTable_0_1_orbits :
    smallPairs_0_1.toFinset = smallPairRepresentatives_0_1.biUnion (smallTripleOrbit 0) := by
  decide +kernel

def smallPairRepresentatives_0_2 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-1), (0,-1)}, {(-2,0), (1,-1)}, {(-1,-1), (-1,1)}, {(-1,-1), (1,-1)}, {(0,-2), (0,2)}}

theorem smallPairTable_0_2_orbits :
    smallPairs_0_2.toFinset = smallPairRepresentatives_0_2.biUnion (smallTripleOrbit 0) := by
  decide +kernel

def smallPairRepresentatives_1_1 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-1), (0,-1)}, {(-2,-1), (1,1)}, {(-1,-2), (1,-2)}, {(-1,-2), (0,1)}, {(-2,0), (2,0)}, {(-1,-1), (-2,1)}, {(-1,-1), (2,-3)}, {(-1,-1), (1,-1)}, {(-1,-1), (1,0)}, {(0,-2), (2,-2)}, {(-1,0), (1,-3)}, {(0,-1), (1,-2)}, {(1,-2), (-1,2)}}

theorem smallPairTable_1_1_orbits :
    smallPairs_1_1.toFinset = smallPairRepresentatives_1_1.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_0_5 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (1,-1)}}

theorem smallPairTable_0_5_orbits :
    smallPairs_0_5.toFinset = smallPairRepresentatives_0_5.biUnion (smallTripleOrbit 0) := by
  decide +kernel

def smallPairRepresentatives_0_6 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (1,-1)}}

theorem smallPairTable_0_6_orbits :
    smallPairs_0_6.toFinset = smallPairRepresentatives_0_6.biUnion (smallTripleOrbit 0) := by
  decide +kernel

def smallPairRepresentatives_1_2 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-1), (-3,1)}, {(-2,-1), (0,-1)}, {(-2,-1), (-1,2)}, {(-2,-1), (1,0)}, {(-2,-1), (3,-1)}, {(-1,-1), (1,-1)}, {(-1,-1), (1,1)}, {(0,-2), (-2,2)}, {(0,-2), (2,-2)}}

theorem smallPairTable_1_2_orbits :
    smallPairs_1_2.toFinset = smallPairRepresentatives_1_2.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_1_3 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (1,-1)}, {(0,-1), (-1,1)}}

theorem smallPairTable_1_3_orbits :
    smallPairs_1_3.toFinset = smallPairRepresentatives_1_3.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_1_4 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (1,-1)}}

theorem smallPairTable_1_4_orbits :
    smallPairs_1_4.toFinset = smallPairRepresentatives_1_4.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_1_5 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (1,-1)}}

theorem smallPairTable_1_5_orbits :
    smallPairs_1_5.toFinset = smallPairRepresentatives_1_5.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_1_6 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (-2,1)}, {(-1,-1), (1,-1)}}

theorem smallPairTable_1_6_orbits :
    smallPairs_1_6.toFinset = smallPairRepresentatives_1_6.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallPairRepresentatives_1_8 : Finset (Finset (ℤ × ℤ)) :=
  {{(0,-1), (-1,1)}}

theorem smallPairTable_1_8_orbits :
    smallPairs_1_8.toFinset = smallPairRepresentatives_1_8.biUnion (smallTripleOrbit 1) := by
  decide +kernel

theorem smallPairs_0_1_checked :
    smallPairClassifiedBool smallDisk_0_1 (smallPairTable 0 1) = true := by
  decide +kernel

theorem smallPair_classified_0_1
    (a b : QuadInt 0 1) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 1 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_1
    (smallPairTable 0 1) ?_ smallPairs_0_1_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_1_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_2_checked :
    smallPairClassifiedBool smallDisk_0_2 (smallPairTable 0 2) = true := by
  decide +kernel

theorem smallPair_classified_0_2
    (a b : QuadInt 0 2) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 2 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_2
    (smallPairTable 0 2) ?_ smallPairs_0_2_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_2_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_3_checked :
    smallPairClassifiedBool smallDisk_0_3 (smallPairTable 0 3) = true := by
  decide +kernel

theorem smallPair_classified_0_3
    (a b : QuadInt 0 3) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 3 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_3
    (smallPairTable 0 3) ?_ smallPairs_0_3_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_3_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_4_checked :
    smallPairClassifiedBool smallDisk_0_4 (smallPairTable 0 4) = true := by
  decide +kernel

theorem smallPair_classified_0_4
    (a b : QuadInt 0 4) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 4 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_4
    (smallPairTable 0 4) ?_ smallPairs_0_4_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_4_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_5_checked :
    smallPairClassifiedBool smallDisk_0_5 (smallPairTable 0 5) = true := by
  decide +kernel

theorem smallPair_classified_0_5
    (a b : QuadInt 0 5) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 5 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_5
    (smallPairTable 0 5) ?_ smallPairs_0_5_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_5_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_6_checked :
    smallPairClassifiedBool smallDisk_0_6 (smallPairTable 0 6) = true := by
  decide +kernel

theorem smallPair_classified_0_6
    (a b : QuadInt 0 6) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 6 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_6
    (smallPairTable 0 6) ?_ smallPairs_0_6_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_6_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_7_checked :
    smallPairClassifiedBool smallDisk_0_7 (smallPairTable 0 7) = true := by
  decide +kernel

theorem smallPair_classified_0_7
    (a b : QuadInt 0 7) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 7 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_7
    (smallPairTable 0 7) ?_ smallPairs_0_7_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_7_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_0_8_checked :
    smallPairClassifiedBool smallDisk_0_8 (smallPairTable 0 8) = true := by
  decide +kernel

theorem smallPair_classified_0_8
    (a b : QuadInt 0 8) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 8 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_0_8
    (smallPairTable 0 8) ?_ smallPairs_0_8_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_0_8_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_1_checked :
    smallPairClassifiedBool smallDisk_1_1 (smallPairTable 1 1) = true := by
  decide +kernel

theorem smallPair_classified_1_1
    (a b : QuadInt 1 1) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 1 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_1
    (smallPairTable 1 1) ?_ smallPairs_1_1_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_1_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_2_checked :
    smallPairClassifiedBool smallDisk_1_2 (smallPairTable 1 2) = true := by
  decide +kernel

theorem smallPair_classified_1_2
    (a b : QuadInt 1 2) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 2 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_2
    (smallPairTable 1 2) ?_ smallPairs_1_2_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_2_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_3_checked :
    smallPairClassifiedBool smallDisk_1_3 (smallPairTable 1 3) = true := by
  decide +kernel

theorem smallPair_classified_1_3
    (a b : QuadInt 1 3) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 3 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_3
    (smallPairTable 1 3) ?_ smallPairs_1_3_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_3_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_4_checked :
    smallPairClassifiedBool smallDisk_1_4 (smallPairTable 1 4) = true := by
  decide +kernel

theorem smallPair_classified_1_4
    (a b : QuadInt 1 4) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 4 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_4
    (smallPairTable 1 4) ?_ smallPairs_1_4_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_4_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_5_checked :
    smallPairClassifiedBool smallDisk_1_5 (smallPairTable 1 5) = true := by
  decide +kernel

theorem smallPair_classified_1_5
    (a b : QuadInt 1 5) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 5 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_5
    (smallPairTable 1 5) ?_ smallPairs_1_5_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_5_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_6_checked :
    smallPairClassifiedBool smallDisk_1_6 (smallPairTable 1 6) = true := by
  decide +kernel

theorem smallPair_classified_1_6
    (a b : QuadInt 1 6) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 6 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_6
    (smallPairTable 1 6) ?_ smallPairs_1_6_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_6_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_7_checked :
    smallPairClassifiedBool smallDisk_1_7 (smallPairTable 1 7) = true := by
  decide +kernel

theorem smallPair_classified_1_7
    (a b : QuadInt 1 7) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 7 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_7
    (smallPairTable 1 7) ?_ smallPairs_1_7_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_7_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPairs_1_8_checked :
    smallPairClassifiedBool smallDisk_1_8 (smallPairTable 1 8) = true := by
  decide +kernel

theorem smallPair_classified_1_8
    (a b : QuadInt 1 8) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 8 := by
  apply smallPairClassified_of_explicit_list (by decide) smallDisk_1_8
    (smallPairTable 1 8) ?_ smallPairs_1_8_checked a b ha hb hab hroot hnondeg hNa hNb
  intro z hz
  rw [smallDisk_1_8_eq, List.mem_toFinset] at hz
  exact hz

theorem smallPair_classified_rectangular {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (a b : QuadInt tau nu) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable tau nu := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · exact smallPair_classified_0_1 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_2 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_3 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_4 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_5 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_6 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_7 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_0_8 a b ha hb hab hroot hnondeg hNa hNb
  · interval_cases nu
    · exact smallPair_classified_1_1 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_2 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_3 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_4 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_5 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_6 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_7 a b ha hb hab hroot hnondeg hNa hNb
    · exact smallPair_classified_1_8 a b ha hb hab hroot hnondeg hNa hNb

end D1Bound5
