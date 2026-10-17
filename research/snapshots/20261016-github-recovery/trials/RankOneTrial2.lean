import D1Bound5.ReferencePerturbation
import Mathlib.LinearAlgebra.Matrix.SchurComplement

open Matrix
namespace D1Bound5

theorem rankOneDeterminant (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) (hF : F.det ≠ 0) :
    (F + Matrix.vecMulVec w w).det =
      F.det * (1 + w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hF
  have hfactor : F + Matrix.vecMulVec w w =
      F * (1 + F⁻¹ * Matrix.vecMulVec w w) := by
    rw [Matrix.mul_add, Matrix.mul_one, ← Matrix.mul_assoc,
      Matrix.mul_nonsing_inv F hu, Matrix.one_mul]
  have hrank : F⁻¹ * Matrix.vecMulVec w w =
      Matrix.replicateCol (Fin 1) (F⁻¹ *ᵥ w) * Matrix.replicateRow (Fin 1) w := by
    rw [Matrix.vecMulVec_eq (Fin 1), ← Matrix.mul_assoc,
      ← Matrix.replicateCol_mulVec]
    rfl
  have hdet : (1 + Matrix.replicateCol (Fin 1) (F⁻¹ *ᵥ w) *
      Matrix.replicateRow (Fin 1) w).det = 1 + w ⬝ᵥ (F⁻¹ *ᵥ w) :=
    Matrix.det_one_add_replicateCol_mul_replicateRow (F⁻¹ *ᵥ w) w
  rw [hfactor, Matrix.det_mul, hrank, hdet]

end D1Bound5
