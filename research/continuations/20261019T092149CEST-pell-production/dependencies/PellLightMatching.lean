import Init

namespace D1Bound5

structure PellLightSquareMasks where
  k : Nat
  ordinary : Nat
  scaled : Nat
deriving DecidableEq, Repr

def pellLightScalarMaskBool (k mask : Nat) (z : Int) : Bool :=
  mask.testBit ((z % Int.ofNat (k + 1)).toNat)

def pellLightScalarMaskValidBool (c : Int) (k mask : Nat) : Bool :=
  (List.range (k + 1)).all fun r =>
    pellLightScalarMaskBool k mask (c * Int.ofNat r * Int.ofNat r)

def PellLightSquareMasks.validBool (d : Int) (m : PellLightSquareMasks) : Bool :=
  pellLightScalarMaskValidBool 1 m.k m.ordinary &&
    pellLightScalarMaskValidBool d m.k m.scaled

def pellLightDefaultMasks : PellLightSquareMasks := ⟨0, 1, 1⟩

def pellLightSelectMasks : List PellLightSquareMasks → Nat → PellLightSquareMasks
  | [], _ => pellLightDefaultMasks
  | m :: _, 0 => m
  | _ :: ms, n + 1 => pellLightSelectMasks ms n

def pellLightPairChecks (ms : List PellLightSquareMasks) (x : Int) :
    List Int → List (Nat × Nat) → Bool
  | [], [] => true
  | y :: ys, w :: ws =>
      let p := pellLightSelectMasks ms w.1
      let n := pellLightSelectMasks ms w.2
      ((!pellLightScalarMaskBool p.k p.ordinary (x*y+1)) &&
        (!pellLightScalarMaskBool n.k n.scaled (x*y-1))) &&
        pellLightPairChecks ms x ys ws
  | _, _ => false

def pellLightMatchingCheck (ms : List PellLightSquareMasks) :
    List Int → List (List (Nat × Nat)) → Bool
  | [], [] => true
  | x :: xs, ws :: wss =>
      pellLightPairChecks ms x xs ws && pellLightMatchingCheck ms xs wss
  | _, _ => false

end D1Bound5
