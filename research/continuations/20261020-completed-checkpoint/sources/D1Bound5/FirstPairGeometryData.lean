import D1Bound5.FirstPairData

namespace D1Bound5
open QuadInt

/-- Exact rational geometry data for S≥15. The M entries here are numerical
parameters; actual polynomial height bounds are proved in separate modules. -/
structure FirstPairGeometryRow where
  tau : ℤ
  nu : ℤ
  a : ℤ × ℤ
  b : ℤ × ℤ
  A1 : ℚ
  B0 : ℚ
  B1 : ℚ
  d1 : ℚ
  M2 : ℚ
  Mn : ℚ
  M3 : ℚ
  M4 : ℚ
  M5 : ℚ
  deriving DecidableEq

namespace FirstPairGeometryRow

def anchorA (r : FirstPairGeometryRow) : QuadInt r.tau r.nu := ⟨r.a.1,r.a.2⟩
def anchorB (r : FirstPairGeometryRow) : QuadInt r.tau r.nu := ⟨r.b.1,r.b.2⟩
def a0 (r : FirstPairGeometryRow) : ℚ := r.anchorA.norm
def b0 (r : FirstPairGeometryRow) : ℚ := r.anchorB.norm
def dab (r : FirstPairGeometryRow) : ℚ := (r.anchorA-r.anchorB).norm

def q (r : FirstPairGeometryRow) : ℚ := r.B0/r.A1
def Q0 (r : FirstPairGeometryRow) : ℚ := r.d1*(1+r.A1/15)*(1+r.B1/15)
def K (r : FirstPairGeometryRow) : ℚ := (9999/100)*r.a0*(1/r.Q0-(51051/400000)/r.b0)^2
def G (r : FirstPairGeometryRow) : ℚ := r.K*(59/20)^5
def H (r : FirstPairGeometryRow) : ℚ :=
  (9999/100)*r.a0*(59/20)^5*(1-(51051/400000)*r.Q0/r.b0)^2
def F0 (r : FirstPairGeometryRow) : ℚ :=
  (r.dab/r.b0)*(1+r.A1/15)^2*(1+r.B1/15)^8
def rho (r : FirstPairGeometryRow) : ℚ := r.H/((3535/409600)*r.F0)

def R2 (r : FirstPairGeometryRow) : ℚ := (5/4)*(101/200)*(r.dab/(4*r.b0))^2
def Rn (r : FirstPairGeometryRow) : ℚ := (35/32)*(101/200)*(r.dab/(4*r.b0))^3
def R3 (r : FirstPairGeometryRow) : ℚ := (35/16)*(101/200)*(r.dab/(4*r.b0))^3
def R4 (r : FirstPairGeometryRow) : ℚ := (63/8)*(101/200)*(r.dab/(4*r.b0))^4
def R5 (r : FirstPairGeometryRow) : ℚ := (495/64)*(101/200)*(r.dab/(4*r.b0))^5
def Rp (r : FirstPairGeometryRow) : ℚ :=
  let x := 1/r.q
  (15+80*x+150*x^2+280*x^3+35*x^4)/256+
    21*(885+1144*x+435*x^2+2634*x^3+170*x^4)/(1024*999)

/-- All fifteen common-window quotients, with A replaced by one,
B²=b0 and S²=225, including both optional detours. -/
def overlaps (r : FirstPairGeometryRow) : List ℚ :=
  let b := r.b0
  let G := r.G
  let h : ℚ := 4001/3999
  let Mm : ℚ := (8/9)*608^2
  let Rm : ℚ := 3920/81
  [9604*(1-1/4000)*b^5/12100,
   784*225^2/(36*r.M2^2*h),
   G^2*b^2/(16*r.R2^2*2400^2*h),
   G^2*225/(16*r.R2^2*2400^2*h),
   G^2/(16*r.Rp^2*r.Mn^2*h),
   G^2/(16*r.Rp^2*r.M3^2*h),
   G^4/(16*r.R3^2*Mm^2*h),
   G^4*b*225/(16*Rm^2*r.Mn^2*h),
   G^2*b^2/(16*r.Rn^2*r.M4^2*h),
   G^4*b^4/(16*r.Rn^2*4143^2*h),
   r.rho^2/(16*r.M4^2*h),
   G^4*b/(144*r.R4^2*42^8*h),
   G^4/(4*r.M5^2*(5/2)^8*h),
   G^6*b^5/(144*r.R5^2*42^10*h),
   G^6*b^2/(36*42^12*(5/2)^10*h)]

def tail (r : FirstPairGeometryRow) : ℚ := r.G*r.B0*15^3/105

def Valid (r : FirstPairGeometryRow) : Prop :=
  (r.a0=1 ∨ r.a0=2) ∧ 9 ≤ r.b0 ∧ 0 < r.dab ∧
  0 < r.A1 ∧ r.a0 ≤ r.A1^2 ∧
  0 < r.B0 ∧ r.B0^2 ≤ r.b0 ∧ 0 < r.B1 ∧ r.b0 ≤ r.B1^2 ∧
  0 < r.d1 ∧ r.dab/r.b0 ≤ r.d1^2 ∧
  2 < r.q ∧ 0 < r.Q0 ∧ (51051/400000)/r.b0 < 1/r.Q0 ∧
  7/4 < r.K ∧ 0 < r.G ∧ 0 < r.H ∧ 0 < r.F0 ∧ 0 < r.rho ∧
  0 < r.R2 ∧ 0 < r.Rn ∧ 0 < r.R3 ∧ 0 < r.R4 ∧ 0 < r.R5 ∧ 0 < r.Rp ∧
  0 < r.M2 ∧ 0 < r.Mn ∧ 0 < r.M3 ∧ 0 < r.M4 ∧ 0 < r.M5 ∧
  (∀ v ∈ r.overlaps, 59/50 < v) ∧ 1 < r.tail

instance (r : FirstPairGeometryRow) : Decidable r.Valid := by
  unfold Valid
  infer_instance

end FirstPairGeometryRow

set_option maxHeartbeats 0
set_option maxRecDepth 100000

def firstPairGeometryRow_0 : FirstPairGeometryRow :=
  ⟨0,1,(0,1),(0,-3),1,3,3,66666667/50000000,62,608,280,12222,136530⟩

theorem firstPairGeometryRow_0_valid : firstPairGeometryRow_0.Valid := by
  decide +kernel

def firstPairGeometryRow_1 : FirstPairGeometryRow :=
  ⟨0,1,(0,1),(0,5),1,5,5,4/5,17,77,44,808,4011⟩

theorem firstPairGeometryRow_1_valid : firstPairGeometryRow_1.Valid := by
  decide +kernel

def firstPairGeometryRow_2 : FirstPairGeometryRow :=
  ⟨0,1,(0,1),(4,-2),1,89442719/20000000,111803399/25000000,111803399/100000000,37,281,147,4610,38256⟩

theorem firstPairGeometryRow_2_valid : firstPairGeometryRow_2.Valid := by
  decide +kernel

def firstPairGeometryRow_3 : FirstPairGeometryRow :=
  ⟨0,1,(0,1),(4,4),1,35355339/6250000,22627417/4000000,22097087/25000000,21,110,64,1402,8160⟩

theorem firstPairGeometryRow_3_valid : firstPairGeometryRow_3.Valid := by
  decide +kernel

def firstPairGeometryRow_4 : FirstPairGeometryRow :=
  ⟨0,1,(1,0),(-5,0),1,5,5,6/5,44,379,180,6340,61370⟩

theorem firstPairGeometryRow_4_valid : firstPairGeometryRow_4.Valid := by
  decide +kernel

def firstPairGeometryRow_5 : FirstPairGeometryRow :=
  ⟨0,1,(1,0),(-4,4),1,35355339/6250000,22627417/4000000,22638463/20000000,37,293,150,4791,40361⟩

theorem firstPairGeometryRow_5_valid : firstPairGeometryRow_5.Valid := by
  decide +kernel

def firstPairGeometryRow_6 : FirstPairGeometryRow :=
  ⟨0,1,(1,0),(2,4),1,89442719/20000000,111803399/25000000,18439089/20000000,23,129,77,1798,11204⟩

theorem firstPairGeometryRow_6_valid : firstPairGeometryRow_6.Valid := by
  decide +kernel

def firstPairGeometryRow_7 : FirstPairGeometryRow :=
  ⟨0,2,(1,0),(-3,0),1,3,3,66666667/50000000,62,608,280,12222,136530⟩

theorem firstPairGeometryRow_7_valid : firstPairGeometryRow_7.Valid := by
  decide +kernel

def firstPairGeometryRow_8 : FirstPairGeometryRow :=
  ⟨0,2,(1,0),(-2,2),1,346410161/100000000,173205081/50000000,1859747/1562500,45,377,183,6284,60438⟩

theorem firstPairGeometryRow_8_valid : firstPairGeometryRow_8.Valid := by
  decide +kernel

def firstPairGeometryRow_9 : FirstPairGeometryRow :=
  ⟨0,2,(1,0),(1,4),1,71807033/12500000,114891253/20000000,98473193/100000000,25,158,95,2471,16976⟩

theorem firstPairGeometryRow_9_valid : firstPairGeometryRow_9.Valid := by
  decide +kernel

def firstPairGeometryRow_10 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-9,6),1,793725393/100000000,396862697/50000000,98399897/100000000,24,156,94,2424,16601⟩

theorem firstPairGeometryRow_10_valid : firstPairGeometryRow_10.Valid := by
  decide +kernel

def firstPairGeometryRow_11 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-6,9),1,793725393/100000000,396862697/50000000,90851353/100000000,21,119,70,1599,9691⟩

theorem firstPairGeometryRow_11_valid : firstPairGeometryRow_11.Valid := by
  decide +kernel

def firstPairGeometryRow_12 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-5,1),1,458257569/100000000,45825757/10000000,54554473/50000000,34,252,136,4117,32986⟩

theorem firstPairGeometryRow_12_valid : firstPairGeometryRow_12.Valid := by
  decide +kernel

def firstPairGeometryRow_13 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-4,-4),1,692820323/100000000,173205081/25000000,28182811/25000000,37,286,147,4661,38983⟩

theorem firstPairGeometryRow_13_valid : firstPairGeometryRow_13.Valid := by
  decide +kernel

def firstPairGeometryRow_14 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-4,4),1,4,4,45069391/50000000,22,121,72,1618,9751⟩

theorem firstPairGeometryRow_14_valid : firstPairGeometryRow_14.Valid := by
  decide +kernel

def firstPairGeometryRow_15 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(-1,5),1,458257569/100000000,45825757/10000000,3933979/5000000,17,73,41,741,3580⟩

theorem firstPairGeometryRow_15_valid : firstPairGeometryRow_15.Valid := by
  decide +kernel

def firstPairGeometryRow_16 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(2,-7),1,624499799/100000000,3122499/500000,57735027/50000000,39,318,159,5209,45613⟩

theorem firstPairGeometryRow_16_valid : firstPairGeometryRow_16.Valid := by
  decide +kernel

def firstPairGeometryRow_17 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(3,-3),1,3,3,120185043/100000000,48,401,193,6835,66703⟩

theorem firstPairGeometryRow_17_valid : firstPairGeometryRow_17.Valid := by
  decide +kernel

def firstPairGeometryRow_18 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(4,4),1,692820323/100000000,173205081/25000000,17559423/20000000,20,106,62,1336,7678⟩

theorem firstPairGeometryRow_18_valid : firstPairGeometryRow_18.Valid := by
  decide +kernel

def firstPairGeometryRow_19 : FirstPairGeometryRow :=
  ⟨1,1,(0,1),(7,-2),1,624499799/100000000,3122499/500000,48701077/50000000,24,152,91,2326,15710⟩

theorem firstPairGeometryRow_19_valid : firstPairGeometryRow_19.Valid := by
  decide +kernel

def firstPairGeometryRow_20 : FirstPairGeometryRow :=
  ⟨1,1,(1,0),(-9,3),1,793725393/100000000,396862697/50000000,27995181/25000000,36,276,143,4502,37275⟩

theorem firstPairGeometryRow_20_valid : firstPairGeometryRow_20.Valid := by
  decide +kernel

def firstPairGeometryRow_21 : FirstPairGeometryRow :=
  ⟨1,1,(1,0),(-5,4),1,458257569/100000000,45825757/10000000,57735027/50000000,40,323,162,5308,46658⟩

theorem firstPairGeometryRow_21_valid : firstPairGeometryRow_21.Valid := by
  decide +kernel

def firstPairGeometryRow_22 : FirstPairGeometryRow :=
  ⟨1,1,(1,0),(-4,0),1,4,4,5/4,51,456,205,8194,83910⟩

theorem firstPairGeometryRow_22_valid : firstPairGeometryRow_22.Valid := by
  decide +kernel

def firstPairGeometryRow_23 : FirstPairGeometryRow :=
  ⟨1,1,(1,0),(-4,8),1,692820323/100000000,173205081/25000000,50518149/50000000,26,173,103,2780,19826⟩

theorem firstPairGeometryRow_23_valid : firstPairGeometryRow_23.Valid := by
  decide +kernel

def firstPairGeometryRow_24 : FirstPairGeometryRow :=
  ⟨1,1,(1,0),(2,5),1,624499799/100000000,3122499/500000,89155583/100000000,21,113,66,1460,8607⟩

theorem firstPairGeometryRow_24_valid : firstPairGeometryRow_24.Valid := by
  decide +kernel

def firstPairGeometryRow_25 : FirstPairGeometryRow :=
  ⟨0,5,(1,0),(-6,0),1,6,6,116666667/100000000,41,333,164,5461,49340⟩

theorem firstPairGeometryRow_25_valid : firstPairGeometryRow_25.Valid := by
  decide +kernel

def firstPairGeometryRow_26 : FirstPairGeometryRow :=
  ⟨0,5,(1,0),(-5,2),1,670820393/100000000,335410197/50000000,111554671/100000000,35,273,142,4450,36676⟩

theorem firstPairGeometryRow_26_valid : firstPairGeometryRow_26.Valid := by
  decide +kernel

def firstPairGeometryRow_27 : FirstPairGeometryRow :=
  ⟨0,6,(1,0),(-7,0),1,7,7,22857143/20000000,38,303,153,4954,42245⟩

theorem firstPairGeometryRow_27_valid : firstPairGeometryRow_27.Valid := by
  decide +kernel

def firstPairGeometryRow_28 : FirstPairGeometryRow :=
  ⟨0,6,(1,0),(-6,2),1,774596669/100000000,77459667/10000000,22060523/20000000,34,259,137,4205,34076⟩

theorem firstPairGeometryRow_28_valid : firstPairGeometryRow_28.Valid := by
  decide +kernel

def firstPairGeometryRow_29 : FirstPairGeometryRow :=
  ⟨1,2,(1,0),(-2,3),1,4,4,53033009/50000000,32,224,127,3666,28238⟩

theorem firstPairGeometryRow_29_valid : firstPairGeometryRow_29.Valid := by
  decide +kernel

def firstPairGeometryRow_30 : FirstPairGeometryRow :=
  ⟨1,2,(1,0),(1,5),1,748331477/100000000,374165739/50000000,94491119/100000000,23,137,81,1973,12709⟩

theorem firstPairGeometryRow_30_valid : firstPairGeometryRow_30.Valid := by
  decide +kernel

def firstPairGeometryRow_31 : FirstPairGeometryRow :=
  ⟨1,3,(1,0),(-4,1),1,193649167/50000000,77459667/20000000,61913919/50000000,50,440,201,7791,78839⟩

theorem firstPairGeometryRow_31_valid : firstPairGeometryRow_31.Valid := by
  decide +kernel

def firstPairGeometryRow_32 : FirstPairGeometryRow :=
  ⟨1,3,(1,0),(-3,3),1,259807621/50000000,519615243/100000000,26787919/25000000,32,230,127,3748,29208⟩

theorem firstPairGeometryRow_32_valid : firstPairGeometryRow_32.Valid := by
  decide +kernel

def firstPairGeometryRow_33 : FirstPairGeometryRow :=
  ⟨1,4,(1,0),(-5,1),1,122474487/25000000,489897949/100000000,1859747/1562500,44,367,176,6049,57935⟩

theorem firstPairGeometryRow_33_valid : firstPairGeometryRow_33.Valid := by
  decide +kernel

def firstPairGeometryRow_34 : FirstPairGeometryRow :=
  ⟨1,4,(1,0),(-4,3),1,158113883/25000000,632455533/100000000,107238053/100000000,32,229,126,3718,28965⟩

theorem firstPairGeometryRow_34_valid : firstPairGeometryRow_34.Valid := by
  decide +kernel

def firstPairGeometryRow_35 : FirstPairGeometryRow :=
  ⟨1,5,(1,0),(-6,1),1,295803989/50000000,591607979/100000000,57940857/50000000,40,324,161,5305,46974⟩

theorem firstPairGeometryRow_35_valid : firstPairGeometryRow_35.Valid := by
  decide +kernel

def firstPairGeometryRow_36 : FirstPairGeometryRow :=
  ⟨1,5,(1,0),(-5,3),1,92702481/12500000,741619849/100000000,107025911/100000000,31,226,124,3660,28401⟩

theorem firstPairGeometryRow_36_valid : firstPairGeometryRow_36.Valid := by
  decide +kernel

def firstPairGeometryRow_37 : FirstPairGeometryRow :=
  ⟨1,6,(1,0),(-7,1),1,692820323/100000000,173205081/25000000,22730303/20000000,37,296,151,4834,40902⟩

theorem firstPairGeometryRow_37_valid : firstPairGeometryRow_37.Valid := by
  decide +kernel

def firstPairGeometryRow_38 : FirstPairGeometryRow :=
  ⟨0,1,(1,1),(-1,-3),141421357/100000000,158113883/50000000,316227767/100000000,141421357/100000000,77,803,387,17946,216405⟩

theorem firstPairGeometryRow_38_valid : firstPairGeometryRow_38.Valid := by
  decide +kernel

def firstPairGeometryRow_39 : FirstPairGeometryRow :=
  ⟨0,1,(1,1),(3,1),141421357/100000000,158113883/50000000,316227767/100000000,31622777/50000000,19,38,41,370,985⟩

theorem firstPairGeometryRow_39_valid : firstPairGeometryRow_39.Valid := by
  decide +kernel

def firstPairGeometryRow_40 : FirstPairGeometryRow :=
  ⟨0,1,(1,0),(3,0),1,3,3,66666667/100000000,12,41,25,300,1100⟩

theorem firstPairGeometryRow_40_valid : firstPairGeometryRow_40.Valid := by
  decide +kernel

def firstPairGeometryRows : List FirstPairGeometryRow :=
  [firstPairGeometryRow_0,firstPairGeometryRow_1,firstPairGeometryRow_2,firstPairGeometryRow_3,firstPairGeometryRow_4,firstPairGeometryRow_5,firstPairGeometryRow_6,firstPairGeometryRow_7,firstPairGeometryRow_8,firstPairGeometryRow_9,firstPairGeometryRow_10,firstPairGeometryRow_11,firstPairGeometryRow_12,firstPairGeometryRow_13,firstPairGeometryRow_14,firstPairGeometryRow_15,firstPairGeometryRow_16,firstPairGeometryRow_17,firstPairGeometryRow_18,firstPairGeometryRow_19,firstPairGeometryRow_20,firstPairGeometryRow_21,firstPairGeometryRow_22,firstPairGeometryRow_23,firstPairGeometryRow_24,firstPairGeometryRow_25,firstPairGeometryRow_26,firstPairGeometryRow_27,firstPairGeometryRow_28,firstPairGeometryRow_29,firstPairGeometryRow_30,firstPairGeometryRow_31,firstPairGeometryRow_32,firstPairGeometryRow_33,firstPairGeometryRow_34,firstPairGeometryRow_35,firstPairGeometryRow_36,firstPairGeometryRow_37,firstPairGeometryRow_38,firstPairGeometryRow_39,firstPairGeometryRow_40]

theorem firstPairGeometryRows_valid (r : FirstPairGeometryRow)
    (hr : r ∈ firstPairGeometryRows) : r.Valid := by
  simp only [firstPairGeometryRows,List.mem_cons,List.not_mem_nil,or_false] at hr
  rcases hr with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact firstPairGeometryRow_0_valid
  · exact firstPairGeometryRow_1_valid
  · exact firstPairGeometryRow_2_valid
  · exact firstPairGeometryRow_3_valid
  · exact firstPairGeometryRow_4_valid
  · exact firstPairGeometryRow_5_valid
  · exact firstPairGeometryRow_6_valid
  · exact firstPairGeometryRow_7_valid
  · exact firstPairGeometryRow_8_valid
  · exact firstPairGeometryRow_9_valid
  · exact firstPairGeometryRow_10_valid
  · exact firstPairGeometryRow_11_valid
  · exact firstPairGeometryRow_12_valid
  · exact firstPairGeometryRow_13_valid
  · exact firstPairGeometryRow_14_valid
  · exact firstPairGeometryRow_15_valid
  · exact firstPairGeometryRow_16_valid
  · exact firstPairGeometryRow_17_valid
  · exact firstPairGeometryRow_18_valid
  · exact firstPairGeometryRow_19_valid
  · exact firstPairGeometryRow_20_valid
  · exact firstPairGeometryRow_21_valid
  · exact firstPairGeometryRow_22_valid
  · exact firstPairGeometryRow_23_valid
  · exact firstPairGeometryRow_24_valid
  · exact firstPairGeometryRow_25_valid
  · exact firstPairGeometryRow_26_valid
  · exact firstPairGeometryRow_27_valid
  · exact firstPairGeometryRow_28_valid
  · exact firstPairGeometryRow_29_valid
  · exact firstPairGeometryRow_30_valid
  · exact firstPairGeometryRow_31_valid
  · exact firstPairGeometryRow_32_valid
  · exact firstPairGeometryRow_33_valid
  · exact firstPairGeometryRow_34_valid
  · exact firstPairGeometryRow_35_valid
  · exact firstPairGeometryRow_36_valid
  · exact firstPairGeometryRow_37_valid
  · exact firstPairGeometryRow_38_valid
  · exact firstPairGeometryRow_39_valid
  · exact firstPairGeometryRow_40_valid

/-- Coordinate-level link to the previously checked first-pair lists. -/
def firstPairGeometryRowsAt (tau nu : ℤ) : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  ((firstPairGeometryRows.filter (fun r => r.tau=tau ∧ r.nu=nu)).map (fun r => (r.a,r.b)))

theorem firstPairGeometryRowsAt_covers_0_1 :
    firstPairRepresentatives_0_1 ⊆ (firstPairGeometryRowsAt 0 1).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_0_2 :
    firstPairRepresentatives_0_2 ⊆ (firstPairGeometryRowsAt 0 2).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_0_5 :
    firstPairRepresentatives_0_5 ⊆ (firstPairGeometryRowsAt 0 5).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_0_6 :
    firstPairRepresentatives_0_6 ⊆ (firstPairGeometryRowsAt 0 6).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_1 :
    firstPairRepresentatives_1_1 ⊆ (firstPairGeometryRowsAt 1 1).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_2 :
    firstPairRepresentatives_1_2 ⊆ (firstPairGeometryRowsAt 1 2).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_3 :
    firstPairRepresentatives_1_3 ⊆ (firstPairGeometryRowsAt 1 3).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_4 :
    firstPairRepresentatives_1_4 ⊆ (firstPairGeometryRowsAt 1 4).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_5 :
    firstPairRepresentatives_1_5 ⊆ (firstPairGeometryRowsAt 1 5).toFinset := by
  decide +kernel

theorem firstPairGeometryRowsAt_covers_1_6 :
    firstPairRepresentatives_1_6 ⊆ (firstPairGeometryRowsAt 1 6).toFinset := by
  decide +kernel

end D1Bound5
