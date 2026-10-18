import D1Bound5.FiniteMIntegralRows
import D1Bound5.FiniteMHeight
import D1Bound5.FiniteMResidual
import D1Bound5.FiniteRowRootTransfer

namespace D1Bound5

def finiteMAnchors {R : Type*} (a b s : R) : Fin 3 → R := ![a,b,s]

theorem finiteMResidual_eq_root_sum (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0) (i : Fin 4) :
    finiteMResidual a b s c i = finiteMDividedMatrix a b s c i 0+
      ∑ j : Fin 3, finiteMAnchors a b s j*finiteMDividedMatrix a b s c i j.succ*
        (1+1/(finiteMAnchors a b s j*c))^(1/2 : ℂ) := by
  have hnode (j : Fin 3) : finiteMNodes a b s j.succ*(a*b*s*c)⁻¹ =
      1/(finiteMAnchors a b s j*c) := by
    fin_cases j <;> simp only [finiteMNodes,finiteMAnchors,Matrix.cons_val_zero,Matrix.cons_val_succ]
    all_goals field_simp [ha,hb,hs,hc]
    all_goals ring
  have hcol (j : Fin 3) : finiteMMatrix a b s c i j.succ =
      finiteMDividedMatrix a b s c i j.succ*finiteMAnchors a b s j := by
    fin_cases j <;> simp [finiteMMatrix,Matrix.mul_diagonal,finiteMAnchors]
  unfold finiteMResidual
  rw [Fin.sum_univ_succ]
  have hfirst : finiteMMatrix a b s c i 0*
      (1+finiteMNodes a b s 0*(a*b*s*c)⁻¹)^(1/2 : ℂ) = finiteMDividedMatrix a b s c i 0 := by
    simp [finiteMMatrix,Matrix.mul_diagonal,finiteMNodes]
  rw [hfirst]
  congr 1
  apply Finset.sum_congr rfl
  intro j _
  rw [hnode,hcol]
  ring

theorem finiteMRowForm_eq_root_sum (a b s c z rA rB rS : ℂ) (i : Fin 4) :
    finiteMRowForm a b s c z rA rB rS i =
      finiteMDividedMatrix a b s c i 0*z+
        ∑ j : Fin 3, finiteMDividedMatrix a b s c i j.succ*![rA,rB,rS] j := by
  simp [finiteMRowForm,Matrix.mulVec,dotProduct,Fin.sum_univ_succ,add_assoc]

/-- Transfer the actual ordinary-three order-two residual to the
original integral row, using its proved finite coefficient height. -/
theorem finiteMRowForm_norm_lt
    (a b s c z rA rB rS : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hC : 1 ≤ ‖c‖) (hAC : 1000 ≤ ‖a‖*‖c‖)
    (herr : ∀ j : Fin 3,
      ‖(1+1/(finiteMAnchors a b s j*c))^(1/2 : ℂ)-
        ![rA,rB,rS] j/(finiteMAnchors a b s j*z)‖ ≤
          (3/2 : ℝ)*‖c‖/(‖finiteMAnchors a b s j‖*‖z‖^2)) (i : Fin 4) :
    ‖finiteMRowForm a b s c z rA rB rS i‖ <
      (8/9 : ℝ)*608^2*‖b‖^3*‖s‖^8*‖c‖^3/‖z‖+
        (3920/81 : ℝ)*‖b‖^2*‖s‖^5*‖z‖/(‖a‖^3*‖c‖^6) := by
  have hheight := finiteMDividedMatrix_root_height a b s c (hA.trans hAB) hAB hBS hC i
  have hres := finiteM_residual_norm_lt a b s c ha hb hs hc hab has hbs hA hAB hBS hAC i
  rw [finiteMResidual_eq_root_sum a b s c ha hb hs hc i] at hres
  have hanchors : ∀ j, finiteMAnchors a b s j ≠ 0 := by
    intro j
    fin_cases j
    · exact ha
    · exact hb
    · exact hs
  have hh := finite_row_root_transfer_norm_lt (finiteMDividedMatrix a b s c i 0) z
    (finiteMAnchors a b s) (fun j => finiteMDividedMatrix a b s c i j.succ)
    (fun j => (1+1/(finiteMAnchors a b s j*c))^(1/2 : ℂ)) ![rA,rB,rS]
    hanchors hz ((3/2 : ℝ)*‖c‖) (169728*‖b‖^3*‖s‖^8*‖c‖^2)
    ((3920/81 : ℝ)*‖b‖^2*‖s‖^5/(‖a‖^3*‖c‖^6)) (by positivity) herr hheight hres
  rw [finiteMRowForm_eq_root_sum]
  apply hh.trans
  have hp : 0 < ‖b‖^3*‖s‖^8*‖c‖^3/‖z‖ := by
    exact div_pos (mul_pos (mul_pos (pow_pos (norm_pos_iff.mpr hb) 3)
      (pow_pos (norm_pos_iff.mpr hs) 8)) (pow_pos (norm_pos_iff.mpr hc) 3)) (norm_pos_iff.mpr hz)
  have hcoef : (254592 : ℝ)*(‖b‖^3*‖s‖^8*‖c‖^3/‖z‖) <
      ((8/9 : ℝ)*608^2)*(‖b‖^3*‖s‖^8*‖c‖^3/‖z‖) :=
    mul_lt_mul_of_pos_right (by norm_num) hp
  nlinarith only [hcoef]

end D1Bound5
