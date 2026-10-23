import D1Bound5.PairLightArithmeticChunks
import Mathlib.Data.List.Basic

namespace D1Bound5

/-- Exact factorization for all inputs, including malformed witness lists.
The first factor checks each early head against its full tail. -/
theorem pairLightSelectedFloorIndependentBool_eq_prefix_drop
    (tau nu : Int) (sieve : List (Nat × Nat)) (n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat)) :
    pairLightSelectedFloorIndependentBool tau nu sieve cached rows =
      (pairLightSelectedFloorPrefixBool tau nu sieve n cached rows &&
        pairLightSelectedFloorIndependentBool tau nu sieve (cached.drop n) (rows.drop n)) := by
  induction n generalizing cached rows with
  | zero =>
      simp only [pairLightSelectedFloorPrefixBool, List.drop_zero, Bool.true_and]
  | succ n ih =>
      cases cached with
      | nil => cases rows <;> rfl
      | cons x xs =>
          cases rows with
          | nil => rfl
          | cons item rows =>
              rcases item with ⟨code, ks⟩
              change
                (pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
                  pairLightSelectedFloorIndependentBool tau nu sieve xs rows) =
                ((pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
                    pairLightSelectedFloorPrefixBool tau nu sieve n xs rows) &&
                  pairLightSelectedFloorIndependentBool tau nu sieve (xs.drop n) (rows.drop n))
              rw [ih xs rows, Bool.and_assoc]

/-- Assemble already checked proof constants without rerunning their arithmetic. -/
theorem pairLightSelectedFloorIndependentBool_of_prefix_drop
    (tau nu : Int) (sieve : List (Nat × Nat)) (n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat))
    (hprefix : pairLightSelectedFloorPrefixBool tau nu sieve n cached rows = true)
    (htail : pairLightSelectedFloorIndependentBool tau nu sieve
      (cached.drop n) (rows.drop n) = true) :
    pairLightSelectedFloorIndependentBool tau nu sieve cached rows = true :=
  (pairLightSelectedFloorIndependentBool_eq_prefix_drop tau nu sieve n cached rows).trans
    (Bool.and_eq_true_iff.mpr ⟨hprefix, htail⟩)

/-- Full ordered coverage and all canonical signatures remain mandatory.
Only the independence computation is divided into prefix proofs. -/
theorem pairLightSelectedFloorIndependentCertificateBool_of_checked_parts
    (tau nu : Int) (sieve : List (Nat × Nat))
    (vertices : List PairLightCoordinate) (cached : List PairLightCachedVertex)
    (rows : List (Nat × List Nat))
    (hcoverage : decide (cached.map Prod.fst = vertices) = true)
    (hsignatures : (cached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true)
    (hindependent : pairLightSelectedFloorIndependentBool tau nu sieve cached rows = true) :
    pairLightSelectedFloorIndependentCertificateBool tau nu sieve vertices cached rows = true :=
  Bool.and_eq_true_iff.mpr ⟨hcoverage, Bool.and_eq_true_iff.mpr ⟨hsignatures, hindependent⟩⟩

end D1Bound5
