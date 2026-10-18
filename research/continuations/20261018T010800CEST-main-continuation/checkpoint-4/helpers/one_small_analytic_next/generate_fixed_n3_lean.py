from pathlib import Path
from fractions import Fraction
import json
root=Path('/workspace/scratch/40edb97fa4c0')
def rat(s):
 x=Fraction(s)
 return str(x.numerator) if x.denominator==1 else f'{x.numerator}/{x.denominator}'
def arr(x):return '!['+', '.join(arr(v) if isinstance(v,list) else rat(v) for v in x)+']'
for mode,label in [('ab','Ab'),('bs','Bs')]:
 rows=json.loads((root/f'one_small_analytic_next/fixed_n3_{mode}_certificates.json').read_text())
 anchor1,anchor2,M=('anchorA','anchorB','Mn') if mode=='ab' else ('anchorB','anchorS','Mbs')
 s=f'''import D1Bound5.FiniteN3FixedHeight
import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5
open QuadInt

/- Exact evaluated N3 coefficient certificates on the {mode} anchors. -/
set_option maxRecDepth 100000
set_option maxHeartbeats 0

'''
 for i,r in enumerate(rows):
  s+=f'def finiteN3{label}CutoffWeights_{i} : Fin 3 → Fin 2 → Fin 4 → ℚ :=\n  '+arr(r['weights'])+'\n\n'
  s+=f'''theorem finiteN3{label}CutoffWeights_{i}_valid :
    FiniteN3FixedBound oneSmallCutoffRow_{i}.triple.{anchor1}
      oneSmallCutoffRow_{i}.triple.{anchor2} oneSmallCutoffRow_{i}.{M}
      finiteN3{label}CutoffWeights_{i} := by
  decide +kernel

'''
 s+=f'''/-- The actual printed fixed-triple rows have verified N3 coefficients
on the {mode} anchor pair, evaluated before taking norms. -/
theorem oneSmallCutoffRows_finiteN3{label}FixedBound (r : OneSmallCutoffRow)
    (hr : r ∈ oneSmallCutoffRows) :
    ∃ w : Fin 3 → Fin 2 → Fin 4 → ℚ,
      FiniteN3FixedBound r.triple.{anchor1} r.triple.{anchor2} r.{M} w := by
  simp only [oneSmallCutoffRows, List.mem_cons, List.mem_singleton] at hr
  rcases hr with '''+' | '.join('rfl' for i in range(57))+'\n'
 for i in range(57):s+=f'  · exact ⟨finiteN3{label}CutoffWeights_{i},finiteN3{label}CutoffWeights_{i}_valid⟩\n'
 s+=f'''
end D1Bound5

#print axioms D1Bound5.oneSmallCutoffRows_finiteN3{label}FixedBound
'''
 (root/f'one_small_analytic_next/OneSmallN3{label}FixedArithmetic.lean').write_text(s)
