import D1Bound5.FrontierLargeCofactors

open scoped NumberField Matrix.Norms.L2Operator BigOperators
open Matrix Module

namespace D1Bound5

/-- Coordinate bounds for a very unbalanced four-variable bilinear form.
The exact coefficient is 88139/270000, strictly below one third. -/
theorem frontier_large_bilinear_bound
    (G : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ) (D : ℝ)
    (hD : 0 ≤ D)
    (hG : ∀ i j, ‖G i j‖ ≤
      if i = j then (273/1000 : ℝ) else (1447/10000 : ℝ))
    (hw : ∀ i, i ≠ 3 → ‖w i‖ ≤ D/18) (hw3 : ‖w 3‖ = D) :
    ‖w ⬝ᵥ (G *ᵥ w)‖ ≤ (88139/270000 : ℝ)*D^2 := by
  let t : Fin 4 → ℝ := fun i => if i = 3 then D else D/18
  let c : Fin 4 → Fin 4 → ℝ := fun i j =>
    if i = j then (273/1000 : ℝ) else (1447/10000 : ℝ)
  have ht (i : Fin 4) : 0 ≤ t i := by dsimp [t]; split_ifs <;> positivity
  have hc (i j : Fin 4) : 0 ≤ c i j := by dsimp [c]; split_ifs <;> norm_num
  have hwt (i : Fin 4) : ‖w i‖ ≤ t i := by
    by_cases hi : i = 3
    · subst i
      simp [t, hw3]
    · simpa only [t, if_neg hi] using hw i hi
  have hid : w ⬝ᵥ (G *ᵥ w) = ∑ i : Fin 4, ∑ j : Fin 4, w i*G i j*w j := by
    simp only [dotProduct, mulVec, Finset.mul_sum, mul_assoc]
  calc
    ‖w ⬝ᵥ (G *ᵥ w)‖ = ‖∑ i : Fin 4, ∑ j : Fin 4, w i*G i j*w j‖ := congrArg norm hid
    _ ≤ ∑ i : Fin 4, ‖∑ j : Fin 4, w i*G i j*w j‖ := norm_sum_le _ _
    _ ≤ ∑ i : Fin 4, ∑ j : Fin 4, ‖w i*G i j*w j‖ := by
      apply Finset.sum_le_sum
      intro i _
      exact norm_sum_le _ _
    _ = ∑ i : Fin 4, ∑ j : Fin 4, ‖w i‖*‖G i j‖*‖w j‖ := by
      simp only [norm_mul]
    _ ≤ ∑ i : Fin 4, ∑ j : Fin 4, t i*c i j*t j := by
      apply Finset.sum_le_sum
      intro i _
      apply Finset.sum_le_sum
      intro j _
      exact mul_le_mul
        (mul_le_mul (hwt i) (hG i j) (norm_nonneg _) (ht i))
        (hwt j) (norm_nonneg _) (mul_nonneg (ht i) (hc i j))
    _ = (88139/270000 : ℝ)*D^2 := by
      simp [t, c, Fin.sum_univ_four]
      ring

/-- The entrywise adjugate estimate sharpens the previous product-four
constant two to three after the already-proved first growth step. -/
theorem frontier_large_rankOne_det_bound
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ) (D : ℝ)
    (hD : 54 ≤ D) (hF : F.det ≠ 0) (hdet : ‖F.det‖ < (1/4 : ℝ))
    (hG : ∀ i j, ‖F.adjugate i j‖ ≤
      if i = j then (273/1000 : ℝ) else (1447/10000 : ℝ))
    (hw : ∀ i, i ≠ 3 → ‖w i‖ ≤ D/18) (hw3 : ‖w 3‖ = D) :
    ‖(F+Matrix.vecMulVec w w).det‖ < D^2/3 := by
  have hD0 : 0 ≤ D := by linarith only [hD]
  have hbil := frontier_large_bilinear_bound F.adjugate w D hD0 hG hw hw3
  have hadj : w ⬝ᵥ (F.adjugate *ᵥ w) = F.det*(w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
    rw [adjugate_eq_det_smul_inverse F hF, Matrix.smul_mulVec, dotProduct_smul]
    rfl
  have hid : (F+Matrix.vecMulVec w w).det = F.det+w ⬝ᵥ (F.adjugate *ᵥ w) := by
    rw [rankOneDeterminant F w hF, hadj]
    ring
  have hsq : 2916 ≤ D^2 := by nlinarith only [hD, sq_nonneg (D-54)]
  have hnum : (1/4 : ℝ)+(88139/270000 : ℝ)*D^2 < D^2/3 := by
    nlinarith only [hsq]
  rw [hid]
  exact (norm_add_le _ _).trans_lt (by linarith only [hdet, hbil, hnum])

end D1Bound5
