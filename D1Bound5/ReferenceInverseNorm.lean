import D1Bound5.ReferenceMatrixSpectral
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

noncomputable def referenceReflection : Matrix (Fin 4) (Fin 4) ℂ :=
  fun i j => if i = j then (1/2 : ℂ) else (-1/2 : ℂ)

theorem referenceReflection_sq :
    referenceReflection * referenceReflection = (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [referenceReflection, Matrix.mul_apply,
      Fin.sum_univ_succ] <;> norm_num

theorem referenceReflection_conjTranspose :
    referenceReflectionᴴ = referenceReflection := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [referenceReflection,
      Matrix.conjTranspose_apply]

theorem referenceReflection_norm : ‖referenceReflection‖ = 1 := by
  have h := Matrix.l2_opNorm_conjTranspose_mul_self referenceReflection
  rw [referenceReflection_conjTranspose, referenceReflection_sq, norm_one] at h
  nlinarith [norm_nonneg referenceReflection]

theorem halfOffDiagonalInverse_decompose :
    halfOffDiagonalInverse =
      (-2/3 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) +
      (-4/3 : ℂ) • referenceReflection := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [halfOffDiagonalInverse, referenceReflection,
      Matrix.smul_apply] <;> norm_num

theorem halfOffDiagonalInverse_norm_le :
    ‖halfOffDiagonalInverse‖ ≤ 2 := by
  rw [halfOffDiagonalInverse_decompose]
  calc
    ‖(-2/3 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ) +
      (-4/3 : ℂ) • referenceReflection‖
        ≤ ‖(-2/3 : ℂ) • (1 : Matrix (Fin 4) (Fin 4) ℂ)‖ +
          ‖(-4/3 : ℂ) • referenceReflection‖ := norm_add_le _ _
    _ = (2/3 : ℝ) * ‖(1 : Matrix (Fin 4) (Fin 4) ℂ)‖ +
          (4/3 : ℝ) * ‖referenceReflection‖ := by
      rw [norm_smul, norm_smul]
      norm_num
    _ = 2 := by rw [norm_one, referenceReflection_norm]; norm_num

theorem halfOffDiagonalInverse_mul_reflection_plus_one :
    halfOffDiagonalInverse *
      ((1 : Matrix (Fin 4) (Fin 4) ℂ) + referenceReflection) =
      (-2 : ℂ) • ((1 : Matrix (Fin 4) (Fin 4) ℂ) + referenceReflection) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp (config := {decide := true}) [halfOffDiagonalInverse, referenceReflection,
      Matrix.mul_apply, Fin.sum_univ_succ, Matrix.one_apply] <;> norm_num

theorem halfOffDiagonalInverse_norm_ge :
    2 ≤ ‖halfOffDiagonalInverse‖ := by
  let Q : Matrix (Fin 4) (Fin 4) ℂ :=
    (1 : Matrix (Fin 4) (Fin 4) ℂ) + referenceReflection
  have hQ : Q ≠ 0 := by
    intro h
    have h00 := congrArg (fun M : Matrix (Fin 4) (Fin 4) ℂ => M 0 0) h
    norm_num [Q, referenceReflection] at h00
  have hQpos : 0 < ‖Q‖ := norm_pos_iff.mpr hQ
  have hKQ : halfOffDiagonalInverse * Q = (-2 : ℂ) • Q :=
    halfOffDiagonalInverse_mul_reflection_plus_one
  have hmul := Matrix.l2_opNorm_mul halfOffDiagonalInverse Q
  rw [hKQ, norm_smul] at hmul
  have hn : ‖(-2 : ℂ)‖ = (2 : ℝ) := by norm_num
  rw [hn] at hmul
  by_contra hbad
  have hdiff : 0 < 2 - ‖halfOffDiagonalInverse‖ := sub_pos.mpr (lt_of_not_ge hbad)
  have hprod := mul_pos hdiff hQpos
  nlinarith only [hmul, hprod]

theorem halfOffDiagonalInverse_norm :
    ‖halfOffDiagonalInverse‖ = 2 :=
  le_antisymm halfOffDiagonalInverse_norm_le halfOffDiagonalInverse_norm_ge

/-- The sharp reference inverse norm makes the normalized correction a
strict contraction when all pair products have modulus at least nine. -/
theorem reference_inverse_error_norm_lt_one
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hnear : ‖F - halfOffDiagonal‖ < 3 * (128/8649 : ℝ)) :
    ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖ < 1 := by
  calc
    ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖
        ≤ ‖halfOffDiagonalInverse‖ * ‖F - halfOffDiagonal‖ :=
          Matrix.l2_opNorm_mul _ _
    _ = 2 * ‖F - halfOffDiagonal‖ := by rw [halfOffDiagonalInverse_norm]
    _ < 2 * (3 * (128/8649 : ℝ)) :=
      mul_lt_mul_of_pos_left hnear (by norm_num)
    _ < 1 := by norm_num

end D1Bound5
