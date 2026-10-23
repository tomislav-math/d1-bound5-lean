import D1Bound5.PairLightClosure
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5

def pairLightRootWitnessCoordinates {tau nu : ℤ} (w : PairRootWitness tau nu) :
    PairLightRootWitness :=
  ⟨pairLightCoordinates w.vertex, pairLightCoordinates w.leftRoot,
    pairLightCoordinates w.rightRoot⟩

theorem pairLightMul_eq {tau nu : ℤ} (x y : QuadInt tau nu) :
    pairLightMul tau nu (pairLightCoordinates x) (pairLightCoordinates y) =
      pairLightCoordinates (x * y) := by
  apply Prod.ext <;>
    simp only [pairLightMul, pairLightCoordinates,
      QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul] <;> ring

theorem pairLightNeg_eq {tau nu : ℤ} (x : QuadInt tau nu) :
    pairLightNeg (pairLightCoordinates x) = pairLightCoordinates (-x) := by
  rfl

theorem pairLightMutate_eq {tau nu : ℤ} (a b z r0 r s : QuadInt tau nu) :
    pairLightMutate tau nu (pairLightCoordinates a) (pairLightCoordinates b)
      (pairLightCoordinates z) (pairLightCoordinates r0) (pairLightCoordinates r)
      (pairLightCoordinates s) = pairLightCoordinates (mutate a b z r0 r s) := by
  apply Prod.ext <;>
    simp only [pairLightMutate, pairLightAdd, pairLightMul, pairLightCoordinates, mutate,
      QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_ofNat, QuadraticAlgebra.im_ofNat] <;> ring

/-- The identity holds for every list and supplied index, including malformed
indices and the strict outside-bound case. No certificate validity is assumed. -/
theorem pairLightIndexedCandidateCoveredBool_eq {tau nu : ℤ} (bound : ℤ)
    (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu)
    (destination : Option Nat) :
    pairLightIndexedCandidateCoveredBool tau nu bound
      (vertices.map pairLightCoordinates) (pairLightCoordinates w) destination =
      pairIndexedCandidateCoveredBool bound vertices w destination := by
  cases destination with
  | none =>
      simp only [pairLightIndexedCandidateCoveredBool, pairIndexedCandidateCoveredBool,
        pairLightNorm_eq]
  | some i =>
      simp only [pairLightIndexedCandidateCoveredBool, pairIndexedCandidateCoveredBool,
        List.getElem?_map]
      cases h : vertices[i]? with
      | none => rfl
      | some v =>
          simp only [Option.map_some, Option.some.injEq, pairLightCoordinates_eq_iff]

theorem pairLightIndexedRootWitnessCheckedBool_eq {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (w : PairRootWitness tau nu) (destinations : Option Nat × Option Nat) :
    pairLightIndexedRootWitnessCheckedBool tau nu
      (pairLightCoordinates a) (pairLightCoordinates b) (pairLightCoordinates r0) bound
      (vertices.map pairLightCoordinates) (pairLightRootWitnessCoordinates w) destinations =
      pairIndexedRootWitnessCheckedBool a b r0 bound vertices w destinations := by
  simp only [pairLightIndexedRootWitnessCheckedBool, pairIndexedRootWitnessCheckedBool,
    pairLightRootWitnessCoordinates, pairLightMul_eq, pairLightProductPlusOne_eq,
    pairLightCoordinates_eq_iff, pairLightNeg_eq, pairLightMutate_eq,
    pairLightIndexedCandidateCoveredBool_eq]

/-- Exact identity of the complete lockstep check, retaining rejection of any
unmatched tail and all globally indexed mutations of both signs. -/
theorem pairLightIndexedWitnessesCheckedBool_eq {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)) :
    pairLightIndexedWitnessesCheckedBool tau nu
      (pairLightCoordinates a) (pairLightCoordinates b) (pairLightCoordinates r0) bound
      (vertices.map pairLightCoordinates) (witnesses.map pairLightRootWitnessCoordinates)
      destinations =
      pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations := by
  induction witnesses generalizing destinations with
  | nil => cases destinations <;> rfl
  | cons w ws ih =>
      cases destinations with
      | nil => rfl
      | cons d ds =>
          simp only [List.map_cons, pairLightIndexedWitnessesCheckedBool,
            pairIndexedWitnessesCheckedBool, pairLightIndexedRootWitnessCheckedBool_eq, ih]

end D1Bound5
