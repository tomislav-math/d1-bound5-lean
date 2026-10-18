from pathlib import Path
import json
b=Path('first_pair_geometry_next');data=json.loads((b/'first_pair_geometry.json').read_text())
s='''import D1Bound5.FirstPairData

namespace D1Bound5
open QuadInt

/-- Exact rational geometry data for S≥15. The M entries here are numerical
parameters; actual polynomial height bounds are proved in separate modules. -/
structure FirstPairGeometryRow where
  tau nu : ℤ
  a b : ℤ × ℤ
  A1 B0 B1 d1 : ℚ
  M2 Mn M3 M4 M5 : ℚ
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

'''
for r in data:
 i=r['index'];a=','.join(map(str,r['a']));bb=','.join(map(str,r['b']))
 vals=[r[x]for x in ('A1','B0','B1','d1','M2','Mn','M3','M4','M5')]
 s+=f'def firstPairGeometryRow_{i} : FirstPairGeometryRow :=\n  ⟨{r["tau"]},{r["nu"]},({a}),({bb}),'+','.join(map(str,vals))+'⟩\n\n'
 s+=f'theorem firstPairGeometryRow_{i}_valid : firstPairGeometryRow_{i}.Valid := by\n  decide +kernel\n\n'
s+='def firstPairGeometryRows : List FirstPairGeometryRow :=\n  ['+','.join(f'firstPairGeometryRow_{i}'for i in range(41))+']\n\n'
s+='theorem firstPairGeometryRows_valid (r : FirstPairGeometryRow)\n    (hr : r ∈ firstPairGeometryRows) : r.Valid := by\n  simp only [firstPairGeometryRows,List.mem_cons,List.mem_singleton] at hr\n  rcases hr with '+ ' | '.join(['rfl']*41)+'\n'
for i in range(41):s+=f'  · exact firstPairGeometryRow_{i}_valid\n'
s+='''
/-- Coordinate-level link to the previously checked first-pair lists. -/
def firstPairGeometryRowsAt (tau nu : ℤ) : List ((ℤ × ℤ) × (ℤ × ℤ)) :=
  ((firstPairGeometryRows.filter (fun r => r.tau=tau ∧ r.nu=nu)).map (fun r => (r.a,r.b)))

'''
for tau,nu in sorted(set((r['tau'],r['nu'])for r in data)):
 s+=f'theorem firstPairGeometryRowsAt_covers_{tau}_{nu} :\n    firstPairRepresentatives_{tau}_{nu} ⊆ (firstPairGeometryRowsAt {tau} {nu}).toFinset := by\n  decide +kernel\n\n'
s+='end D1Bound5\n'
(b/'FirstPairGeometryData.lean').write_text(s)
print('FirstPairGeometryData.lean',len(s.encode()),'bytes,41 rational certificates +10 coverage checks')
