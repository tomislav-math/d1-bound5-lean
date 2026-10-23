import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_8 : QuadInt 0 1 := ⟨-4,4⟩
def oneSmallTripleCutoff_8 : ℤ := 3299

theorem oneSmallFourth_8_checked :
    oneSmallFourthGrowthBool oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_8
      oneSmallTripleCutoff_8 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_8_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_8)
    (ha : ∃ q, q*q = oneSmallPairA_4*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_4*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_8*z+1) :
    z.norm ≤ 4*oneSmallPairB_4.norm*oneSmallTripleS_8.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_8
    (by decide) (by decide) oneSmallTripleCutoff_8 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_8_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_9 : QuadInt 0 1 := ⟨-1,8⟩
def oneSmallTripleCutoff_9 : ℤ := 4857

theorem oneSmallFourth_9_checked :
    oneSmallFourthGrowthBool oneSmallPairA_5 oneSmallPairB_5 oneSmallTripleS_9
      oneSmallTripleCutoff_9 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_9_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_9)
    (ha : ∃ q, q*q = oneSmallPairA_5*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_5*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_9*z+1) :
    z.norm ≤ 4*oneSmallPairB_5.norm*oneSmallTripleS_9.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_5 oneSmallPairB_5 oneSmallTripleS_9
    (by decide) (by decide) oneSmallTripleCutoff_9 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_9_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_10 : QuadInt 0 1 := ⟨7,6⟩
def oneSmallTripleCutoff_10 : ℤ := 2018

theorem oneSmallFourth_10_checked :
    oneSmallFourthGrowthBool oneSmallPairA_6 oneSmallPairB_6 oneSmallTripleS_10
      oneSmallTripleCutoff_10 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_10_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_10)
    (ha : ∃ q, q*q = oneSmallPairA_6*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_6*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_10*z+1) :
    z.norm ≤ 4*oneSmallPairB_6.norm*oneSmallTripleS_10.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_6 oneSmallPairB_6 oneSmallTripleS_10
    (by decide) (by decide) oneSmallTripleCutoff_10 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_10_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_11 : QuadInt 0 2 := ⟨-2,-2⟩
def oneSmallTripleCutoff_11 : ℤ := 1024

theorem oneSmallFourth_11_checked :
    oneSmallFourthGrowthBool oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_11
      oneSmallTripleCutoff_11 oneSmallDisk_300_0_2 = true := by
  decide +kernel

theorem oneSmallFourth_11_growth (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_11)
    (ha : ∃ q, q*q = oneSmallPairA_7*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_7*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_11*z+1) :
    z.norm ≤ 4*oneSmallPairB_7.norm*oneSmallTripleS_11.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_11
    (by decide) (by decide) oneSmallTripleCutoff_11 (by decide)
    oneSmallDisk_300_0_2 ?_ oneSmallFourth_11_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_12 : QuadInt 0 2 := ⟨-2,2⟩
def oneSmallTripleCutoff_12 : ℤ := 1024

theorem oneSmallFourth_12_checked :
    oneSmallFourthGrowthBool oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_12
      oneSmallTripleCutoff_12 oneSmallDisk_300_0_2 = true := by
  decide +kernel

theorem oneSmallFourth_12_growth (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_12)
    (ha : ∃ q, q*q = oneSmallPairA_7*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_7*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_12*z+1) :
    z.norm ≤ 4*oneSmallPairB_7.norm*oneSmallTripleS_12.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_12
    (by decide) (by decide) oneSmallTripleCutoff_12 (by decide)
    oneSmallDisk_300_0_2 ?_ oneSmallFourth_12_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_13 : QuadInt 0 2 := ⟨1,4⟩
def oneSmallTripleCutoff_13 : ℤ := 1024

theorem oneSmallFourth_13_checked :
    oneSmallFourthGrowthBool oneSmallPairA_8 oneSmallPairB_8 oneSmallTripleS_13
      oneSmallTripleCutoff_13 oneSmallDisk_300_0_2 = true := by
  decide +kernel

theorem oneSmallFourth_13_growth (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_13)
    (ha : ∃ q, q*q = oneSmallPairA_8*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_8*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_13*z+1) :
    z.norm ≤ 4*oneSmallPairB_8.norm*oneSmallTripleS_13.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_8 oneSmallPairB_8 oneSmallTripleS_13
    (by decide) (by decide) oneSmallTripleCutoff_13 (by decide)
    oneSmallDisk_300_0_2 ?_ oneSmallFourth_13_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_14 : QuadInt 0 2 := ⟨6,6⟩
def oneSmallTripleCutoff_14 : ℤ := 4775

theorem oneSmallFourth_14_checked :
    oneSmallFourthGrowthBool oneSmallPairA_9 oneSmallPairB_9 oneSmallTripleS_14
      oneSmallTripleCutoff_14 oneSmallDisk_300_0_2 = true := by
  decide +kernel

theorem oneSmallFourth_14_growth (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_14)
    (ha : ∃ q, q*q = oneSmallPairA_9*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_9*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_14*z+1) :
    z.norm ≤ 4*oneSmallPairB_9.norm*oneSmallTripleS_14.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_9 oneSmallPairB_9 oneSmallTripleS_14
    (by decide) (by decide) oneSmallTripleCutoff_14 (by decide)
    oneSmallDisk_300_0_2 ?_ oneSmallFourth_14_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_15 : QuadInt 1 1 := ⟨-13,13⟩
def oneSmallTripleCutoff_15 : ℤ := 13059

theorem oneSmallFourth_15_checked :
    oneSmallFourthGrowthBool oneSmallPairA_10 oneSmallPairB_10 oneSmallTripleS_15
      oneSmallTripleCutoff_15 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_15_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_15)
    (ha : ∃ q, q*q = oneSmallPairA_10*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_10*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_15*z+1) :
    z.norm ≤ 4*oneSmallPairB_10.norm*oneSmallTripleS_15.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_10 oneSmallPairB_10 oneSmallTripleS_15
    (by decide) (by decide) oneSmallTripleCutoff_15 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_15_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
