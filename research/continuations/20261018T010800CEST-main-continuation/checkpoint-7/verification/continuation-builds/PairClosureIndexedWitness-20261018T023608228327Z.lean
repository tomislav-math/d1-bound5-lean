import D1Bound5.PairClosureWitness

namespace D1Bound5
open QuadInt

/-- A supplied destination is checked by exact indexed lookup. `none` is
accepted only when the computed candidate lies strictly outside the bound.
No membership search or square-root search occurs in this checker. -/
def pairIndexedCandidateCoveredBool {tau nu : ℤ} (bound : ℤ)
    (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu)
    (destination : Option Nat) : Bool :=
  match destination with
  | none => decide (bound < w.norm)
  | some i => decide (vertices[i]? = some w)

/-- Check the same supplied roots and both signed mutations as the accepted
witness checker, using the two supplied destination indices. -/
def pairIndexedRootWitnessCheckedBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (w : PairRootWitness tau nu) (destinations : Option Nat × Option Nat) : Bool :=
  decide (w.leftRoot * w.leftRoot = a * w.vertex + 1 ∧
    w.rightRoot * w.rightRoot = b * w.vertex + 1) &&
    (pairIndexedCandidateCoveredBool bound vertices
        (mutate a b w.vertex r0 w.leftRoot w.rightRoot) destinations.1 &&
      pairIndexedCandidateCoveredBool bound vertices
        (mutate a b w.vertex r0 w.leftRoot (-w.rightRoot)) destinations.2)

/-- Consume the roots and destination pairs together. Either unmatched tail
rejects the certificate, so no vertex or mutation sign can be omitted. -/
def pairIndexedWitnessesCheckedBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu)) :
    List (PairRootWitness tau nu) → List (Option Nat × Option Nat) → Bool
  | [], [] => true
  | w :: ws, d :: ds =>
      pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
        pairIndexedWitnessesCheckedBool a b r0 bound vertices ws ds
  | _, _ => false

/-- The original anchor root and ordered vertex coverage are checked exactly.
Only the method of certifying each mutation's membership is different. -/
def pairClosureIndexedWitnessBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)) : Bool :=
  decide (r0 * r0 = a * b + 1 ∧ witnesses.map PairRootWitness.vertex = vertices) &&
    pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations

/-- Every accepted indexed candidate satisfies the original membership
checker. In-range lookup is required by `getElem? = some w` itself. -/
theorem pairWitnessCandidateCoveredBool_of_indexed_checked {tau nu : ℤ}
    (bound : ℤ) (vertices : List (QuadInt tau nu)) (w : QuadInt tau nu)
    (destination : Option Nat)
    (hcheck : pairIndexedCandidateCoveredBool bound vertices w destination = true) :
    pairWitnessCandidateCoveredBool bound vertices w = true := by
  cases destination with
  | none =>
      change decide (bound < w.norm) = true at hcheck
      have hout : bound < w.norm := of_decide_eq_true hcheck
      simp [pairWitnessCandidateCoveredBool, not_le.mpr hout]
  | some i =>
      change decide (vertices[i]? = some w) = true at hcheck
      have hlookup : vertices[i]? = some w := of_decide_eq_true hcheck
      have hmem : w ∈ vertices := List.mem_of_getElem? hlookup
      simp [pairWitnessCandidateCoveredBool, hmem]

/-- Indexed checking implies the previously accepted two-mutation witness
check, retaining exactly its root equations and sign coverage. -/
theorem pairRootWitnessCheckedBool_of_indexed_checked {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (w : PairRootWitness tau nu) (destinations : Option Nat × Option Nat)
    (hcheck : pairIndexedRootWitnessCheckedBool a b r0 bound vertices w destinations = true) :
    pairRootWitnessCheckedBool a b r0 bound vertices w = true := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  have hneighbors := Bool.and_eq_true_iff.mp hparts.2
  apply Bool.and_eq_true_iff.mpr
  refine ⟨hparts.1, Bool.and_eq_true_iff.mpr ⟨?_, ?_⟩⟩
  · exact pairWitnessCandidateCoveredBool_of_indexed_checked bound vertices _
      destinations.1 hneighbors.1
  · exact pairWitnessCandidateCoveredBool_of_indexed_checked bound vertices _
      destinations.2 hneighbors.2

/-- The lockstep checker validates every witness in the original list. -/
theorem pairRootWitnesses_all_of_indexed_checked {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hcheck : pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations = true) :
    witnesses.all (pairRootWitnessCheckedBool a b r0 bound vertices) = true := by
  induction witnesses generalizing destinations with
  | nil => rfl
  | cons w ws ih =>
      cases destinations with
      | nil => simp only [pairIndexedWitnessesCheckedBool, Bool.false_eq_true] at hcheck
      | cons d ds =>
          have hparts := Bool.and_eq_true_iff.mp hcheck
          change pairRootWitnessCheckedBool a b r0 bound vertices w &&
            ws.all (pairRootWitnessCheckedBool a b r0 bound vertices) = true
          exact Bool.and_eq_true_iff.mpr
            ⟨pairRootWitnessCheckedBool_of_indexed_checked a b r0 bound vertices w d hparts.1,
              ih ds hparts.2⟩

/-- The indexed certificate proves the exact accepted witness certificate. -/
theorem pairClosureWitnessBool_of_indexed_checked {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hcheck : pairClosureIndexedWitnessBool a b r0 bound vertices witnesses destinations = true) :
    pairClosureWitnessBool a b r0 bound vertices witnesses = true := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  exact Bool.and_eq_true_iff.mpr
    ⟨hparts.1, pairRootWitnesses_all_of_indexed_checked a b r0 bound vertices
      witnesses destinations hparts.2⟩

/-- The final closure assertion is unchanged. All canonical-root and sign
coverage is inherited from the accepted symbolic witness soundness theorem. -/
theorem pairClosureBool_of_indexed_witness_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hcheck : pairClosureIndexedWitnessBool a b r0 bound vertices witnesses destinations = true) :
    pairClosureBool a b bound vertices = true :=
  pairClosureBool_of_witness_checked hd a b r0 bound vertices witnesses
    (pairClosureWitnessBool_of_indexed_checked a b r0 bound vertices witnesses
      destinations hcheck)

end D1Bound5
