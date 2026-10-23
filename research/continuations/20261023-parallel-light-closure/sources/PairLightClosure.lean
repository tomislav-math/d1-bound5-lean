import D1Bound5.PairLightArithmetic

namespace D1Bound5

/- Exact coordinate-only version of the indexed closure checker. Mathematical
soundness is established in PairLightClosureBridge, not assumed here. -/

def pairLightMul (tau nu : Int) (x y : PairLightCoordinate) : PairLightCoordinate :=
  (x.1 * y.1 + (-nu) * x.2 * y.2,
    x.1 * y.2 + x.2 * y.1 + tau * x.2 * y.2)

def pairLightAdd (x y : PairLightCoordinate) : PairLightCoordinate :=
  (x.1 + y.1, x.2 + y.2)

def pairLightNeg (x : PairLightCoordinate) : PairLightCoordinate := (-x.1, -x.2)

def pairLightMutate (tau nu : Int) (a b z r0 r s : PairLightCoordinate) :
    PairLightCoordinate :=
  pairLightAdd
    (pairLightAdd (pairLightAdd a b)
      (pairLightMul tau nu
        (pairLightAdd (pairLightMul tau nu (pairLightMul tau nu (2, 0) a) b) (1, 0)) z))
    (pairLightMul tau nu (pairLightMul tau nu (pairLightMul tau nu (2, 0) r0) r) s)

structure PairLightRootWitness where
  vertex : PairLightCoordinate
  leftRoot : PairLightCoordinate
  rightRoot : PairLightCoordinate

def pairLightIndexedCandidateCoveredBool (tau nu bound : Int)
    (vertices : List PairLightCoordinate) (w : PairLightCoordinate)
    (destination : Option Nat) : Bool :=
  match destination with
  | none => decide (bound < pairLightNorm tau nu w)
  | some i => decide (vertices[i]? = some w)

def pairLightIndexedRootWitnessCheckedBool (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate)
    (w : PairLightRootWitness) (destinations : Option Nat × Option Nat) : Bool :=
  decide (pairLightMul tau nu w.leftRoot w.leftRoot =
      pairLightProductPlusOne tau nu a w.vertex ∧
    pairLightMul tau nu w.rightRoot w.rightRoot =
      pairLightProductPlusOne tau nu b w.vertex) &&
    (pairLightIndexedCandidateCoveredBool tau nu bound vertices
        (pairLightMutate tau nu a b w.vertex r0 w.leftRoot w.rightRoot) destinations.1 &&
      pairLightIndexedCandidateCoveredBool tau nu bound vertices
        (pairLightMutate tau nu a b w.vertex r0 w.leftRoot (pairLightNeg w.rightRoot))
        destinations.2)

def pairLightIndexedWitnessesCheckedBool (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate) :
    List PairLightRootWitness → List (Option Nat × Option Nat) → Bool
  | [], [] => true
  | w :: ws, d :: ds =>
      pairLightIndexedRootWitnessCheckedBool tau nu a b r0 bound vertices w d &&
        pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices ws ds
  | _, _ => false

/-- A prefix always looks up destinations in the complete original list. -/
def pairLightIndexedWitnessesPrefixBool (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate) :
    Nat → List PairLightRootWitness → List (Option Nat × Option Nat) → Bool
  | 0, _, _ => true
  | _ + 1, [], [] => true
  | n + 1, w :: ws, d :: ds =>
      pairLightIndexedRootWitnessCheckedBool tau nu a b r0 bound vertices w d &&
        pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n ws ds
  | _ + 1, _, _ => false

theorem pairLightIndexedWitnessesCheckedBool_eq_prefix_drop (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate)
    (n : Nat) (witnesses : List PairLightRootWitness)
    (destinations : List (Option Nat × Option Nat)) :
    pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices witnesses destinations =
      (pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n witnesses destinations &&
        pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices
          (witnesses.drop n) (destinations.drop n)) := by
  induction n generalizing witnesses destinations with
  | zero =>
      simp only [pairLightIndexedWitnessesPrefixBool, List.drop_zero, Bool.true_and]
  | succ n ih =>
      cases witnesses with
      | nil => cases destinations <;> rfl
      | cons w ws =>
          cases destinations with
          | nil => rfl
          | cons d ds =>
              change
                (pairLightIndexedRootWitnessCheckedBool tau nu a b r0 bound vertices w d &&
                  pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices ws ds) =
                ((pairLightIndexedRootWitnessCheckedBool tau nu a b r0 bound vertices w d &&
                    pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n ws ds) &&
                  pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices
                    (ws.drop n) (ds.drop n))
              rw [ih ws ds, Bool.and_assoc]

theorem pairLightIndexedWitnessesCheckedBool_of_prefix_drop (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate)
    (n : Nat) (witnesses : List PairLightRootWitness)
    (destinations : List (Option Nat × Option Nat))
    (hprefix : pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n
      witnesses destinations = true)
    (htail : pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices
      (witnesses.drop n) (destinations.drop n) = true) :
    pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices witnesses destinations = true :=
  (pairLightIndexedWitnessesCheckedBool_eq_prefix_drop tau nu a b r0 bound vertices n
    witnesses destinations).trans (Bool.and_eq_true_iff.mpr ⟨hprefix, htail⟩)

end D1Bound5
