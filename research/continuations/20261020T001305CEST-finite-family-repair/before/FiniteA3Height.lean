import D1Bound5.FiniteA3Coefficients
import D1Bound5.FinitePolynomialHeight

namespace D1Bound5

/-- Each exact homogeneous coefficient pair has its own checked height. -/
theorem finiteA3_root_coefficient_norm_le (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin 4) :
    ‖finiteA3RootCoeff x y i 0 ell‖+‖finiteA3RootCoeff x y i 1 ell‖ ≤
      (finiteA3CoefficientSums i ell : ℝ)*‖y‖^(3+(ell : ℕ)) := by
  fin_cases ell
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 3 (finiteA3Coeff0 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 3 (finiteA3Coeff0 i 1) x y hxy)
    rw [← add_mul,finiteA3_coefficient_sums_0] at hh
    simpa [finiteA3RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 4 (finiteA3Coeff1 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 4 (finiteA3Coeff1 i 1) x y hxy)
    rw [← add_mul,finiteA3_coefficient_sums_1] at hh
    simpa [finiteA3RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 5 (finiteA3Coeff2 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 5 (finiteA3Coeff2 i 1) x y hxy)
    rw [← add_mul,finiteA3_coefficient_sums_2] at hh
    simpa [finiteA3RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 6 (finiteA3Coeff3 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 6 (finiteA3Coeff3 i 1) x y hxy)
    rw [← add_mul,finiteA3_coefficient_sums_3] at hh
    simpa [finiteA3RootCoeff] using hh

theorem finiteA3_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 4) :
    0 ≤ (finiteA3CoefficientSums i ell : ℝ) := by
  fin_cases i <;> fin_cases ell <;> norm_num [finiteA3CoefficientSums]

/-- Exact rational row checks preserve the manuscript's sharp M=2265. -/
theorem finiteA3_height_slack (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 4,
      (finiteA3CoefficientSums i ell : ℝ)/(1000 : ℝ)^(3-(ell : ℕ))) < 2265 := by
  fin_cases i <;> norm_num [finiteA3CoefficientSums,Fin.sum_univ_succ]

theorem finiteA3_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteA3Left x y c i‖+‖finiteA3Right x y c i‖ ≤
      ‖y‖^3*∑ ell : Fin 4, (finiteA3CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  have h0 := finiteA3_root_coeff_decomposition x y c i 0
  have h1 := finiteA3_root_coeff_decomposition x y c i 1
  change finiteA3Left x y c i = _ at h0
  change finiteA3Right x y c i = _ at h1
  rw [h0,h1]
  exact finitePolynomial_two_columns_norm_le 3 3 (finiteA3RootCoeff x y i)
    (fun ell => (finiteA3CoefficientSums i ell : ℝ)) c ‖y‖
    (finiteA3_root_coefficient_norm_le x y hxy i)

/-- Actual integral A3 root-column height. No coefficient table or bound
is an input hypothesis: all coefficients and the strict margin are proved. -/
theorem finiteA3_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA3Left x y c i‖+‖finiteA3Right x y c i‖) <
      2265*‖y‖^6*‖c‖^3 := by
  have hnorm := mul_le_mul_of_nonneg_left (finiteA3_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 3
    (fun ell => (finiteA3CoefficientSums i ell : ℝ)) (finiteA3_coefficient_sums_nonneg i)
    2265 (‖y‖*‖c‖) hYC (finiteA3_height_slack i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 3)
  have heq : (101/100 : ℝ)*(‖y‖^3*∑ ell : Fin 4,
      (finiteA3CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
      2265*‖y‖^6*‖c‖^3 := by
    convert hm using 1 <;> ring
  exact hnorm.trans_lt heq

end D1Bound5
