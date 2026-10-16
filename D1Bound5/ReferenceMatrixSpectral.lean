import D1Bound5.RootMatrixOperatorBound
import Mathlib.LinearAlgebra.Matrix.SchurComplement
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- An explicit inverse of the reference matrix `(J₄-I₄)/2`. -/
noncomputable def halfOffDiagonalInverse : Matrix (Fin 4) (Fin 4) ℂ :=
  fun i j => if i = j then (-4/3 : ℂ) else (2/3 : ℂ)

/-- Exact inverse calculation, including all sixteen entries. -/
theorem halfOffDiagonal_mul_inverse :
    halfOffDiagonal * halfOffDiagonalInverse = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [halfOffDiagonal, halfOffDiagonalInverse,
      Matrix.mul_apply, Fin.sum_univ_succ] <;> norm_num

/-- The other inverse identity is also an equality over complex matrices. -/
theorem inverse_mul_halfOffDiagonal :
    halfOffDiagonalInverse * halfOffDiagonal = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [halfOffDiagonal, halfOffDiagonalInverse,
      Matrix.mul_apply, Fin.sum_univ_succ] <;> norm_num

/-- The reference matrix is nonsingular, without using any estimate. -/
theorem halfOffDiagonal_det_ne_zero : halfOffDiagonal.det ≠ 0 := by
  intro hd
  have h := congrArg Matrix.det halfOffDiagonal_mul_inverse
  rw [Matrix.det_mul, Matrix.det_one, hd] at h
  simp at h

private def negativeOnes : Fin 4 → ℂ := fun _ => -1
private def positiveOnes : Fin 4 → ℂ := fun _ => 1

/-- Exact reference determinant, obtained from the rank-one determinant
lemma rather than a computer expansion of twenty-four permutation terms. -/
theorem halfOffDiagonal_det : halfOffDiagonal.det = (-3/16 : ℂ) := by
  let V : Matrix (Fin 4) (Fin 4) ℂ :=
    (1 : Matrix (Fin 4) (Fin 4) ℂ) +
      Matrix.replicateCol (Fin 1) negativeOnes *
        Matrix.replicateRow (Fin 1) positiveOnes
  have hV : halfOffDiagonal = (-1/2 : ℂ) • V := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp (config := {decide := true}) [V, halfOffDiagonal, negativeOnes,
        positiveOnes, Matrix.mul_apply] <;> norm_num
  have hdot : positiveOnes ⬝ᵥ negativeOnes = (-4 : ℂ) := by
    norm_num [dotProduct, positiveOnes, negativeOnes,
      Fin.sum_univ_succ]
  rw [hV, Matrix.det_smul]
  have hrank : V.det = 1 + positiveOnes ⬝ᵥ negativeOnes := by
    exact Matrix.det_one_add_replicateCol_mul_replicateRow negativeOnes positiveOnes
  rw [hrank, hdot]
  norm_num

/-- The adjugate of the reference matrix, expressed through the explicit
inverse without applying Cramer's rule to individual minors. -/
theorem halfOffDiagonal_adjugate :
    halfOffDiagonal.adjugate = (-3/16 : ℂ) • halfOffDiagonalInverse := by
  calc
    halfOffDiagonal.adjugate =
        (1 : Matrix (Fin 4) (Fin 4) ℂ) * halfOffDiagonal.adjugate := by simp
    _ = (halfOffDiagonalInverse * halfOffDiagonal) * halfOffDiagonal.adjugate := by
      rw [inverse_mul_halfOffDiagonal]
    _ = halfOffDiagonalInverse * (halfOffDiagonal * halfOffDiagonal.adjugate) := by
      rw [Matrix.mul_assoc]
    _ = halfOffDiagonalInverse * (halfOffDiagonal.det • (1 : Matrix (Fin 4) (Fin 4) ℂ)) := by
      rw [Matrix.mul_adjugate]
    _ = halfOffDiagonal.det • halfOffDiagonalInverse := by
      simp
    _ = (-3/16 : ℂ) • halfOffDiagonalInverse := by
      rw [halfOffDiagonal_det]

/-- Exact cofactors at the reference matrix: diagonal 1/4, otherwise -1/8. -/
theorem halfOffDiagonal_adjugate_apply (i j : Fin 4) :
    halfOffDiagonal.adjugate i j =
      if i = j then (1/4 : ℂ) else (-1/8 : ℂ) := by
  rw [halfOffDiagonal_adjugate]
  by_cases h : i = j
  · simp [halfOffDiagonalInverse, h]
    norm_num
  · simp [halfOffDiagonalInverse, h]
    norm_num

end D1Bound5
