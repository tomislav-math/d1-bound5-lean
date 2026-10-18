import D1Bound5.FiniteA4Coefficients
import D1Bound5.FinitePolynomialHeight

namespace D1Bound5

/-- Each exact homogeneous coefficient pair has its own checked height. -/
theorem finiteA4_root_coefficient_norm_le (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin 5) :
    ‖finiteA4RootCoeff x y i 0 ell‖+‖finiteA4RootCoeff x y i 1 ell‖ ≤
      (finiteA4CoefficientSums i ell : ℝ)*‖y‖^(5+(ell : ℕ)) := by
  fin_cases ell
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 5 (finiteA4Coeff0 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 5 (finiteA4Coeff0 i 1) x y hxy)
    rw [← add_mul,finiteA4_coefficient_sums_0] at hh
    simpa [finiteA4RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 6 (finiteA4Coeff1 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 6 (finiteA4Coeff1 i 1) x y hxy)
    rw [← add_mul,finiteA4_coefficient_sums_1] at hh
    simpa [finiteA4RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 7 (finiteA4Coeff2 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 7 (finiteA4Coeff2 i 1) x y hxy)
    rw [← add_mul,finiteA4_coefficient_sums_2] at hh
    simpa [finiteA4RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 8 (finiteA4Coeff3 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 8 (finiteA4Coeff3 i 1) x y hxy)
    rw [← add_mul,finiteA4_coefficient_sums_3] at hh
    simpa [finiteA4RootCoeff] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 9 (finiteA4Coeff4 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 9 (finiteA4Coeff4 i 1) x y hxy)
    rw [← add_mul,finiteA4_coefficient_sums_4] at hh
    simpa [finiteA4RootCoeff] using hh

theorem finiteA4_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 5) :
    0 ≤ (finiteA4CoefficientSums i ell : ℝ) := by
  fin_cases i <;> fin_cases ell <;> norm_num [finiteA4CoefficientSums]

/-- Exact rational row checks preserve the manuscript's sharp M=165763. -/
theorem finiteA4_height_slack (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 5,
      (finiteA4CoefficientSums i ell : ℝ)/(1000 : ℝ)^(4-(ell : ℕ))) < 165763 := by
  fin_cases i <;> norm_num [finiteA4CoefficientSums,Fin.sum_univ_succ]

theorem finiteA4_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖ ≤
      ‖y‖^5*∑ ell : Fin 5, (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  have h0 := finiteA4_root_coeff_decomposition x y c i 0
  have h1 := finiteA4_root_coeff_decomposition x y c i 1
  change finiteA4Left x y c i = _ at h0
  change finiteA4Right x y c i = _ at h1
  rw [h0,h1]
  exact finitePolynomial_two_columns_norm_le 4 5 (finiteA4RootCoeff x y i)
    (fun ell => (finiteA4CoefficientSums i ell : ℝ)) c ‖y‖
    (finiteA4_root_coefficient_norm_le x y hxy i)

/-- Actual integral A4 root-column height. No coefficient table or bound
is an input hypothesis: all coefficients and the strict margin are proved. -/
theorem finiteA4_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖) <
      165763*‖y‖^9*‖c‖^4 := by
  have hnorm := mul_le_mul_of_nonneg_left (finiteA4_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 4
    (fun ell => (finiteA4CoefficientSums i ell : ℝ)) (finiteA4_coefficient_sums_nonneg i)
    165763 (‖y‖*‖c‖) hYC (finiteA4_height_slack i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 5)
  have heq : (101/100 : ℝ)*(‖y‖^5*∑ ell : Fin 5,
      (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
      165763*‖y‖^9*‖c‖^4 := by
    convert hm using 1 <;> ring
  exact hnorm.trans_lt heq

end D1Bound5
