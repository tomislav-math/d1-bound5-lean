import D1Bound5.OneSmallFourthData1
import D1Bound5.OneSmallFourthData2
import D1Bound5.OneSmallFourthData3
import D1Bound5.OneSmallFourthData4
import D1Bound5.OneSmallFourthData5
import D1Bound5.OneSmallFourthData6
import D1Bound5.OneSmallFourthData7

namespace D1Bound5
open QuadInt

/-- The complete fixed-triple certificate record from the manuscript. -/
structure OneSmallTripleRow where
  tau : ℤ
  nu : ℤ
  a : ℤ × ℤ
  b : ℤ × ℤ
  s : ℤ × ℤ
  cutoff : ℤ
  deriving DecidableEq, Repr

def oneSmallFixedRows : Finset OneSmallTripleRow :=
  {⟨0,1,(0,1),(0,-3),(-4,-2),1024⟩,
   ⟨0,1,(0,1),(0,-3),(4,-2),1024⟩,
   ⟨0,1,(0,1),(0,-3),(0,5),1934⟩,
   ⟨0,1,(0,1),(0,5),(0,10),2311⟩,
   ⟨0,1,(0,1),(4,-2),(-4,4),4770⟩,
   ⟨0,1,(0,1),(4,-2),(8,1),2359⟩,
   ⟨0,1,(0,1),(4,4),(6,9),3896⟩,
   ⟨0,1,(1,0),(-5,0),(-4,-4),3299⟩,
   ⟨0,1,(1,0),(-5,0),(-4,4),3299⟩,
   ⟨0,1,(1,0),(-4,4),(-1,8),4857⟩,
   ⟨0,1,(1,0),(2,4),(7,6),2018⟩,
   ⟨0,2,(1,0),(-3,0),(-2,-2),1024⟩,
   ⟨0,2,(1,0),(-3,0),(-2,2),1024⟩,
   ⟨0,2,(1,0),(-2,2),(1,4),1024⟩,
   ⟨0,2,(1,0),(1,4),(6,6),4775⟩,
   ⟨1,1,(0,1),(-9,6),(-13,13),13059⟩,
   ⟨1,1,(0,1),(-6,9),(-8,16),12244⟩,
   ⟨1,1,(0,1),(-5,1),(-9,6),2301⟩,
   ⟨1,1,(0,1),(-4,-4),(-10,1),9744⟩,
   ⟨1,1,(0,1),(-4,4),(-6,9),1195⟩,
   ⟨1,1,(0,1),(-1,5),(-1,10),1760⟩,
   ⟨1,1,(0,1),(2,-7),(-4,-4),7354⟩,
   ⟨1,1,(0,1),(2,-7),(8,-8),7441⟩,
   ⟨1,1,(0,1),(3,-3),(7,-2),1024⟩,
   ⟨1,1,(0,1),(4,4),(6,9),7943⟩,
   ⟨1,1,(0,1),(7,-2),(11,1),6361⟩,
   ⟨1,1,(1,0),(-9,3),(-6,-3),14404⟩,
   ⟨1,1,(1,0),(-9,3),(-10,9),14608⟩,
   ⟨1,1,(1,0),(-5,4),(-4,8),2461⟩,
   ⟨1,1,(1,0),(-4,0),(-5,4),1622⟩,
   ⟨1,1,(1,0),(-4,0),(-1,-4),1622⟩,
   ⟨1,1,(1,0),(-4,8),(4,-8),21270⟩,
   ⟨1,1,(1,0),(-4,8),(-1,12),8968⟩,
   ⟨1,1,(1,0),(2,5),(7,7),5928⟩,
   ⟨0,5,(1,0),(-6,0),(-5,-2),5913⟩,
   ⟨0,5,(1,0),(-6,0),(-5,2),5913⟩,
   ⟨0,5,(1,0),(-5,2),(-2,4),8435⟩,
   ⟨0,6,(1,0),(-7,0),(-6,-2),9706⟩,
   ⟨0,6,(1,0),(-7,0),(-6,2),9706⟩,
   ⟨0,6,(1,0),(-6,2),(-3,4),13453⟩,
   ⟨1,2,(1,0),(-2,3),(1,5),1517⟩,
   ⟨1,2,(1,0),(1,5),(6,7),11143⟩,
   ⟨1,3,(1,0),(-4,1),(-3,-1),1451⟩,
   ⟨1,3,(1,0),(-4,1),(-3,3),1460⟩,
   ⟨1,3,(1,0),(-3,3),(0,5),3590⟩,
   ⟨1,4,(1,0),(-5,1),(-4,-1),3059⟩,
   ⟨1,4,(1,0),(-5,1),(-4,3),3090⟩,
   ⟨1,4,(1,0),(-4,3),(-1,5),6843⟩,
   ⟨1,5,(1,0),(-6,1),(-5,-1),5592⟩,
   ⟨1,5,(1,0),(-6,1),(-5,3),5661⟩,
   ⟨1,5,(1,0),(-5,3),(-2,5),11532⟩,
   ⟨1,6,(1,0),(-7,1),(-6,-1),9289⟩,
   ⟨1,6,(1,0),(-7,1),(-6,3),9415⟩,
   ⟨0,1,(1,1),(-1,-3),(-4,0),1281⟩,
   ⟨0,1,(1,1),(-1,-3),(4,-4),2561⟩,
   ⟨0,1,(1,1),(3,1),(8,4),6401⟩}

def OneSmallTripleRow.anchorA (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.a.1,r.a.2⟩
def OneSmallTripleRow.anchorB (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.b.1,r.b.2⟩
def OneSmallTripleRow.anchorS (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.s.1,r.s.2⟩

/-- All 56 bounded complements are checked with exact integral roots.
Zero and anchor coincidences are allowed throughout this theorem. -/
theorem oneSmallFixedRows_bounded_growth (r : OneSmallTripleRow)
    (hr : r ∈ oneSmallFixedRows) (z : QuadInt r.tau r.nu) (hz : z.norm < r.cutoff)
    (ha : ∃ q, q*q = r.anchorA*z+1) (hb : ∃ q, q*q = r.anchorB*z+1)
    (hs : ∃ q, q*q = r.anchorS*z+1) : z.norm ≤ 4*r.anchorB.norm*r.anchorS.norm := by
  simp only [oneSmallFixedRows, Finset.mem_insert, Finset.mem_singleton] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact oneSmallFourth_0_growth z hz ha hb hs
  · exact oneSmallFourth_1_growth z hz ha hb hs
  · exact oneSmallFourth_2_growth z hz ha hb hs
  · exact oneSmallFourth_3_growth z hz ha hb hs
  · exact oneSmallFourth_4_growth z hz ha hb hs
  · exact oneSmallFourth_5_growth z hz ha hb hs
  · exact oneSmallFourth_6_growth z hz ha hb hs
  · exact oneSmallFourth_7_growth z hz ha hb hs
  · exact oneSmallFourth_8_growth z hz ha hb hs
  · exact oneSmallFourth_9_growth z hz ha hb hs
  · exact oneSmallFourth_10_growth z hz ha hb hs
  · exact oneSmallFourth_11_growth z hz ha hb hs
  · exact oneSmallFourth_12_growth z hz ha hb hs
  · exact oneSmallFourth_13_growth z hz ha hb hs
  · exact oneSmallFourth_14_growth z hz ha hb hs
  · exact oneSmallFourth_15_growth z hz ha hb hs
  · exact oneSmallFourth_16_growth z hz ha hb hs
  · exact oneSmallFourth_17_growth z hz ha hb hs
  · exact oneSmallFourth_18_growth z hz ha hb hs
  · exact oneSmallFourth_19_growth z hz ha hb hs
  · exact oneSmallFourth_20_growth z hz ha hb hs
  · exact oneSmallFourth_21_growth z hz ha hb hs
  · exact oneSmallFourth_22_growth z hz ha hb hs
  · exact oneSmallFourth_23_growth z hz ha hb hs
  · exact oneSmallFourth_24_growth z hz ha hb hs
  · exact oneSmallFourth_25_growth z hz ha hb hs
  · exact oneSmallFourth_26_growth z hz ha hb hs
  · exact oneSmallFourth_27_growth z hz ha hb hs
  · exact oneSmallFourth_28_growth z hz ha hb hs
  · exact oneSmallFourth_29_growth z hz ha hb hs
  · exact oneSmallFourth_30_growth z hz ha hb hs
  · exact oneSmallFourth_31_growth z hz ha hb hs
  · exact oneSmallFourth_32_growth z hz ha hb hs
  · exact oneSmallFourth_33_growth z hz ha hb hs
  · exact oneSmallFourth_34_growth z hz ha hb hs
  · exact oneSmallFourth_35_growth z hz ha hb hs
  · exact oneSmallFourth_36_growth z hz ha hb hs
  · exact oneSmallFourth_37_growth z hz ha hb hs
  · exact oneSmallFourth_38_growth z hz ha hb hs
  · exact oneSmallFourth_39_growth z hz ha hb hs
  · exact oneSmallFourth_40_growth z hz ha hb hs
  · exact oneSmallFourth_41_growth z hz ha hb hs
  · exact oneSmallFourth_42_growth z hz ha hb hs
  · exact oneSmallFourth_43_growth z hz ha hb hs
  · exact oneSmallFourth_44_growth z hz ha hb hs
  · exact oneSmallFourth_45_growth z hz ha hb hs
  · exact oneSmallFourth_46_growth z hz ha hb hs
  · exact oneSmallFourth_47_growth z hz ha hb hs
  · exact oneSmallFourth_48_growth z hz ha hb hs
  · exact oneSmallFourth_49_growth z hz ha hb hs
  · exact oneSmallFourth_50_growth z hz ha hb hs
  · exact oneSmallFourth_51_growth z hz ha hb hs
  · exact oneSmallFourth_52_growth z hz ha hb hs
  · exact oneSmallFourth_53_growth z hz ha hb hs
  · exact oneSmallFourth_54_growth z hz ha hb hs
  · exact oneSmallFourth_55_growth z hz ha hb hs

/-- The ordered finite row relation keeps the cutoff attached to its exact triple. -/
def OneSmallRowMembership {tau nu : ℤ} (a b s : QuadInt tau nu) (cutoff : ℤ) : Prop :=
  (⟨tau,nu,(a.re,a.im),(b.re,b.im),(s.re,s.im),cutoff⟩ : OneSmallTripleRow) ∈ oneSmallFixedRows

def OneSmallThirdRowProperty {tau nu : ℤ} (a b : QuadInt tau nu) : Prop :=
  ∀ s : QuadInt tau nu, s.norm ≤ 224 → b.norm ≤ s.norm → s ≠ a → s ≠ b →
    PairExtension a b s →
    (a = 1 ∧ b = -3 ∧ s = 3) ∨ ∃ cutoff, OneSmallRowMembership a b s cutoff

theorem oneSmallThirdRows_0_complete :
    OneSmallThirdRowProperty oneSmallPairA_0 oneSmallPairB_0 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_0_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_0, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl | rfl
  · exact Or.inr ⟨1024, by decide +kernel⟩
  · exact Or.inr ⟨1934, by decide +kernel⟩
  · exact Or.inr ⟨1024, by decide +kernel⟩

theorem oneSmallThirdRows_1_complete :
    OneSmallThirdRowProperty oneSmallPairA_1 oneSmallPairB_1 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_1_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_1, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨2311, by decide +kernel⟩

theorem oneSmallThirdRows_2_complete :
    OneSmallThirdRowProperty oneSmallPairA_2 oneSmallPairB_2 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_2_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_2, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨4770, by decide +kernel⟩
  · exact Or.inr ⟨2359, by decide +kernel⟩

theorem oneSmallThirdRows_3_complete :
    OneSmallThirdRowProperty oneSmallPairA_3 oneSmallPairB_3 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_3_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_3, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨3896, by decide +kernel⟩

theorem oneSmallThirdRows_4_complete :
    OneSmallThirdRowProperty oneSmallPairA_4 oneSmallPairB_4 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_4_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_4, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨3299, by decide +kernel⟩
  · exact Or.inr ⟨3299, by decide +kernel⟩

theorem oneSmallThirdRows_5_complete :
    OneSmallThirdRowProperty oneSmallPairA_5 oneSmallPairB_5 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_5_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_5, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨4857, by decide +kernel⟩

theorem oneSmallThirdRows_6_complete :
    OneSmallThirdRowProperty oneSmallPairA_6 oneSmallPairB_6 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_6_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_6, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨2018, by decide +kernel⟩

theorem oneSmallThirdRows_7_complete :
    OneSmallThirdRowProperty oneSmallPairA_7 oneSmallPairB_7 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_7_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_7, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl | rfl
  · exact Or.inr ⟨1024, by decide +kernel⟩
  · exact Or.inr ⟨1024, by decide +kernel⟩
  · left
    norm_num [oneSmallPairA_7,oneSmallPairB_7]

theorem oneSmallThirdRows_8_complete :
    OneSmallThirdRowProperty oneSmallPairA_8 oneSmallPairB_8 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_8_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_8, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨1024, by decide +kernel⟩

theorem oneSmallThirdRows_9_complete :
    OneSmallThirdRowProperty oneSmallPairA_9 oneSmallPairB_9 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_9_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_9, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨4775, by decide +kernel⟩

theorem oneSmallThirdRows_10_complete :
    OneSmallThirdRowProperty oneSmallPairA_10 oneSmallPairB_10 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_10_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_10, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨13059, by decide +kernel⟩

theorem oneSmallThirdRows_11_complete :
    OneSmallThirdRowProperty oneSmallPairA_11 oneSmallPairB_11 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_11_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_11, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨12244, by decide +kernel⟩

theorem oneSmallThirdRows_12_complete :
    OneSmallThirdRowProperty oneSmallPairA_12 oneSmallPairB_12 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_12_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_12, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨2301, by decide +kernel⟩

theorem oneSmallThirdRows_13_complete :
    OneSmallThirdRowProperty oneSmallPairA_13 oneSmallPairB_13 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_13_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_13, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨9744, by decide +kernel⟩

theorem oneSmallThirdRows_14_complete :
    OneSmallThirdRowProperty oneSmallPairA_14 oneSmallPairB_14 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_14_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_14, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨1195, by decide +kernel⟩

theorem oneSmallThirdRows_15_complete :
    OneSmallThirdRowProperty oneSmallPairA_15 oneSmallPairB_15 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_15_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_15, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨1760, by decide +kernel⟩

theorem oneSmallThirdRows_16_complete :
    OneSmallThirdRowProperty oneSmallPairA_16 oneSmallPairB_16 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_16_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_16, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨7354, by decide +kernel⟩
  · exact Or.inr ⟨7441, by decide +kernel⟩

theorem oneSmallThirdRows_17_complete :
    OneSmallThirdRowProperty oneSmallPairA_17 oneSmallPairB_17 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_17_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_17, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨1024, by decide +kernel⟩

theorem oneSmallThirdRows_18_complete :
    OneSmallThirdRowProperty oneSmallPairA_18 oneSmallPairB_18 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_18_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_18, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨7943, by decide +kernel⟩

theorem oneSmallThirdRows_19_complete :
    OneSmallThirdRowProperty oneSmallPairA_19 oneSmallPairB_19 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_19_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_19, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨6361, by decide +kernel⟩

theorem oneSmallThirdRows_20_complete :
    OneSmallThirdRowProperty oneSmallPairA_20 oneSmallPairB_20 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_20_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_20, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨14608, by decide +kernel⟩
  · exact Or.inr ⟨14404, by decide +kernel⟩

theorem oneSmallThirdRows_21_complete :
    OneSmallThirdRowProperty oneSmallPairA_21 oneSmallPairB_21 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_21_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_21, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨2461, by decide +kernel⟩

theorem oneSmallThirdRows_22_complete :
    OneSmallThirdRowProperty oneSmallPairA_22 oneSmallPairB_22 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_22_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_22, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨1622, by decide +kernel⟩
  · exact Or.inr ⟨1622, by decide +kernel⟩

theorem oneSmallThirdRows_23_complete :
    OneSmallThirdRowProperty oneSmallPairA_23 oneSmallPairB_23 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_23_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_23, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨8968, by decide +kernel⟩
  · exact Or.inr ⟨21270, by decide +kernel⟩

theorem oneSmallThirdRows_24_complete :
    OneSmallThirdRowProperty oneSmallPairA_24 oneSmallPairB_24 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_24_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_24, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨5928, by decide +kernel⟩

theorem oneSmallThirdRows_25_complete :
    OneSmallThirdRowProperty oneSmallPairA_25 oneSmallPairB_25 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_25_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_25, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨5913, by decide +kernel⟩
  · exact Or.inr ⟨5913, by decide +kernel⟩

theorem oneSmallThirdRows_26_complete :
    OneSmallThirdRowProperty oneSmallPairA_26 oneSmallPairB_26 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_26_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_26, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨8435, by decide +kernel⟩

theorem oneSmallThirdRows_27_complete :
    OneSmallThirdRowProperty oneSmallPairA_27 oneSmallPairB_27 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_27_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_27, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨9706, by decide +kernel⟩
  · exact Or.inr ⟨9706, by decide +kernel⟩

theorem oneSmallThirdRows_28_complete :
    OneSmallThirdRowProperty oneSmallPairA_28 oneSmallPairB_28 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_28_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_28, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨13453, by decide +kernel⟩

theorem oneSmallThirdRows_29_complete :
    OneSmallThirdRowProperty oneSmallPairA_29 oneSmallPairB_29 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_29_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_29, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨1517, by decide +kernel⟩

theorem oneSmallThirdRows_30_complete :
    OneSmallThirdRowProperty oneSmallPairA_30 oneSmallPairB_30 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_30_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_30, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨11143, by decide +kernel⟩

theorem oneSmallThirdRows_31_complete :
    OneSmallThirdRowProperty oneSmallPairA_31 oneSmallPairB_31 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_31_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_31, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨1451, by decide +kernel⟩
  · exact Or.inr ⟨1460, by decide +kernel⟩

theorem oneSmallThirdRows_32_complete :
    OneSmallThirdRowProperty oneSmallPairA_32 oneSmallPairB_32 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_32_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_32, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨3590, by decide +kernel⟩

theorem oneSmallThirdRows_33_complete :
    OneSmallThirdRowProperty oneSmallPairA_33 oneSmallPairB_33 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_33_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_33, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨3059, by decide +kernel⟩
  · exact Or.inr ⟨3090, by decide +kernel⟩

theorem oneSmallThirdRows_34_complete :
    OneSmallThirdRowProperty oneSmallPairA_34 oneSmallPairB_34 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_34_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_34, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨6843, by decide +kernel⟩

theorem oneSmallThirdRows_35_complete :
    OneSmallThirdRowProperty oneSmallPairA_35 oneSmallPairB_35 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_35_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_35, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨5592, by decide +kernel⟩
  · exact Or.inr ⟨5661, by decide +kernel⟩

theorem oneSmallThirdRows_36_complete :
    OneSmallThirdRowProperty oneSmallPairA_36 oneSmallPairB_36 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_36_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_36, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨11532, by decide +kernel⟩

theorem oneSmallThirdRows_37_complete :
    OneSmallThirdRowProperty oneSmallPairA_37 oneSmallPairB_37 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_37_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_37, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨9289, by decide +kernel⟩
  · exact Or.inr ⟨9415, by decide +kernel⟩

theorem oneSmallThirdRows_38_complete :
    OneSmallThirdRowProperty oneSmallPairA_38 oneSmallPairB_38 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_38_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_38, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl | rfl
  · exact Or.inr ⟨1281, by decide +kernel⟩
  · exact Or.inr ⟨2561, by decide +kernel⟩

theorem oneSmallThirdRows_39_complete :
    OneSmallThirdRowProperty oneSmallPairA_39 oneSmallPairB_39 := by
  intro s hbound horder ha hb hpair
  have hm := oneSmallThirds_39_complete s hbound horder ha hb hpair
  simp only [oneSmallThirds_39, List.mem_cons, List.not_mem_nil, or_false] at hm
  rcases hm with rfl
  · exact Or.inr ⟨6401, by decide +kernel⟩

end D1Bound5
