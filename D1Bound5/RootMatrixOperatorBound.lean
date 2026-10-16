import D1Bound5.MatrixOperatorNorm
import D1Bound5.DeterminantNormalization

open scoped Matrix.Norms.L2Operator

namespace D1Bound5

/-- The reference matrix (J_4-I_4)/2 in the determinant estimates. -/
noncomputable def halfOffDiagonal : Matrix (Fin 4) (Fin 4) ℂ :=
  fun i j => if i = j then 0 else (1/2 : ℂ)

/-- The six signed entry bounds imply the strict Euclidean operator-norm
estimate for the full normalized correction matrix. -/
theorem signed_root_matrix_operator_bound
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (S : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hgood : ∀ i j, i ≠ j →
      SignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) :
    ‖normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j)) - halfOffDiagonal‖ <
      3 * (128/8649 : ℝ) := by
  let fa : Fin 4 → ℂ := fun i => f (a i)
  let fS : Matrix (Fin 4) (Fin 4) ℂ := fun i j => f (S i j)
  let F := normalizedRootError fa u fS
  let E := F - halfOffDiagonal
  have hd (i : Fin 4) : fS i i = fa i := congrArg f (hdiag i)
  have hF (i : Fin 4) : F i i = 0 :=
    normalizedRootError_diag fa u fS hu hd i
  have hEdiag (i : Fin 4) : E i i = 0 := by
    change F i i - halfOffDiagonal i i = 0
    simp [hF i, halfOffDiagonal]
  have hEoff (i j : Fin 4) (hij : i ≠ j) :
      ‖E i j‖ < (128/8649 : ℝ) := by
    have hg := (hgood i j hij).2
    change ‖u i * f (S i j) * u j - f (a i) * f (a j) - (1/2 : ℂ)‖ <
      (128/8649 : ℝ) at hg
    have hE : E i j =
        u i * f (S i j) * u j - f (a i) * f (a j) - (1/2 : ℂ) := by
      simp [E, F, fa, fS, normalizedRootError, scaledRootMatrix,
        halfOffDiagonal, hij]
    rw [hE]
    exact hg
  exact four_zero_diagonal_operator_norm_lt E (128/8649 : ℝ)
    (by norm_num) hEdiag hEoff

/-- Uniform simultaneous signs, still valued in the original ring,
with a kernel-proved spectral bound on the normalized complex matrix. -/
theorem exists_signed_root_matrix_operator_bound
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
      ‖normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j)) - halfOffDiagonal‖ <
        3 * (128/8649 : ℝ) := by
  obtain ⟨u, S, hu, hd, hs, hsign, hsq, hnear⟩ :=
    exists_good_symmetric_root_matrix_with_roots f a M hdiag hsymm hroot hlarge
  exact ⟨u, S, hu, hd, hs, hsign, hsq,
    signed_root_matrix_operator_bound f a u S hu hd hnear⟩

end D1Bound5
