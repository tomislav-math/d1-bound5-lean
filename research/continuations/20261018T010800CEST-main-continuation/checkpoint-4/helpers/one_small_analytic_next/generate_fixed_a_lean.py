from pathlib import Path
from fractions import Fraction
import json
root=Path('/workspace/scratch/40edb97fa4c0')
def rat(s):
 x=Fraction(s)
 return str(x.numerator) if x.denominator==1 else f'{x.numerator}/{x.denominator}'
def arr(x):return '!['+', '.join(arr(v) if isinstance(v,list) else rat(v) for v in x)+']'
for k in [3,4,5]:
 rows=json.loads((root/f'one_small_analytic_next/fixed_a{k}_certificates.json').read_text())
 s=f'''import D1Bound5.FiniteA{k}FixedHeight
import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5
open QuadInt

/- Each exact square certificate evaluates the actual divided A{k} root
coefficient in the quadratic integer ring before taking its field norm.
It then checks the printed M{k} with a strict rational row-sum comparison. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 0

'''
 for i,r in enumerate(rows):
  s+=f'def finiteA{k}CutoffWeights_{i} : Fin 3 → Fin 2 → Fin {k+1} → ℚ :=\n  '+arr(r['weights'])+'\n\n'
  s+=f'''theorem finiteA{k}CutoffWeights_{i}_valid :
    FiniteA{k}FixedBound oneSmallCutoffRow_{i}.triple.anchorA
      oneSmallCutoffRow_{i}.triple.anchorB oneSmallCutoffRow_{i}.M{k}
      finiteA{k}CutoffWeights_{i} := by
  decide +kernel

'''
 s+=f'''/-- The actual printed fixed-triple rows have verified A{k} coefficients. -/
theorem oneSmallCutoffRows_finiteA{k}FixedBound (r : OneSmallCutoffRow)
    (hr : r ∈ oneSmallCutoffRows) :
    ∃ w : Fin 3 → Fin 2 → Fin {k+1} → ℚ,
      FiniteA{k}FixedBound r.triple.anchorA r.triple.anchorB r.M{k} w := by
  simp only [oneSmallCutoffRows, List.mem_cons, List.mem_singleton] at hr
  rcases hr with '''+' | '.join('rfl' for i in range(57))+'\n'
 for i in range(57):s+=f'  · exact ⟨finiteA{k}CutoffWeights_{i},finiteA{k}CutoffWeights_{i}_valid⟩\n'
 s+=f'''
end D1Bound5

#print axioms D1Bound5.oneSmallCutoffRows_finiteA{k}FixedBound
'''
 (root/f'one_small_analytic_next/OneSmallA{k}FixedArithmetic.lean').write_text(s)
