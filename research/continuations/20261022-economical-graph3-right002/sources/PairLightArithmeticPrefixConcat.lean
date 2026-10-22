import D1Bound5.PairLightArithmeticChunkProofs

namespace D1Bound5

/-- Concatenate two finite head prefixes without shortening any head's tail.
The identity also covers malformed and unequal witness lists. -/
theorem pairLightSelectedFloorPrefixBool_add
    (tau nu : Int) (sieve : List (Nat × Nat)) (m n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat)) :
    pairLightSelectedFloorPrefixBool tau nu sieve (m+n) cached rows =
      (pairLightSelectedFloorPrefixBool tau nu sieve m cached rows &&
        pairLightSelectedFloorPrefixBool tau nu sieve n (cached.drop m) (rows.drop m)) := by
  induction m generalizing cached rows with
  | zero =>
      simp only [Nat.zero_add, pairLightSelectedFloorPrefixBool, List.drop_zero, Bool.true_and]
  | succ m ih =>
      cases cached with
      | nil =>
          cases rows <;> cases n <;>
            simp [Nat.succ_add, pairLightSelectedFloorPrefixBool]
      | cons x xs =>
          cases rows with
          | nil => simp [Nat.succ_add, pairLightSelectedFloorPrefixBool]
          | cons item rows =>
              rcases item with ⟨code, ks⟩
              rw [Nat.succ_add]
              change
                (pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
                  pairLightSelectedFloorPrefixBool tau nu sieve (m+n) xs rows) =
                ((pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
                    pairLightSelectedFloorPrefixBool tau nu sieve m xs rows) &&
                  pairLightSelectedFloorPrefixBool tau nu sieve n (xs.drop m) (rows.drop m))
              rw [ih xs rows, Bool.and_assoc]

/-- Join two checked finite prefixes without re-executing either certificate. -/
theorem pairLightSelectedFloorPrefixBool_of_add
    (tau nu : Int) (sieve : List (Nat × Nat)) (m n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat))
    (hm : pairLightSelectedFloorPrefixBool tau nu sieve m cached rows = true)
    (hn : pairLightSelectedFloorPrefixBool tau nu sieve n
      (cached.drop m) (rows.drop m) = true) :
    pairLightSelectedFloorPrefixBool tau nu sieve (m+n) cached rows = true :=
  (pairLightSelectedFloorPrefixBool_add tau nu sieve m n cached rows).trans
    (Bool.and_eq_true_iff.mpr ⟨hm, hn⟩)

end D1Bound5
