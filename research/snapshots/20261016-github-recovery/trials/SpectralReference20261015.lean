import D1Bound5.RootMatrixOperatorBound
import Mathlib.Tactic.FinCases

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

private noncomputable def walsh4 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![(1/2 : ℂ), 1/2, 1/2, 1/2;
     1/2, 1/2, -1/2, -1/2;
     1/2, -1/2, 1/2, -1/2;
     1/2, -1/2, -1/2, 1/2]

private noncomputable def referenceSpectrum : Fin 4 → ℂ :=
  ![(3/2 : ℂ), -1/2, -1/2, -1/2]

private theorem walsh4_conjTranspose : walsh4ᴴ = walsh4 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [walsh4, Matrix.conjTranspose_apply]

private theorem walsh4_sq : walsh4 * walsh4 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [walsh4, Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply]

private theorem walsh4_mul_diagonal :
    walsh4 * Matrix.diagonal referenceSpectrum =
      (fun i j => walsh4 i j * referenceSpectrum j) := by
  ext i j
  simp

private theorem halfOffDiagonal_diagonalization :
    halfOffDiagonal = walsh4 * Matrix.diagonal referenceSpectrum * walsh4 := by
  rw [walsh4_mul_diagonal]
  ext i j
  change halfOffDiagonal i j = ∑ k : Fin 4,
    (walsh4 i k * referenceSpectrum k) * walsh4 k j
  fin_cases i <;> fin_cases j <;>
    norm_num [halfOffDiagonal, walsh4, referenceSpectrum, Fin.sum_univ_succ]

private theorem walsh4_opNorm : ‖walsh4‖ = 1 := by
  have hc : walsh4ᴴ * walsh4 = 1 := by rw [walsh4_conjTranspose, walsh4_sq]
  have h := Matrix.l2_opNorm_conjTranspose_mul_self walsh4
  rw [hc, norm_one] at h
  nlinarith [norm_nonneg walsh4]

private theorem referenceSpectrum_opNorm :
    ‖(Matrix.diagonal referenceSpectrum : Matrix (Fin 4) (Fin 4) ℂ)‖ ≤ 3/2 := by
  rw [Matrix.l2_opNorm_diagonal]
  apply (pi_norm_le_iff_of_nonneg (by norm_num : (0 : ℝ) ≤ 3/2)).2
  intro i
  fin_cases i <;> norm_num [referenceSpectrum]

theorem halfOffDiagonal_opNorm_le : ‖halfOffDiagonal‖ ≤ 3/2 := by
  rw [halfOffDiagonal_diagonalization]
  calc
    ‖walsh4 * Matrix.diagonal referenceSpectrum * walsh4‖
      ≤ ‖walsh4 * Matrix.diagonal referenceSpectrum‖ * ‖walsh4‖ :=
        Matrix.l2_opNorm_mul _ _
    _ ≤ (‖walsh4‖ * ‖(Matrix.diagonal referenceSpectrum : Matrix (Fin 4) (Fin 4) ℂ)‖) *
        ‖walsh4‖ := by
        gcongr
        exact Matrix.l2_opNorm_mul _ _
    _ ≤ 3/2 := by rw [walsh4_opNorm]; simpa using referenceSpectrum_opNorm

private noncomputable def referenceInverseSpectrum : Fin 4 → ℂ :=
  ![(2/3 : ℂ), -2, -2, -2]

/-- The explicit inverse of the reference matrix, constructed by Walsh
diagonalization. -/
noncomputable def halfOffDiagonalInverse : Matrix (Fin 4) (Fin 4) ℂ :=
  walsh4 * Matrix.diagonal referenceInverseSpectrum * walsh4

private theorem referenceSpectrum_inverse :
    Matrix.diagonal referenceSpectrum * Matrix.diagonal referenceInverseSpectrum =
      (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [referenceSpectrum, referenceInverseSpectrum,
      Matrix.mul_diagonal, Matrix.diagonal_apply, Matrix.one_apply]

private theorem referenceInverseSpectrum_opNorm :
    ‖(Matrix.diagonal referenceInverseSpectrum : Matrix (Fin 4) (Fin 4) ℂ)‖ ≤ 2 := by
  rw [Matrix.l2_opNorm_diagonal]
  apply (pi_norm_le_iff_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)).2
  intro i
  fin_cases i <;> norm_num [referenceInverseSpectrum]

theorem halfOffDiagonal_inverse_opNorm_le : ‖halfOffDiagonalInverse‖ ≤ 2 := by
  unfold halfOffDiagonalInverse
  calc
    ‖walsh4 * Matrix.diagonal referenceInverseSpectrum * walsh4‖
      ≤ ‖walsh4 * Matrix.diagonal referenceInverseSpectrum‖ * ‖walsh4‖ :=
        Matrix.l2_opNorm_mul _ _
    _ ≤ (‖walsh4‖ * ‖(Matrix.diagonal referenceInverseSpectrum :
        Matrix (Fin 4) (Fin 4) ℂ)‖) * ‖walsh4‖ := by
        gcongr
        exact Matrix.l2_opNorm_mul _ _
    _ ≤ 2 := by rw [walsh4_opNorm]; simpa using referenceInverseSpectrum_opNorm

theorem halfOffDiagonal_mul_inverse :
    halfOffDiagonal * halfOffDiagonalInverse = 1 := by
  rw [halfOffDiagonal_diagonalization]
  unfold halfOffDiagonalInverse
  calc
    (walsh4 * Matrix.diagonal referenceSpectrum * walsh4) *
        (walsh4 * Matrix.diagonal referenceInverseSpectrum * walsh4) =
      walsh4 * Matrix.diagonal referenceSpectrum * (walsh4 * walsh4) *
        Matrix.diagonal referenceInverseSpectrum * walsh4 := by
          simp only [Matrix.mul_assoc]
    _ = 1 := by
      rw [walsh4_sq]
      simp only [Matrix.mul_one, Matrix.mul_assoc]
      rw [← Matrix.mul_assoc (Matrix.diagonal referenceSpectrum)
        (Matrix.diagonal referenceInverseSpectrum) walsh4, referenceSpectrum_inverse]
      simp only [Matrix.one_mul, walsh4_sq]

end D1Bound5
