import D1Bound5.RankOneDeterminantBound

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- The determinant of the scaled root matrix obeys the cofactor bound
in (integrated-1). The normalized correction need only be nonsingular. -/
theorem scaledRootMatrix_det_adjugate_norm_le
    (a u : Fin 4 → ℂ) (M : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : (normalizedRootError a u M).det ≠ 0) :
    ‖(scaledRootMatrix u M).det‖ ≤
      ‖(normalizedRootError a u M).det‖ +
      ‖(normalizedRootError a u M).adjugate‖ *
        (∑ i, ‖a i‖ ^ 2) := by
  have h : scaledRootMatrix u M =
      normalizedRootError a u M + Matrix.vecMulVec a a := by
    ext i j
    simp only [Matrix.add_apply, Matrix.vecMulVec_apply,
      normalizedRootError, scaledRootMatrix]
    ring
  rw [h]
  exact rankOneDeterminant_adjugate_norm_le _ a hd

end D1Bound5
