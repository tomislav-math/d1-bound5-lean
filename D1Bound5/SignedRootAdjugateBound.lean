import D1Bound5.AdjugateCoverage
import D1Bound5.RootMatrixSigns

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- Transfer the adjugate bound to a simultaneously signed root matrix.
All entries and signs still live in the original commutative ring. -/
theorem signed_root_matrix_adjugate_upper
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (S : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hsymm : ∀ i j, S i j = S j i)
    (hgood : ∀ i j, i ≠ j →
      SignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) :
    ‖(normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j))).adjugate‖ <
        productFourH * productFourS^2 := by
  let fa : Fin 4 → ℂ := fun i => f (a i)
  let fS : Matrix (Fin 4) (Fin 4) ℂ := fun i j => f (S i j)
  let F := normalizedRootError fa u fS
  have hFdiag : ∀ i, F i i = 0 := by
    intro i
    exact normalizedRootError_diag fa u fS hu
      (fun j => congrArg f (hdiag j)) i
  have hFsymm : ∀ i j, F i j = F j i := by
    intro i j
    change u i * f (S i j) * u j - f (a i) * f (a j) =
      u j * f (S j i) * u i - f (a j) * f (a i)
    rw [hsymm i j]
    ring
  have hFsmall : ∀ i j, i ≠ j →
      ‖F i j - (1/2 : ℂ)‖ < (128/8649 : ℝ) := by
    intro i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (128/8649 : ℝ)
    exact (hgood i j hij).2
  exact symmetric_zero_four_adjugate_norm_lt F hFdiag hFsymm hFsmall

/-- The simultaneous choice of integral signs yields the cofactor
operator bound without an additional approximation hypothesis. -/
theorem exists_signed_root_matrix_adjugate_upper
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
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      ‖(normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))).adjugate‖ <
          productFourH * productFourS^2 := by
  obtain ⟨u,S,hu,hd,hs,_,hsq,hgood⟩ :=
    exists_good_symmetric_root_matrix_with_roots f a M hdiag hsymm hroot hlarge
  exact ⟨u,S,hu,hd,hs,hsq,
    signed_root_matrix_adjugate_upper f a u S hu hd hs hgood⟩

end D1Bound5
