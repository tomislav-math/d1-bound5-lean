import D1Bound5.MixedSignedRootAdjugate
import D1Bound5.WeightedSchur
import D1Bound5.ReferencePerturbation
open scoped Matrix.Norms.L2Operator
open Matrix
namespace D1Bound5

theorem mixed_four_det_ne_zero_of_entry_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, F i i = 0)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    F.det ≠ 0 := by
  have hd : ∀ i, (F - halfOffDiagonal) i i = 0 := by
    intro i
    simpa [Matrix.sub_apply, halfOffDiagonal, hdiag i]
  have hf : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖(F - halfOffDiagonal) i j‖ < (1/18 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hfirst i j hij hz
  have hl : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖(F - halfOffDiagonal) i j‖ < (1/64 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hlater i j hij hz
  have hnear : ‖F - halfOffDiagonal‖ ≤ (11/96 : ℝ) :=
    mixedFour_operator_norm_le (F - halfOffDiagonal) hd hf hl
  have hsmall :
      ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖ < 1 := by
    calc
      ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖
          ≤ ‖halfOffDiagonalInverse‖ * ‖F - halfOffDiagonal‖ :=
            Matrix.l2_opNorm_mul _ _
      _ = 2 * ‖F - halfOffDiagonal‖ := by rw [halfOffDiagonalInverse_norm]
      _ ≤ 2 * (11/96 : ℝ) :=
        mul_le_mul_of_nonneg_left hnear (by norm_num)
      _ < 1 := by norm_num
  exact reference_perturbed_det_ne_zero F hsmall

#print axioms D1Bound5.mixed_four_det_ne_zero_of_entry_bounds
end D1Bound5
