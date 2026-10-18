import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_32 : QuadInt 1 1 := ⟨-1,12⟩
def oneSmallTripleCutoff_32 : ℤ := 8968

theorem oneSmallFourth_32_checked :
    oneSmallFourthGrowthBool oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_32
      oneSmallTripleCutoff_32 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_32_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_32)
    (ha : ∃ q, q*q = oneSmallPairA_23*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_23*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_32*z+1) :
    z.norm ≤ 4*oneSmallPairB_23.norm*oneSmallTripleS_32.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_32
    (by decide) (by decide) oneSmallTripleCutoff_32 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_32_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_33 : QuadInt 1 1 := ⟨7,7⟩
def oneSmallTripleCutoff_33 : ℤ := 5928

theorem oneSmallFourth_33_checked :
    oneSmallFourthGrowthBool oneSmallPairA_24 oneSmallPairB_24 oneSmallTripleS_33
      oneSmallTripleCutoff_33 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_33_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_33)
    (ha : ∃ q, q*q = oneSmallPairA_24*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_24*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_33*z+1) :
    z.norm ≤ 4*oneSmallPairB_24.norm*oneSmallTripleS_33.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_24 oneSmallPairB_24 oneSmallTripleS_33
    (by decide) (by decide) oneSmallTripleCutoff_33 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_33_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_34 : QuadInt 0 5 := ⟨-5,-2⟩
def oneSmallTripleCutoff_34 : ℤ := 5913

theorem oneSmallFourth_34_checked :
    oneSmallFourthGrowthBool oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_34
      oneSmallTripleCutoff_34 oneSmallDisk_300_0_5 = true := by
  decide +kernel

theorem oneSmallFourth_34_growth (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_34)
    (ha : ∃ q, q*q = oneSmallPairA_25*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_25*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_34*z+1) :
    z.norm ≤ 4*oneSmallPairB_25.norm*oneSmallTripleS_34.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_34
    (by decide) (by decide) oneSmallTripleCutoff_34 (by decide)
    oneSmallDisk_300_0_5 ?_ oneSmallFourth_34_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_35 : QuadInt 0 5 := ⟨-5,2⟩
def oneSmallTripleCutoff_35 : ℤ := 5913

theorem oneSmallFourth_35_checked :
    oneSmallFourthGrowthBool oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_35
      oneSmallTripleCutoff_35 oneSmallDisk_300_0_5 = true := by
  decide +kernel

theorem oneSmallFourth_35_growth (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_35)
    (ha : ∃ q, q*q = oneSmallPairA_25*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_25*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_35*z+1) :
    z.norm ≤ 4*oneSmallPairB_25.norm*oneSmallTripleS_35.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_35
    (by decide) (by decide) oneSmallTripleCutoff_35 (by decide)
    oneSmallDisk_300_0_5 ?_ oneSmallFourth_35_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_36 : QuadInt 0 5 := ⟨-2,4⟩
def oneSmallTripleCutoff_36 : ℤ := 8435

theorem oneSmallFourth_36_checked :
    oneSmallFourthGrowthBool oneSmallPairA_26 oneSmallPairB_26 oneSmallTripleS_36
      oneSmallTripleCutoff_36 oneSmallDisk_300_0_5 = true := by
  decide +kernel

theorem oneSmallFourth_36_growth (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_36)
    (ha : ∃ q, q*q = oneSmallPairA_26*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_26*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_36*z+1) :
    z.norm ≤ 4*oneSmallPairB_26.norm*oneSmallTripleS_36.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_26 oneSmallPairB_26 oneSmallTripleS_36
    (by decide) (by decide) oneSmallTripleCutoff_36 (by decide)
    oneSmallDisk_300_0_5 ?_ oneSmallFourth_36_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_5_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_37 : QuadInt 0 6 := ⟨-6,-2⟩
def oneSmallTripleCutoff_37 : ℤ := 9706

theorem oneSmallFourth_37_checked :
    oneSmallFourthGrowthBool oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_37
      oneSmallTripleCutoff_37 oneSmallDisk_300_0_6 = true := by
  decide +kernel

theorem oneSmallFourth_37_growth (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_37)
    (ha : ∃ q, q*q = oneSmallPairA_27*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_27*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_37*z+1) :
    z.norm ≤ 4*oneSmallPairB_27.norm*oneSmallTripleS_37.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_37
    (by decide) (by decide) oneSmallTripleCutoff_37 (by decide)
    oneSmallDisk_300_0_6 ?_ oneSmallFourth_37_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_38 : QuadInt 0 6 := ⟨-6,2⟩
def oneSmallTripleCutoff_38 : ℤ := 9706

theorem oneSmallFourth_38_checked :
    oneSmallFourthGrowthBool oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_38
      oneSmallTripleCutoff_38 oneSmallDisk_300_0_6 = true := by
  decide +kernel

theorem oneSmallFourth_38_growth (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_38)
    (ha : ∃ q, q*q = oneSmallPairA_27*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_27*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_38*z+1) :
    z.norm ≤ 4*oneSmallPairB_27.norm*oneSmallTripleS_38.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_38
    (by decide) (by decide) oneSmallTripleCutoff_38 (by decide)
    oneSmallDisk_300_0_6 ?_ oneSmallFourth_38_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_6_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_39 : QuadInt 0 6 := ⟨-3,4⟩
def oneSmallTripleCutoff_39 : ℤ := 13453

theorem oneSmallFourth_39_checked :
    oneSmallFourthGrowthBool oneSmallPairA_28 oneSmallPairB_28 oneSmallTripleS_39
      oneSmallTripleCutoff_39 oneSmallDisk_300_0_6 = true := by
  decide +kernel

theorem oneSmallFourth_39_growth (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_39)
    (ha : ∃ q, q*q = oneSmallPairA_28*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_28*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_39*z+1) :
    z.norm ≤ 4*oneSmallPairB_28.norm*oneSmallTripleS_39.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_28 oneSmallPairB_28 oneSmallTripleS_39
    (by decide) (by decide) oneSmallTripleCutoff_39 (by decide)
    oneSmallDisk_300_0_6 ?_ oneSmallFourth_39_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_0_6_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
