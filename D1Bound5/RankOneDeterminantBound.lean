import D1Bound5.ReferencePerturbation
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.SchurComplement

open scoped Matrix.Norms.L2Operator
open scoped InnerProductSpace
open Matrix

namespace D1Bound5

/-- The modulus of a complex bilinear quadratic form is bounded by the
Euclidean operator norm. No Hermitian or symmetry assumption is needed. -/
theorem bilinear_mulVec_norm_le (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) :
    ‖w ⬝ᵥ (F *ᵥ w)‖ ≤ ‖F‖ * (∑ i, ‖w i‖ ^ 2) := by
  let x : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 w
  let y : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 (star w)
  have hy : ‖y‖ = ‖x‖ := by
    have hsq : ‖y‖ ^ 2 = ‖x‖ ^ 2 := by
      rw [EuclideanSpace.norm_sq_eq y, EuclideanSpace.norm_sq_eq x]
      simp [x, y]
    nlinarith only [hsq, norm_nonneg x, norm_nonneg y]
  have hinner : w ⬝ᵥ (F *ᵥ w) =
      inner ℂ y ((EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)) := by
    change w ⬝ᵥ (F *ᵥ w) = inner ℂ (WithLp.toLp 2 (star w))
      (WithLp.toLp 2 (F *ᵥ w))
    rw [EuclideanSpace.inner_toLp_toLp]
    simp [dotProduct_comm]
  have hv : ‖(EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)‖ ≤ ‖F‖ * ‖x‖ := by
    simpa only [x] using Matrix.l2_opNorm_mulVec F x
  calc
    ‖w ⬝ᵥ (F *ᵥ w)‖ =
        ‖inner ℂ y ((EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w))‖ :=
          congrArg norm hinner
    _ ≤ ‖y‖ * ‖(EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)‖ :=
      norm_inner_le_norm _ _
    _ ≤ ‖x‖ * (‖F‖ * ‖x‖) := by
      rw [hy]
      exact mul_le_mul_of_nonneg_left hv (norm_nonneg x)
    _ = ‖F‖ * (∑ i, ‖w i‖ ^ 2) := by
      rw [← EuclideanSpace.norm_sq_eq x]
      ring

/-- The determinant lemma for a symmetric algebraic rank-one update in
dimension four. This holds for complex vectors without conjugation. -/
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

/-- Express the adjugate of an invertible matrix in terms of its inverse. -/
theorem adjugate_eq_det_smul_inverse (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : F.det ≠ 0) : F.adjugate = F.det • F⁻¹ := by
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hd
  calc
    F.adjugate = (F⁻¹ * F) * F.adjugate := by
      rw [Matrix.nonsing_inv_mul F hu, one_mul]
    _ = F⁻¹ * (F * F.adjugate) := Matrix.mul_assoc _ _ _
    _ = F⁻¹ * (F.det • (1 : Matrix (Fin 4) (Fin 4) ℂ)) := by
      rw [Matrix.mul_adjugate]
    _ = F.det • F⁻¹ := by simp

/-- Determinant bound for a rank-one update, using the inverse norm. -/
theorem rankOneDeterminant_norm_le (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) (hF : F.det ≠ 0) :
    ‖(F + Matrix.vecMulVec w w).det‖ ≤
      ‖F.det‖ * (1 + ‖F⁻¹‖ * (∑ i, ‖w i‖ ^ 2)) := by
  have htriangle :
      ‖(1 : ℂ) + w ⬝ᵥ (F⁻¹ *ᵥ w)‖ ≤
        1 + ‖w ⬝ᵥ (F⁻¹ *ᵥ w)‖ := by
    simpa only [norm_one] using
      norm_add_le (1 : ℂ) (w ⬝ᵥ (F⁻¹ *ᵥ w))
  have hquad := bilinear_mulVec_norm_le F⁻¹ w
  calc
    ‖(F + Matrix.vecMulVec w w).det‖ =
        ‖F.det‖ * ‖(1 : ℂ) + w ⬝ᵥ (F⁻¹ *ᵥ w)‖ := by
          rw [rankOneDeterminant F w hF, norm_mul]
    _ ≤ ‖F.det‖ * (1 + ‖w ⬝ᵥ (F⁻¹ *ᵥ w)‖) :=
      mul_le_mul_of_nonneg_left htriangle (norm_nonneg _)
    _ ≤ ‖F.det‖ * (1 + ‖F⁻¹‖ * (∑ i, ‖w i‖ ^ 2)) := by
      apply mul_le_mul_of_nonneg_left _ (norm_nonneg _)
      linarith only [hquad]

/-- The rank-one determinant bound in precisely the cofactor form required
by the determinant argument in lem:product-four. -/
theorem rankOneDeterminant_adjugate_norm_le (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) (hF : F.det ≠ 0) :
    ‖(F + Matrix.vecMulVec w w).det‖ ≤
      ‖F.det‖ + ‖F.adjugate‖ * (∑ i, ‖w i‖ ^ 2) := by
  have hadj : ‖F.adjugate‖ = ‖F.det‖ * ‖F⁻¹‖ := by
    rw [adjugate_eq_det_smul_inverse F hF, norm_smul]
  calc
    ‖(F + Matrix.vecMulVec w w).det‖
        ≤ ‖F.det‖ * (1 + ‖F⁻¹‖ * (∑ i, ‖w i‖ ^ 2)) :=
          rankOneDeterminant_norm_le F w hF
    _ = ‖F.det‖ + ‖F.adjugate‖ * (∑ i, ‖w i‖ ^ 2) := by
      rw [hadj]
      ring

end D1Bound5
