import D1Bound5.ProductFivePrefixDet
import D1Bound5.ProductFiveMatrixBridge
import D1Bound5.MixedRootMatrixSigns

open Matrix

namespace D1Bound5

/-- The sharp determinant estimate holds for the original-ring mixed
signed-root matrix, with the same sign choices as all other mixed estimates. -/
theorem mixed_signed_root_det_upper_33_128
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (S : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hsymm : ∀ i j, S i j = S j i)
    (hgood : ∀ i j, i ≠ j →
      MixedSignedEntryGood f a u i j (S i j)) :
    ‖(normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j))).det‖ < (33/128 : ℝ) := by
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
  have hFfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a i) (a j) (u i) (u j)
        (S i j) (5/9) (25/486) := by
      simpa [MixedSignedEntryGood, hz] using hgood i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (1/18 : ℝ)
    exact lt_trans h.2 (by norm_num)
  have hFlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a i) (a j) (u i) (u j)
        (S i j) (7/13) (1/64) := by
      simpa [MixedSignedEntryGood, hz] using hgood i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (1/64 : ℝ)
    exact h.2
  exact mixed_zero_four_det_norm_lt_33_128 F hFdiag hFsymm hFfirst hFlater

/-- The exact four-entry determinant estimate inside a full five-entry
integral root matrix, conditional only on the signed first-four entries.
No condition on the fifth row or column is used here. -/
theorem five_prefix_det_upper_of_mixed_signed_entries
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hsymm : ∀ i j, S i j = S j i)
    (hgood : ∀ i j : Fin 4, i ≠ j →
      MixedSignedEntryGood f
        (fun k => a (Fin.castAdd 1 k)) (fun k => u (Fin.castAdd 1 k))
        i j (S (Fin.castAdd 1 i) (Fin.castAdd 1 j))) :
    ‖(fivePrefixError (normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j)))).det‖ < (33/128 : ℝ) := by
  let a4 : Fin 4 → R := fun i => a (Fin.castAdd 1 i)
  let u4 : Fin 4 → ℂ := fun i => u (Fin.castAdd 1 i)
  let S4 : Matrix (Fin 4) (Fin 4) R :=
    fun i j => S (Fin.castAdd 1 i) (Fin.castAdd 1 j)
  have heq : fivePrefixError (normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j))) =
    normalizedRootError (fun i => f (a4 i)) u4 (fun i j => f (S4 i j)) := by
    ext i j
    rfl
  rw [heq]
  exact mixed_signed_root_det_upper_33_128 f a4 u4 S4
    (fun i => hu (Fin.castAdd 1 i))
    (fun i => hdiag (Fin.castAdd 1 i))
    (fun i j => hsymm (Fin.castAdd 1 i) (Fin.castAdd 1 j))
    (fun i j hij => hgood i j hij)

end D1Bound5
