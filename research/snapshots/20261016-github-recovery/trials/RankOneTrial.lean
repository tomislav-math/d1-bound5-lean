import D1Bound5.ReferencePerturbation
import Mathlib.LinearAlgebra.Matrix.SchurComplement

open Matrix
namespace D1Bound5

theorem rankOneDeterminant (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) (hF : F.det ≠ 0) :
    (F + Matrix.vecMulVec w w).det =
      F.det * (1 + w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hF
  rw [Matrix.vecMulVec_eq (Fin 1), Matrix.det_add_replicateCol_mul_replicateRow hu]
  congr 1
  have h : Matrix.replicateRow (Fin 1) w * F⁻¹ * Matrix.replicateCol (Fin 1) w =
      (fun _ _ : Fin 1 => w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
    calc
      _ = Matrix.replicateRow (Fin 1) w * (F⁻¹ * Matrix.replicateCol (Fin 1) w) :=
        Matrix.mul_assoc _ _ _
      _ = Matrix.replicateRow (Fin 1) w *
          Matrix.replicateCol (Fin 1) (F⁻¹ *ᵥ w) := by
        rw [Matrix.replicateCol_mulVec]
      _ = _ := by
        ext i j
        exact Matrix.replicateRow_mul_replicateCol_apply w (F⁻¹ *ᵥ w) i j
  rw [h]
  simp [Matrix.det_unique, Pi.add_apply, Matrix.one_apply]

end D1Bound5
