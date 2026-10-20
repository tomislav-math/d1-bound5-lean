import D1Bound5.FinitePIntegralRows
import D1Bound5.FinitePHeight
import D1Bound5.FinitePResidualBound
import D1Bound5.FiniteRowRootTransfer

namespace D1Bound5

attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three

theorem finitePRowForm_eq_root_sum (a b s c z rA rB rS : ℂ) (i : Fin 4) :
    finitePRowForm a b s c z rA rB rS i =
      finitePDividedMatrix a b s c i 0*z+
        ∑ j : Fin 3, finitePRootColumn a b s c i j*![rA,rB,rS] j := by
  simp [finitePRowForm,finitePRootColumn,Matrix.mulVec,dotProduct,
    Fin.sum_univ_succ,add_assoc]

theorem finitePRowForm_norm_lt (a b s c z rA rB rS : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hz : z ≠ 0)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hC : 200 ≤ ‖c‖) (hAC : 1000 ≤ ‖a‖*‖c‖)
    (herr : ∀ j : Fin 3,
      ‖(1+1/(![a,b,s] j*c))^(1/2 : ℂ)-![rA,rB,rS] j/(![a,b,s] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![a,b,s] j‖*‖z‖^2)) (i : Fin 4) :
    ‖finitePRowForm a b s c z rA rB rS i‖ <
      2400*max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*‖c‖^3/‖z‖+
        3*‖s‖^2*‖z‖/(‖a‖^3*‖c‖^5) := by
  have hanchor (j : Fin 3) : ![a,b,s] j ≠ 0 := by fin_cases j <;> assumption
  have hh := finiteP_height_scaled a b s c hA hAB hBS hC i
  have hheight : (∑ j : Fin 3, ‖finitePRootColumn a b s c i j‖) ≤
      (2400*max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*‖c‖^2)/(101/100 : ℝ) := by
    apply (le_div_iff₀ (by norm_num : (0:ℝ)<101/100)).mpr
    nlinarith only [hh.le]
  have hres := finiteP_residual_norm_lt a b s c hA hAB hBS hAC i
  have h := finite_row_root_transfer_norm_lt (finitePDividedMatrix a b s c i 0) z
    ![a,b,s] (finitePRootColumn a b s c i)
    (fun j => (1+1/(![a,b,s] j*c))^(1/2 : ℂ)) ![rA,rB,rS]
    hanchor hz ((101/100 : ℝ)*‖c‖)
    ((2400*max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*‖c‖^2)/(101/100 : ℝ))
    (3*‖s‖^2/(‖a‖^3*‖c‖^5)) (by positivity) herr hheight
    (by simpa only [finitePResidual,finitePRootColumn] using hres)
  rw [finitePRowForm_eq_root_sum]
  convert h using 1 <;> ring

end D1Bound5
