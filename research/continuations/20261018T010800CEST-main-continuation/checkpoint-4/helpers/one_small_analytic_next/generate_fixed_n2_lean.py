from pathlib import Path
from fractions import Fraction
import json
root=Path('/workspace/scratch/40edb97fa4c0')
rows=json.loads((root/'one_small_analytic_next/fixed_n2_certificates.json').read_text())
def rat(s):
 x=Fraction(s)
 return str(x.numerator) if x.denominator==1 else f'{x.numerator}/{x.denominator}'
def arr(x):return '!['+', '.join(arr(v) if isinstance(v,list) else rat(v) for v in x)+']'
s='''import D1Bound5.FiniteN2Height
import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5
open QuadInt

/-- Actual divided N2 root-column coefficients at a fixed pair. The
three values are the coefficients of c⁰,c¹,c² after evaluation in the
quadratic integer ring, before taking any norm. -/
def finiteN2FixedPolynomial {R : Type*} [CommRing R] (a b : R)
    (i : Fin 3) (j : Fin 2) : Fin 3 → R :=
  ![finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) a b,
    finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) a b,
    finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) a b]

/-- Exact square certificates for the coefficient normalization.
Below B²=25 the radius1000 is used; above it radius200B is used.
The last comparison retains the strict integer coefficient bound. -/
def FiniteN2FixedBound (r : OneSmallCutoffRow)
    (w : Fin 3 → Fin 2 → Fin 3 → ℚ) : Prop :=
  (∀ i j ell, 0 ≤ w i j ell) ∧
  (∀ i j ell,
    ((finiteN2FixedPolynomial r.triple.anchorA r.triple.anchorB i j ell).norm : ℚ) ≤
      if r.b0 ≤ 25 then
        (w i j ell)^2*r.b0^4*1000^(4-2*(ell : ℕ))
      else (w i j ell)^2*r.b0^(6-(ell : ℕ))*200^(4-2*(ell : ℕ))) ∧
  (∀ i, (101/100 : ℚ)*(∑ j, ∑ ell, w i j ell) < r.M2)

instance (r : OneSmallCutoffRow) (w : Fin 3 → Fin 2 → Fin 3 → ℚ) :
    Decidable (FiniteN2FixedBound r w) := by
  unfold FiniteN2FixedBound
  infer_instance

set_option maxRecDepth 100000
set_option maxHeartbeats 0

'''
for i,r in enumerate(rows):
 s+=f'def finiteN2CutoffWeights_{i} : Fin 3 → Fin 2 → Fin 3 → ℚ :=\n  '+arr(r['weights'])+'\n\n'
 s+=f'theorem finiteN2CutoffWeights_{i}_valid :\n    FiniteN2FixedBound oneSmallCutoffRow_{i} finiteN2CutoffWeights_{i} := by\n  decide +kernel\n\n'
s+='''/-- Each of the57 actual cutoff triples has exact coefficient-square
certificates for the manuscript's M2, computed from the proved N2
integer coefficient vectors. -/
theorem oneSmallCutoffRows_finiteN2FixedBound (r : OneSmallCutoffRow)
    (hr : r ∈ oneSmallCutoffRows) :
    ∃ w : Fin 3 → Fin 2 → Fin 3 → ℚ, FiniteN2FixedBound r w := by
  simp only [oneSmallCutoffRows, List.mem_cons, List.mem_singleton] at hr
  rcases hr with '''+' | '.join('rfl' for i in range(57))+'\n'
for i in range(57):s+=f'  · exact ⟨finiteN2CutoffWeights_{i},finiteN2CutoffWeights_{i}_valid⟩\n'
s+='''
end D1Bound5

#print axioms D1Bound5.oneSmallCutoffRows_finiteN2FixedBound
'''
(root/'one_small_analytic_next/OneSmallN2FixedArithmetic.lean').write_text(s)
