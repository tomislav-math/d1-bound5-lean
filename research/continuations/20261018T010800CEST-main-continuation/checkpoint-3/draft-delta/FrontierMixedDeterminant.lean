import D1Bound5.FrontierMixedCofactors
import D1Bound5.FrontierLargeNumeric

open scoped NumberField Matrix.Norms.L2Operator BigOperators
open Matrix Module

namespace D1Bound5

/-- The mixed six-variable cofactor bounds apply to any symmetric
zero-diagonal matrix with the designated first-row error envelope. -/
theorem frontier_mixed_matrix_bounds (F : Matrix (Fin 4) (Fin 4) ℂ) (k l : ℝ)
    (hl : (1/2 : ℝ) ≤ l) (hlk : l ≤ k)
    (hd : ∀ i, F i i = 0) (hs : ∀ i j, F i j = F j i)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j-(1/2 : ℂ)‖ ≤ k-1/2)
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j-(1/2 : ℂ)‖ ≤ l-1/2) :
    ‖F.det‖ ≤ 9*k^2*l^2 ∧
    ∀ i j, ‖F.adjugate i j‖ ≤ if i = j then 2*(k^2*l) else 3*(k^2*l)-1/4 := by
  have hrepr : F =
      !![0,F 0 1,F 0 2,F 0 3;
         F 0 1,0,F 1 2,F 1 3;
         F 0 2,F 1 2,0,F 2 3;
         F 0 3,F 1 3,F 2 3,0] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      (simp (config := {decide := true}) [hd] <;>
        (first | exact hs _ _ | exact (hs _ _).symm))
  have h := frontier_mixed_six_bounds
    (F 0 1) (F 0 2) (F 0 3) (F 1 2) (F 1 3) (F 2 3) k l hl hlk
    (hfirst 0 1 (by decide) (by decide))
    (hfirst 0 2 (by decide) (by decide))
    (hfirst 0 3 (by decide) (by decide))
    (hlater 1 2 (by decide) (by decide))
    (hlater 1 3 (by decide) (by decide))
    (hlater 2 3 (by decide) (by decide))
  simpa only [← hrepr] using h

/-- The exact integrated-four-entry bound before division by ABST. This
retains the leading cubic cancellation in off-diagonal cofactors. -/
theorem frontier_mixed_rankOne_upper
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ) (K Q : ℝ)
    (hF : F.det ≠ 0) (hdet : ‖F.det‖ ≤ Q)
    (hG : ∀ i j, ‖F.adjugate i j‖ ≤ if i = j then 2*K else 3*K-1/4) :
    ‖(F+Matrix.vecMulVec w w).det‖ ≤
      2*K*(‖w 0‖^2+‖w 1‖^2+‖w 2‖^2+‖w 3‖^2)+
      (6*K-1/2)*(‖w 0‖*‖w 1‖+‖w 0‖*‖w 2‖+‖w 0‖*‖w 3‖+
        ‖w 1‖*‖w 2‖+‖w 1‖*‖w 3‖+‖w 2‖*‖w 3‖)+Q := by
  have hadj : w ⬝ᵥ (F.adjugate *ᵥ w) = F.det*(w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
    simp only [adjugate_eq_det_smul_inverse F hF, Matrix.smul_mulVec,
      dotProduct_smul, smul_eq_mul]
  have hid : (F+Matrix.vecMulVec w w).det = F.det+w ⬝ᵥ (F.adjugate *ᵥ w) := by
    rw [rankOneDeterminant F w hF, hadj]
    ring
  have hform : w ⬝ᵥ (F.adjugate *ᵥ w) =
      ∑ i : Fin 4, ∑ j : Fin 4, w i*F.adjugate i j*w j := by
    simp only [dotProduct, mulVec, Finset.mul_sum, mul_assoc]
  have hbil : ‖w ⬝ᵥ (F.adjugate *ᵥ w)‖ ≤
      ∑ i : Fin 4, ∑ j : Fin 4,
        ‖w i‖*(if i = j then 2*K else 3*K-1/4)*‖w j‖ := by
    rw [hform]
    calc
      _ ≤ ∑ i : Fin 4, ‖∑ j : Fin 4, w i*F.adjugate i j*w j‖ := norm_sum_le _ _
      _ ≤ ∑ i : Fin 4, ∑ j : Fin 4, ‖w i*F.adjugate i j*w j‖ := by
        apply Finset.sum_le_sum
        intro i _
        exact norm_sum_le _ _
      _ = ∑ i : Fin 4, ∑ j : Fin 4, ‖w i‖*‖F.adjugate i j‖*‖w j‖ := by
        simp only [norm_mul]
      _ ≤ _ := by
        apply Finset.sum_le_sum
        intro i _
        apply Finset.sum_le_sum
        intro j _
        exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left (hG i j) (norm_nonneg _)) (norm_nonneg _)
  have hsum : (∑ i : Fin 4, ∑ j : Fin 4,
        ‖w i‖*(if i = j then 2*K else 3*K-1/4)*‖w j‖) =
      2*K*(‖w 0‖^2+‖w 1‖^2+‖w 2‖^2+‖w 3‖^2)+
      (6*K-1/2)*(‖w 0‖*‖w 1‖+‖w 0‖*‖w 2‖+‖w 0‖*‖w 3‖+
        ‖w 1‖*‖w 2‖+‖w 1‖*‖w 3‖+‖w 2‖*‖w 3‖) := by
    simp [Fin.sum_univ_four]
    ring
  rw [hsum] at hbil
  rw [hid]
  have h := norm_add_le F.det (w ⬝ᵥ (F.adjugate *ᵥ w))
  linarith only [h, hdet, hbil]

end D1Bound5
