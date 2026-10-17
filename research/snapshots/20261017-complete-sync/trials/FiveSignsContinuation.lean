import D1Bound5.ProductFivePrefixSigned
import D1Bound5.TupleRootMatrixBridge

namespace D1Bound5

/-- Uniform last-column estimate, including the endpoint |ab| = 54. -/
theorem signedEntryBounds_fiftyfour_or_neg
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b)
    (hr : r^2 = a*b+1) (hab : 54 ≤ ‖f a * f b‖) :
    SignedEntryBounds f a b u v r (50/99) (625/264627) ∨
      SignedEntryBounds f a b u v (-r) (50/99) (625/264627) := by
  let x := f a * f b
  have hx : 0 < ‖x‖ := by dsimp [x]; linarith
  have hg : 1 < (1-(49/50 : ℝ)^2)*‖x‖ := by
    dsimp [x]
    nlinarith only [hab]
  have ht : (u * f r * v)^2 = x*(x+1) := by
    have h := congrArg f hr
    simp only [map_pow, map_mul, map_add, map_one] at h
    rw [mul_pow, mul_pow, hu, hv, h]
    dsimp [x]
    ring
  obtain ⟨t, ht, hn, he⟩ := exists_root_error_control x (u*f r*v)
    (49/50) (by norm_num) hx hg ht
  have hn' : ‖t-x‖ < (50/99 : ℝ) := by nlinarith only [hn]
  have hm := mul_nonneg (sub_nonneg.mpr hab)
    (norm_nonneg ((t-x)-(1/2 : ℂ)))
  have he' : ‖(t-x)-(1/2 : ℂ)‖ < (625/264627 : ℝ) := by
    change 0 ≤ (‖x‖-54)*‖(t-x)-(1/2 : ℂ)‖ at hm
    nlinarith only [he, hm]
  rcases ht with ht | ht
  · left
    simpa only [SignedEntryBounds, ← ht, x] using And.intro hn' he'
  · right
    have hs : u*f (-r)*v = t := by rw [ht, map_neg]; ring
    simpa only [SignedEntryBounds, hs, x] using And.intro hn' he'

/-- The fifth-column bound takes priority over the mixed prefix bounds. -/
def FiveSignedEntryGood {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (i j : Fin 5) (r : R) : Prop :=
  if i = 4 ∨ j = 4 then
    SignedEntryBounds f (a i) (a j) (u i) (u j) r (50/99) (625/264627)
  else if i = 0 ∨ j = 0 then
    SignedEntryBounds f (a i) (a j) (u i) (u j) r (5/9) (25/486)
  else
    SignedEntryBounds f (a i) (a j) (u i) (u j) r (7/13) (1/64)

theorem fiveSignedEntryGood_swap {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (i j : Fin 5) (r : R) (h : FiveSignedEntryGood f a u i j r) :
    FiveSignedEntryGood f a u j i r := by
  by_cases h4 : i = 4 ∨ j = 4
  · have h4' : j = 4 ∨ i = 4 := by tauto
    have hh : SignedEntryBounds f (a i) (a j) (u i) (u j) r
        (50/99) (625/264627) := by simpa [FiveSignedEntryGood, h4] using h
    simpa [FiveSignedEntryGood, h4'] using
      signedEntryBounds_swap f (a i) (a j) r (u i) (u j) _ _ hh
  · have h4' : ¬(j = 4 ∨ i = 4) := by tauto
    by_cases h0 : i = 0 ∨ j = 0
    · have h0' : j = 0 ∨ i = 0 := by tauto
      have hh : SignedEntryBounds f (a i) (a j) (u i) (u j) r
          (5/9) (25/486) := by simpa [FiveSignedEntryGood, h4, h0] using h
      simpa [FiveSignedEntryGood, h4', h0'] using
        signedEntryBounds_swap f (a i) (a j) r (u i) (u j) _ _ hh
    · have h0' : ¬(j = 0 ∨ i = 0) := by tauto
      have hh : SignedEntryBounds f (a i) (a j) (u i) (u j) r
          (7/13) (1/64) := by simpa [FiveSignedEntryGood, h4, h0] using h
      simpa [FiveSignedEntryGood, h4', h0'] using
        signedEntryBounds_swap f (a i) (a j) r (u i) (u j) _ _ hh

theorem fiveSignedEntryGood_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (i j : Fin 5) (r : R)
    (hu : ∀ k, (u k)^2 = f (a k))
    (hr : r^2 = a i*a j+1)
    (hfirst : 3 ≤ ‖f (a i)*f (a j)‖)
    (hlater : ¬(i = 0 ∨ j = 0) → 9 ≤ ‖f (a i)*f (a j)‖)
    (hlast : i = 4 ∨ j = 4 → 54 ≤ ‖f (a i)*f (a j)‖) :
    FiveSignedEntryGood f a u i j r ∨ FiveSignedEntryGood f a u i j (-r) := by
  unfold FiveSignedEntryGood
  split_ifs with h4 h0
  · exact signedEntryBounds_fiftyfour_or_neg f (a i) (a j) r
      (u i) (u j) (hu i) (hu j) hr (hlast h4)
  · exact signedEntryBounds_three_or_neg f (a i) (a j) r
      (u i) (u j) (hu i) (hu j) hr hfirst
  · exact signedEntryBounds_nine_or_neg f (a i) (a j) r
      (u i) (u j) (hu i) (hu j) hr (hlater h0)

/-- One simultaneous choice for all ten original-ring roots. -/
theorem exists_five_signed_root_matrix
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (M : Matrix (Fin 5) (Fin 5) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (_hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hfirst : ∀ i j, i ≠ j →
      3 ≤ ‖f (a i) * f (a j)‖)
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      9 ≤ ‖f (a i) * f (a j)‖)
    (hlast : ∀ i j, i ≠ j → i = 4 ∨ j = 4 →
      54 ≤ ‖f (a i) * f (a j)‖) :
    ∃ S : Matrix (Fin 5) (Fin 5) R,
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      (∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) := by
  classical
  let q : Fin 5 → Fin 5 → R := fun i j =>
    if FiveSignedEntryGood f a u i j (M i j) then
      M i j else -M i j
  have hqsign (i j : Fin 5) : q i j = M i j ∨ q i j = -M i j := by
    dsimp [q]
    split_ifs
    · exact Or.inl rfl
    · exact Or.inr rfl
  have hqgood (i j : Fin 5) (hij : i ≠ j) :
      FiveSignedEntryGood f a u i j (q i j) := by
    dsimp [q]
    split_ifs with h
    · exact h
    · rcases fiveSignedEntryGood_or_neg f a u i j (M i j) hu
        (hroot i j hij) (hfirst i j hij) (hlater i j hij) (hlast i j hij) with hp | hn
      · exact False.elim (h hp)
      · exact hn
  let S : Matrix (Fin 5) (Fin 5) R := fun i j =>
    if i = j then a i else q (min i j) (max i j)
  have hSdiag (i : Fin 5) : S i i = a i := by simp [S]
  have hSsym (i j : Fin 5) : S i j = S j i := by
    by_cases h : i = j
    · subst j
      rfl
    · simp [S, h, Ne.symm h, min_comm, max_comm]
  have hSsign (i j : Fin 5) (hij : i ≠ j) :
      S i j = M i j ∨ S i j = -M i j := by
    rcases lt_trichotomy i j with hlt | heq | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using hqsign i j
    · exact False.elim (hij heq)
    · have hq := hqsign j i
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le, hsymm j i] using hq
  have hSroot (i j : Fin 5) (hij : i ≠ j) :
      (S i j)^2 = a i * a j + 1 := by
    rcases hSsign i j hij with h | h
    · rw [h]
      exact hroot i j hij
    · rw [h]
      simpa only [neg_sq] using hroot i j hij
  have hSgood (i j : Fin 5) (hij : i ≠ j) :
      FiveSignedEntryGood f a u i j (S i j) := by
    rcases lt_trichotomy i j with hlt | heq | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using
        hqgood i j hij
    · exact False.elim (hij heq)
    · have h := fiveSignedEntryGood_swap f a u j i (q j i)
        (hqgood j i hij.symm)
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le] using h
  exact ⟨S, hSdiag, hSsym, hSsign, hSroot, hSgood⟩

/-- A simultaneous five-entry choice retains the existing mixed prefix predicate. -/
theorem fiveSignedEntryGood_prefix {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hgood : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) :
    ∀ i j : Fin 4, i ≠ j →
      MixedSignedEntryGood f (fun k => a (Fin.castAdd 1 k))
        (fun k => u (Fin.castAdd 1 k)) i j
        (S (Fin.castAdd 1 i) (Fin.castAdd 1 j)) := by
  have h4 (i : Fin 4) : Fin.castAdd 1 i ≠ (4 : Fin 5) := by
    intro h
    have hv := congrArg (fun k : Fin 5 => k.val) h
    change i.val = 4 at hv
    omega
  have h0 (i : Fin 4) : Fin.castAdd 1 i = (0 : Fin 5) ↔ i = 0 := by
    constructor
    · intro h
      apply Fin.ext
      exact congrArg (fun k : Fin 5 => k.val) h
    · intro h
      subst i
      rfl
  intro i j hij
  have hne : Fin.castAdd 1 i ≠ Fin.castAdd 1 j := by
    intro h
    exact hij (Fin.ext (congrArg (fun k : Fin 5 => k.val) h))
  have h := hgood (Fin.castAdd 1 i) (Fin.castAdd 1 j) hne
  simpa only [FiveSignedEntryGood, h4 i, h4 j, false_or, ite_false,
    h0 i, h0 j, MixedSignedEntryGood] using h

/-- Last-column bounds refer to the SAME normalized five-entry matrix. -/
theorem fiveSignedEntryGood_last_column {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hgood : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) :
    ∀ i : Fin 4,
      ‖fiveLastError (normalizedRootError (fun k => f (a k)) u
        (fun k l => f (S k l))) i‖ < (50/99 : ℝ) ∧
      ‖fiveLastError (normalizedRootError (fun k => f (a k)) u
        (fun k l => f (S k l))) i - (1/2 : ℂ)‖ < (1/400 : ℝ) := by
  intro i
  have hi : Fin.castAdd 1 i ≠ (4 : Fin 5) := by
    intro h
    have hv := congrArg (fun k : Fin 5 => k.val) h
    change i.val = 4 at hv
    omega
  have h : SignedEntryBounds f (a (Fin.castAdd 1 i)) (a 4)
      (u (Fin.castAdd 1 i)) (u 4) (S (Fin.castAdd 1 i) 4)
      (50/99) (625/264627) := by
    simpa [FiveSignedEntryGood] using hgood (Fin.castAdd 1 i) 4 hi
  exact ⟨h.1, lt_trans h.2 (by norm_num)⟩

/-- Choose all five complex square roots and all ten original-ring signs.
The prefix determinant and last-column bounds use a single witness S. -/
theorem exists_five_signed_root_matrix_with_bounds
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (M : Matrix (Fin 5) (Fin 5) R)
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hfirst : ∀ i j, i ≠ j → 3 ≤ ‖f (a i)*f (a j)‖)
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      9 ≤ ‖f (a i)*f (a j)‖)
    (hlast : ∀ i j, i ≠ j → i = 4 ∨ j = 4 →
      54 ≤ ‖f (a i)*f (a j)‖) :
    ∃ (u : Fin 5 → ℂ) (S : Matrix (Fin 5) (Fin 5) R),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → S i j = M i j ∨ S i j = -M i j) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i*a j+1) ∧
      (∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) ∧
      ‖(fivePrefixError (normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j)))).det‖ < (33/128 : ℝ) ∧
      (∀ i : Fin 4,
        ‖fiveLastError (normalizedRootError (fun k => f (a k)) u
          (fun k l => f (S k l))) i - (1/2 : ℂ)‖ < (1/400 : ℝ)) := by
  classical
  have hr (i : Fin 5) : ∃ z : ℂ, z^2 = f (a i) :=
    IsAlgClosed.exists_pow_nat_eq (f (a i)) (by decide : 0 < 2)
  let u : Fin 5 → ℂ := fun i => Classical.choose (hr i)
  have hu (i : Fin 5) : (u i)^2 = f (a i) := Classical.choose_spec (hr i)
  obtain ⟨S, hd, hs, hsign, hsq, hg⟩ :=
    exists_five_signed_root_matrix f a u M hu hdiag hsymm hroot hfirst hlater hlast
  have hp := fiveSignedEntryGood_prefix f a u S hg
  have hdet := five_prefix_det_upper_of_mixed_signed_entries f a u S hu hd hs hp
  have hcol := fiveSignedEntryGood_last_column f a u S hg
  exact ⟨u, S, hu, hd, hs, hsign, hsq, hg, hdet, fun i => (hcol i).2⟩

open scoped NumberField
open Module

/-- The four large entries give the exact last-entry threshold used in the
last-column sign estimates. This is a consequence of an actual tuple. -/
theorem IsD1Tuple.five_last_modulus_gt_fiftyfour
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : 3 ≤ ‖phi (a 1 : K)‖) :
    54 < ‖phi (a 4 : K)‖ := by
  let b : Fin 4 → 𝓞 K := fun i => a i.succ
  have hb : IsD1Tuple b := by
    refine ⟨?_, ?_, ?_⟩
    · intro i j h
      apply Fin.ext
      have h' := congrArg (fun k : Fin 5 => k.val) (ha.1 h)
      simpa using h'
    · intro i
      exact ha.2.1 i.succ
    · intro i j hij
      exact ha.2.2 i.succ j.succ (by
        intro h
        apply hij
        apply Fin.ext
        have h' := congrArg (fun k : Fin 5 => k.val) h
        simpa using h')
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    apply hmon
    change i.val+1 ≤ j.val+1
    change i.val ≤ j.val at hij
    omega
  have hg := hb.productFour_large_growth hK phi b hbmon hB
  change 2 * ‖phi (a 1 : K)‖ * ‖phi (a 2 : K)‖ *
      ‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖ at hg
  have h2 : 3 ≤ ‖phi (a 2 : K)‖ := hB.trans (hmon (by decide))
  have h3 : 3 ≤ ‖phi (a 3 : K)‖ := hB.trans (hmon (by decide))
  have hp : 9 ≤ ‖phi (a 1 : K)‖ * ‖phi (a 2 : K)‖ := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hB) (sub_nonneg.mpr h2)]
  have hq := mul_nonneg (sub_nonneg.mpr hp) (sub_nonneg.mpr h3)
  nlinarith only [hg, hp, h3, hq]

/-- The actual ordered full-integer-ring D(1) quintuple supplies every
threshold: no unproved sign-existence or large-last-entry hypothesis remains. -/
theorem IsD1Tuple.exists_five_compatible_signed_matrix
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 1 ≤ ‖phi (a 0 : K)‖) (hB : 3 ≤ ‖phi (a 1 : K)‖) :
    let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
    ∃ (u : Fin 5 → ℂ) (S : Matrix (Fin 5) (Fin 5) (𝓞 K)),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i*a j+1) ∧
      (∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) ∧
      ‖(fivePrefixError (normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j)))).det‖ < (33/128 : ℝ) ∧
      (∀ i : Fin 4,
        ‖fiveLastError (normalizedRootError (fun k => f (a k)) u
          (fun k l => f (S k l))) i - (1/2 : ℂ)‖ < (1/400 : ℝ)) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hone (i : Fin 5) : 1 ≤ ‖f (a i)‖ := hA.trans (hmon (Fin.zero_le i))
  have hthree (i : Fin 5) (hi : i ≠ 0) : 3 ≤ ‖f (a i)‖ := by
    have hle : (1 : Fin 5) ≤ i := by omega
    exact hB.trans (hmon hle)
  have h54 : 54 ≤ ‖f (a 4)‖ :=
    (ha.five_last_modulus_gt_fiftyfour hK phi a hmon hB).le
  have hfirst (i j : Fin 5) (hij : i ≠ j) : 3 ≤ ‖f (a i)*f (a j)‖ := by
    rw [norm_mul]
    by_cases hi : i = 0
    · subst i
      have hi' := hone 0
      have hj' := hthree j hij.symm
      nlinarith [mul_nonneg (sub_nonneg.mpr hi') (sub_nonneg.mpr hj')]
    · have hi' := hthree i hi
      have hj' := hone j
      nlinarith [mul_nonneg (sub_nonneg.mpr hi') (sub_nonneg.mpr hj')]
  have hlater (i j : Fin 5) (_hij : i ≠ j) (h : ¬(i = 0 ∨ j = 0)) :
      9 ≤ ‖f (a i)*f (a j)‖ := by
    rw [norm_mul]
    have hi := hthree i (by tauto)
    have hj := hthree j (by tauto)
    nlinarith [mul_nonneg (sub_nonneg.mpr hi) (sub_nonneg.mpr hj)]
  have hlast (i j : Fin 5) (_hij : i ≠ j) (h : i = 4 ∨ j = 4) :
      54 ≤ ‖f (a i)*f (a j)‖ := by
    rw [norm_mul]
    rcases h with h | h
    · subst i
      have hj := hone j
      nlinarith [mul_nonneg (sub_nonneg.mpr h54) (sub_nonneg.mpr hj)]
    · subst j
      have hi := hone i
      nlinarith [mul_nonneg (sub_nonneg.mpr hi) (sub_nonneg.mpr h54)]
  obtain ⟨M, hd, hs, hsq⟩ := ha.exists_symmetric_root_matrix a
  obtain ⟨u, S, hu, hd', hs', _hsgn, hsq', hg, hdet, hcol⟩ :=
    exists_five_signed_root_matrix_with_bounds f a M hd hs hsq hfirst hlater hlast
  exact ⟨u, S, hu, hd', hs', hsq', hg, hdet, hcol⟩


/-- The last-column entry bounds imply the Euclidean estimates in
(integrated-4); the norm here is explicitly the L2 vector norm. -/
theorem fiveLastColumn_l2_bounds (v : Fin 4 → ℂ)
    (hv : ∀ i, ‖v i - (1/2 : ℂ)‖ < (1/400 : ℝ)) :
    ‖(WithLp.toLp 2 (fun i => v i - (1/2 : ℂ)) : EuclideanSpace ℂ (Fin 4))‖ <
        (1/200 : ℝ) ∧
    ‖(WithLp.toLp 2 v : EuclideanSpace ℂ (Fin 4))‖ < (201/200 : ℝ) := by
  let e : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 (fun i => v i - (1/2 : ℂ))
  let z : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 (fun _ => (1/2 : ℂ))
  let x : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 v
  have hsq (i : Fin 4) : ‖v i - (1/2 : ℂ)‖^2 < (1/400 : ℝ)^2 := by
    have hn := norm_nonneg (v i - (1/2 : ℂ))
    have h := hv i
    nlinarith only [h, hn]
  have hen : ‖e‖^2 = ∑ i : Fin 4, ‖v i - (1/2 : ℂ)‖^2 := by
    simpa [e] using EuclideanSpace.norm_sq_eq e
  have hes : ‖e‖^2 < (1/200 : ℝ)^2 := by
    rw [hen, Fin.sum_univ_four]
    linarith only [hsq 0, hsq 1, hsq 2, hsq 3]
  have he : ‖e‖ < (1/200 : ℝ) := by
    nlinarith only [hes, norm_nonneg e]
  have hzsq : ‖z‖^2 = 1 := by
    rw [EuclideanSpace.norm_sq_eq z, Fin.sum_univ_four]
    norm_num [z]
  have hz : ‖z‖ = 1 := by nlinarith only [hzsq, norm_nonneg z]
  have hx : x = e + z := by
    ext i
    change v i = (v i - (1/2 : ℂ)) + (1/2 : ℂ)
    ring
  have hxn : ‖x‖ < (201/200 : ℝ) := by
    have hb := norm_add_le e z
    rw [← hx, hz] at hb
    linarith only [hb, he]
  exact ⟨he, hxn⟩

end D1Bound5
