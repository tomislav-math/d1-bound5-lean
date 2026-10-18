import D1Bound5.PairCachedResidues

namespace D1Bound5

/-- Check one supplied rejecting position in the existing ordered cached
sieve. The same index selects the mask and both cached residues. Missing or
out-of-range entries reject the certificate; they never supply a default. -/
def pairSelectedCachedMaskRejectBool (tau nu : ℤ) (sieve : List (ℕ × ℕ))
    (xs ys : List (ℕ × ℕ)) (i : ℕ) : Bool :=
  match sieve[i]?, xs[i]?, ys[i]? with
  | some (k, mask), some u, some v => !pairResidueMaskBool tau nu k mask u v
  | _, _, _ => false

/-- One genuinely rejecting aligned conjunct makes the entire original
cached sieve false. This is a statement about the exact old Boolean, so no
signature-validity, mask-validity, or discriminant assumption is needed. -/
theorem pairSelectedCachedMaskRejectBool_sound (tau nu : ℤ)
    (sieve : List (ℕ × ℕ)) (xs ys : List (ℕ × ℕ)) (i : ℕ)
    (hcheck : pairSelectedCachedMaskRejectBool tau nu sieve xs ys i = true) :
    pairCachedCoordinateSieveBool tau nu sieve xs ys = false := by
  induction i generalizing sieve xs ys with
  | zero =>
      cases sieve with
      | nil => simp [pairSelectedCachedMaskRejectBool] at hcheck
      | cons item sieve =>
          cases xs with
          | nil => rfl
          | cons u xs =>
              cases ys with
              | nil => rfl
              | cons v ys =>
                  rcases item with ⟨k, mask⟩
                  change (!pairResidueMaskBool tau nu k mask u v) = true at hcheck
                  change (pairResidueMaskBool tau nu k mask u v &&
                    pairCachedCoordinateSieveBool tau nu sieve xs ys) = false
                  cases hm : pairResidueMaskBool tau nu k mask u v with
                  | false => simp only [Bool.false_and]
                  | true =>
                      simp only [hm, Bool.not_true, Bool.false_eq_true] at hcheck
  | succ i ih =>
      cases sieve with
      | nil => simp [pairSelectedCachedMaskRejectBool] at hcheck
      | cons item sieve =>
          cases xs with
          | nil => rfl
          | cons u xs =>
              cases ys with
              | nil => rfl
              | cons v ys =>
                  change pairSelectedCachedMaskRejectBool tau nu sieve xs ys i = true at hcheck
                  have htail := ih sieve xs ys hcheck
                  rcases item with ⟨k, mask⟩
                  change (pairResidueMaskBool tau nu k mask u v &&
                    pairCachedCoordinateSieveBool tau nu sieve xs ys) = false
                  rw [htail, Bool.and_false]

end D1Bound5
