import D1Bound5.OneSmallRows

namespace D1Bound5
open QuadInt

/-- Exact rational data for a printed fixed-triple cutoff. Coefficient
and residual entries are arithmetic parameters here; this record does not
assert analytic bounds for any approximating polynomial family. -/
structure OneSmallCutoffRow where
  triple : OneSmallTripleRow
  q1 : ℚ
  phi1 : ℚ
  q : ℚ
  M2 : ℚ
  Mn : ℚ
  M3 : ℚ
  M4 : ℚ
  M5 : ℚ
  Mbs : ℚ
  deriving DecidableEq

namespace OneSmallCutoffRow

def a0 (r : OneSmallCutoffRow) : ℚ := r.triple.anchorA.norm
def b0 (r : OneSmallCutoffRow) : ℚ := r.triple.anchorB.norm
def s0 (r : OneSmallCutoffRow) : ℚ := r.triple.anchorS.norm
def dab (r : OneSmallCutoffRow) : ℚ := (r.triple.anchorA-r.triple.anchorB).norm
def das (r : OneSmallCutoffRow) : ℚ := (r.triple.anchorA-r.triple.anchorS).norm
def dbs (r : OneSmallCutoffRow) : ℚ := (r.triple.anchorB-r.triple.anchorS).norm

def retainedCoefficient (r : OneSmallCutoffRow) : ℚ :=
  (9999/100)*r.a0*(1/r.q1-(51051/400000)/r.b0)^2

def R2 (r : OneSmallCutoffRow) : ℚ := (5/4)*(101/200)*(r.dab/(4*r.b0))^2
def Rn (r : OneSmallCutoffRow) : ℚ := (35/32)*(101/200)*(r.dab/(4*r.b0))^3
def R3 (r : OneSmallCutoffRow) : ℚ := (35/16)*(101/200)*(r.dab/(4*r.b0))^3
def R4 (r : OneSmallCutoffRow) : ℚ := (63/8)*(101/200)*(r.dab/(4*r.b0))^4
def R5 (r : OneSmallCutoffRow) : ℚ := (495/64)*(101/200)*(r.dab/(4*r.b0))^5
def Rbs (r : OneSmallCutoffRow) : ℚ := (3535/409600)*r.phi1

def Rp (r : OneSmallCutoffRow) : ℚ :=
  let x := 1/r.q
  (15+80*x+150*x^2+280*x^3+35*x^4)/256 +
    21*(885+1144*x+435*x^2+2634*x^3+170*x^4)/(1024*999)

/-- The thirteen exact coefficients and powers in the manuscript's
fixed-triple adjacent-overlap table. The two maxima entering P are
represented by separate inequalities. -/
def overlaps (r : OneSmallCutoffRow) : List (ℚ × ℕ) :=
  let K := r.retainedCoefficient
  let b := r.b0
  let s := r.s0
  let h : ℚ := 4001/3999
  let Mm : ℚ := (8/9)*608^2
  let Rm : ℚ := 3920/81
  [((1-1/4000)*K^4/(12100*s^5),5),
   (K^2/(36*r.M2^2*b^4*s^2*h),4),
   (K^2/(16*r.R2^2*2400^2*b^3*s^5*h),5),
   (K^2/(16*r.R2^2*2400^2*b^5*s^4*h),5),
   (K^2/(16*r.Rp^2*r.M3^2*b^6*s^4*h),5),
   (K^4/(16*r.R3^2*Mm^2*b^6*s^12*h),10),
   (K^4/(16*Rm^2*r.Mn^2*b^9*s^9*h),10),
   (K^4/(16*r.Rn^2*r.Mbs^2*b^3*s^11*h),10),
   (K^2/(16*r.Rbs^2*r.M4^2*b^5*s^5*h),5),
   (K^4/(144*r.R4^2*42^8*b^15*s^4*h),10),
   ((2/5)^8*K^4/(4*r.M5^2*b^16*s^4*h),10),
   (K^6/(144*r.R5^2*42^10*b^19*s^6*h),15),
   ((2/5)^10*K^6/(36*42^12*b^22*s^6*h),15)]

def ordinaryTail (r : OneSmallCutoffRow) : ℚ :=
  r.retainedCoefficient^2*(r.triple.cutoff : ℚ)^5/(105^2*r.b0^4*r.s0^2)

/-- All square-root enclosures are verified by rational square
comparisons, followed by all thirteen strict overlap comparisons and
the ordinary-tail comparison at the printed cutoff. -/
def Valid (r : OneSmallCutoffRow) : Prop :=
  1024 ≤ r.triple.cutoff ∧
  (r.a0=1 ∨ (r.a0=2 ∧ 4*r.a0*r.b0*r.s0 < (r.triple.cutoff : ℚ))) ∧
  9 ≤ r.b0 ∧ r.b0 ≤ r.s0 ∧
  2 < r.q ∧ r.q^2 ≤ r.b0/r.a0 ∧
  0 < r.q1 ∧ r.dab*r.das*r.dbs/(r.b0*r.s0^2) ≤ r.q1^2 ∧
  0 ≤ r.phi1 ∧ r.dbs^6/r.s0^6 ≤ r.phi1^2 ∧
  r.b0*r.dbs^5/r.s0^6 ≤ r.phi1^2 ∧
  (51051/400000)/r.b0 < 1/r.q1 ∧ 1 < r.retainedCoefficient ∧
  0 < r.M2 ∧ 0 < r.Mn ∧ 0 < r.M3 ∧ 0 < r.M4 ∧ 0 < r.M5 ∧ 0 < r.Mbs ∧
  (∀ e ∈ r.overlaps, 1 < e.1*(r.triple.cutoff : ℚ)^e.2) ∧
  1 < r.ordinaryTail

instance (r : OneSmallCutoffRow) : Decidable r.Valid :=
by
  unfold Valid
  infer_instance

end OneSmallCutoffRow

set_option maxRecDepth 100000
set_option maxHeartbeats 0

def oneSmallCutoffRow_0 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (0, -3), (-4, -2), 1024⟩, 13743685419/10000000000, 4913/8000, 3, 62, 608, 280, 12222, 136530, 285⟩

theorem oneSmallCutoffRow_0_valid : oneSmallCutoffRow_0.Valid := by
  decide +kernel

def oneSmallCutoffRow_1 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (0, -3), (4, -2), 1024⟩, 13743685419/10000000000, 4913/8000, 3, 62, 608, 280, 12222, 136530, 285⟩

theorem oneSmallCutoffRow_1_valid : oneSmallCutoffRow_1.Valid := by
  decide +kernel

def oneSmallCutoffRow_2 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (0, -3), (0, 5), 1934⟩, 17066666667/10000000000, 262144/15625, 3, 62, 608, 280, 12222, 136530, 1368⟩

theorem oneSmallCutoffRow_2_valid : oneSmallCutoffRow_2.Valid := by
  decide +kernel

def oneSmallCutoffRow_3 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (0, 5), (0, 10), 2311⟩, 9/25, 1/64, 5, 17, 77, 44, 808, 4011, 42⟩

theorem oneSmallCutoffRow_3_valid : oneSmallCutoffRow_3.Valid := by
  decide +kernel

def oneSmallCutoffRow_4 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (4, -2), (-4, 4), 4770⟩, 698771243/400000000, 15625/512, 44721359549/10000000000, 37, 281, 147, 4610, 38256, 2238⟩

theorem oneSmallCutoffRow_4_valid : oneSmallCutoffRow_4.Valid := by
  decide +kernel

def oneSmallCutoffRow_5 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (4, -2), (8, 1), 2359⟩, 3440104581/5000000000, 56895767/1000000000, 44721359549/10000000000, 37, 281, 147, 4610, 38256, 72⟩

theorem oneSmallCutoffRow_5_valid : oneSmallCutoffRow_5.Valid := by
  decide +kernel

def oneSmallCutoffRow_6 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (0, 1), (4, 4), (6, 9), 3896⟩, 813650973/2000000000, 15996037/1000000000, 28284271247/5000000000, 21, 110, 64, 1402, 8160, 44⟩

theorem oneSmallCutoffRow_6_valid : oneSmallCutoffRow_6.Valid := by
  decide +kernel

def oneSmallCutoffRow_7 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 0), (-5, 0), (-4, -4), 3299⟩, 9900284087/10000000000, 454550753/2500000000, 5, 44, 379, 180, 6340, 61370, 396⟩

theorem oneSmallCutoffRow_7_valid : oneSmallCutoffRow_7.Valid := by
  decide +kernel

def oneSmallCutoffRow_8 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 0), (-5, 0), (-4, 4), 3299⟩, 9900284087/10000000000, 454550753/2500000000, 5, 44, 379, 180, 6340, 61370, 396⟩

theorem oneSmallCutoffRow_8_valid : oneSmallCutoffRow_8.Valid := by
  decide +kernel

def oneSmallCutoffRow_9 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 0), (-4, 4), (-1, 8), 4857⟩, 7180059501/10000000000, 643702123/10000000000, 28284271247/5000000000, 37, 293, 150, 4791, 40361, 172⟩

theorem oneSmallCutoffRow_9_valid : oneSmallCutoffRow_9.Valid := by
  decide +kernel

def oneSmallCutoffRow_10 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 0), (2, 4), (7, 6), 2018⟩, 61953493/125000000, 198567067/5000000000, 44721359549/10000000000, 23, 129, 77, 1798, 11204, 29⟩

theorem oneSmallCutoffRow_10_valid : oneSmallCutoffRow_10.Valid := by
  decide +kernel

def oneSmallCutoffRow_11 : OneSmallCutoffRow :=
  ⟨⟨0, 2, (1, 0), (-3, 0), (-2, -2), 1024⟩, 13743685419/10000000000, 27/64, 3, 62, 608, 280, 12222, 136530, 474⟩

theorem oneSmallCutoffRow_11_valid : oneSmallCutoffRow_11.Valid := by
  decide +kernel

def oneSmallCutoffRow_12 : OneSmallCutoffRow :=
  ⟨⟨0, 2, (1, 0), (-3, 0), (-2, 2), 1024⟩, 13743685419/10000000000, 27/64, 3, 62, 608, 280, 12222, 136530, 474⟩

theorem oneSmallCutoffRow_12_valid : oneSmallCutoffRow_12.Valid := by
  decide +kernel

def oneSmallCutoffRow_13 : OneSmallCutoffRow :=
  ⟨⟨0, 2, (1, 0), (-2, 2), (1, 4), 1024⟩, 1051548627/1250000000, 1367114673/10000000000, 34641016151/10000000000, 45, 377, 183, 6284, 60438, 133⟩

theorem oneSmallCutoffRow_13_valid : oneSmallCutoffRow_13.Valid := by
  decide +kernel

def oneSmallCutoffRow_14 : OneSmallCutoffRow :=
  ⟨⟨0, 2, (1, 0), (1, 4), (6, 6), 4775⟩, 206346493/400000000, 285279493/10000000000, 11489125293/2000000000, 25, 158, 95, 2471, 16976, 56⟩

theorem oneSmallCutoffRow_14_valid : oneSmallCutoffRow_14.Valid := by
  decide +kernel

def oneSmallCutoffRow_15 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-9, 6), (-13, 13), 13059⟩, 221885351/500000000, 68467501/5000000000, 79372539331/10000000000, 24, 156, 94, 2424, 16601, 77⟩

theorem oneSmallCutoffRow_15_valid : oneSmallCutoffRow_15.Valid := by
  decide +kernel

def oneSmallCutoffRow_16 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-6, 9), (-8, 16), 12244⟩, 384154411/1000000000, 26629813/2500000000, 79372539331/10000000000, 21, 119, 70, 1599, 9691, 60⟩

theorem oneSmallCutoffRow_16_valid : oneSmallCutoffRow_16.Valid := by
  decide +kernel

def oneSmallCutoffRow_17 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-5, 1), (-9, 6), 2301⟩, 3099305427/5000000000, 370370371/10000000000, 45825756949/10000000000, 34, 252, 136, 4117, 32986, 74⟩

theorem oneSmallCutoffRow_17_valid : oneSmallCutoffRow_17.Valid := by
  decide +kernel

def oneSmallCutoffRow_18 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-4, -4), (-10, 1), 9744⟩, 431085853/625000000, 491927019/10000000000, 34641016151/5000000000, 37, 286, 147, 4661, 38983, 180⟩

theorem oneSmallCutoffRow_18_valid : oneSmallCutoffRow_18.Valid := by
  decide +kernel

def oneSmallCutoffRow_19 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-4, 4), (-6, 9), 1195⟩, 281079793/625000000, 274308431/10000000000, 4, 22, 121, 72, 1618, 9751, 35⟩

theorem oneSmallCutoffRow_19_valid : oneSmallCutoffRow_19.Valid := by
  decide +kernel

def oneSmallCutoffRow_20 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (-1, 5), (-1, 10), 1760⟩, 369361879/1000000000, 20734609/1000000000, 45825756949/10000000000, 17, 73, 41, 741, 3580, 37⟩

theorem oneSmallCutoffRow_20_valid : oneSmallCutoffRow_20.Valid := by
  decide +kernel

def oneSmallCutoffRow_21 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (2, -7), (-4, -4), 7354⟩, 1952562419/2000000000, 2139035547/10000000000, 62449979983/10000000000, 39, 318, 159, 5209, 45613, 430⟩

theorem oneSmallCutoffRow_21_valid : oneSmallCutoffRow_21.Valid := by
  decide +kernel

def oneSmallCutoffRow_22 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (2, -7), (8, -8), 7441⟩, 429142647/500000000, 127466663/1000000000, 62449979983/10000000000, 39, 318, 159, 5209, 45613, 271⟩

theorem oneSmallCutoffRow_22_valid : oneSmallCutoffRow_22.Valid := by
  decide +kernel

def oneSmallCutoffRow_23 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (3, -3), (7, -2), 1024⟩, 8590062503/10000000000, 780609923/5000000000, 3, 48, 401, 193, 6835, 66703, 78⟩

theorem oneSmallCutoffRow_23_valid : oneSmallCutoffRow_23.Valid := by
  decide +kernel

def oneSmallCutoffRow_24 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (4, 4), (6, 9), 7943⟩, 243796413/625000000, 13161149/1000000000, 34641016151/5000000000, 20, 106, 62, 1336, 7678, 48⟩

theorem oneSmallCutoffRow_24_valid : oneSmallCutoffRow_24.Valid := by
  decide +kernel

def oneSmallCutoffRow_25 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (0, 1), (7, -2), (11, 1), 6361⟩, 4900162301/10000000000, 221045507/10000000000, 62449979983/10000000000, 24, 152, 91, 2326, 15710, 48⟩

theorem oneSmallCutoffRow_25_valid : oneSmallCutoffRow_25.Valid := by
  decide +kernel

def oneSmallCutoffRow_26 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-9, 3), (-6, -3), 14404⟩, 1641829841/2000000000, 120242511/1000000000, 79372539331/10000000000, 36, 276, 143, 4502, 37275, 473⟩

theorem oneSmallCutoffRow_26_valid : oneSmallCutoffRow_26.Valid := by
  decide +kernel

def oneSmallCutoffRow_27 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-9, 3), (-10, 9), 14608⟩, 6953466039/10000000000, 1408933/25000000, 79372539331/10000000000, 36, 276, 143, 4502, 37275, 272⟩

theorem oneSmallCutoffRow_27_valid : oneSmallCutoffRow_27.Valid := by
  decide +kernel

def oneSmallCutoffRow_28 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-5, 4), (-4, 8), 2461⟩, 3858387329/5000000000, 104675293/1250000000, 45825756949/10000000000, 40, 323, 162, 5308, 46658, 155⟩

theorem oneSmallCutoffRow_28_valid : oneSmallCutoffRow_28.Valid := by
  decide +kernel

def oneSmallCutoffRow_29 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-4, 0), (-5, 4), 1622⟩, 2271283813/2000000000, 2631846089/10000000000, 4, 51, 456, 205, 8194, 83910, 422⟩

theorem oneSmallCutoffRow_29_valid : oneSmallCutoffRow_29.Valid := by
  decide +kernel

def oneSmallCutoffRow_30 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-4, 0), (-1, -4), 1622⟩, 2271283813/2000000000, 2631846089/10000000000, 4, 51, 456, 205, 8194, 83910, 422⟩

theorem oneSmallCutoffRow_30_valid : oneSmallCutoffRow_30.Valid := by
  decide +kernel

def oneSmallCutoffRow_31 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-4, 8), (4, -8), 21270⟩, 20416666667/10000000000, 64, 34641016151/5000000000, 26, 173, 103, 2780, 19826, 4138⟩

theorem oneSmallCutoffRow_31_valid : oneSmallCutoffRow_31.Valid := by
  decide +kernel

def oneSmallCutoffRow_32 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (-4, 8), (-1, 12), 8968⟩, 205824693/400000000, 61306993/2500000000, 34641016151/5000000000, 26, 173, 103, 2780, 19826, 78⟩

theorem oneSmallCutoffRow_32_valid : oneSmallCutoffRow_32.Valid := by
  decide +kernel

def oneSmallCutoffRow_33 : OneSmallCutoffRow :=
  ⟨⟨1, 1, (1, 0), (2, 5), (7, 7), 5928⟩, 426840257/1000000000, 186741919/10000000000, 62449979983/10000000000, 21, 113, 66, 1460, 8607, 41⟩

theorem oneSmallCutoffRow_33_valid : oneSmallCutoffRow_33.Valid := by
  decide +kernel

def oneSmallCutoffRow_34 : OneSmallCutoffRow :=
  ⟨⟨0, 5, (1, 0), (-6, 0), (-5, -2), 5913⟩, 2222685137/2500000000, 665322101/5000000000, 6, 41, 333, 164, 5461, 49340, 381⟩

theorem oneSmallCutoffRow_34_valid : oneSmallCutoffRow_34.Valid := by
  decide +kernel

def oneSmallCutoffRow_35 : OneSmallCutoffRow :=
  ⟨⟨0, 5, (1, 0), (-6, 0), (-5, 2), 5913⟩, 2222685137/2500000000, 665322101/5000000000, 6, 41, 333, 164, 5461, 49340, 381⟩

theorem oneSmallCutoffRow_35_valid : oneSmallCutoffRow_35.Valid := by
  decide +kernel

def oneSmallCutoffRow_36 : OneSmallCutoffRow :=
  ⟨⟨0, 5, (1, 0), (-5, 2), (-2, 4), 8435⟩, 674687203/1000000000, 10251641/200000000, 16770509831/2500000000, 35, 273, 142, 4450, 36676, 186⟩

theorem oneSmallCutoffRow_36_valid : oneSmallCutoffRow_36.Valid := by
  decide +kernel

def oneSmallCutoffRow_37 : OneSmallCutoffRow :=
  ⟨⟨0, 6, (1, 0), (-7, 0), (-6, -2), 9706⟩, 325485857/400000000, 506365741/5000000000, 7, 38, 303, 153, 4954, 42245, 370⟩

theorem oneSmallCutoffRow_37_valid : oneSmallCutoffRow_37.Valid := by
  decide +kernel

def oneSmallCutoffRow_38 : OneSmallCutoffRow :=
  ⟨⟨0, 6, (1, 0), (-7, 0), (-6, 2), 9706⟩, 325485857/400000000, 506365741/5000000000, 7, 38, 303, 153, 4954, 42245, 370⟩

theorem oneSmallCutoffRow_38_valid : oneSmallCutoffRow_38.Valid := by
  decide +kernel

def oneSmallCutoffRow_39 : OneSmallCutoffRow :=
  ⟨⟨0, 6, (1, 0), (-6, 2), (-3, 4), 13453⟩, 1277298737/2000000000, 209296797/5000000000, 19364916731/2500000000, 34, 259, 137, 4205, 34076, 197⟩

theorem oneSmallCutoffRow_39_valid : oneSmallCutoffRow_39.Valid := by
  decide +kernel

def oneSmallCutoffRow_40 : OneSmallCutoffRow :=
  ⟨⟨1, 2, (1, 0), (-2, 3), (1, 5), 1517⟩, 802873581/1250000000, 692818423/10000000000, 4, 32, 224, 127, 3666, 28238, 67⟩

theorem oneSmallCutoffRow_40_valid : oneSmallCutoffRow_40.Valid := by
  decide +kernel

def oneSmallCutoffRow_41 : OneSmallCutoffRow :=
  ⟨⟨1, 2, (1, 0), (1, 5), (6, 7), 11143⟩, 1106320859/2500000000, 16642829/1000000000, 14966629547/2000000000, 23, 137, 81, 1973, 12709, 57⟩

theorem oneSmallCutoffRow_41_valid : oneSmallCutoffRow_41.Valid := by
  decide +kernel

def oneSmallCutoffRow_42 : OneSmallCutoffRow :=
  ⟨⟨1, 3, (1, 0), (-4, 1), (-3, -1), 1451⟩, 820667637/625000000, 921050751/2000000000, 19364916731/5000000000, 50, 440, 201, 7791, 78839, 646⟩

theorem oneSmallCutoffRow_42_valid : oneSmallCutoffRow_42.Valid := by
  decide +kernel

def oneSmallCutoffRow_43 : OneSmallCutoffRow :=
  ⟨⟨1, 3, (1, 0), (-4, 1), (-3, 3), 1460⟩, 1977930359/2000000000, 1714677641/10000000000, 19364916731/5000000000, 50, 440, 201, 7791, 78839, 261⟩

theorem oneSmallCutoffRow_43_valid : oneSmallCutoffRow_43.Valid := by
  decide +kernel

def oneSmallCutoffRow_44 : OneSmallCutoffRow :=
  ⟨⟨1, 3, (1, 0), (-3, 3), (0, 5), 3590⟩, 6255308857/10000000000, 729/15625, 51961524227/10000000000, 32, 230, 127, 3748, 29208, 94⟩

theorem oneSmallCutoffRow_44_valid : oneSmallCutoffRow_44.Valid := by
  decide +kernel

def oneSmallCutoffRow_45 : OneSmallCutoffRow :=
  ⟨⟨1, 4, (1, 0), (-5, 1), (-4, -1), 3059⟩, 559986669/500000000, 1544080889/5000000000, 9797958971/2000000000, 44, 367, 176, 6049, 57935, 579⟩

theorem oneSmallCutoffRow_45_valid : oneSmallCutoffRow_45.Valid := by
  decide +kernel

def oneSmallCutoffRow_46 : OneSmallCutoffRow :=
  ⟨⟨1, 4, (1, 0), (-5, 1), (-4, 3), 3090⟩, 549806133/625000000, 1204507891/10000000000, 9797958971/2000000000, 44, 367, 176, 6049, 57935, 263⟩

theorem oneSmallCutoffRow_46_valid : oneSmallCutoffRow_46.Valid := by
  decide +kernel

def oneSmallCutoffRow_47 : OneSmallCutoffRow :=
  ⟨⟨1, 4, (1, 0), (-4, 3), (-1, 5), 6843⟩, 6030071489/10000000000, 382490393/10000000000, 63245553203/10000000000, 32, 229, 126, 3718, 28965, 115⟩

theorem oneSmallCutoffRow_47_valid : oneSmallCutoffRow_47.Valid := by
  decide +kernel

def oneSmallCutoffRow_48 : OneSmallCutoffRow :=
  ⟨⟨1, 5, (1, 0), (-6, 1), (-5, -1), 5592⟩, 4947007813/5000000000, 2171270299/10000000000, 5916079783/1000000000, 40, 324, 161, 5305, 46974, 532⟩

theorem oneSmallCutoffRow_48_valid : oneSmallCutoffRow_48.Valid := by
  decide +kernel

def oneSmallCutoffRow_49 : OneSmallCutoffRow :=
  ⟨⟨1, 5, (1, 0), (-6, 1), (-5, 3), 5661⟩, 64161779/80000000, 902122561/10000000000, 5916079783/1000000000, 40, 324, 161, 5305, 46974, 266⟩

theorem oneSmallCutoffRow_49_valid : oneSmallCutoffRow_49.Valid := by
  decide +kernel

def oneSmallCutoffRow_50 : OneSmallCutoffRow :=
  ⟨⟨1, 5, (1, 0), (-5, 3), (-2, 5), 11532⟩, 232171797/400000000, 159470581/5000000000, 7416198487/1000000000, 31, 226, 124, 3660, 28401, 133⟩

theorem oneSmallCutoffRow_50_valid : oneSmallCutoffRow_50.Valid := by
  decide +kernel

def oneSmallCutoffRow_51 : OneSmallCutoffRow :=
  ⟨⟨1, 6, (1, 0), (-7, 1), (-6, -1), 9289⟩, 8941157631/10000000000, 39733471/250000000, 34641016151/5000000000, 37, 296, 151, 4834, 40902, 499⟩

theorem oneSmallCutoffRow_51_valid : oneSmallCutoffRow_51.Valid := by
  decide +kernel

def oneSmallCutoffRow_52 : OneSmallCutoffRow :=
  ⟨⟨1, 6, (1, 0), (-7, 1), (-6, 3), 9415⟩, 371365489/500000000, 9/128, 34641016151/5000000000, 37, 296, 151, 4834, 40902, 269⟩

theorem oneSmallCutoffRow_52_valid : oneSmallCutoffRow_52.Valid := by
  decide +kernel

def oneSmallCutoffRow_53 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 1), (-1, -3), (-4, 0), 1281⟩, 2390165397/1250000000, 729/512, 11180339887/5000000000, 77, 803, 387, 17946, 216405, 540⟩

theorem oneSmallCutoffRow_53_valid : oneSmallCutoffRow_53.Valid := by
  decide +kernel

def oneSmallCutoffRow_54 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 1), (-1, -3), (4, -4), 2561⟩, 13139872527/10000000000, 1340942383/2500000000, 11180339887/5000000000, 77, 803, 387, 17946, 216405, 182⟩

theorem oneSmallCutoffRow_54_valid : oneSmallCutoffRow_54.Valid := by
  decide +kernel

def oneSmallCutoffRow_55 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 1), (3, 1), (8, 4), 6401⟩, 3510697937/10000000000, 4913/64000, 11180339887/5000000000, 19, 38, 41, 370, 985, 38⟩

theorem oneSmallCutoffRow_55_valid : oneSmallCutoffRow_55.Valid := by
  decide +kernel

def oneSmallCutoffRow_56 : OneSmallCutoffRow :=
  ⟨⟨0, 1, (1, 0), (3, 0), (8, 0), 1024⟩, 1822916667/5000000000, 37252903/625000000, 3, 12, 41, 25, 300, 1100, 34⟩

theorem oneSmallCutoffRow_56_valid : oneSmallCutoffRow_56.Valid := by
  decide +kernel

def oneSmallCutoffRows : List OneSmallCutoffRow :=
  [oneSmallCutoffRow_0,
   oneSmallCutoffRow_1,
   oneSmallCutoffRow_2,
   oneSmallCutoffRow_3,
   oneSmallCutoffRow_4,
   oneSmallCutoffRow_5,
   oneSmallCutoffRow_6,
   oneSmallCutoffRow_7,
   oneSmallCutoffRow_8,
   oneSmallCutoffRow_9,
   oneSmallCutoffRow_10,
   oneSmallCutoffRow_11,
   oneSmallCutoffRow_12,
   oneSmallCutoffRow_13,
   oneSmallCutoffRow_14,
   oneSmallCutoffRow_15,
   oneSmallCutoffRow_16,
   oneSmallCutoffRow_17,
   oneSmallCutoffRow_18,
   oneSmallCutoffRow_19,
   oneSmallCutoffRow_20,
   oneSmallCutoffRow_21,
   oneSmallCutoffRow_22,
   oneSmallCutoffRow_23,
   oneSmallCutoffRow_24,
   oneSmallCutoffRow_25,
   oneSmallCutoffRow_26,
   oneSmallCutoffRow_27,
   oneSmallCutoffRow_28,
   oneSmallCutoffRow_29,
   oneSmallCutoffRow_30,
   oneSmallCutoffRow_31,
   oneSmallCutoffRow_32,
   oneSmallCutoffRow_33,
   oneSmallCutoffRow_34,
   oneSmallCutoffRow_35,
   oneSmallCutoffRow_36,
   oneSmallCutoffRow_37,
   oneSmallCutoffRow_38,
   oneSmallCutoffRow_39,
   oneSmallCutoffRow_40,
   oneSmallCutoffRow_41,
   oneSmallCutoffRow_42,
   oneSmallCutoffRow_43,
   oneSmallCutoffRow_44,
   oneSmallCutoffRow_45,
   oneSmallCutoffRow_46,
   oneSmallCutoffRow_47,
   oneSmallCutoffRow_48,
   oneSmallCutoffRow_49,
   oneSmallCutoffRow_50,
   oneSmallCutoffRow_51,
   oneSmallCutoffRow_52,
   oneSmallCutoffRow_53,
   oneSmallCutoffRow_54,
   oneSmallCutoffRow_55,
   oneSmallCutoffRow_56]

/-- Every arithmetic row is kernel checked separately. -/
theorem oneSmallCutoffRows_valid (r : OneSmallCutoffRow)
    (hr : r ∈ oneSmallCutoffRows) : r.Valid := by
  simp only [oneSmallCutoffRows, List.mem_cons, List.not_mem_nil, or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact oneSmallCutoffRow_0_valid
  · exact oneSmallCutoffRow_1_valid
  · exact oneSmallCutoffRow_2_valid
  · exact oneSmallCutoffRow_3_valid
  · exact oneSmallCutoffRow_4_valid
  · exact oneSmallCutoffRow_5_valid
  · exact oneSmallCutoffRow_6_valid
  · exact oneSmallCutoffRow_7_valid
  · exact oneSmallCutoffRow_8_valid
  · exact oneSmallCutoffRow_9_valid
  · exact oneSmallCutoffRow_10_valid
  · exact oneSmallCutoffRow_11_valid
  · exact oneSmallCutoffRow_12_valid
  · exact oneSmallCutoffRow_13_valid
  · exact oneSmallCutoffRow_14_valid
  · exact oneSmallCutoffRow_15_valid
  · exact oneSmallCutoffRow_16_valid
  · exact oneSmallCutoffRow_17_valid
  · exact oneSmallCutoffRow_18_valid
  · exact oneSmallCutoffRow_19_valid
  · exact oneSmallCutoffRow_20_valid
  · exact oneSmallCutoffRow_21_valid
  · exact oneSmallCutoffRow_22_valid
  · exact oneSmallCutoffRow_23_valid
  · exact oneSmallCutoffRow_24_valid
  · exact oneSmallCutoffRow_25_valid
  · exact oneSmallCutoffRow_26_valid
  · exact oneSmallCutoffRow_27_valid
  · exact oneSmallCutoffRow_28_valid
  · exact oneSmallCutoffRow_29_valid
  · exact oneSmallCutoffRow_30_valid
  · exact oneSmallCutoffRow_31_valid
  · exact oneSmallCutoffRow_32_valid
  · exact oneSmallCutoffRow_33_valid
  · exact oneSmallCutoffRow_34_valid
  · exact oneSmallCutoffRow_35_valid
  · exact oneSmallCutoffRow_36_valid
  · exact oneSmallCutoffRow_37_valid
  · exact oneSmallCutoffRow_38_valid
  · exact oneSmallCutoffRow_39_valid
  · exact oneSmallCutoffRow_40_valid
  · exact oneSmallCutoffRow_41_valid
  · exact oneSmallCutoffRow_42_valid
  · exact oneSmallCutoffRow_43_valid
  · exact oneSmallCutoffRow_44_valid
  · exact oneSmallCutoffRow_45_valid
  · exact oneSmallCutoffRow_46_valid
  · exact oneSmallCutoffRow_47_valid
  · exact oneSmallCutoffRow_48_valid
  · exact oneSmallCutoffRow_49_valid
  · exact oneSmallCutoffRow_50_valid
  · exact oneSmallCutoffRow_51_valid
  · exact oneSmallCutoffRow_52_valid
  · exact oneSmallCutoffRow_53_valid
  · exact oneSmallCutoffRow_54_valid
  · exact oneSmallCutoffRow_55_valid
  · exact oneSmallCutoffRow_56_valid

/-- The arithmetic rows cover exactly the 56 finite-table triples and
the separate rational triple (1,3,8), with their printed cutoffs. -/
theorem oneSmallCutoffRows_triples :
    (oneSmallCutoffRows.map OneSmallCutoffRow.triple).toFinset =
      insert (⟨0,1,(1,0),(3,0),(8,0),1024⟩ : OneSmallTripleRow)
        oneSmallFixedRows := by
  decide +kernel

/-- Every fixed-triple finite row has an actual matching arithmetic
certificate; the coefficient bounds for approximating families remain
separate analytic theorems. -/
theorem oneSmallFixedRows_cutoff_certificate (r : OneSmallTripleRow)
    (hr : r ∈ oneSmallFixedRows) :
    ∃ c : OneSmallCutoffRow, c.triple = r ∧ c.Valid := by
  have hm : r ∈ (oneSmallCutoffRows.map OneSmallCutoffRow.triple).toFinset := by
    rw [oneSmallCutoffRows_triples]
    exact Finset.mem_insert_of_mem hr
  have hl : r ∈ oneSmallCutoffRows.map OneSmallCutoffRow.triple := by
    simpa only [List.mem_toFinset] using hm
  obtain ⟨c,hc,hcr⟩ := List.mem_map.mp hl
  exact ⟨c,hcr,oneSmallCutoffRows_valid c hc⟩

end D1Bound5

#print axioms D1Bound5.oneSmallCutoffRows_valid
#print axioms D1Bound5.oneSmallCutoffRows_triples
#print axioms D1Bound5.oneSmallFixedRows_cutoff_certificate
