import D1Bound5.OneSmallThirdData

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def oneSmallTripleS_16 : QuadInt 1 1 := ⟨-8,16⟩
def oneSmallTripleCutoff_16 : ℤ := 12244

theorem oneSmallFourth_16_checked :
    oneSmallFourthGrowthBool oneSmallPairA_11 oneSmallPairB_11 oneSmallTripleS_16
      oneSmallTripleCutoff_16 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_16_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_16)
    (ha : ∃ q, q*q = oneSmallPairA_11*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_11*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_16*z+1) :
    z.norm ≤ 4*oneSmallPairB_11.norm*oneSmallTripleS_16.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_11 oneSmallPairB_11 oneSmallTripleS_16
    (by decide) (by decide) oneSmallTripleCutoff_16 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_16_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_17 : QuadInt 1 1 := ⟨-9,6⟩
def oneSmallTripleCutoff_17 : ℤ := 2301

theorem oneSmallFourth_17_checked :
    oneSmallFourthGrowthBool oneSmallPairA_12 oneSmallPairB_12 oneSmallTripleS_17
      oneSmallTripleCutoff_17 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_17_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_17)
    (ha : ∃ q, q*q = oneSmallPairA_12*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_12*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_17*z+1) :
    z.norm ≤ 4*oneSmallPairB_12.norm*oneSmallTripleS_17.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_12 oneSmallPairB_12 oneSmallTripleS_17
    (by decide) (by decide) oneSmallTripleCutoff_17 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_17_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_18 : QuadInt 1 1 := ⟨-10,1⟩
def oneSmallTripleCutoff_18 : ℤ := 9744

theorem oneSmallFourth_18_checked :
    oneSmallFourthGrowthBool oneSmallPairA_13 oneSmallPairB_13 oneSmallTripleS_18
      oneSmallTripleCutoff_18 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_18_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_18)
    (ha : ∃ q, q*q = oneSmallPairA_13*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_13*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_18*z+1) :
    z.norm ≤ 4*oneSmallPairB_13.norm*oneSmallTripleS_18.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_13 oneSmallPairB_13 oneSmallTripleS_18
    (by decide) (by decide) oneSmallTripleCutoff_18 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_18_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_19 : QuadInt 1 1 := ⟨-6,9⟩
def oneSmallTripleCutoff_19 : ℤ := 1195

theorem oneSmallFourth_19_checked :
    oneSmallFourthGrowthBool oneSmallPairA_14 oneSmallPairB_14 oneSmallTripleS_19
      oneSmallTripleCutoff_19 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_19_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_19)
    (ha : ∃ q, q*q = oneSmallPairA_14*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_14*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_19*z+1) :
    z.norm ≤ 4*oneSmallPairB_14.norm*oneSmallTripleS_19.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_14 oneSmallPairB_14 oneSmallTripleS_19
    (by decide) (by decide) oneSmallTripleCutoff_19 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_19_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_20 : QuadInt 1 1 := ⟨-1,10⟩
def oneSmallTripleCutoff_20 : ℤ := 1760

theorem oneSmallFourth_20_checked :
    oneSmallFourthGrowthBool oneSmallPairA_15 oneSmallPairB_15 oneSmallTripleS_20
      oneSmallTripleCutoff_20 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_20_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_20)
    (ha : ∃ q, q*q = oneSmallPairA_15*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_15*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_20*z+1) :
    z.norm ≤ 4*oneSmallPairB_15.norm*oneSmallTripleS_20.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_15 oneSmallPairB_15 oneSmallTripleS_20
    (by decide) (by decide) oneSmallTripleCutoff_20 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_20_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_21 : QuadInt 1 1 := ⟨-4,-4⟩
def oneSmallTripleCutoff_21 : ℤ := 7354

theorem oneSmallFourth_21_checked :
    oneSmallFourthGrowthBool oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_21
      oneSmallTripleCutoff_21 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_21_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_21)
    (ha : ∃ q, q*q = oneSmallPairA_16*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_16*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_21*z+1) :
    z.norm ≤ 4*oneSmallPairB_16.norm*oneSmallTripleS_21.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_21
    (by decide) (by decide) oneSmallTripleCutoff_21 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_21_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_22 : QuadInt 1 1 := ⟨8,-8⟩
def oneSmallTripleCutoff_22 : ℤ := 7441

theorem oneSmallFourth_22_checked :
    oneSmallFourthGrowthBool oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_22
      oneSmallTripleCutoff_22 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_22_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_22)
    (ha : ∃ q, q*q = oneSmallPairA_16*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_16*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_22*z+1) :
    z.norm ≤ 4*oneSmallPairB_16.norm*oneSmallTripleS_22.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_22
    (by decide) (by decide) oneSmallTripleCutoff_22 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_22_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

def oneSmallTripleS_23 : QuadInt 1 1 := ⟨7,-2⟩
def oneSmallTripleCutoff_23 : ℤ := 1024

theorem oneSmallFourth_23_checked :
    oneSmallFourthGrowthBool oneSmallPairA_17 oneSmallPairB_17 oneSmallTripleS_23
      oneSmallTripleCutoff_23 oneSmallDisk_300_1_1 = true := by
  decide +kernel

theorem oneSmallFourth_23_growth (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_23)
    (ha : ∃ q, q*q = oneSmallPairA_17*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_17*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_23*z+1) :
    z.norm ≤ 4*oneSmallPairB_17.norm*oneSmallTripleS_23.norm := by
  apply oneSmallFourthGrowth_of_checked (by decide)
    oneSmallPairA_17 oneSmallPairB_17 oneSmallTripleS_23
    (by decide) (by decide) oneSmallTripleCutoff_23 (by decide)
    oneSmallDisk_300_1_1 ?_ oneSmallFourth_23_checked z hz ha hb hs
  intro q hq; rw [oneSmallDisk_300_1_1_eq, List.mem_toFinset] at hq; exact hq

end D1Bound5
