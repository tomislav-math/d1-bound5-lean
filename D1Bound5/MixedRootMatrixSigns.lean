import D1Bound5.RootErrorMagnitude
import D1Bound5.RootMatrixSigns

namespace D1Bound5

/-- Two scalar perturbation bounds for an integral root and chosen complex square roots. -/
def SignedEntryBounds {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b : R) (u v : ℂ) (r : R) (rho eta : ℝ) : Prop :=
  ‖u * f r * v - f a * f b‖ < rho ∧
  ‖(u * f r * v - f a * f b) - (1/2 : ℂ)‖ < eta

theorem signedEntryBounds_swap {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ) (rho eta : ℝ)
    (h : SignedEntryBounds f a b u v r rho eta) :
    SignedEntryBounds f b a v u r rho eta := by
  unfold SignedEntryBounds at h ⊢
  have heq : v * f r * u = u * f r * v := by ring
  rw [heq, mul_comm (f b) (f a)]
  exact h

theorem signedEntryBounds_three_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b)
    (hr : r^2 = a*b+1) (hab : 3 ≤ ‖f a * f b‖) :
    SignedEntryBounds f a b u v r (5/9) (25/486) ∨
      SignedEntryBounds f a b u v (-r) (5/9) (25/486) := by
  have ht : (u * f r * v)^2 = (f a * f b) * (f a * f b + 1) := by
    rw [mul_pow, mul_pow, hu, hv]
    have h := congrArg f hr
    simp only [map_pow, map_mul, map_add, map_one] at h
    rw [h]
    ring
  obtain ⟨t, ht', hn, he⟩ :=
    exists_root_error_three (f a * f b) (u * f r * v) hab ht
  rcases ht' with ht' | ht'
  · left
    simpa only [SignedEntryBounds, ← ht'] using And.intro hn he
  · right
    have hsign : u * f (-r) * v = t := by
      rw [ht', map_neg]
      ring
    simpa only [SignedEntryBounds, hsign] using And.intro hn he

theorem signedEntryBounds_twelve_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b)
    (hr : r^2 = a*b+1) (hab : 12 ≤ ‖f a * f b‖) :
    SignedEntryBounds f a b u v r (7/13) (1/64) ∨
      SignedEntryBounds f a b u v (-r) (7/13) (1/64) := by
  have ht : (u * f r * v)^2 = (f a * f b) * (f a * f b + 1) := by
    rw [mul_pow, mul_pow, hu, hv]
    have h := congrArg f hr
    simp only [map_pow, map_mul, map_add, map_one] at h
    rw [h]
    ring
  obtain ⟨t, ht', hn, he⟩ :=
    exists_root_error_twelve (f a * f b) (u * f r * v) hab ht
  rcases ht' with ht' | ht'
  · left
    simpa only [SignedEntryBounds, ← ht'] using And.intro hn he
  · right
    have hsign : u * f (-r) * v = t := by
      rw [ht', map_neg]
      ring
    simpa only [SignedEntryBounds, hsign] using And.intro hn he

/-- The nine-threshold estimate is already stronger than the requested
twelve-threshold constants: 16/31 < 7/13 and 128/8649 < 1/64.
This avoids any unproved B*C >= 12 assumption for ordered quadruples. -/
theorem signedEntryBounds_nine_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b)
    (hr : r^2 = a*b+1) (hab : 9 ≤ ‖f a * f b‖) :
    SignedEntryBounds f a b u v r (7/13) (1/64) ∨
      SignedEntryBounds f a b u v (-r) (7/13) (1/64) := by
  have h1 : (16/31 : ℝ) < 7/13 := by norm_num
  have h2 : (128/8649 : ℝ) < 1/64 := by norm_num
  rcases signed_entry_good_or_neg f a b r u v hu hv hr hab with h | h
  · exact Or.inl ⟨lt_trans h.1 h1, lt_trans h.2 h2⟩
  · exact Or.inr ⟨lt_trans h.1 h1, lt_trans h.2 h2⟩

/-- Row-dependent estimates: pairs meeting zero use the three-bound;
all other pairs use the nine-bound, yielding the tighter later constants. -/
def MixedSignedEntryGood {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (i j : Fin 4) (r : R) : Prop :=
  if i = 0 ∨ j = 0 then
    SignedEntryBounds f (a i) (a j) (u i) (u j) r (5/9) (25/486)
  else
    SignedEntryBounds f (a i) (a j) (u i) (u j) r (7/13) (1/64)

theorem mixedSignedEntryGood_swap {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (i j : Fin 4) (r : R)
    (h : MixedSignedEntryGood f a u i j r) :
    MixedSignedEntryGood f a u j i r := by
  by_cases hi : i = 0 ∨ j = 0
  · have hj : j = 0 ∨ i = 0 := by tauto
    have hx : SignedEntryBounds f (a i) (a j) (u i) (u j) r (5/9) (25/486) := by
      simpa [MixedSignedEntryGood, hi] using h
    simpa [MixedSignedEntryGood, hj] using
      signedEntryBounds_swap f (a i) (a j) r (u i) (u j) (5/9) (25/486) hx
  · have hj : ¬(j = 0 ∨ i = 0) := by tauto
    have hx : SignedEntryBounds f (a i) (a j) (u i) (u j) r (7/13) (1/64) := by
      simpa [MixedSignedEntryGood, hi] using h
    simpa [MixedSignedEntryGood, hj] using
      signedEntryBounds_swap f (a i) (a j) r (u i) (u j) (7/13) (1/64) hx

theorem mixedSignedEntryGood_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (i j : Fin 4) (r : R)
    (hu : ∀ k, (u k)^2 = f (a k))
    (hr : r^2 = a i*a j+1)
    (hfirst : i = 0 ∨ j = 0 → 3 ≤ ‖f (a i) * f (a j)‖)
    (hlater : ¬(i = 0 ∨ j = 0) → 9 ≤ ‖f (a i) * f (a j)‖) :
    MixedSignedEntryGood f a u i j r ∨
      MixedSignedEntryGood f a u i j (-r) := by
  unfold MixedSignedEntryGood
  split_ifs with h
  · exact signedEntryBounds_three_or_neg f (a i) (a j) r (u i) (u j)
      (hu i) (hu j) hr (hfirst h)
  · exact signedEntryBounds_nine_or_neg f (a i) (a j) r (u i) (u j)
      (hu i) (hu j) hr (hlater h)

end D1Bound5
namespace D1Bound5

/-- A single symmetric integral sign choice gives the mixed first-row and
later-row bounds, requiring norm >= 3 on the first row and >= 9 elsewhere.
No C >= 4 hypothesis is needed for ordered quadruples. -/
theorem exists_mixed_symmetric_root_matrix
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (M : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      3 ≤ ‖f (a i) * f (a j)‖)
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      9 ≤ ‖f (a i) * f (a j)‖) :
    ∃ S : Matrix (Fin 4) (Fin 4) R,
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      (∀ i j, i ≠ j → MixedSignedEntryGood f a u i j (S i j)) := by
  classical
  let q : Fin 4 → Fin 4 → R := fun i j =>
    if MixedSignedEntryGood f a u i j (M i j) then
      M i j else -M i j
  have hqsign (i j : Fin 4) : q i j = M i j ∨ q i j = -M i j := by
    dsimp [q]
    split_ifs
    · exact Or.inl rfl
    · exact Or.inr rfl
  have hqgood (i j : Fin 4) (hij : i ≠ j) :
      MixedSignedEntryGood f a u i j (q i j) := by
    dsimp [q]
    split_ifs with h
    · exact h
    · rcases mixedSignedEntryGood_or_neg f a u i j (M i j) hu
        (hroot i j hij) (hfirst i j hij) (hlater i j hij) with hp | hn
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
      MixedSignedEntryGood f a u i j (S i j) := by
    rcases lt_trichotomy i j with hlt | heq | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using
        hqgood i j hij
    · exact False.elim (hij heq)
    · have h := mixedSignedEntryGood_swap f a u j i (q j i)
        (hqgood j i hij.symm)
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le] using h
  exact ⟨S, hSdiag, hSsym, hSsign, hSroot, hSgood⟩

/-- Also choose the four complex square roots, preserving the integral
symmetric matrix and the exact root-square equations. -/
theorem exists_mixed_symmetric_root_matrix_with_roots
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (M : Matrix (Fin 4) (Fin 4) R)
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      3 ≤ ‖f (a i) * f (a j)‖)
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      9 ≤ ‖f (a i) * f (a j)‖) :
    ∃ (u : Fin 4 → ℂ) (S : Matrix (Fin 4) (Fin 4) R),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      (∀ i j, i ≠ j → MixedSignedEntryGood f a u i j (S i j)) := by
  classical
  have hr (i : Fin 4) : ∃ z : ℂ, z^2 = f (a i) :=
    IsAlgClosed.exists_pow_nat_eq (f (a i)) (by decide : 0 < 2)
  let u : Fin 4 → ℂ := fun i => Classical.choose (hr i)
  have hu (i : Fin 4) : (u i)^2 = f (a i) := Classical.choose_spec (hr i)
  obtain ⟨S, hd, hs, hsgn, hsq, hnear⟩ :=
    exists_mixed_symmetric_root_matrix f a u M hu hdiag hsymm hroot hfirst hlater
  exact ⟨u, S, hu, hd, hs, hsgn, hsq, hnear⟩

end D1Bound5
