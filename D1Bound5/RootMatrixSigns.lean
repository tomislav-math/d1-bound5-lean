import D1Bound5.RootErrorMagnitude
import Mathlib.Analysis.Complex.Polynomial.Basic

namespace D1Bound5

/-- The two numerical inequalities required of a normalized signed entry. -/
def SignedEntryGood {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b : R) (u v : ℂ) (r : R) : Prop :=
  ‖u * f r * v - f a * f b‖ < (16/31 : ℝ) ∧
  ‖(u * f r * v - f a * f b) - (1/2 : ℂ)‖ < (128/8649 : ℝ)

/-- One of the two integral signs satisfies both normalized bounds.
The proof uses only the two possible signs of an existing root. -/
theorem signed_entry_good_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b)
    (hr : r^2 = a*b+1) (hab : 9 ≤ ‖f a * f b‖) :
    SignedEntryGood f a b u v r ∨ SignedEntryGood f a b u v (-r) := by
  have hrC : (f r)^2 = f a * f b + 1 := by
    have h := congrArg f hr
    simpa only [map_pow, map_mul, map_add, map_one] using h
  obtain ⟨t, ht, hnear, hhalf⟩ :=
    exists_small_normalized_root_error (f a) (f b) u v (f r) hu hv hrC hab
  rcases ht with h | h
  · left
    simpa only [SignedEntryGood, ← h] using And.intro hnear hhalf
  · right
    have hsign : u * f (-r) * v = t := by
      rw [h, map_neg]
      ring
    simpa only [SignedEntryGood, hsign] using And.intro hnear hhalf

end D1Bound5

namespace D1Bound5

/-- Interchanging endpoints preserves the two error inequalities. -/
theorem signed_entry_good_swap {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (h : SignedEntryGood f a b u v r) :
    SignedEntryGood f b a v u r := by
  unfold SignedEntryGood at h ⊢
  have heq : v * f r * u = u * f r * v := by ring
  rw [heq, mul_comm (f b) (f a)]
  exact h

/-- The signs can be chosen for all six unordered off-diagonal positions
of a symmetric four-by-four integral root matrix simultaneously. The
chosen matrix remains symmetric and its entries remain in the original ring.
No nonzero-root or distinct-modulus assumptions are used. -/
theorem exists_good_symmetric_root_matrix {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (M : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hlarge : ∀ i j, i ≠ j → 9 ≤ ‖f (a i) * f (a j)‖) :
    ∃ S : Matrix (Fin 4) (Fin 4) R,
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      (∀ i j, i ≠ j → SignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) := by
  classical
  let q : Fin 4 → Fin 4 → R := fun i j =>
    if SignedEntryGood f (a i) (a j) (u i) (u j) (M i j) then
      M i j else -M i j
  have hqsign (i j : Fin 4) : q i j = M i j ∨ q i j = -M i j := by
    dsimp [q]
    split_ifs
    · exact Or.inl rfl
    · exact Or.inr rfl
  have hqgood (i j : Fin 4) (hij : i ≠ j) :
      SignedEntryGood f (a i) (a j) (u i) (u j) (q i j) := by
    dsimp [q]
    split_ifs with h
    · exact h
    · rcases signed_entry_good_or_neg f (a i) (a j) (M i j)
        (u i) (u j) (hu i) (hu j) (hroot i j hij)
        (hlarge i j hij) with hp | hn
      · exact False.elim (h hp)
      · exact hn
  let S : Matrix (Fin 4) (Fin 4) R := fun i j =>
    if i = j then a i else q (min i j) (max i j)
  have hSdiag (i : Fin 4) : S i i = a i := by simp [S]
  have hSsym (i j : Fin 4) : S i j = S j i := by
    by_cases h : i = j
    · subst j
      rfl
    · simp [S, h, Ne.symm h, min_comm, max_comm]
  have hSsign (i j : Fin 4) (hij : i ≠ j) :
      S i j = M i j ∨ S i j = -M i j := by
    rcases lt_trichotomy i j with hlt | heq | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using hqsign i j
    · exact False.elim (hij heq)
    · have hq := hqsign j i
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le, hsymm j i] using hq
  have hSroot (i j : Fin 4) (hij : i ≠ j) :
      (S i j)^2 = a i * a j + 1 := by
    rcases hSsign i j hij with h | h
    · rw [h]
      exact hroot i j hij
    · rw [h]
      simpa only [neg_sq] using hroot i j hij
  have hSgood (i j : Fin 4) (hij : i ≠ j) :
      SignedEntryGood f (a i) (a j) (u i) (u j) (S i j) := by
    rcases lt_trichotomy i j with hlt | heq | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using
        hqgood i j hij
    · exact False.elim (hij heq)
    · have h := signed_entry_good_swap f (a j) (a i) (q j i) (u j) (u i)
        (hqgood j i hij.symm)
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le] using h
  exact ⟨S, hSdiag, hSsym, hSsign, hSroot, hSgood⟩

end D1Bound5

namespace D1Bound5

/-- Simultaneously choose complex square roots of the four diagonal
entries and integral signs of all six off-diagonal roots. The
normalization is uniform without selecting an analytic square-root branch. -/
theorem exists_good_symmetric_root_matrix_with_roots
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
      (∀ i j, i ≠ j →
        SignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) := by
  classical
  have hr (i : Fin 4) : ∃ z : ℂ, z^2 = f (a i) :=
    IsAlgClosed.exists_pow_nat_eq (f (a i)) (by decide : 0 < 2)
  let u : Fin 4 → ℂ := fun i => Classical.choose (hr i)
  have hu (i : Fin 4) : (u i)^2 = f (a i) := Classical.choose_spec (hr i)
  obtain ⟨S, hd, hs, hsgn, hsq, hnear⟩ :=
    exists_good_symmetric_root_matrix f a u M hu hdiag hsymm hroot hlarge
  exact ⟨u, S, hu, hd, hs, hsgn, hsq, hnear⟩

end D1Bound5
