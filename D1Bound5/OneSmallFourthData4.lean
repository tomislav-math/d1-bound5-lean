import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_24 : QuadInt 1 1 := ⟨6,9⟩
def oneSmallTripleCutoff_24 : ℤ := 7943

theorem oneSmallFourth_24_checked :
    oneSmallFourthGrowthBool oneSmallPairA_18 oneSmallPairB_18 oneSmallTripleS_24
      oneSmallTripleCutoff_24 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_24_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_24)
    (ha : ∃ q, q*q = oneSmallPairA_18*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_18*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_24*z+1) :
    z.norm ≤ 4*oneSmallPairB_18.norm*oneSmallTripleS_24.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_18 oneSmallPairB_18 oneSmallTripleS_24
    (by decide) (by decide) oneSmallTripleCutoff_24 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_24_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_25 : QuadInt 1 1 := ⟨11,1⟩
def oneSmallTripleCutoff_25 : ℤ := 6361

theorem oneSmallFourth_25_checked :
    oneSmallFourthGrowthBool oneSmallPairA_19 oneSmallPairB_19 oneSmallTripleS_25
      oneSmallTripleCutoff_25 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_25_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_25)
    (ha : ∃ q, q*q = oneSmallPairA_19*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_19*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_25*z+1) :
    z.norm ≤ 4*oneSmallPairB_19.norm*oneSmallTripleS_25.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_19 oneSmallPairB_19 oneSmallTripleS_25
    (by decide) (by decide) oneSmallTripleCutoff_25 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_25_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_26 : QuadInt 1 1 := ⟨-6,-3⟩
def oneSmallTripleCutoff_26 : ℤ := 14404

theorem oneSmallFourth_26_checked :
    oneSmallFourthGrowthBool oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_26
      oneSmallTripleCutoff_26 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_26_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_26)
    (ha : ∃ q, q*q = oneSmallPairA_20*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_20*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_26*z+1) :
    z.norm ≤ 4*oneSmallPairB_20.norm*oneSmallTripleS_26.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_26
    (by decide) (by decide) oneSmallTripleCutoff_26 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_26_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_27 : QuadInt 1 1 := ⟨-10,9⟩
def oneSmallTripleCutoff_27 : ℤ := 14608

theorem oneSmallFourth_27_checked :
    oneSmallFourthGrowthBool oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_27
      oneSmallTripleCutoff_27 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_27_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_27)
    (ha : ∃ q, q*q = oneSmallPairA_20*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_20*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_27*z+1) :
    z.norm ≤ 4*oneSmallPairB_20.norm*oneSmallTripleS_27.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_27
    (by decide) (by decide) oneSmallTripleCutoff_27 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_27_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_28 : QuadInt 1 1 := ⟨-4,8⟩
def oneSmallTripleCutoff_28 : ℤ := 2461

theorem oneSmallFourth_28_checked :
    oneSmallFourthGrowthBool oneSmallPairA_21 oneSmallPairB_21 oneSmallTripleS_28
      oneSmallTripleCutoff_28 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_28_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_28)
    (ha : ∃ q, q*q = oneSmallPairA_21*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_21*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_28*z+1) :
    z.norm ≤ 4*oneSmallPairB_21.norm*oneSmallTripleS_28.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_21 oneSmallPairB_21 oneSmallTripleS_28
    (by decide) (by decide) oneSmallTripleCutoff_28 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_28_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_29 : QuadInt 1 1 := ⟨-5,4⟩
def oneSmallTripleCutoff_29 : ℤ := 1622

theorem oneSmallFourth_29_checked :
    oneSmallFourthGrowthBool oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_29
      oneSmallTripleCutoff_29 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_29_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_29)
    (ha : ∃ q, q*q = oneSmallPairA_22*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_22*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_29*z+1) :
    z.norm ≤ 4*oneSmallPairB_22.norm*oneSmallTripleS_29.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_29
    (by decide) (by decide) oneSmallTripleCutoff_29 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_29_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_30 : QuadInt 1 1 := ⟨-1,-4⟩
def oneSmallTripleCutoff_30 : ℤ := 1622

theorem oneSmallFourth_30_checked :
    oneSmallFourthGrowthBool oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_30
      oneSmallTripleCutoff_30 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_30_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_30)
    (ha : ∃ q, q*q = oneSmallPairA_22*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_22*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_30*z+1) :
    z.norm ≤ 4*oneSmallPairB_22.norm*oneSmallTripleS_30.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_30
    (by decide) (by decide) oneSmallTripleCutoff_30 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_30_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_31 : QuadInt 1 1 := ⟨4,-8⟩
def oneSmallTripleCutoff_31 : ℤ := 21270

theorem oneSmallFourth_31_checked :
    oneSmallFourthGrowthBool oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_31
      oneSmallTripleCutoff_31 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_31_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_31)
    (ha : ∃ q, q*q = oneSmallPairA_23*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_23*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_31*z+1) :
    z.norm ≤ 4*oneSmallPairB_23.norm*oneSmallTripleS_31.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_31
    (by decide) (by decide) oneSmallTripleCutoff_31 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_31_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
