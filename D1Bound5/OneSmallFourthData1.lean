import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_0 : QuadInt 0 1 := ⟨-4,-2⟩
def oneSmallTripleCutoff_0 : ℤ := 1024

theorem oneSmallFourth_0_checked :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_0
      oneSmallTripleCutoff_0 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_0_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_0)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_0*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_0.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_0
    (by decide) (by decide) oneSmallTripleCutoff_0 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_0_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_1 : QuadInt 0 1 := ⟨4,-2⟩
def oneSmallTripleCutoff_1 : ℤ := 1024

theorem oneSmallFourth_1_checked :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_1
      oneSmallTripleCutoff_1 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_1_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_1)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_1*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_1.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_1
    (by decide) (by decide) oneSmallTripleCutoff_1 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_1_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_2 : QuadInt 0 1 := ⟨0,5⟩
def oneSmallTripleCutoff_2 : ℤ := 1934

theorem oneSmallFourth_2_checked :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_2
      oneSmallTripleCutoff_2 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_2_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_2)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_2*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_2.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_2
    (by decide) (by decide) oneSmallTripleCutoff_2 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_2_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_3 : QuadInt 0 1 := ⟨0,10⟩
def oneSmallTripleCutoff_3 : ℤ := 2311

theorem oneSmallFourth_3_checked :
    oneSmallFourthGrowthBool oneSmallPairA_1 oneSmallPairB_1 oneSmallTripleS_3
      oneSmallTripleCutoff_3 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_3_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_3)
    (ha : ∃ q, q*q = oneSmallPairA_1*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_1*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_3*z+1) :
    z.norm ≤ 4*oneSmallPairB_1.norm*oneSmallTripleS_3.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_1 oneSmallPairB_1 oneSmallTripleS_3
    (by decide) (by decide) oneSmallTripleCutoff_3 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_3_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_4 : QuadInt 0 1 := ⟨-4,4⟩
def oneSmallTripleCutoff_4 : ℤ := 4770

theorem oneSmallFourth_4_checked :
    oneSmallFourthGrowthBool oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_4
      oneSmallTripleCutoff_4 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_4_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_4)
    (ha : ∃ q, q*q = oneSmallPairA_2*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_2*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_4*z+1) :
    z.norm ≤ 4*oneSmallPairB_2.norm*oneSmallTripleS_4.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_4
    (by decide) (by decide) oneSmallTripleCutoff_4 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_4_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_5 : QuadInt 0 1 := ⟨8,1⟩
def oneSmallTripleCutoff_5 : ℤ := 2359

theorem oneSmallFourth_5_checked :
    oneSmallFourthGrowthBool oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_5
      oneSmallTripleCutoff_5 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_5_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_5)
    (ha : ∃ q, q*q = oneSmallPairA_2*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_2*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_5*z+1) :
    z.norm ≤ 4*oneSmallPairB_2.norm*oneSmallTripleS_5.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_5
    (by decide) (by decide) oneSmallTripleCutoff_5 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_5_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_6 : QuadInt 0 1 := ⟨6,9⟩
def oneSmallTripleCutoff_6 : ℤ := 3896

theorem oneSmallFourth_6_checked :
    oneSmallFourthGrowthBool oneSmallPairA_3 oneSmallPairB_3 oneSmallTripleS_6
      oneSmallTripleCutoff_6 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_6_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_6)
    (ha : ∃ q, q*q = oneSmallPairA_3*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_3*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_6*z+1) :
    z.norm ≤ 4*oneSmallPairB_3.norm*oneSmallTripleS_6.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_3 oneSmallPairB_3 oneSmallTripleS_6
    (by decide) (by decide) oneSmallTripleCutoff_6 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_6_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_7 : QuadInt 0 1 := ⟨-4,-4⟩
def oneSmallTripleCutoff_7 : ℤ := 3299

theorem oneSmallFourth_7_checked :
    oneSmallFourthGrowthBool oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_7
      oneSmallTripleCutoff_7 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_7_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_7)
    (ha : ∃ q, q*q = oneSmallPairA_4*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_4*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_7*z+1) :
    z.norm ≤ 4*oneSmallPairB_4.norm*oneSmallTripleS_7.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_7
    (by decide) (by decide) oneSmallTripleCutoff_7 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_7_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
