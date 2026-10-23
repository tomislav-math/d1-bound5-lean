import D1Bound5.PairLightClosureBridge
import Lean.Util.CollectAxioms

namespace D1Bound5

example : ∀ (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate)
    (n : Nat) (witnesses : List PairLightRootWitness)
    (destinations : List (Option Nat × Option Nat)),
    pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices witnesses destinations =
      (pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n witnesses destinations &&
        pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices
          (witnesses.drop n) (destinations.drop n)) := @D1Bound5.pairLightIndexedWitnessesCheckedBool_eq_prefix_drop

example : ∀ (tau nu : Int)
    (a b r0 : PairLightCoordinate) (bound : Int) (vertices : List PairLightCoordinate)
    (n : Nat) (witnesses : List PairLightRootWitness)
    (destinations : List (Option Nat × Option Nat))
    (hprefix : pairLightIndexedWitnessesPrefixBool tau nu a b r0 bound vertices n
      witnesses destinations = true)
    (htail : pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices
      (witnesses.drop n) (destinations.drop n) = true),
    pairLightIndexedWitnessesCheckedBool tau nu a b r0 bound vertices witnesses destinations = true := @D1Bound5.pairLightIndexedWitnessesCheckedBool_of_prefix_drop

example : ∀ {tau nu : ℤ} (x y : QuadInt tau nu),
    pairLightMul tau nu (pairLightCoordinates x) (pairLightCoordinates y) =
      pairLightCoordinates (x * y) := @D1Bound5.pairLightMul_eq

example : ∀ {tau nu : ℤ} (x : QuadInt tau nu),
    pairLightNeg (pairLightCoordinates x) = pairLightCoordinates (-x) := @D1Bound5.pairLightNeg_eq

example : ∀ {tau nu : ℤ} (a b z r0 r s : QuadInt tau nu),
    pairLightMutate tau nu (pairLightCoordinates a) (pairLightCoordinates b)
      (pairLightCoordinates z) (pairLightCoordinates r0) (pairLightCoordinates r)
      (pairLightCoordinates s) = pairLightCoordinates (mutate a b z r0 r s) := @D1Bound5.pairLightMutate_eq

example : ∀ {tau nu : ℤ} (bound : ℤ)
    (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu)
    (destination : Option Nat),
    pairLightIndexedCandidateCoveredBool tau nu bound
      (vertices.map pairLightCoordinates) (pairLightCoordinates w) destination =
      pairIndexedCandidateCoveredBool bound vertices w destination := @D1Bound5.pairLightIndexedCandidateCoveredBool_eq

example : ∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (w : PairRootWitness tau nu) (destinations : Option Nat × Option Nat),
    pairLightIndexedRootWitnessCheckedBool tau nu
      (pairLightCoordinates a) (pairLightCoordinates b) (pairLightCoordinates r0) bound
      (vertices.map pairLightCoordinates) (pairLightRootWitnessCoordinates w) destinations =
      pairIndexedRootWitnessCheckedBool a b r0 bound vertices w destinations := @D1Bound5.pairLightIndexedRootWitnessCheckedBool_eq

example : ∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)),
    pairLightIndexedWitnessesCheckedBool tau nu
      (pairLightCoordinates a) (pairLightCoordinates b) (pairLightCoordinates r0) bound
      (vertices.map pairLightCoordinates) (witnesses.map pairLightRootWitnessCoordinates)
      destinations =
      pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations := @D1Bound5.pairLightIndexedWitnessesCheckedBool_eq

open Lean Elab Command
run_cmd do
  let names : List Name := [`D1Bound5.pairLightMul, `D1Bound5.pairLightAdd, `D1Bound5.pairLightNeg, `D1Bound5.pairLightMutate, `D1Bound5.PairLightRootWitness, `D1Bound5.pairLightIndexedCandidateCoveredBool, `D1Bound5.pairLightIndexedRootWitnessCheckedBool, `D1Bound5.pairLightIndexedWitnessesCheckedBool, `D1Bound5.pairLightIndexedWitnessesPrefixBool, `D1Bound5.pairLightIndexedWitnessesCheckedBool_eq_prefix_drop, `D1Bound5.pairLightIndexedWitnessesCheckedBool_of_prefix_drop, `D1Bound5.pairLightRootWitnessCoordinates, `D1Bound5.pairLightMul_eq, `D1Bound5.pairLightNeg_eq, `D1Bound5.pairLightMutate_eq, `D1Bound5.pairLightIndexedCandidateCoveredBool_eq, `D1Bound5.pairLightIndexedRootWitnessCheckedBool_eq, `D1Bound5.pairLightIndexedWitnessesCheckedBool_eq]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"AUDIT {n}: {axioms}"
  logInfo m!"EXACT_TYPE_AXIOM_AUDIT_PASS {names.length}"

end D1Bound5
