import D1Bound5.FiniteN2IntegralRows
import D1Bound5.FiniteN2Height
import D1Bound5.FiniteN2Residual
import D1Bound5.FiniteRowRootTransfer

namespace D1Bound5

theorem finiteN2RowForm_eq_root_sum (x y c z sX sY : ℂ) (i : Fin 3) :
    finiteN2RowForm x y c z sX sY i =
      finiteN2Constant x y c i*z +
        ∑ j : Fin 2, ![finiteN2Left x y c i,finiteN2Right x y c i] j * ![sX,sY] j := by
  simp [finiteN2RowForm, finiteN2DividedMatrix, Matrix.mulVec, dotProduct,
    Fin.sum_univ_succ, add_assoc]

private theorem finiteN2RowForm_norm_lt_of_residual
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hz : z ≠ 0)
    (hXY : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2))
    (i : Fin 3) (R : ℝ) (hres : ‖finiteN2Residual x y c i‖ < R) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      243*‖y‖^4*‖c‖^3/‖z‖+R*‖z‖ := by
  have ha (j : Fin 2) : ![x,y] j ≠ 0 := by fin_cases j <;> assumption
  have hh := finiteN2_height_scaled x y c hy hXY hYC i
  have hheight : (∑ j : Fin 2, ‖![finiteN2Left x y c i,finiteN2Right x y c i] j‖) ≤
      (243*‖y‖^4*‖c‖^2)/(101/100 : ℝ) := by
    simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]
    apply (le_div_iff₀ (by norm_num : (0 : ℝ) < 101/100)).mpr
    nlinarith only [hh.le]
  have hres' : ‖finiteN2Constant x y c i +
      ∑ j : Fin 2, ![x,y] j * ![finiteN2Left x y c i,finiteN2Right x y c i] j *
        (1+1/(![x,y] j*c))^(1/2 : ℂ)‖ < R := by
    simpa [Fin.sum_univ_two, finiteN2Residual, add_assoc] using hres
  have h := finite_row_root_transfer_norm_lt (finiteN2Constant x y c i) z
    ![x,y] ![finiteN2Left x y c i,finiteN2Right x y c i]
    (fun j => (1+1/(![x,y] j*c))^(1/2 : ℂ)) ![sX,sY]
    ha hz ((101/100 : ℝ)*‖c‖) ((243*‖y‖^4*‖c‖^2)/(101/100 : ℝ)) R
    (by positivity) herr hheight hres'
  rw [finiteN2RowForm_eq_root_sum]
  convert h using 1 <;> ring

theorem finiteN2RowForm_norm_lt
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0)
    (hxy : x ≠ y) (hz : z ≠ 0) (hXY : ‖x‖ ≤ ‖y‖)
    (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      243*‖y‖^4*‖c‖^3/‖z‖ + (5/4 : ℝ)*‖y‖^2*‖z‖/(‖x‖^3*‖c‖^4) := by
  have hYC := hXC.trans (mul_le_mul_of_nonneg_right hXY (norm_nonneg c))
  have h := finiteN2RowForm_norm_lt_of_residual x y c z sX sY hx hy hz hXY hYC
    herr i _ (finiteN2_residual_norm_lt x y c hx hy hc hxy hXY hXC i)
  convert h using 1 <;> ring

theorem finiteN2RowForm_norm_lt_point
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0)
    (hxy : x ≠ y) (hz : z ≠ 0) (hXY : ‖x‖ ≤ ‖y‖)
    (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      243*‖y‖^4*‖c‖^3/‖z‖ +
        (101/2560 : ℝ)*max (‖x-y‖^4) (‖x‖*‖x-y‖^3)*‖z‖/
          (‖x‖^3*‖y‖^2*‖c‖^4) := by
  have hYC := hXC.trans (mul_le_mul_of_nonneg_right hXY (norm_nonneg c))
  have h := finiteN2RowForm_norm_lt_of_residual x y c z sX sY hx hy hz hXY hYC
    herr i _ (finiteN2_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i)
  convert h using 1 <;> ring

end D1Bound5
