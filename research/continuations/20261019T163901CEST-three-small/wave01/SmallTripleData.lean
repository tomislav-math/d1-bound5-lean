import D1Bound5.SmallTripleCheck
import D1Bound5.SmallQuadrupleData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def smallTriples_0_1 : List (Finset (ℤ × ℤ)) := [
  {(-2,-2), (-2,2), (2,0)},
  {(-2,-1), (0,-1), (2,-1)},
  {(-2,-1), (0,2), (2,-1)},
  {(-2,0), (-1,-2), (1,0)},
  {(-2,0), (-1,2), (1,0)},
  {(-2,0), (2,-2), (2,2)},
  {(-2,1), (0,-2), (2,1)},
  {(-2,1), (0,1), (2,1)},
  {(-1,0), (1,-2), (2,0)},
  {(-1,0), (1,2), (2,0)}
]

def smallTriples_0_2 : List (Finset (ℤ × ℤ)) := [
  {(-2,0), (1,-1), (1,1)},
  {(-1,-1), (-1,1), (2,0)}
]

def smallTriples_0_4 : List (Finset (ℤ × ℤ)) := [
  {(-2,-1), (-2,1), (2,0)},
  {(-2,0), (2,-1), (2,1)}
]

def smallTriples_1_1 : List (Finset (ℤ × ℤ)) := [
  {(-2,1), (-1,-1), (1,0)},
  {(-2,1), (-1,3), (1,0)},
  {(-2,3), (-1,0), (1,1)},
  {(-1,-1), (1,0), (2,-3)},
  {(-1,0), (1,-3), (2,-1)},
  {(-1,0), (1,1), (2,-1)},
  {(-1,1), (-1,2), (0,1)},
  {(0,-1), (1,-2), (1,-1)}
]

def smallTriples_1_2 : List (Finset (ℤ × ℤ)) := [
  {(-3,1), (-2,-1), (1,0)},
  {(-3,1), (1,-2), (2,1)},
  {(-2,-1), (-1,2), (3,-1)},
  {(-1,0), (2,1), (3,-1)}
]

/-- Simultaneous negation and the coordinate conjugation x+yω ↦ x+τy−yω. -/
def smallTripleOrbit (tau : ℤ) (row : Finset (ℤ × ℤ)) :
    Finset (Finset (ℤ × ℤ)) :=
  {row, row.image (fun p => (-p.1, -p.2)),
    row.image (fun p => (p.1+tau*p.2, -p.2)),
    row.image (fun p => (-p.1-tau*p.2, p.2))}

/-- The ten rows displayed in manuscript Table 7.2, in normalized coordinates. -/
def smallTripleRepresentatives_0_1 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-2), (-2,2), (2,0)}, {(-2,-1), (0,-1), (2,-1)},
   {(-2,-1), (0,2), (2,-1)}, {(-2,0), (-1,-2), (1,0)}}
def smallTripleRepresentatives_0_2 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,0), (1,-1), (1,1)}}
def smallTripleRepresentatives_1_1 : Finset (Finset (ℤ × ℤ)) :=
  {{(-1,-1), (-2,1), (1,0)}, {(-1,-1), (2,-3), (1,0)},
   {(0,-1), (1,-2), (1,-1)}}
def smallTripleRepresentatives_1_2 : Finset (Finset (ℤ × ℤ)) :=
  {{(-2,-1), (-3,1), (1,0)}, {(-2,-1), (-1,2), (3,-1)}}

/-- Exact agreement between the explicit 24 triples and the ten manuscript
orbits. The half-integral models use ω=(1+sqrt(-d))/2. -/
theorem smallTripleTable_orbits :
    smallTriples_0_1.toFinset = smallTripleRepresentatives_0_1.biUnion (smallTripleOrbit 0) ∧
    smallTriples_0_2.toFinset = smallTripleRepresentatives_0_2.biUnion (smallTripleOrbit 0) ∧
    smallTriples_1_1.toFinset = smallTripleRepresentatives_1_1.biUnion (smallTripleOrbit 1) ∧
    smallTriples_1_2.toFinset = smallTripleRepresentatives_1_2.biUnion (smallTripleOrbit 1) := by
  decide +kernel

def smallTripleTable (tau nu : ℤ) : List (Finset (ℤ × ℤ)) :=
  if tau = 0 then
    if nu = 1 then smallTriples_0_1 else
    if nu = 2 then smallTriples_0_2 else
    if nu = 4 then smallTriples_0_4 else []
  else if tau = 1 then
    if nu = 1 then smallTriples_1_1 else
    if nu = 2 then smallTriples_1_2 else []
  else []

/-- Only five normalized coordinate models admit a small triple. The fifth
is the nonmaximal Gaussian order, excluded at the full-ring endpoint. -/
theorem smallTripleTable_models {tau nu : ℤ} {row : Finset (ℤ × ℤ)}
    (h : row ∈ smallTripleTable tau nu) :
    (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨ (tau = 0 ∧ nu = 4) ∨
    (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2) := by
  unfold smallTripleTable at h
  split_ifs at h <;> simp_all

/-- The actual maximal-ring tables contain exactly 24 distinct triples. -/
theorem smallTripleTable_counts :
    smallTriples_0_1.length = 10 ∧ smallTriples_0_1.Nodup ∧
    smallTriples_0_2.length = 2 ∧ smallTriples_0_2.Nodup ∧
    smallTriples_1_1.length = 8 ∧ smallTriples_1_1.Nodup ∧
    smallTriples_1_2.length = 4 ∧ smallTriples_1_2.Nodup := by
  decide +kernel

theorem smallTriples_0_1_checked :
    smallTripleClassifiedBool smallDisk_0_1 (smallTripleTable 0 1) = true := by
  decide +kernel

theorem smallTriple_classified_0_1
    (t : Fin 3 → QuadInt 0 1) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 1 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_1
    (smallTripleTable 0 1) ?_ smallTriples_0_1_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_1_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_2_checked :
    smallTripleClassifiedBool smallDisk_0_2 (smallTripleTable 0 2) = true := by
  decide +kernel

theorem smallTriple_classified_0_2
    (t : Fin 3 → QuadInt 0 2) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 2 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_2
    (smallTripleTable 0 2) ?_ smallTriples_0_2_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_2_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_3_checked :
    smallTripleClassifiedBool smallDisk_0_3 (smallTripleTable 0 3) = true := by
  decide +kernel

theorem smallTriple_classified_0_3
    (t : Fin 3 → QuadInt 0 3) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 3 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_3
    (smallTripleTable 0 3) ?_ smallTriples_0_3_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_3_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_4_checked :
    smallTripleClassifiedBool smallDisk_0_4 (smallTripleTable 0 4) = true := by
  decide +kernel

theorem smallTriple_classified_0_4
    (t : Fin 3 → QuadInt 0 4) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 4 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_4
    (smallTripleTable 0 4) ?_ smallTriples_0_4_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_4_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_5_checked :
    smallTripleClassifiedBool smallDisk_0_5 (smallTripleTable 0 5) = true := by
  decide +kernel

theorem smallTriple_classified_0_5
    (t : Fin 3 → QuadInt 0 5) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 5 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_5
    (smallTripleTable 0 5) ?_ smallTriples_0_5_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_5_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_6_checked :
    smallTripleClassifiedBool smallDisk_0_6 (smallTripleTable 0 6) = true := by
  decide +kernel

theorem smallTriple_classified_0_6
    (t : Fin 3 → QuadInt 0 6) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 6 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_6
    (smallTripleTable 0 6) ?_ smallTriples_0_6_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_6_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_7_checked :
    smallTripleClassifiedBool smallDisk_0_7 (smallTripleTable 0 7) = true := by
  decide +kernel

theorem smallTriple_classified_0_7
    (t : Fin 3 → QuadInt 0 7) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 7 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_7
    (smallTripleTable 0 7) ?_ smallTriples_0_7_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_7_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_0_8_checked :
    smallTripleClassifiedBool smallDisk_0_8 (smallTripleTable 0 8) = true := by
  decide +kernel

theorem smallTriple_classified_0_8
    (t : Fin 3 → QuadInt 0 8) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 8 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_0_8
    (smallTripleTable 0 8) ?_ smallTriples_0_8_checked t ht hnorm
  intro z hz
  rw [smallDisk_0_8_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_1_checked :
    smallTripleClassifiedBool smallDisk_1_1 (smallTripleTable 1 1) = true := by
  decide +kernel

theorem smallTriple_classified_1_1
    (t : Fin 3 → QuadInt 1 1) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 1 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_1
    (smallTripleTable 1 1) ?_ smallTriples_1_1_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_1_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_2_checked :
    smallTripleClassifiedBool smallDisk_1_2 (smallTripleTable 1 2) = true := by
  decide +kernel

theorem smallTriple_classified_1_2
    (t : Fin 3 → QuadInt 1 2) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 2 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_2
    (smallTripleTable 1 2) ?_ smallTriples_1_2_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_2_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_3_checked :
    smallTripleClassifiedBool smallDisk_1_3 (smallTripleTable 1 3) = true := by
  decide +kernel

theorem smallTriple_classified_1_3
    (t : Fin 3 → QuadInt 1 3) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 3 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_3
    (smallTripleTable 1 3) ?_ smallTriples_1_3_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_3_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_4_checked :
    smallTripleClassifiedBool smallDisk_1_4 (smallTripleTable 1 4) = true := by
  decide +kernel

theorem smallTriple_classified_1_4
    (t : Fin 3 → QuadInt 1 4) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 4 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_4
    (smallTripleTable 1 4) ?_ smallTriples_1_4_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_4_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_5_checked :
    smallTripleClassifiedBool smallDisk_1_5 (smallTripleTable 1 5) = true := by
  decide +kernel

theorem smallTriple_classified_1_5
    (t : Fin 3 → QuadInt 1 5) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 5 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_5
    (smallTripleTable 1 5) ?_ smallTriples_1_5_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_5_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_6_checked :
    smallTripleClassifiedBool smallDisk_1_6 (smallTripleTable 1 6) = true := by
  decide +kernel

theorem smallTriple_classified_1_6
    (t : Fin 3 → QuadInt 1 6) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 6 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_6
    (smallTripleTable 1 6) ?_ smallTriples_1_6_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_6_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_7_checked :
    smallTripleClassifiedBool smallDisk_1_7 (smallTripleTable 1 7) = true := by
  decide +kernel

theorem smallTriple_classified_1_7
    (t : Fin 3 → QuadInt 1 7) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 7 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_7
    (smallTripleTable 1 7) ?_ smallTriples_1_7_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_7_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriples_1_8_checked :
    smallTripleClassifiedBool smallDisk_1_8 (smallTripleTable 1 8) = true := by
  decide +kernel

theorem smallTriple_classified_1_8
    (t : Fin 3 → QuadInt 1 8) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 8 := by
  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_1_8
    (smallTripleTable 1 8) ?_ smallTriples_1_8_checked t ht hnorm
  intro z hz
  rw [smallDisk_1_8_eq, List.mem_toFinset] at hz
  exact hz

theorem smallTriple_classified_rectangular {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8) :
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable tau nu := by
  rcases htau with rfl | rfl
  · interval_cases nu
    · exact smallTriple_classified_0_1 t ht hnorm
    · exact smallTriple_classified_0_2 t ht hnorm
    · exact smallTriple_classified_0_3 t ht hnorm
    · exact smallTriple_classified_0_4 t ht hnorm
    · exact smallTriple_classified_0_5 t ht hnorm
    · exact smallTriple_classified_0_6 t ht hnorm
    · exact smallTriple_classified_0_7 t ht hnorm
    · exact smallTriple_classified_0_8 t ht hnorm
  · interval_cases nu
    · exact smallTriple_classified_1_1 t ht hnorm
    · exact smallTriple_classified_1_2 t ht hnorm
    · exact smallTriple_classified_1_3 t ht hnorm
    · exact smallTriple_classified_1_4 t ht hnorm
    · exact smallTriple_classified_1_5 t ht hnorm
    · exact smallTriple_classified_1_6 t ht hnorm
    · exact smallTriple_classified_1_7 t ht hnorm
    · exact smallTriple_classified_1_8 t ht hnorm

end D1Bound5
