import D1Bound5.FiniteQIntegralRows
import D1Bound5.FiniteQHeight
import D1Bound5.FiniteQResidualBound
import D1Bound5.FiniteRowRootTransfer

namespace D1Bound5

def finiteQAnchors {R : Type*} (a b s t : R) : Fin 4 → R := ![a,b,s,t]

noncomputable def finiteQRowResidual (a b s t c : ℂ) (i : Fin 5) : ℂ :=
  finiteQDividedMatrix a b s t c i 0 +
    ∑ j : Fin 4, finiteQAnchors a b s t j * finiteQDividedMatrix a b s t c i j.succ *
      ((1+1/(finiteQAnchors a b s t j*c))^(1/2 : ℂ))

/-- Every one of the actual five rows has the uniform residual bound,
without a premise certifying its formal cancellations. -/
theorem finiteQRowResidual_norm_lt
    (a b s t c : ℂ) (A T : ℝ) (hA : 0 < A)
    (hlower : ∀ j, A ≤ ‖finiteQAnchors a b s t j‖)
    (hupper : ∀ j, ‖finiteQAnchors a b s t j‖ ≤ T)
    (hAC : 1000 ≤ A*‖c‖) (i : Fin 5) :
    ‖finiteQRowResidual a b s t c i‖ < 3*T/(2*A^2*‖c‖^4) := by
  have hab := finiteQResidual_norm_lt a b c A T hA (hlower 0) (hlower 1)
    (hupper 0) (hupper 1) hAC
  have has := finiteQResidual_norm_lt a s c A T hA (hlower 0) (hlower 2)
    (hupper 0) (hupper 2) hAC
  have hbs := finiteQResidual_norm_lt b s c A T hA (hlower 1) (hlower 2)
    (hupper 1) (hupper 2) hAC
  have hat := finiteQResidual_norm_lt a t c A T hA (hlower 0) (hlower 3)
    (hupper 0) (hupper 3) hAC
  have hbt := finiteQResidual_norm_lt b t c A T hA (hlower 1) (hlower 3)
    (hupper 1) (hupper 3) hAC
  fin_cases i
  · simpa [finiteQRowResidual, finiteQDividedMatrix, finiteQAnchors,
      finiteQResidual, Fin.sum_univ_succ, add_assoc] using hab
  · simpa [finiteQRowResidual, finiteQDividedMatrix, finiteQAnchors,
      finiteQResidual, Fin.sum_univ_succ, add_assoc] using has
  · simpa [finiteQRowResidual, finiteQDividedMatrix, finiteQAnchors,
      finiteQResidual, Fin.sum_univ_succ, add_assoc] using hbs
  · simpa [finiteQRowResidual, finiteQDividedMatrix, finiteQAnchors,
      finiteQResidual, Fin.sum_univ_succ, add_assoc] using hat
  · simpa [finiteQRowResidual, finiteQDividedMatrix, finiteQAnchors,
      finiteQResidual, Fin.sum_univ_succ, add_assoc] using hbt

theorem finiteQRowForm_eq_root_sum
    (a b s t c z rA rB rS rT : ℂ) (i : Fin 5) :
    finiteQRowForm a b s t c z rA rB rS rT i =
      finiteQDividedMatrix a b s t c i 0*z +
        ∑ j : Fin 4, finiteQDividedMatrix a b s t c i j.succ * ![rA,rB,rS,rT] j := by
  simp [finiteQRowForm, Matrix.mulVec, dotProduct, Fin.sum_univ_succ, add_assoc]

/-- The actual Q row has coefficient54 after the signed-root transfer.
Only the root error estimates are intermediate hypotheses here; its height
and residual estimates are derived from the constructed family. -/
theorem finiteQRowForm_norm_lt
    (a b s t c z rA rB rS rT : ℂ) (A T : ℝ) (hA : 0 < A) (hz : z ≠ 0)
    (hlower : ∀ j, A ≤ ‖finiteQAnchors a b s t j‖)
    (hupper : ∀ j, ‖finiteQAnchors a b s t j‖ ≤ T)
    (hAC : 1000 ≤ A*‖c‖)
    (herr : ∀ j : Fin 4,
      ‖((1+1/(finiteQAnchors a b s t j*c))^(1/2 : ℂ)) -
        ![rA,rB,rS,rT] j/(finiteQAnchors a b s t j*z)‖ ≤
          (3/2 : ℝ)*‖c‖/(‖finiteQAnchors a b s t j‖*‖z‖^2)) (i : Fin 5) :
    ‖finiteQRowForm a b s t c z rA rB rS rT i‖ <
      54*T^3*‖c‖^2/‖z‖+3*T*‖z‖/(2*A^2*‖c‖^4) := by
  have hT : 0 < T := (hA.trans_le (hlower 0)).trans_le (hupper 0)
  have hAT : A ≤ T := (hlower 0).trans (hupper 0)
  have hTC : 1 ≤ T*‖c‖ := by
    have hm := mul_le_mul_of_nonneg_right hAT (norm_nonneg c)
    linarith
  have ha (j : Fin 4) : finiteQAnchors a b s t j ≠ 0 :=
    norm_pos_iff.mp (hA.trans_le (hlower j))
  have hheight := finiteQDividedMatrix_root_height a b s t c T ‖c‖ hT.le
    (norm_nonneg c) (hupper 0) (hupper 1) (hupper 2) (hupper 3) le_rfl hTC i
  have hres := finiteQRowResidual_norm_lt a b s t c A T hA hlower hupper hAC i
  have h := finite_row_root_transfer_norm_lt
    (finiteQDividedMatrix a b s t c i 0) z (finiteQAnchors a b s t)
    (fun j => finiteQDividedMatrix a b s t c i j.succ)
    (fun j => (1+1/(finiteQAnchors a b s t j*c))^(1/2 : ℂ))
    ![rA,rB,rS,rT] ha hz ((3/2 : ℝ)*‖c‖) (36*T^3*‖c‖)
    (3*T/(2*A^2*‖c‖^4)) (by positivity) herr hheight hres
  rw [finiteQRowForm_eq_root_sum]
  convert h using 1 <;> ring

end D1Bound5
