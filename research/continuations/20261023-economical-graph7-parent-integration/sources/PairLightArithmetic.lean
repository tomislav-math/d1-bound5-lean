import Init

namespace D1Bound5

/-!
Optional computation-only version of the raw selected-floor checker.

This module intentionally imports no D1Bound5 or Mathlib proof module. Coordinates
are ordinary integer pairs and cached signatures are ordinary natural pairs.
An exact Boolean equality with PairRawSelectedFloorWitnesses belongs in a separate
bridge module; these definitions alone make no mathematical soundness claim.
-/

abbrev PairLightCoordinate := Int × Int
abbrev PairLightSignature := List (Nat × Nat)
abbrev PairLightCachedVertex := PairLightCoordinate × PairLightSignature

/-- Coordinates of x*y+1 for omega^2 = tau*omega-nu. -/
def pairLightProductPlusOne (tau nu : Int)
    (x y : PairLightCoordinate) : PairLightCoordinate :=
  (x.1 * y.1 + (-nu) * x.2 * y.2 + 1,
    x.1 * y.2 + x.2 * y.1 + tau * x.2 * y.2)

/-- The integral quadratic norm, without an algebra structure or embedding. -/
def pairLightNorm (tau nu : Int) (z : PairLightCoordinate) : Int :=
  z.1 ^ 2 + tau * z.1 * z.2 + nu * z.2 ^ 2

/-- Canonical residues at the positive modulus k+1. -/
def pairLightCoordinateResidues (k : Nat) (z : PairLightCoordinate) : Nat × Nat :=
  ((z.1 % Int.ofNat (k + 1)).toNat, (z.2 % Int.ofNat (k + 1)).toNat)

def pairLightCoordinateSignature (sieve : List (Nat × Nat))
    (z : PairLightCoordinate) : PairLightSignature :=
  sieve.map fun item => pairLightCoordinateResidues item.1 z

/-- The raw natural mask polynomial. The negative nu and tau coefficients use
integer remainder followed by toNat, replacing only the corresponding ZMod.val.
No bound on the supplied natural residue pairs is assumed. -/
def pairLightResidueMaskNatBool (tau nu : Int) (k mask : Nat)
    (u v : Nat × Nat) : Bool :=
  let p := k + 1
  let nn := ((-nu) % Int.ofNat p).toNat
  let tt := (tau % Int.ofNat p).toNat
  let real := (u.1 * v.1 + nn * u.2 * v.2 + 1) % p
  let imag := (u.1 * v.2 + u.2 * v.1 + tt * u.2 * v.2) % p
  mask.testBit (real * p + imag)

/-- The same aligned lookup; a missing mask or either residue rejects. -/
def pairLightSelectedMaskRejectBool (tau nu : Int) (sieve : List (Nat × Nat))
    (xs ys : PairLightSignature) (i : Nat) : Bool :=
  match sieve[i]?, xs[i]?, ys[i]? with
  | some (k, mask), some u, some v => !pairLightResidueMaskNatBool tau nu k mask u v
  | _, _, _ => false

/-- The accepted negative-integer guard expressed in plain coordinates.
Unsupported traces and zero radicands retain the original behavior. -/
def pairLightNegativeIntegerObstructionBool (tau nu : Int)
    (z : PairLightCoordinate) : Bool :=
  decide (z.2 = 0 ∧ z.1 < 0) &&
    (if tau = 0 then decide (¬ nu ∣ z.1)
     else if tau = 1 then decide (¬ (4 * nu - 1) ∣ z.1)
     else false)

/-- The same strict square intervals, branch order, and integer scales as the
accepted floor checker; nonreal coordinates use the integral norm above. -/
def pairLightFloorObstructionBool (tau nu : Int)
    (z : PairLightCoordinate) (k : Nat) : Bool :=
  if z.2 = 0 then
    if 0 < z.1 then
      decide ((Int.ofNat k) ^ 2 < z.1 ∧ z.1 < (Int.ofNat k + 1) ^ 2)
    else if tau = 0 then
      decide (nu * (Int.ofNat k) ^ 2 < -z.1 ∧
        -z.1 < nu * (Int.ofNat k + 1) ^ 2)
    else if tau = 1 then
      decide ((4 * nu - 1) * (Int.ofNat k) ^ 2 < -z.1 ∧
        -z.1 < (4 * nu - 1) * (Int.ofNat k + 1) ^ 2)
    else false
  else
    decide ((Int.ofNat k) ^ 2 < pairLightNorm tau nu z ∧
      pairLightNorm tau nu z < (Int.ofNat k + 1) ^ 2)

/-- Full-tail recursion, packed base-32 tags, floor consumption and exhaustion
are unchanged from pairRawSelectedFloorRowBool. In particular a zero word does
not skip the remaining tail; tags 25--29 reject. -/
def pairLightSelectedFloorRowBool (tau nu : Int) (sieve : List (Nat × Nat))
    (x : PairLightCachedVertex) :
    List PairLightCachedVertex → Nat → List Nat → Bool
  | [], code, ks => decide (code = 0 ∧ ks = [])
  | y :: ys, code, ks =>
      if code % 32 < 25 then
        pairLightSelectedMaskRejectBool tau nu sieve x.2 y.2 (code % 32) &&
          pairLightSelectedFloorRowBool tau nu sieve x ys (code / 32) ks
      else if code % 32 = 30 then
        decide (x.1 = y.1) &&
          pairLightSelectedFloorRowBool tau nu sieve x ys (code / 32) ks
      else if code % 32 = 31 then
        if pairLightNegativeIntegerObstructionBool tau nu
            (pairLightProductPlusOne tau nu x.1 y.1) = true then
          pairLightSelectedFloorRowBool tau nu sieve x ys (code / 32) ks
        else match ks with
          | [] => false
          | k :: rest =>
              pairLightFloorObstructionBool tau nu
                  (pairLightProductPlusOne tau nu x.1 y.1) k &&
                pairLightSelectedFloorRowBool tau nu sieve x ys (code / 32) rest
      else false

/-- Exact outer lockstep traversal; unmatched vertex/witness tails reject. -/
def pairLightSelectedFloorIndependentBool (tau nu : Int)
    (sieve : List (Nat × Nat)) :
    List PairLightCachedVertex → List (Nat × List Nat) → Bool
  | [], [] => true
  | x :: xs, (code, ks) :: rows =>
      pairLightSelectedFloorRowBool tau nu sieve x xs code ks &&
        pairLightSelectedFloorIndependentBool tau nu sieve xs rows
  | _, _ => false

/-- Full original ordered coverage and every canonical signature are checked
before the independent-class computation. No supplied coordinate data is trusted. -/
def pairLightSelectedFloorIndependentCertificateBool (tau nu : Int)
    (sieve : List (Nat × Nat)) (vertices : List PairLightCoordinate)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat)) : Bool :=
  decide (cached.map Prod.fst = vertices) &&
    ((cached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) &&
      pairLightSelectedFloorIndependentBool tau nu sieve cached rows)

end D1Bound5
