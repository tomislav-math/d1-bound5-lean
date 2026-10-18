import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_48 : QuadInt 1 5 := ⟨-5,-1⟩
def oneSmallTripleCutoff_48 : ℤ := 5592

theorem oneSmallFourth_48_checked :
    oneSmallFourthGrowthBool oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_48
      oneSmallTripleCutoff_48 oneSmallDisk_300_1_5 = true := by
  decide +kernel

theorem oneSmallFourth_48_growth (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_48)
    (ha : ∃ q, q*q = oneSmallPairA_35*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_35*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_48*z+1) :
    z.norm ≤ 4*oneSmallPairB_35.norm*oneSmallTripleS_48.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_48
    (by decide) (by decide) oneSmallTripleCutoff_48 (by decide)
    oneSmallDisk_300_1_5 ?_ oneSmallFourth_48_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_49 : QuadInt 1 5 := ⟨-5,3⟩
def oneSmallTripleCutoff_49 : ℤ := 5661

theorem oneSmallFourth_49_checked :
    oneSmallFourthGrowthBool oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_49
      oneSmallTripleCutoff_49 oneSmallDisk_300_1_5 = true := by
  decide +kernel

theorem oneSmallFourth_49_growth (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_49)
    (ha : ∃ q, q*q = oneSmallPairA_35*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_35*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_49*z+1) :
    z.norm ≤ 4*oneSmallPairB_35.norm*oneSmallTripleS_49.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_49
    (by decide) (by decide) oneSmallTripleCutoff_49 (by decide)
    oneSmallDisk_300_1_5 ?_ oneSmallFourth_49_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_50 : QuadInt 1 5 := ⟨-2,5⟩
def oneSmallTripleCutoff_50 : ℤ := 11532

theorem oneSmallFourth_50_checked :
    oneSmallFourthGrowthBool oneSmallPairA_36 oneSmallPairB_36 oneSmallTripleS_50
      oneSmallTripleCutoff_50 oneSmallDisk_300_1_5 = true := by
  decide +kernel

theorem oneSmallFourth_50_growth (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_50)
    (ha : ∃ q, q*q = oneSmallPairA_36*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_36*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_50*z+1) :
    z.norm ≤ 4*oneSmallPairB_36.norm*oneSmallTripleS_50.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_36 oneSmallPairB_36 oneSmallTripleS_50
    (by decide) (by decide) oneSmallTripleCutoff_50 (by decide)
    oneSmallDisk_300_1_5 ?_ oneSmallFourth_50_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_51 : QuadInt 1 6 := ⟨-6,-1⟩
def oneSmallTripleCutoff_51 : ℤ := 9289

theorem oneSmallFourth_51_checked :
    oneSmallFourthGrowthBool oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_51
      oneSmallTripleCutoff_51 oneSmallDisk_300_1_6 = true := by
  decide +kernel

theorem oneSmallFourth_51_growth (z : QuadInt 1 6)
    (hz : z.norm < oneSmallTripleCutoff_51)
    (ha : ∃ q, q*q = oneSmallPairA_37*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_37*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_51*z+1) :
    z.norm ≤ 4*oneSmallPairB_37.norm*oneSmallTripleS_51.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_51
    (by decide) (by decide) oneSmallTripleCutoff_51 (by decide)
    oneSmallDisk_300_1_6 ?_ oneSmallFourth_51_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_52 : QuadInt 1 6 := ⟨-6,3⟩
def oneSmallTripleCutoff_52 : ℤ := 9415

theorem oneSmallFourth_52_checked :
    oneSmallFourthGrowthBool oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_52
      oneSmallTripleCutoff_52 oneSmallDisk_300_1_6 = true := by
  decide +kernel

theorem oneSmallFourth_52_growth (z : QuadInt 1 6)
    (hz : z.norm < oneSmallTripleCutoff_52)
    (ha : ∃ q, q*q = oneSmallPairA_37*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_37*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_52*z+1) :
    z.norm ≤ 4*oneSmallPairB_37.norm*oneSmallTripleS_52.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_52
    (by decide) (by decide) oneSmallTripleCutoff_52 (by decide)
    oneSmallDisk_300_1_6 ?_ oneSmallFourth_52_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_53 : QuadInt 0 1 := ⟨-4,0⟩
def oneSmallTripleCutoff_53 : ℤ := 1281

theorem oneSmallFourth_53_checked :
    oneSmallFourthGrowthBool oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_53
      oneSmallTripleCutoff_53 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_53_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_53)
    (ha : ∃ q, q*q = oneSmallPairA_38*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_38*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_53*z+1) :
    z.norm ≤ 4*oneSmallPairB_38.norm*oneSmallTripleS_53.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_53
    (by decide) (by decide) oneSmallTripleCutoff_53 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_53_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_54 : QuadInt 0 1 := ⟨4,-4⟩
def oneSmallTripleCutoff_54 : ℤ := 2561

theorem oneSmallFourth_54_checked :
    oneSmallFourthGrowthBool oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_54
      oneSmallTripleCutoff_54 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_54_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_54)
    (ha : ∃ q, q*q = oneSmallPairA_38*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_38*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_54*z+1) :
    z.norm ≤ 4*oneSmallPairB_38.norm*oneSmallTripleS_54.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_54
    (by decide) (by decide) oneSmallTripleCutoff_54 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_54_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_55 : QuadInt 0 1 := ⟨8,4⟩
def oneSmallTripleCutoff_55 : ℤ := 6401

theorem oneSmallFourth_55_checked :
    oneSmallFourthGrowthBool oneSmallPairA_39 oneSmallPairB_39 oneSmallTripleS_55
      oneSmallTripleCutoff_55 oneSmallDisk_300_0_1 = true := by
  decide +kernel

theorem oneSmallFourth_55_growth (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_55)
    (ha : ∃ q, q*q = oneSmallPairA_39*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_39*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_55*z+1) :
    z.norm ≤ 4*oneSmallPairB_39.norm*oneSmallTripleS_55.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_39 oneSmallPairB_39 oneSmallTripleS_55
    (by decide) (by decide) oneSmallTripleCutoff_55 (by decide)
    oneSmallDisk_300_0_1 ?_ oneSmallFourth_55_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
