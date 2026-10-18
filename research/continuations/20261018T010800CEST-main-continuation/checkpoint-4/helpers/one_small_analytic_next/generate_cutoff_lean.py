from fractions import Fraction
from pathlib import Path
import json
root=Path('/workspace/scratch/40edb97fa4c0')
records=json.loads((root/'one_small_analytic_next/fixed_cutoff_certificates.json').read_text())
data=json.loads((root/'finite_next/one_small/finite_data.json').read_text())
pairs=data['pairs']+[dict(tau=0,nu=1,a=[1,0],b=[3,0])]
triples=data['triples']+[dict(s=[8,0])]
def rat(s):
 f=Fraction(s)
 return str(f.numerator) if f.denominator==1 else f'{f.numerator}/{f.denominator}'
def pair(x):return f'({x[0]}, {x[1]})'
header='''import D1Bound5.OneSmallRows

namespace D1Bound5
open QuadInt

/-- Exact rational data for a printed fixed-triple cutoff. Coefficient
and residual entries are arithmetic parameters here; this record does not
assert analytic bounds for any approximating polynomial family. -/
structure OneSmallCutoffRow where
  triple : OneSmallTripleRow
  q1 phi1 q : ℚ
  M2 Mn M3 M4 M5 Mbs : ℚ
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

'''
chunks=[header]
for i,rec in enumerate(records):
 p=pairs[rec['pair']];s=triples[i]['s']
 triple=f"⟨{p['tau']}, {p['nu']}, {pair(p['a'])}, {pair(p['b'])}, {pair(s)}, {rec['cutoff']}⟩"
 fields=', '.join(rat(rec[k]) for k in ['q1','phi1','q','M2','Mn','M3','M4','M5','Mbs'])
 chunks.append(f'def oneSmallCutoffRow_{i} : OneSmallCutoffRow :=\n  ⟨{triple}, {fields}⟩\n\ntheorem oneSmallCutoffRow_{i}_valid : oneSmallCutoffRow_{i}.Valid := by\n  decide +kernel\n\n')
chunks.append('def oneSmallCutoffRows : List OneSmallCutoffRow :=\n  ['+',\n   '.join(f'oneSmallCutoffRow_{i}' for i in range(57))+']\n\n')
chunks.append('''/-- Every arithmetic row is kernel checked separately. -/
theorem oneSmallCutoffRows_valid (r : OneSmallCutoffRow)
    (hr : r ∈ oneSmallCutoffRows) : r.Valid := by
  simp only [oneSmallCutoffRows, List.mem_cons, List.mem_singleton] at hr
  rcases hr with '''+' | '.join('rfl' for i in range(57))+'\n')
chunks.extend(f'  · exact oneSmallCutoffRow_{i}_valid\n' for i in range(57))
chunks.append('''
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
''')
(root/'one_small_analytic_next/OneSmallCutoffArithmetic.lean').write_text(''.join(chunks))
