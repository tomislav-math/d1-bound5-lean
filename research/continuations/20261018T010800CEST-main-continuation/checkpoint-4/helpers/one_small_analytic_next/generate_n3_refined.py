from pathlib import Path
src=Path('finite_n3_next/FiniteN3Approximation.lean').read_text()
start=src.index('theorem finiteN3RowForm_norm_lt ')
body=src[start:src.rindex('end D1Bound5')]
body=body.replace('finiteN3RowForm_norm_lt','finiteN3RowForm_norm_lt_refined')
body=body.replace('full_ring_finiteN3_integer','full_ring_finiteN3_integer_refined')
body=body.replace('4143','M').replace('(35/32 : ℝ)','Rbound')
body=body.replace('''      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) :''','''      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2))
    (M Rbound : ℝ)
    (hheightBound : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖) <
        M*‖y‖^7*‖c‖^3)
    (hdistance : (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤ Rbound*‖y‖^6)
    (i : Fin 3) :''')
body=body.replace('have hheight := finiteN3_height_scaled x y c hy hXY hYC i','have hheight := hheightBound i')
body=body.replace('(finiteN3_residual_norm_lt x y c hx hy hc hxy hXY hXC i)','(finiteN3_residual_norm_lt_refined x y c hx hy hc hxy hXY hXC Rbound hdistance i)')
body=body.replace('''    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) :''','''    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M Rbound : ℝ)
    (hheightBound : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^7*‖phi (c : K)‖^3)
    (hdistance : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤ Rbound*‖phi (y : K)‖^6) :''')
body=body.replace('hx\' hy\' hc\' hz\' hxy\' hXY hXC herrorX herrorY i)','hx\' hy\' hc\' hz\' hxy\' hXY hXC herrorX herrorY M Rbound hheightBound hdistance i)')
head='''import D1Bound5.FiniteN3Approximation
import D1Bound5.FiniteN3RefinedResidual

open scoped NumberField
open Module

namespace D1Bound5

/- The fixed-pair specialization retains the same actual integral row
and signed tuple-root construction as the uniform N3 theorem. Only its
proved coefficient height and exact distance enclosure are parameters. -/
'''
Path('one_small_analytic_next/FiniteN3HeightRefinement.lean').write_text(head+body+'''end D1Bound5

#print axioms D1Bound5.finiteN3RowForm_norm_lt_refined
#print axioms D1Bound5.full_ring_finiteN3_integer_refined
''')
