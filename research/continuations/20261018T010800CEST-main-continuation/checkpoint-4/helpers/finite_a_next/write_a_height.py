from pathlib import Path
BASE=Path('finite_a_next')
for k,m,g,M in [(3,2,4,2265),(4,3,2,165763),(5,4,4,3113013)]:
 n=f'finiteA{k}';d0=m+k-2
 src=f'''import D1Bound5.FiniteA{k}Coefficients
import D1Bound5.FinitePolynomialHeight

namespace D1Bound5

/-- Each exact homogeneous coefficient pair has its own checked height. -/
theorem {n}_root_coefficient_norm_le (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin {k+1}) :
    ‖{n}RootCoeff x y i 0 ell‖+‖{n}RootCoeff x y i 1 ell‖ ≤
      ({n}CoefficientSums i ell : ℝ)*‖y‖^({d0}+(ell : ℕ)) := by
  fin_cases ell
'''
 for ell in range(k+1):
  src+=f'''  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le {d0+ell} ({n}Coeff{ell} i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le {d0+ell} ({n}Coeff{ell} i 1) x y hxy)
    rw [← add_mul,{n}_coefficient_sums_{ell}] at hh
    simpa only [{n}RootCoeff,Fin.isValue,Matrix.cons_val_zero,Matrix.cons_val_one,
      Matrix.cons_val,Matrix.head_cons,Matrix.tail_cons,Fin.reduceFinMk] using hh
'''
 src+=f'''
theorem {n}_coefficient_sums_nonneg (i : Fin 3) (ell : Fin {k+1}) :
    0 ≤ ({n}CoefficientSums i ell : ℝ) := by
  fin_cases i <;> fin_cases ell <;> norm_num [{n}CoefficientSums]

/-- Exact rational row checks preserve the manuscript's sharp M={M}. -/
theorem {n}_height_slack (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin {k+1},
      ({n}CoefficientSums i ell : ℝ)/(1000 : ℝ)^({k}-(ell : ℕ))) < {M} := by
  fin_cases i <;> norm_num [{n}CoefficientSums,Fin.sum_univ_succ]

theorem {n}_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖{n}Left x y c i‖+‖{n}Right x y c i‖ ≤
      ‖y‖^{d0}*∑ ell : Fin {k+1}, ({n}CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  have h0 := {n}_root_coeff_decomposition x y c i 0
  have h1 := {n}_root_coeff_decomposition x y c i 1
  change {n}Left x y c i = _ at h0
  change {n}Right x y c i = _ at h1
  rw [h0,h1]
  exact finitePolynomial_two_columns_norm_le {k} {d0} ({n}RootCoeff x y i)
    (fun ell => ({n}CoefficientSums i ell : ℝ)) c ‖y‖
    ({n}_root_coefficient_norm_le x y hxy i)

/-- Actual integral A{k} root-column height. No coefficient table or bound
is an input hypothesis: all coefficients and the strict margin are proved. -/
theorem {n}_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖{n}Left x y c i‖+‖{n}Right x y c i‖) <
      {M}*‖y‖^{d0+k}*‖c‖^{k} := by
  have hnorm := mul_le_mul_of_nonneg_left ({n}_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar {k}
    (fun ell => ({n}CoefficientSums i ell : ℝ)) ({n}_coefficient_sums_nonneg i)
    {M} (‖y‖*‖c‖) hYC ({n}_height_slack i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) {d0})
  have heq : (101/100 : ℝ)*(‖y‖^{d0}*∑ ell : Fin {k+1},
      ({n}CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
      {M}*‖y‖^{d0+k}*‖c‖^{k} := by
    convert hm using 1 <;> ring
  exact hnorm.trans_lt heq

end D1Bound5
'''
 # Use ordinary simp on a concrete finite vector rather than API-specific simp lemmas.
 import re
 src=re.sub(r'simpa only \['+n+r'RootCoeff,Fin.isValue,Matrix.cons_val_zero,Matrix.cons_val_one,\n      Matrix.cons_val,Matrix.head_cons,Matrix.tail_cons,Fin.reduceFinMk\] using hh',f'simpa [{n}RootCoeff] using hh',src)
 (BASE/f'FiniteA{k}Height.lean').write_text(src)
 print(f'A{k} height {M} source generated')
