import D1Bound5.PairLightArithmetic

namespace D1Bound5

/-- Check at most n complete head rows. Every selected head is checked
against its entire remaining tail, including vertices beyond the cut.
This computation-only module retains the Init-only import closure. -/
def pairLightSelectedFloorPrefixBool (tau nu : Int) (sieve : List (Nat × Nat)) :
    Nat → List PairLightCachedVertex → List (Nat × List Nat) → Bool
  | 0, _, _ => true
  | _ + 1, [], [] => true
  | n + 1, x :: xs, (code, ks) :: rows =>
      pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
        pairLightSelectedFloorPrefixBool tau nu sieve n xs rows
  | _ + 1, _, _ => false

end D1Bound5
