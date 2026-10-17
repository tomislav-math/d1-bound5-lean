import D1Bound5.ReferenceInverseNorm
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

private theorem ref_factorization (F : Matrix (Fin 4) (Fin 4) ℂ) :
    halfOffDiagonalInverse * F =
      1 + halfOffDiagonalInverse * (F - halfOffDiagonal) := by
  calc
    halfOffDiagonalInverse * F =
        halfOffDiagonalInverse * (halfOffDiagonal + (F - halfOffDiagonal)) := by
          congr 1
          abel
    _ = halfOffDiagonalInverse * halfOffDiagonal +
        halfOffDiagonalInverse * (F - halfOffDiagonal) := mul_add _ _ _
    _ = _ := by rw [inverse_mul_halfOffDiagonal]

/-- A small normalized correction makes the perturbed matrix nonsingular. -/
theorem reference_perturbed_det_ne_zero
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hc : ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖ < 1) :
    F.det ≠ 0 := by
  have hneg : ‖-(halfOffDiagonalInverse * (F - halfOffDiagonal))‖ < 1 := by
    simpa only [norm_neg] using hc
  have hunit : IsUnit (halfOffDiagonalInverse * F) := by
    rw [ref_factorization]
    simpa only [sub_neg_eq_add] using (isUnit_one_sub_of_norm_lt_one hneg)
  have hdet : (halfOffDiagonalInverse * F).det ≠ 0 :=
    ((Matrix.isUnit_iff_isUnit_det _).mp hunit).ne_zero
  rw [Matrix.det_mul] at hdet
  exact (mul_ne_zero_iff.mp hdet).2

/-- The reference estimate makes the normalised 4-by-4 correction invertible. -/
theorem reference_perturbed_det_ne_zero_of_near
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hnear : ‖F - halfOffDiagonal‖ < 3 * (128/8649 : ℝ)) :
    F.det ≠ 0 :=
  reference_perturbed_det_ne_zero F (reference_inverse_error_norm_lt_one F hnear)

/-- A strict one-eighth perturbation admits a uniformly bounded inverse. -/
theorem reference_perturbed_inverse_norm_lt
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hnear : ‖F - halfOffDiagonal‖ < (1/8 : ℝ)) :
    ‖F⁻¹‖ < (8/3 : ℝ) := by
  let Q := halfOffDiagonalInverse * (F - halfOffDiagonal)
  have hQ : ‖Q‖ < (1/4 : ℝ) := by
    calc
      ‖Q‖ ≤ ‖halfOffDiagonalInverse‖ * ‖F - halfOffDiagonal‖ :=
        Matrix.l2_opNorm_mul _ _
      _ = 2 * ‖F - halfOffDiagonal‖ := by rw [halfOffDiagonalInverse_norm]
      _ < 2 * (1/8 : ℝ) := mul_lt_mul_of_pos_left hnear (by norm_num)
      _ = 1/4 := by norm_num
  have hsmall : ‖Q‖ < 1 := lt_trans hQ (by norm_num)
  have hd : F.det ≠ 0 := reference_perturbed_det_ne_zero F hsmall
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hd
  have hi : F * F⁻¹ = 1 := Matrix.mul_nonsing_inv F hu
  have hid : halfOffDiagonalInverse = F⁻¹ + Q * F⁻¹ := by
    calc
      halfOffDiagonalInverse = (halfOffDiagonalInverse * F) * F⁻¹ := by
        rw [Matrix.mul_assoc, hi, mul_one]
      _ = (1 + Q) * F⁻¹ := by rw [ref_factorization]
      _ = F⁻¹ + Q * F⁻¹ := by rw [add_mul, one_mul]
  have hsolve : F⁻¹ = halfOffDiagonalInverse - Q * F⁻¹ := by
    rw [hid]
    abel
  have hnorm : ‖F⁻¹‖ ≤ 2 + ‖Q‖ * ‖F⁻¹‖ := by
    calc
      ‖F⁻¹‖ = ‖halfOffDiagonalInverse - Q * F⁻¹‖ := congrArg norm hsolve
      _ ≤ ‖halfOffDiagonalInverse‖ + ‖Q * F⁻¹‖ := norm_sub_le _ _
      _ ≤ 2 + ‖Q‖ * ‖F⁻¹‖ := by
        rw [halfOffDiagonalInverse_norm]
        linarith only [Matrix.l2_opNorm_mul Q F⁻¹]
  have hinv : F⁻¹ ≠ 0 := by
    intro h
    rw [h, mul_zero] at hi
    exact one_ne_zero hi.symm
  have hpos : 0 < ‖F⁻¹‖ := norm_pos_iff.mpr hinv
  have hstrict := mul_lt_mul_of_pos_right hQ hpos
  nlinarith only [hnorm, hstrict]

/-- The uniform signed-root construction also produces a nonsingular
normalized matrix with a quantitatively bounded inverse. -/
theorem exists_signed_root_matrix_with_bounded_inverse
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (M : Matrix (Fin 4) (Fin 4) R)
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hlarge : ∀ i j, i ≠ j → 9 ≤ ‖f (a i) * f (a j)‖) :
    ∃ (u : Fin 4 → ℂ) (S : Matrix (Fin 4) (Fin 4) R),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      (normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))).det ≠ 0 ∧
      ‖(normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j)))⁻¹‖ < (8/3 : ℝ) := by
  obtain ⟨u,S,hu,hd,hs,hsign,hsq,hnear⟩ :=
    exists_signed_root_matrix_operator_bound f a M hdiag hsymm hroot hlarge
  refine ⟨u,S,hu,hd,hs,hsign,hsq,?_,?_⟩
  · exact reference_perturbed_det_ne_zero_of_near _ hnear
  · exact reference_perturbed_inverse_norm_lt _
      (lt_trans hnear (by norm_num))

end D1Bound5
