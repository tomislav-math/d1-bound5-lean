import D1Bound5.SymmetricFourDetBound
import D1Bound5.SignedRootAdjugateBound

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- Both estimates hold for the SAME simultaneous choice of signs
in the original commutative ring, rather than for two unrelated witnesses. -/
theorem exists_signed_root_matrix_det_and_adjugate_upper
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
      ‖(normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))).det‖ < productFourH * productFourS^3 ∧
      ‖(normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))).adjugate‖ < productFourH * productFourS^2 := by
  obtain ⟨u, S, hu, hd, hs, hsign, hsq, hgood⟩ :=
    exists_good_symmetric_root_matrix_with_roots f a M hdiag hsymm hroot hlarge
  exact ⟨u, S, hu, hd, hs, hsign, hsq,
    signed_root_matrix_det_upper f a u S hu hd hs hgood,
    signed_root_matrix_adjugate_upper f a u S hu hd hs hgood⟩

end D1Bound5
