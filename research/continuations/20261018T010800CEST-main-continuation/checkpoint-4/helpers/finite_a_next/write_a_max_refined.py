from pathlib import Path
from fractions import Fraction as F
b=Path('finite_a_next')
for k,alpha in [(3,F(707,40960)),(4,F(6363,409600)),(5,F(9999,2621440))]:
 p=3*k-3;aa=f'{alpha.numerator}/{alpha.denominator}';name=f'finiteA{k}'
 old=(b/f'FiniteA{k}HeightRefinement.lean').read_text()
 shared=old[old.index(f'theorem {name}RowForm_norm_lt_refined'):old.index('\nend D1Bound5')]
 shared=shared.replace('_norm_lt_refined','_norm_lt_max_distance').replace('_integer_refined','_integer_max_distance').replace('_inequality_of_height','_inequality_of_height_max_distance')
 shared=shared.replace('    (hdelta : ‖x‖ ≤ ‖x-y‖)\n','').replace('    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)\n','')
 shared=shared.replace(f'({aa} : ℝ)*‖x-y‖^{2*k} ≤ R*‖y‖^{2*k}',f'({aa} : ℝ)*max (‖x-y‖^{2*k}) (‖x‖*‖x-y‖^{2*k-1}) ≤ R*‖y‖^{2*k}')
 shared=shared.replace(f'({aa} : ℝ)*‖phi (x : K)-phi (y : K)‖^{2*k} ≤ R*‖phi (y : K)‖^{2*k}',f'({aa} : ℝ)*max (‖phi (x : K)-phi (y : K)‖^{2*k})\n      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^{2*k-1}) ≤ R*‖phi (y : K)‖^{2*k}')
 shared=shared.replace(' hdelta R hR',' R hR').replace(' hdelta hR',' hR')
 src=f'''import D1Bound5.FiniteA{k}Approximation
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- Actual A{k} residual without any separation assumption between A
and |a-b|. The maximum preserves all three distinct row factors. -/
theorem {name}_residual_norm_lt_max_distance (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (R : ℝ)
    (hR : ({aa} : ℝ)*max (‖x-y‖^{2*k}) (‖x‖*‖x-y‖^{2*k-1}) ≤ R*‖y‖^{2*k})
    (i : Fin 3) :
    ‖{name}Residual x y c i‖ < R*‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1}) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrowpos := norm_pos_iff.mpr ({name}RowFactor_ne_zero x y hx hy hxy i)
  let V := max (‖x-y‖^{2*k}) (‖x‖*‖x-y‖^{2*k-1})
  have hleft : ‖x-y‖^{2*k} ≤ V := le_max_left _ _
  have hright : ‖x‖*‖x-y‖^{2*k-1} ≤ V := le_max_right _ _
  have hV : 0 ≤ V := (pow_nonneg hD.le {2*k}).trans hleft
  have hrow : ‖x‖*‖x-y‖^{2*k} ≤ V*‖{name}RowFactor x y i‖ := by
    fin_cases i
    · have hh := mul_le_mul_of_nonneg_right hright hD.le
      simpa only [{name}RowFactor,Matrix.cons_val_zero] using
        (show ‖x‖*‖x-y‖^{2*k} ≤ V*‖x-y‖ by nlinarith only [hh])
    · have hh := mul_le_mul_of_nonneg_right hleft hX.le
      simpa [{name}RowFactor,mul_comm] using hh
    · have hh := mul_le_mul_of_nonneg_right hleft hX.le
      have hh' := mul_le_mul_of_nonneg_left hXY hV
      simpa [{name}RowFactor,mul_comm] using hh.trans hh'
  have hfrac : ‖x‖*‖x-y‖^{2*k}/‖{name}RowFactor x y i‖ ≤ V :=
    (div_le_iff₀ hrowpos).mpr hrow
  have hcoef : ({aa} : ℝ)*V/‖y‖^{2*k} ≤ R :=
    (div_le_iff₀ (by positivity)).mpr hR
  have hcoef' : ({aa} : ℝ)*(‖x‖*‖x-y‖^{2*k}/‖{name}RowFactor x y i‖)/‖y‖^{2*k} ≤ R := by
    apply le_trans _ hcoef
    exact div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hfrac (by norm_num)) (by positivity)
  apply ({name}_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ = (({aa} : ℝ)*(‖x‖*‖x-y‖^{2*k}/‖{name}RowFactor x y i‖)/‖y‖^{2*k})*
        (‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1})) := by
      field_simp [hX.ne',hY.ne',hC.ne',hrowpos.ne']
      <;> ring
    _ ≤ R*(‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1})) :=
      mul_le_mul_of_nonneg_right hcoef' (by positivity)
    _ = _ := by ring

'''+shared+'\nend D1Bound5\n'
 (b/f'FiniteA{k}MaxHeightRefinement.lean').write_text(src)
 old=(b/f'FiniteA{k}FixedInterval.lean').read_text()
 old=old.replace(f'FiniteA{k}HeightRefinement',f'FiniteA{k}MaxHeightRefinement').replace('_fixed_interval_of_bounds','_max_interval_of_bounds').replace('_inequality_of_height','_inequality_of_height_max_distance')
 old=old.replace('    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)\n','').replace(' hdelta hR',' hR')
 old=old.replace(f'({aa} : ℝ)*‖phi (x : K)-phi (y : K)‖^{2*k} ≤ R*‖phi (y : K)‖^{2*k}',f'({aa} : ℝ)*max (‖phi (x : K)-phi (y : K)‖^{2*k})\n      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^{2*k-1}) ≤ R*‖phi (y : K)‖^{2*k}')
 old=old.replace(f'(hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^{4*k-3}/',f'(hright : ‖phi (d : K)‖ ≤ ‖phi (x : K)‖^{2*k+2}*‖phi (c : K)‖^{4*k-3}/')
 marker='  · rw [heqhi]\n'
 old=old[:old.index(marker)]+marker+'    exact hright\n\nend D1Bound5\n'
 old=old.replace('/-- The complete fixed-anchor', '/-- The complete distance-sensitive').replace('and the explicit anchor-distance bound. Integrality supplies A≥1 in the\nupper endpoint; roots, signs, and nonzero row selection are constructed.','and the explicit maximum-distance bound. Every anchor power is preserved\nin the upper endpoint; roots, signs, and nonzero row selection are constructed.')
 (b/f'FiniteA{k}MaxInterval.lean').write_text(old)
print('Wrote6 max-distance A-family modules; no frozen files changed')
