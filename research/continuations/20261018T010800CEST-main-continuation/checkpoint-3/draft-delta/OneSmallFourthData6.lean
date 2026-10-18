import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_40 : QuadInt 1 2 := ⟨1,5⟩
def oneSmallTripleCutoff_40 : ℤ := 1517

theorem oneSmallFourth_40_checked :
    oneSmallFourthGrowthBool oneSmallPairA_29 oneSmallPairB_29 oneSmallTripleS_40
      oneSmallTripleCutoff_40 oneSmallDisk_300_1_2 = true := by
  decide +kernel

theorem oneSmallFourth_40_growth (z : QuadInt 1 2)
    (hz : z.norm < oneSmallTripleCutoff_40)
    (ha : ∃ q, q*q = oneSmallPairA_29*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_29*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_40*z+1) :
    z.norm ≤ 4*oneSmallPairB_29.norm*oneSmallTripleS_40.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_29 oneSmallPairB_29 oneSmallTripleS_40
    (by decide) (by decide) oneSmallTripleCutoff_40 (by decide)
    oneSmallDisk_300_1_2 ?_ oneSmallFourth_40_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_41 : QuadInt 1 2 := ⟨6,7⟩
def oneSmallTripleCutoff_41 : ℤ := 11143

theorem oneSmallFourth_41_checked :
    oneSmallFourthGrowthBool oneSmallPairA_30 oneSmallPairB_30 oneSmallTripleS_41
      oneSmallTripleCutoff_41 oneSmallDisk_300_1_2 = true := by
  decide +kernel

theorem oneSmallFourth_41_growth (z : QuadInt 1 2)
    (hz : z.norm < oneSmallTripleCutoff_41)
    (ha : ∃ q, q*q = oneSmallPairA_30*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_30*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_41*z+1) :
    z.norm ≤ 4*oneSmallPairB_30.norm*oneSmallTripleS_41.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_30 oneSmallPairB_30 oneSmallTripleS_41
    (by decide) (by decide) oneSmallTripleCutoff_41 (by decide)
    oneSmallDisk_300_1_2 ?_ oneSmallFourth_41_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_2_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_42 : QuadInt 1 3 := ⟨-3,-1⟩
def oneSmallTripleCutoff_42 : ℤ := 1451

theorem oneSmallFourth_42_checked :
    oneSmallFourthGrowthBool oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_42
      oneSmallTripleCutoff_42 oneSmallDisk_300_1_3 = true := by
  decide +kernel

theorem oneSmallFourth_42_growth (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_42)
    (ha : ∃ q, q*q = oneSmallPairA_31*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_31*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_42*z+1) :
    z.norm ≤ 4*oneSmallPairB_31.norm*oneSmallTripleS_42.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_42
    (by decide) (by decide) oneSmallTripleCutoff_42 (by decide)
    oneSmallDisk_300_1_3 ?_ oneSmallFourth_42_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_3_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_43 : QuadInt 1 3 := ⟨-3,3⟩
def oneSmallTripleCutoff_43 : ℤ := 1460

theorem oneSmallFourth_43_checked :
    oneSmallFourthGrowthBool oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_43
      oneSmallTripleCutoff_43 oneSmallDisk_300_1_3 = true := by
  decide +kernel

theorem oneSmallFourth_43_growth (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_43)
    (ha : ∃ q, q*q = oneSmallPairA_31*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_31*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_43*z+1) :
    z.norm ≤ 4*oneSmallPairB_31.norm*oneSmallTripleS_43.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_43
    (by decide) (by decide) oneSmallTripleCutoff_43 (by decide)
    oneSmallDisk_300_1_3 ?_ oneSmallFourth_43_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_3_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_44 : QuadInt 1 3 := ⟨0,5⟩
def oneSmallTripleCutoff_44 : ℤ := 3590

theorem oneSmallFourth_44_checked :
    oneSmallFourthGrowthBool oneSmallPairA_32 oneSmallPairB_32 oneSmallTripleS_44
      oneSmallTripleCutoff_44 oneSmallDisk_300_1_3 = true := by
  decide +kernel

theorem oneSmallFourth_44_growth (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_44)
    (ha : ∃ q, q*q = oneSmallPairA_32*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_32*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_44*z+1) :
    z.norm ≤ 4*oneSmallPairB_32.norm*oneSmallTripleS_44.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_32 oneSmallPairB_32 oneSmallTripleS_44
    (by decide) (by decide) oneSmallTripleCutoff_44 (by decide)
    oneSmallDisk_300_1_3 ?_ oneSmallFourth_44_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_3_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_45 : QuadInt 1 4 := ⟨-4,-1⟩
def oneSmallTripleCutoff_45 : ℤ := 3059

theorem oneSmallFourth_45_checked :
    oneSmallFourthGrowthBool oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_45
      oneSmallTripleCutoff_45 oneSmallDisk_300_1_4 = true := by
  decide +kernel

theorem oneSmallFourth_45_growth (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_45)
    (ha : ∃ q, q*q = oneSmallPairA_33*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_33*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_45*z+1) :
    z.norm ≤ 4*oneSmallPairB_33.norm*oneSmallTripleS_45.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_45
    (by decide) (by decide) oneSmallTripleCutoff_45 (by decide)
    oneSmallDisk_300_1_4 ?_ oneSmallFourth_45_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_4_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_46 : QuadInt 1 4 := ⟨-4,3⟩
def oneSmallTripleCutoff_46 : ℤ := 3090

theorem oneSmallFourth_46_checked :
    oneSmallFourthGrowthBool oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_46
      oneSmallTripleCutoff_46 oneSmallDisk_300_1_4 = true := by
  decide +kernel

theorem oneSmallFourth_46_growth (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_46)
    (ha : ∃ q, q*q = oneSmallPairA_33*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_33*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_46*z+1) :
    z.norm ≤ 4*oneSmallPairB_33.norm*oneSmallTripleS_46.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_46
    (by decide) (by decide) oneSmallTripleCutoff_46 (by decide)
    oneSmallDisk_300_1_4 ?_ oneSmallFourth_46_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_4_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_47 : QuadInt 1 4 := ⟨-1,5⟩
def oneSmallTripleCutoff_47 : ℤ := 6843

theorem oneSmallFourth_47_checked :
    oneSmallFourthGrowthBool oneSmallPairA_34 oneSmallPairB_34 oneSmallTripleS_47
      oneSmallTripleCutoff_47 oneSmallDisk_300_1_4 = true := by
  decide +kernel

theorem oneSmallFourth_47_growth (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_47)
    (ha : ∃ q, q*q = oneSmallPairA_34*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_34*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_47*z+1) :
    z.norm ≤ 4*oneSmallPairB_34.norm*oneSmallTripleS_47.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_34 oneSmallPairB_34 oneSmallTripleS_47
    (by decide) (by decide) oneSmallTripleCutoff_47 (by decide)
    oneSmallDisk_300_1_4 ?_ oneSmallFourth_47_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_4_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
