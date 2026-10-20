import D1Bound5.FiniteA5Coefficients
import D1Bound5.FinitePolynomialHeight

namespace D1Bound5

/-- Each exact homogeneous coefficient pair has its own checked height. -/
theorem finiteA5_root_coefficient_norm_le (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin 6) :
    ‖finiteA5RootCoeff x y i 0 ell‖+‖finiteA5RootCoeff x y i 1 ell‖ ≤
      (finiteA5CoefficientSums i ell : ℝ)*‖y‖^(7+(ell : ℕ)) := by
  fin_cases ell
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 7 (finiteA5Coeff0 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 7 (finiteA5Coeff0 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_0] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 8 (finiteA5Coeff1 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 8 (finiteA5Coeff1 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_1] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 9 (finiteA5Coeff2 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 9 (finiteA5Coeff2 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_2] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 10 (finiteA5Coeff3 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 10 (finiteA5Coeff3 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_3] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 11 (finiteA5Coeff4 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 11 (finiteA5Coeff4 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_4] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh
  · have hh := add_le_add
      (finiteHomogeneousTwo_norm_le 12 (finiteA5Coeff5 i 0) x y hxy)
      (finiteHomogeneousTwo_norm_le 12 (finiteA5Coeff5 i 1) x y hxy)
    rw [← add_mul,finiteA5_coefficient_sums_5] at hh
    simpa [finiteA5RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons] using hh

theorem finiteA5_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 6) :
    0 ≤ (finiteA5CoefficientSums i ell : ℝ) := by
  fin_cases i <;> fin_cases ell <;> norm_num [finiteA5CoefficientSums, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

/-- Exact rational row checks preserve the manuscript's sharp M=3113013. -/
theorem finiteA5_height_slack (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 6,
      (finiteA5CoefficientSums i ell : ℝ)/(1000 : ℝ)^(5-(ell : ℕ))) < 3113013 := by
  fin_cases i <;> norm_num [finiteA5CoefficientSums,Fin.sum_univ_succ]

theorem finiteA5_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖ ≤
      ‖y‖^7*∑ ell : Fin 6, (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  have h0 := finiteA5_root_coeff_decomposition x y c i 0
  have h1 := finiteA5_root_coeff_decomposition x y c i 1
  change finiteA5Left x y c i = _ at h0
  change finiteA5Right x y c i = _ at h1
  rw [h0,h1]
  exact finitePolynomial_two_columns_norm_le 5 7 (finiteA5RootCoeff x y i)
    (fun ell => (finiteA5CoefficientSums i ell : ℝ)) c ‖y‖
    (finiteA5_root_coefficient_norm_le x y hxy i)

/-- Actual integral A5 root-column height. No coefficient table or bound
is an input hypothesis: all coefficients and the strict margin are proved. -/
theorem finiteA5_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖) <
      3113013*‖y‖^12*‖c‖^5 := by
  have hnorm := mul_le_mul_of_nonneg_left (finiteA5_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 5
    (fun ell => (finiteA5CoefficientSums i ell : ℝ)) (finiteA5_coefficient_sums_nonneg i)
    3113013 (‖y‖*‖c‖) hYC (finiteA5_height_slack i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 7)
  have heq : (101/100 : ℝ)*(‖y‖^7*∑ ell : Fin 6,
      (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) <
      3113013*‖y‖^12*‖c‖^5 := by
    calc
      (101/100 : ℝ)*(‖y‖^7*∑ ell : Fin 6,
          (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ)) =
          ‖y‖^7*((101/100 : ℝ)*(∑ ell : Fin 6,
            (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ))) := by ring
      _ < ‖y‖^7*(3113013*(‖y‖*‖c‖)^5) := hm
      _ = 3113013*‖y‖^12*‖c‖^5 := by ring
  exact hnorm.trans_lt heq

end D1Bound5
