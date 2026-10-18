from pathlib import Path
from fractions import Fraction as F
import re
b=Path('finite_a_next')
for k,M,R,beta,g in [(3,2265,'35/16',F(35,32768),4),(4,165763,'63/8',F(63,524288),2),(5,3113013,'495/64',F(495,33554432),4)]:
 p=3*k-3;m=k-1;alpha=F(101,100)*beta*4**k/g;aa=f'{alpha.numerator}/{alpha.denominator}'
 name=f'finiteA{k}'
 src=f'''import D1Bound5.FiniteA{k}Approximation
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual residual retains the evaluated anchor distance. The sole
extra comparison concerns explicit norms, and is verified by fixed-pair data. -/
theorem {name}_residual_norm_lt_refined (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (hdelta : ‖x‖ ≤ ‖x-y‖) (R : ℝ)
    (hR : ({aa} : ℝ)*‖x-y‖^{2*k} ≤ R*‖y‖^{2*k}) (i : Fin 3) :
    ‖{name}Residual x y c i‖ < R*‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1}) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hrow : ‖x‖ ≤ ‖{name}RowFactor x y i‖ := by
    fin_cases i
    · simpa [{name}RowFactor] using hdelta
    · simp [{name}RowFactor]
    · simpa [{name}RowFactor] using hXY
  have hrowpos : 0 < ‖{name}RowFactor x y i‖ := hX.trans_le hrow
  have hcoef : ({aa} : ℝ)*‖x-y‖^{2*k}/‖y‖^{2*k} ≤ R :=
    (div_le_iff₀ (by positivity)).mpr hR
  apply ({name}_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ = (({aa} : ℝ)*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{2*k-1}))/
        ‖{name}RowFactor x y i‖ := by ring
    _ ≤ (({aa} : ℝ)*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{2*k-1}))/‖x‖ := by
      apply div_le_div_of_nonneg_left (by positivity) hX hrow
    _ = (({aa} : ℝ)*‖x-y‖^{2*k}/‖y‖^{2*k})*
        (‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1})) := by
      field_simp [hX.ne',hY.ne',hC.ne']
      <;> ring
    _ ≤ R*(‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{2*k-1})) :=
      mul_le_mul_of_nonneg_right hcoef (by positivity)
    _ = _ := by ring

'''
 old=(b/f'FiniteA{k}Approximation.lean').read_text()
 row=old[old.index(f'theorem {name}RowForm_norm_lt'):old.index('/-- The actual')]
 row=re.sub(r'\bR\b','Lright',row)
 row=row.replace(f'{name}RowForm_norm_lt',f'{name}RowForm_norm_lt_refined')
 row=row.replace(f'(i : Fin 3) :',f'''(i : Fin 3) (M R : ℝ)
    (hheight : (101/100 : ℝ)*(‖{name}Left x y c i‖+‖{name}Right x y c i‖) <
      M*‖y‖^{p}*‖c‖^{k})
    (hdelta : ‖x‖ ≤ ‖x-y‖)
    (hR : ({aa} : ℝ)*‖x-y‖^{2*k} ≤ R*‖y‖^{2*k}) :''')
 row=row.replace(str(M)+'*','M*').replace(f'({R} : ℝ)', 'R')
 row=row.replace(f'  have hheight := {name}_height_scaled x y c hy hXY hYC i\n','')
 row=row.replace(f'({name}_residual_norm_lt x y c hx hy hc hxy hXY hXC i)',f'({name}_residual_norm_lt_refined x y c hx hy hc hxy hXY hXC hdelta R hR i)')
 src+=row
 full=old[old.index('/-- The actual'):old.index('\nend D1Bound5')]
 full=full[full.index('theorem '):]
 full=full.replace(f'full_ring_{name}_integer',f'full_ring_{name}_integer_refined')
 marker='    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) :'
 full=full.replace(marker,marker[:-2]+f'''
    (M R : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖{name}Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖{name}Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^{p}*‖phi (c : K)‖^{k})
    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)
    (hR : ({aa} : ℝ)*‖phi (x : K)-phi (y : K)‖^{2*k} ≤ R*‖phi (y : K)‖^{2*k}) :''')
 full=full.replace(str(M)+'*','M*').replace(f'({R} : ℝ)', 'R')
 full=full.replace(f'{name}RowForm_norm_lt (',f'{name}RowForm_norm_lt_refined (')
 full=full.replace('hXY hXC herrorX herrorY i)','hXY hXC herrorX herrorY i M R (hheight i) hdelta hR)')
 src+=f'/-- Full-ring root transfer with proved evaluated height and distance constants. -/\n'+full+'\n'
 src+=f'''
/-- Finite-set version of the actual refined A{k} inequality. -/
theorem full_ring_{name}_inequality_of_height
    {{K : Type*}} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {{S : Finset (𝓞 K)}} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M R : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖{name}Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖{name}Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^{p}*‖phi (c : K)‖^{k})
    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)
    (hR : ({aa} : ℝ)*‖phi (x : K)-phi (y : K)‖^{2*k} ≤ R*‖phi (y : K)‖^{2*k}) :
    ∃ z : 𝓞 K, z^2=c*d+1 ∧
      1 < M*‖phi (y : K)‖^{p}*‖phi (c : K)‖^{k+1}/‖phi (z : K)‖+
        R*‖phi (y : K)‖^{k}*‖phi (z : K)‖/(‖phi (x : K)‖^{k+1}*‖phi (c : K)‖^{2*k-1}) := by
  obtain ⟨rX,hrX⟩ := hS.2 x hxS c hcS hxc
  obtain ⟨rY,hrY⟩ := hS.2 y hyS c hcS hyc
  obtain ⟨vX,hvX⟩ := hS.2 x hxS d hdS hxd
  obtain ⟨vY,hvY⟩ := hS.2 y hyS d hdS hyd
  obtain ⟨z,hz⟩ := hS.2 c hcS d hdS hcd
  have hz' : z^2=c*d+1 := by simpa only [pow_two] using hz
  refine ⟨z,hz',?_⟩
  exact full_ring_{name}_integer_refined hK phi x y c d rX rY vX vY z
    (hS.1 x hxS) (hS.1 y hyS) (hS.1 c hcS) (hS.1 d hdS) hxy
    (by simpa only [pow_two] using hrX) (by simpa only [pow_two] using hrY)
    (by simpa only [pow_two] using hvX) (by simpa only [pow_two] using hvY)
    hz' hXY hXC hCY M R hheight hdelta hR

end D1Bound5
'''
 (b/f'FiniteA{k}HeightRefinement.lean').write_text(src)
 print(k,'alpha',aa)
