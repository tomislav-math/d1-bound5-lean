import D1Bound5.OneSmallDisks

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallPairA_0 : QuadInt 0 1 := ⟨0,1⟩
def oneSmallPairB_0 : QuadInt 0 1 := ⟨0,-3⟩
def oneSmallThirds_0 : List (QuadInt 0 1) := [⟨-4,-2⟩, ⟨0,5⟩, ⟨4,-2⟩]

theorem oneSmallThirds_0_checked :
    oneSmallThirdCoveredBool oneSmallPairA_0 oneSmallPairB_0
      oneSmallDisk_224_0_1 oneSmallThirds_0 = true := by
  decide +kernel

theorem oneSmallThirds_0_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_0.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_0) (hb : s ≠ oneSmallPairB_0)
    (hpair : PairExtension oneSmallPairA_0 oneSmallPairB_0 s) : s ∈ oneSmallThirds_0 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_0 oneSmallPairB_0
    oneSmallDisk_224_0_1 oneSmallThirds_0 ?_ oneSmallThirds_0_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_1 : QuadInt 0 1 := ⟨0,1⟩
def oneSmallPairB_1 : QuadInt 0 1 := ⟨0,5⟩
def oneSmallThirds_1 : List (QuadInt 0 1) := [⟨0,10⟩]

theorem oneSmallThirds_1_checked :
    oneSmallThirdCoveredBool oneSmallPairA_1 oneSmallPairB_1
      oneSmallDisk_224_0_1 oneSmallThirds_1 = true := by
  decide +kernel

theorem oneSmallThirds_1_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_1.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_1) (hb : s ≠ oneSmallPairB_1)
    (hpair : PairExtension oneSmallPairA_1 oneSmallPairB_1 s) : s ∈ oneSmallThirds_1 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_1 oneSmallPairB_1
    oneSmallDisk_224_0_1 oneSmallThirds_1 ?_ oneSmallThirds_1_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_2 : QuadInt 0 1 := ⟨0,1⟩
def oneSmallPairB_2 : QuadInt 0 1 := ⟨4,-2⟩
def oneSmallThirds_2 : List (QuadInt 0 1) := [⟨-4,4⟩, ⟨8,1⟩]

theorem oneSmallThirds_2_checked :
    oneSmallThirdCoveredBool oneSmallPairA_2 oneSmallPairB_2
      oneSmallDisk_224_0_1 oneSmallThirds_2 = true := by
  decide +kernel

theorem oneSmallThirds_2_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_2.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_2) (hb : s ≠ oneSmallPairB_2)
    (hpair : PairExtension oneSmallPairA_2 oneSmallPairB_2 s) : s ∈ oneSmallThirds_2 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_2 oneSmallPairB_2
    oneSmallDisk_224_0_1 oneSmallThirds_2 ?_ oneSmallThirds_2_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_3 : QuadInt 0 1 := ⟨0,1⟩
def oneSmallPairB_3 : QuadInt 0 1 := ⟨4,4⟩
def oneSmallThirds_3 : List (QuadInt 0 1) := [⟨6,9⟩]

theorem oneSmallThirds_3_checked :
    oneSmallThirdCoveredBool oneSmallPairA_3 oneSmallPairB_3
      oneSmallDisk_224_0_1 oneSmallThirds_3 = true := by
  decide +kernel

theorem oneSmallThirds_3_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_3.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_3) (hb : s ≠ oneSmallPairB_3)
    (hpair : PairExtension oneSmallPairA_3 oneSmallPairB_3 s) : s ∈ oneSmallThirds_3 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_3 oneSmallPairB_3
    oneSmallDisk_224_0_1 oneSmallThirds_3 ?_ oneSmallThirds_3_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_4 : QuadInt 0 1 := ⟨1,0⟩
def oneSmallPairB_4 : QuadInt 0 1 := ⟨-5,0⟩
def oneSmallThirds_4 : List (QuadInt 0 1) := [⟨-4,-4⟩, ⟨-4,4⟩]

theorem oneSmallThirds_4_checked :
    oneSmallThirdCoveredBool oneSmallPairA_4 oneSmallPairB_4
      oneSmallDisk_224_0_1 oneSmallThirds_4 = true := by
  decide +kernel

theorem oneSmallThirds_4_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_4.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_4) (hb : s ≠ oneSmallPairB_4)
    (hpair : PairExtension oneSmallPairA_4 oneSmallPairB_4 s) : s ∈ oneSmallThirds_4 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_4 oneSmallPairB_4
    oneSmallDisk_224_0_1 oneSmallThirds_4 ?_ oneSmallThirds_4_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_5 : QuadInt 0 1 := ⟨1,0⟩
def oneSmallPairB_5 : QuadInt 0 1 := ⟨-4,4⟩
def oneSmallThirds_5 : List (QuadInt 0 1) := [⟨-1,8⟩]

theorem oneSmallThirds_5_checked :
    oneSmallThirdCoveredBool oneSmallPairA_5 oneSmallPairB_5
      oneSmallDisk_224_0_1 oneSmallThirds_5 = true := by
  decide +kernel

theorem oneSmallThirds_5_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_5.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_5) (hb : s ≠ oneSmallPairB_5)
    (hpair : PairExtension oneSmallPairA_5 oneSmallPairB_5 s) : s ∈ oneSmallThirds_5 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_5 oneSmallPairB_5
    oneSmallDisk_224_0_1 oneSmallThirds_5 ?_ oneSmallThirds_5_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_6 : QuadInt 0 1 := ⟨1,0⟩
def oneSmallPairB_6 : QuadInt 0 1 := ⟨2,4⟩
def oneSmallThirds_6 : List (QuadInt 0 1) := [⟨7,6⟩]

theorem oneSmallThirds_6_checked :
    oneSmallThirdCoveredBool oneSmallPairA_6 oneSmallPairB_6
      oneSmallDisk_224_0_1 oneSmallThirds_6 = true := by
  decide +kernel

theorem oneSmallThirds_6_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_6.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_6) (hb : s ≠ oneSmallPairB_6)
    (hpair : PairExtension oneSmallPairA_6 oneSmallPairB_6 s) : s ∈ oneSmallThirds_6 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_6 oneSmallPairB_6
    oneSmallDisk_224_0_1 oneSmallThirds_6 ?_ oneSmallThirds_6_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_7 : QuadInt 0 2 := ⟨1,0⟩
def oneSmallPairB_7 : QuadInt 0 2 := ⟨-3,0⟩
def oneSmallThirds_7 : List (QuadInt 0 2) := [⟨-2,-2⟩, ⟨-2,2⟩, ⟨3,0⟩]

theorem oneSmallThirds_7_checked :
    oneSmallThirdCoveredBool oneSmallPairA_7 oneSmallPairB_7
      oneSmallDisk_224_0_2 oneSmallThirds_7 = true := by
  decide +kernel

theorem oneSmallThirds_7_complete (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_7.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_7) (hb : s ≠ oneSmallPairB_7)
    (hpair : PairExtension oneSmallPairA_7 oneSmallPairB_7 s) : s ∈ oneSmallThirds_7 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_7 oneSmallPairB_7
    oneSmallDisk_224_0_2 oneSmallThirds_7 ?_ oneSmallThirds_7_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_8 : QuadInt 0 2 := ⟨1,0⟩
def oneSmallPairB_8 : QuadInt 0 2 := ⟨-2,2⟩
def oneSmallThirds_8 : List (QuadInt 0 2) := [⟨1,4⟩]

theorem oneSmallThirds_8_checked :
    oneSmallThirdCoveredBool oneSmallPairA_8 oneSmallPairB_8
      oneSmallDisk_224_0_2 oneSmallThirds_8 = true := by
  decide +kernel

theorem oneSmallThirds_8_complete (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_8.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_8) (hb : s ≠ oneSmallPairB_8)
    (hpair : PairExtension oneSmallPairA_8 oneSmallPairB_8 s) : s ∈ oneSmallThirds_8 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_8 oneSmallPairB_8
    oneSmallDisk_224_0_2 oneSmallThirds_8 ?_ oneSmallThirds_8_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_9 : QuadInt 0 2 := ⟨1,0⟩
def oneSmallPairB_9 : QuadInt 0 2 := ⟨1,4⟩
def oneSmallThirds_9 : List (QuadInt 0 2) := [⟨6,6⟩]

theorem oneSmallThirds_9_checked :
    oneSmallThirdCoveredBool oneSmallPairA_9 oneSmallPairB_9
      oneSmallDisk_224_0_2 oneSmallThirds_9 = true := by
  decide +kernel

theorem oneSmallThirds_9_complete (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_9.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_9) (hb : s ≠ oneSmallPairB_9)
    (hpair : PairExtension oneSmallPairA_9 oneSmallPairB_9 s) : s ∈ oneSmallThirds_9 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_9 oneSmallPairB_9
    oneSmallDisk_224_0_2 oneSmallThirds_9 ?_ oneSmallThirds_9_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_10 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_10 : QuadInt 1 1 := ⟨-9,6⟩
def oneSmallThirds_10 : List (QuadInt 1 1) := [⟨-13,13⟩]

theorem oneSmallThirds_10_checked :
    oneSmallThirdCoveredBool oneSmallPairA_10 oneSmallPairB_10
      oneSmallDisk_224_1_1 oneSmallThirds_10 = true := by
  decide +kernel

theorem oneSmallThirds_10_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_10.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_10) (hb : s ≠ oneSmallPairB_10)
    (hpair : PairExtension oneSmallPairA_10 oneSmallPairB_10 s) : s ∈ oneSmallThirds_10 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_10 oneSmallPairB_10
    oneSmallDisk_224_1_1 oneSmallThirds_10 ?_ oneSmallThirds_10_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_11 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_11 : QuadInt 1 1 := ⟨-6,9⟩
def oneSmallThirds_11 : List (QuadInt 1 1) := [⟨-8,16⟩]

theorem oneSmallThirds_11_checked :
    oneSmallThirdCoveredBool oneSmallPairA_11 oneSmallPairB_11
      oneSmallDisk_224_1_1 oneSmallThirds_11 = true := by
  decide +kernel

theorem oneSmallThirds_11_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_11.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_11) (hb : s ≠ oneSmallPairB_11)
    (hpair : PairExtension oneSmallPairA_11 oneSmallPairB_11 s) : s ∈ oneSmallThirds_11 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_11 oneSmallPairB_11
    oneSmallDisk_224_1_1 oneSmallThirds_11 ?_ oneSmallThirds_11_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_12 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_12 : QuadInt 1 1 := ⟨-5,1⟩
def oneSmallThirds_12 : List (QuadInt 1 1) := [⟨-9,6⟩]

theorem oneSmallThirds_12_checked :
    oneSmallThirdCoveredBool oneSmallPairA_12 oneSmallPairB_12
      oneSmallDisk_224_1_1 oneSmallThirds_12 = true := by
  decide +kernel

theorem oneSmallThirds_12_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_12.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_12) (hb : s ≠ oneSmallPairB_12)
    (hpair : PairExtension oneSmallPairA_12 oneSmallPairB_12 s) : s ∈ oneSmallThirds_12 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_12 oneSmallPairB_12
    oneSmallDisk_224_1_1 oneSmallThirds_12 ?_ oneSmallThirds_12_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_13 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_13 : QuadInt 1 1 := ⟨-4,-4⟩
def oneSmallThirds_13 : List (QuadInt 1 1) := [⟨-10,1⟩]

theorem oneSmallThirds_13_checked :
    oneSmallThirdCoveredBool oneSmallPairA_13 oneSmallPairB_13
      oneSmallDisk_224_1_1 oneSmallThirds_13 = true := by
  decide +kernel

theorem oneSmallThirds_13_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_13.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_13) (hb : s ≠ oneSmallPairB_13)
    (hpair : PairExtension oneSmallPairA_13 oneSmallPairB_13 s) : s ∈ oneSmallThirds_13 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_13 oneSmallPairB_13
    oneSmallDisk_224_1_1 oneSmallThirds_13 ?_ oneSmallThirds_13_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_14 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_14 : QuadInt 1 1 := ⟨-4,4⟩
def oneSmallThirds_14 : List (QuadInt 1 1) := [⟨-6,9⟩]

theorem oneSmallThirds_14_checked :
    oneSmallThirdCoveredBool oneSmallPairA_14 oneSmallPairB_14
      oneSmallDisk_224_1_1 oneSmallThirds_14 = true := by
  decide +kernel

theorem oneSmallThirds_14_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_14.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_14) (hb : s ≠ oneSmallPairB_14)
    (hpair : PairExtension oneSmallPairA_14 oneSmallPairB_14 s) : s ∈ oneSmallThirds_14 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_14 oneSmallPairB_14
    oneSmallDisk_224_1_1 oneSmallThirds_14 ?_ oneSmallThirds_14_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_15 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_15 : QuadInt 1 1 := ⟨-1,5⟩
def oneSmallThirds_15 : List (QuadInt 1 1) := [⟨-1,10⟩]

theorem oneSmallThirds_15_checked :
    oneSmallThirdCoveredBool oneSmallPairA_15 oneSmallPairB_15
      oneSmallDisk_224_1_1 oneSmallThirds_15 = true := by
  decide +kernel

theorem oneSmallThirds_15_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_15.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_15) (hb : s ≠ oneSmallPairB_15)
    (hpair : PairExtension oneSmallPairA_15 oneSmallPairB_15 s) : s ∈ oneSmallThirds_15 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_15 oneSmallPairB_15
    oneSmallDisk_224_1_1 oneSmallThirds_15 ?_ oneSmallThirds_15_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_16 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_16 : QuadInt 1 1 := ⟨2,-7⟩
def oneSmallThirds_16 : List (QuadInt 1 1) := [⟨-4,-4⟩, ⟨8,-8⟩]

theorem oneSmallThirds_16_checked :
    oneSmallThirdCoveredBool oneSmallPairA_16 oneSmallPairB_16
      oneSmallDisk_224_1_1 oneSmallThirds_16 = true := by
  decide +kernel

theorem oneSmallThirds_16_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_16.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_16) (hb : s ≠ oneSmallPairB_16)
    (hpair : PairExtension oneSmallPairA_16 oneSmallPairB_16 s) : s ∈ oneSmallThirds_16 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_16 oneSmallPairB_16
    oneSmallDisk_224_1_1 oneSmallThirds_16 ?_ oneSmallThirds_16_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_17 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_17 : QuadInt 1 1 := ⟨3,-3⟩
def oneSmallThirds_17 : List (QuadInt 1 1) := [⟨7,-2⟩]

theorem oneSmallThirds_17_checked :
    oneSmallThirdCoveredBool oneSmallPairA_17 oneSmallPairB_17
      oneSmallDisk_224_1_1 oneSmallThirds_17 = true := by
  decide +kernel

theorem oneSmallThirds_17_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_17.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_17) (hb : s ≠ oneSmallPairB_17)
    (hpair : PairExtension oneSmallPairA_17 oneSmallPairB_17 s) : s ∈ oneSmallThirds_17 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_17 oneSmallPairB_17
    oneSmallDisk_224_1_1 oneSmallThirds_17 ?_ oneSmallThirds_17_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_18 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_18 : QuadInt 1 1 := ⟨4,4⟩
def oneSmallThirds_18 : List (QuadInt 1 1) := [⟨6,9⟩]

theorem oneSmallThirds_18_checked :
    oneSmallThirdCoveredBool oneSmallPairA_18 oneSmallPairB_18
      oneSmallDisk_224_1_1 oneSmallThirds_18 = true := by
  decide +kernel

theorem oneSmallThirds_18_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_18.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_18) (hb : s ≠ oneSmallPairB_18)
    (hpair : PairExtension oneSmallPairA_18 oneSmallPairB_18 s) : s ∈ oneSmallThirds_18 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_18 oneSmallPairB_18
    oneSmallDisk_224_1_1 oneSmallThirds_18 ?_ oneSmallThirds_18_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_19 : QuadInt 1 1 := ⟨0,1⟩
def oneSmallPairB_19 : QuadInt 1 1 := ⟨7,-2⟩
def oneSmallThirds_19 : List (QuadInt 1 1) := [⟨11,1⟩]

theorem oneSmallThirds_19_checked :
    oneSmallThirdCoveredBool oneSmallPairA_19 oneSmallPairB_19
      oneSmallDisk_224_1_1 oneSmallThirds_19 = true := by
  decide +kernel

theorem oneSmallThirds_19_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_19.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_19) (hb : s ≠ oneSmallPairB_19)
    (hpair : PairExtension oneSmallPairA_19 oneSmallPairB_19 s) : s ∈ oneSmallThirds_19 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_19 oneSmallPairB_19
    oneSmallDisk_224_1_1 oneSmallThirds_19 ?_ oneSmallThirds_19_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_20 : QuadInt 1 1 := ⟨1,0⟩
def oneSmallPairB_20 : QuadInt 1 1 := ⟨-9,3⟩
def oneSmallThirds_20 : List (QuadInt 1 1) := [⟨-10,9⟩, ⟨-6,-3⟩]

theorem oneSmallThirds_20_checked :
    oneSmallThirdCoveredBool oneSmallPairA_20 oneSmallPairB_20
      oneSmallDisk_224_1_1 oneSmallThirds_20 = true := by
  decide +kernel

theorem oneSmallThirds_20_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_20.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_20) (hb : s ≠ oneSmallPairB_20)
    (hpair : PairExtension oneSmallPairA_20 oneSmallPairB_20 s) : s ∈ oneSmallThirds_20 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_20 oneSmallPairB_20
    oneSmallDisk_224_1_1 oneSmallThirds_20 ?_ oneSmallThirds_20_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_21 : QuadInt 1 1 := ⟨1,0⟩
def oneSmallPairB_21 : QuadInt 1 1 := ⟨-5,4⟩
def oneSmallThirds_21 : List (QuadInt 1 1) := [⟨-4,8⟩]

theorem oneSmallThirds_21_checked :
    oneSmallThirdCoveredBool oneSmallPairA_21 oneSmallPairB_21
      oneSmallDisk_224_1_1 oneSmallThirds_21 = true := by
  decide +kernel

theorem oneSmallThirds_21_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_21.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_21) (hb : s ≠ oneSmallPairB_21)
    (hpair : PairExtension oneSmallPairA_21 oneSmallPairB_21 s) : s ∈ oneSmallThirds_21 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_21 oneSmallPairB_21
    oneSmallDisk_224_1_1 oneSmallThirds_21 ?_ oneSmallThirds_21_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_22 : QuadInt 1 1 := ⟨1,0⟩
def oneSmallPairB_22 : QuadInt 1 1 := ⟨-4,0⟩
def oneSmallThirds_22 : List (QuadInt 1 1) := [⟨-5,4⟩, ⟨-1,-4⟩]

theorem oneSmallThirds_22_checked :
    oneSmallThirdCoveredBool oneSmallPairA_22 oneSmallPairB_22
      oneSmallDisk_224_1_1 oneSmallThirds_22 = true := by
  decide +kernel

theorem oneSmallThirds_22_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_22.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_22) (hb : s ≠ oneSmallPairB_22)
    (hpair : PairExtension oneSmallPairA_22 oneSmallPairB_22 s) : s ∈ oneSmallThirds_22 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_22 oneSmallPairB_22
    oneSmallDisk_224_1_1 oneSmallThirds_22 ?_ oneSmallThirds_22_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_23 : QuadInt 1 1 := ⟨1,0⟩
def oneSmallPairB_23 : QuadInt 1 1 := ⟨-4,8⟩
def oneSmallThirds_23 : List (QuadInt 1 1) := [⟨-1,12⟩, ⟨4,-8⟩]

theorem oneSmallThirds_23_checked :
    oneSmallThirdCoveredBool oneSmallPairA_23 oneSmallPairB_23
      oneSmallDisk_224_1_1 oneSmallThirds_23 = true := by
  decide +kernel

theorem oneSmallThirds_23_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_23.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_23) (hb : s ≠ oneSmallPairB_23)
    (hpair : PairExtension oneSmallPairA_23 oneSmallPairB_23 s) : s ∈ oneSmallThirds_23 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_23 oneSmallPairB_23
    oneSmallDisk_224_1_1 oneSmallThirds_23 ?_ oneSmallThirds_23_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_24 : QuadInt 1 1 := ⟨1,0⟩
def oneSmallPairB_24 : QuadInt 1 1 := ⟨2,5⟩
def oneSmallThirds_24 : List (QuadInt 1 1) := [⟨7,7⟩]

theorem oneSmallThirds_24_checked :
    oneSmallThirdCoveredBool oneSmallPairA_24 oneSmallPairB_24
      oneSmallDisk_224_1_1 oneSmallThirds_24 = true := by
  decide +kernel

theorem oneSmallThirds_24_complete (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_24.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_24) (hb : s ≠ oneSmallPairB_24)
    (hpair : PairExtension oneSmallPairA_24 oneSmallPairB_24 s) : s ∈ oneSmallThirds_24 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_24 oneSmallPairB_24
    oneSmallDisk_224_1_1 oneSmallThirds_24 ?_ oneSmallThirds_24_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_25 : QuadInt 0 5 := ⟨1,0⟩
def oneSmallPairB_25 : QuadInt 0 5 := ⟨-6,0⟩
def oneSmallThirds_25 : List (QuadInt 0 5) := [⟨-5,-2⟩, ⟨-5,2⟩]

theorem oneSmallThirds_25_checked :
    oneSmallThirdCoveredBool oneSmallPairA_25 oneSmallPairB_25
      oneSmallDisk_224_0_5 oneSmallThirds_25 = true := by
  decide +kernel

theorem oneSmallThirds_25_complete (s : QuadInt 0 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_25.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_25) (hb : s ≠ oneSmallPairB_25)
    (hpair : PairExtension oneSmallPairA_25 oneSmallPairB_25 s) : s ∈ oneSmallThirds_25 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_25 oneSmallPairB_25
    oneSmallDisk_224_0_5 oneSmallThirds_25 ?_ oneSmallThirds_25_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_26 : QuadInt 0 5 := ⟨1,0⟩
def oneSmallPairB_26 : QuadInt 0 5 := ⟨-5,2⟩
def oneSmallThirds_26 : List (QuadInt 0 5) := [⟨-2,4⟩]

theorem oneSmallThirds_26_checked :
    oneSmallThirdCoveredBool oneSmallPairA_26 oneSmallPairB_26
      oneSmallDisk_224_0_5 oneSmallThirds_26 = true := by
  decide +kernel

theorem oneSmallThirds_26_complete (s : QuadInt 0 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_26.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_26) (hb : s ≠ oneSmallPairB_26)
    (hpair : PairExtension oneSmallPairA_26 oneSmallPairB_26 s) : s ∈ oneSmallThirds_26 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_26 oneSmallPairB_26
    oneSmallDisk_224_0_5 oneSmallThirds_26 ?_ oneSmallThirds_26_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_27 : QuadInt 0 6 := ⟨1,0⟩
def oneSmallPairB_27 : QuadInt 0 6 := ⟨-7,0⟩
def oneSmallThirds_27 : List (QuadInt 0 6) := [⟨-6,-2⟩, ⟨-6,2⟩]

theorem oneSmallThirds_27_checked :
    oneSmallThirdCoveredBool oneSmallPairA_27 oneSmallPairB_27
      oneSmallDisk_224_0_6 oneSmallThirds_27 = true := by
  decide +kernel

theorem oneSmallThirds_27_complete (s : QuadInt 0 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_27.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_27) (hb : s ≠ oneSmallPairB_27)
    (hpair : PairExtension oneSmallPairA_27 oneSmallPairB_27 s) : s ∈ oneSmallThirds_27 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_27 oneSmallPairB_27
    oneSmallDisk_224_0_6 oneSmallThirds_27 ?_ oneSmallThirds_27_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_28 : QuadInt 0 6 := ⟨1,0⟩
def oneSmallPairB_28 : QuadInt 0 6 := ⟨-6,2⟩
def oneSmallThirds_28 : List (QuadInt 0 6) := [⟨-3,4⟩]

theorem oneSmallThirds_28_checked :
    oneSmallThirdCoveredBool oneSmallPairA_28 oneSmallPairB_28
      oneSmallDisk_224_0_6 oneSmallThirds_28 = true := by
  decide +kernel

theorem oneSmallThirds_28_complete (s : QuadInt 0 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_28.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_28) (hb : s ≠ oneSmallPairB_28)
    (hpair : PairExtension oneSmallPairA_28 oneSmallPairB_28 s) : s ∈ oneSmallThirds_28 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_28 oneSmallPairB_28
    oneSmallDisk_224_0_6 oneSmallThirds_28 ?_ oneSmallThirds_28_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_29 : QuadInt 1 2 := ⟨1,0⟩
def oneSmallPairB_29 : QuadInt 1 2 := ⟨-2,3⟩
def oneSmallThirds_29 : List (QuadInt 1 2) := [⟨1,5⟩]

theorem oneSmallThirds_29_checked :
    oneSmallThirdCoveredBool oneSmallPairA_29 oneSmallPairB_29
      oneSmallDisk_224_1_2 oneSmallThirds_29 = true := by
  decide +kernel

theorem oneSmallThirds_29_complete (s : QuadInt 1 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_29.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_29) (hb : s ≠ oneSmallPairB_29)
    (hpair : PairExtension oneSmallPairA_29 oneSmallPairB_29 s) : s ∈ oneSmallThirds_29 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_29 oneSmallPairB_29
    oneSmallDisk_224_1_2 oneSmallThirds_29 ?_ oneSmallThirds_29_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_30 : QuadInt 1 2 := ⟨1,0⟩
def oneSmallPairB_30 : QuadInt 1 2 := ⟨1,5⟩
def oneSmallThirds_30 : List (QuadInt 1 2) := [⟨6,7⟩]

theorem oneSmallThirds_30_checked :
    oneSmallThirdCoveredBool oneSmallPairA_30 oneSmallPairB_30
      oneSmallDisk_224_1_2 oneSmallThirds_30 = true := by
  decide +kernel

theorem oneSmallThirds_30_complete (s : QuadInt 1 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_30.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_30) (hb : s ≠ oneSmallPairB_30)
    (hpair : PairExtension oneSmallPairA_30 oneSmallPairB_30 s) : s ∈ oneSmallThirds_30 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_30 oneSmallPairB_30
    oneSmallDisk_224_1_2 oneSmallThirds_30 ?_ oneSmallThirds_30_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_31 : QuadInt 1 3 := ⟨1,0⟩
def oneSmallPairB_31 : QuadInt 1 3 := ⟨-4,1⟩
def oneSmallThirds_31 : List (QuadInt 1 3) := [⟨-3,-1⟩, ⟨-3,3⟩]

theorem oneSmallThirds_31_checked :
    oneSmallThirdCoveredBool oneSmallPairA_31 oneSmallPairB_31
      oneSmallDisk_224_1_3 oneSmallThirds_31 = true := by
  decide +kernel

theorem oneSmallThirds_31_complete (s : QuadInt 1 3) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_31.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_31) (hb : s ≠ oneSmallPairB_31)
    (hpair : PairExtension oneSmallPairA_31 oneSmallPairB_31 s) : s ∈ oneSmallThirds_31 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_31 oneSmallPairB_31
    oneSmallDisk_224_1_3 oneSmallThirds_31 ?_ oneSmallThirds_31_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_3_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_32 : QuadInt 1 3 := ⟨1,0⟩
def oneSmallPairB_32 : QuadInt 1 3 := ⟨-3,3⟩
def oneSmallThirds_32 : List (QuadInt 1 3) := [⟨0,5⟩]

theorem oneSmallThirds_32_checked :
    oneSmallThirdCoveredBool oneSmallPairA_32 oneSmallPairB_32
      oneSmallDisk_224_1_3 oneSmallThirds_32 = true := by
  decide +kernel

theorem oneSmallThirds_32_complete (s : QuadInt 1 3) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_32.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_32) (hb : s ≠ oneSmallPairB_32)
    (hpair : PairExtension oneSmallPairA_32 oneSmallPairB_32 s) : s ∈ oneSmallThirds_32 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_32 oneSmallPairB_32
    oneSmallDisk_224_1_3 oneSmallThirds_32 ?_ oneSmallThirds_32_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_3_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_33 : QuadInt 1 4 := ⟨1,0⟩
def oneSmallPairB_33 : QuadInt 1 4 := ⟨-5,1⟩
def oneSmallThirds_33 : List (QuadInt 1 4) := [⟨-4,-1⟩, ⟨-4,3⟩]

theorem oneSmallThirds_33_checked :
    oneSmallThirdCoveredBool oneSmallPairA_33 oneSmallPairB_33
      oneSmallDisk_224_1_4 oneSmallThirds_33 = true := by
  decide +kernel

theorem oneSmallThirds_33_complete (s : QuadInt 1 4) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_33.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_33) (hb : s ≠ oneSmallPairB_33)
    (hpair : PairExtension oneSmallPairA_33 oneSmallPairB_33 s) : s ∈ oneSmallThirds_33 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_33 oneSmallPairB_33
    oneSmallDisk_224_1_4 oneSmallThirds_33 ?_ oneSmallThirds_33_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_4_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_34 : QuadInt 1 4 := ⟨1,0⟩
def oneSmallPairB_34 : QuadInt 1 4 := ⟨-4,3⟩
def oneSmallThirds_34 : List (QuadInt 1 4) := [⟨-1,5⟩]

theorem oneSmallThirds_34_checked :
    oneSmallThirdCoveredBool oneSmallPairA_34 oneSmallPairB_34
      oneSmallDisk_224_1_4 oneSmallThirds_34 = true := by
  decide +kernel

theorem oneSmallThirds_34_complete (s : QuadInt 1 4) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_34.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_34) (hb : s ≠ oneSmallPairB_34)
    (hpair : PairExtension oneSmallPairA_34 oneSmallPairB_34 s) : s ∈ oneSmallThirds_34 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_34 oneSmallPairB_34
    oneSmallDisk_224_1_4 oneSmallThirds_34 ?_ oneSmallThirds_34_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_4_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_35 : QuadInt 1 5 := ⟨1,0⟩
def oneSmallPairB_35 : QuadInt 1 5 := ⟨-6,1⟩
def oneSmallThirds_35 : List (QuadInt 1 5) := [⟨-5,-1⟩, ⟨-5,3⟩]

theorem oneSmallThirds_35_checked :
    oneSmallThirdCoveredBool oneSmallPairA_35 oneSmallPairB_35
      oneSmallDisk_224_1_5 oneSmallThirds_35 = true := by
  decide +kernel

theorem oneSmallThirds_35_complete (s : QuadInt 1 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_35.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_35) (hb : s ≠ oneSmallPairB_35)
    (hpair : PairExtension oneSmallPairA_35 oneSmallPairB_35 s) : s ∈ oneSmallThirds_35 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_35 oneSmallPairB_35
    oneSmallDisk_224_1_5 oneSmallThirds_35 ?_ oneSmallThirds_35_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_36 : QuadInt 1 5 := ⟨1,0⟩
def oneSmallPairB_36 : QuadInt 1 5 := ⟨-5,3⟩
def oneSmallThirds_36 : List (QuadInt 1 5) := [⟨-2,5⟩]

theorem oneSmallThirds_36_checked :
    oneSmallThirdCoveredBool oneSmallPairA_36 oneSmallPairB_36
      oneSmallDisk_224_1_5 oneSmallThirds_36 = true := by
  decide +kernel

theorem oneSmallThirds_36_complete (s : QuadInt 1 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_36.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_36) (hb : s ≠ oneSmallPairB_36)
    (hpair : PairExtension oneSmallPairA_36 oneSmallPairB_36 s) : s ∈ oneSmallThirds_36 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_36 oneSmallPairB_36
    oneSmallDisk_224_1_5 oneSmallThirds_36 ?_ oneSmallThirds_36_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_37 : QuadInt 1 6 := ⟨1,0⟩
def oneSmallPairB_37 : QuadInt 1 6 := ⟨-7,1⟩
def oneSmallThirds_37 : List (QuadInt 1 6) := [⟨-6,-1⟩, ⟨-6,3⟩]

theorem oneSmallThirds_37_checked :
    oneSmallThirdCoveredBool oneSmallPairA_37 oneSmallPairB_37
      oneSmallDisk_224_1_6 oneSmallThirds_37 = true := by
  decide +kernel

theorem oneSmallThirds_37_complete (s : QuadInt 1 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_37.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_37) (hb : s ≠ oneSmallPairB_37)
    (hpair : PairExtension oneSmallPairA_37 oneSmallPairB_37 s) : s ∈ oneSmallThirds_37 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_37 oneSmallPairB_37
    oneSmallDisk_224_1_6 oneSmallThirds_37 ?_ oneSmallThirds_37_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_1_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_38 : QuadInt 0 1 := ⟨1,1⟩
def oneSmallPairB_38 : QuadInt 0 1 := ⟨-1,-3⟩
def oneSmallThirds_38 : List (QuadInt 0 1) := [⟨-4,0⟩, ⟨4,-4⟩]

theorem oneSmallThirds_38_checked :
    oneSmallThirdCoveredBool oneSmallPairA_38 oneSmallPairB_38
      oneSmallDisk_224_0_1 oneSmallThirds_38 = true := by
  decide +kernel

theorem oneSmallThirds_38_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_38.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_38) (hb : s ≠ oneSmallPairB_38)
    (hpair : PairExtension oneSmallPairA_38 oneSmallPairB_38 s) : s ∈ oneSmallThirds_38 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_38 oneSmallPairB_38
    oneSmallDisk_224_0_1 oneSmallThirds_38 ?_ oneSmallThirds_38_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallPairA_39 : QuadInt 0 1 := ⟨1,1⟩
def oneSmallPairB_39 : QuadInt 0 1 := ⟨3,1⟩
def oneSmallThirds_39 : List (QuadInt 0 1) := [⟨8,4⟩]

theorem oneSmallThirds_39_checked :
    oneSmallThirdCoveredBool oneSmallPairA_39 oneSmallPairB_39
      oneSmallDisk_224_0_1 oneSmallThirds_39 = true := by
  decide +kernel

theorem oneSmallThirds_39_complete (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_39.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_39) (hb : s ≠ oneSmallPairB_39)
    (hpair : PairExtension oneSmallPairA_39 oneSmallPairB_39 s) : s ∈ oneSmallThirds_39 := by
  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_39 oneSmallPairB_39
    oneSmallDisk_224_0_1 oneSmallThirds_39 ?_ oneSmallThirds_39_checked s hbound horder ha hb hpair
  intro q hq; rw [oneSmallDisk_224_0_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
