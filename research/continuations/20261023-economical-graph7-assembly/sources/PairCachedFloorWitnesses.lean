import D1Bound5.PairCachedIntegerObstruction
import D1Bound5.QuadSquareFloorObstruction

namespace D1Bound5
open QuadInt

/-- An actual nonsquare makes the existing exact cached pair test false,
regardless of the supplied modular signatures. -/
theorem pairCachedHasSquareRoot_eq_false_of_no_root {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (x y : PairResidueVertex tau nu)
    (hnot : ¬ ∃ r : QuadInt tau nu, r * r = x.vertex * y.vertex + 1) :
    pairCachedHasSquareRoot sieve x y = false := by
  have hroot : QuadInt.hasSquareRoot (x.vertex * y.vertex + 1) = false := by
    cases hs : QuadInt.hasSquareRoot (x.vertex * y.vertex + 1) with
    | false => rfl
    | true => exact False.elim (hnot ((hasSquareRoot_iff hd _).1 hs))
  simp only [pairCachedHasSquareRoot, hroot, Bool.and_false]

/-- Traverse a head against its entire remaining tail. A natural floor
witness is consumed exactly when a distinct pair passes the cached sieve
and the proved negative-integer rejection does not apply. Missing witnesses
and witnesses left at the end reject the row. No root search is performed. -/
def pairCachedFloorRowBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) :
    List (PairResidueVertex tau nu) → List ℕ → Bool
  | [], [] => true
  | [], _ :: _ => false
  | y :: ys, ks =>
      if x.vertex = y.vertex then pairCachedFloorRowBool sieve x ys ks
      else if pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature = true then
        if pairNegativeIntegerObstructionBool (x.vertex * y.vertex + 1) = true then
          pairCachedFloorRowBool sieve x ys ks
        else match ks with
          | [] => false
          | k :: rest =>
              QuadInt.floorObstructionBool (x.vertex * y.vertex + 1) k &&
                pairCachedFloorRowBool sieve x ys rest
      else pairCachedFloorRowBool sieve x ys ks

/-- Every pair in the full tail is rejected by the exact original cached
pair test. Supplied floors are checked against the actual current pair;
there is no default witness, index lookup, or omitted cross-row pair. -/
theorem pairCachedFloorRowBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) (ys : List (PairResidueVertex tau nu))
    (ks : List ℕ) (hcheck : pairCachedFloorRowBool sieve x ys ks = true) :
    (ys.all fun y => if decide (x.vertex = y.vertex) then true
      else !(pairCachedHasSquareRoot sieve x y)) = true := by
  induction ys generalizing ks with
  | nil => rfl
  | cons y ys ih =>
      by_cases heq : x.vertex = y.vertex
      · have htail : pairCachedFloorRowBool sieve x ys ks = true := by
          simpa only [pairCachedFloorRowBool, if_pos heq] using hcheck
        simpa [heq] using ih ks htail
      · by_cases hcache :
            pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature = true
        · by_cases hobs : pairNegativeIntegerObstructionBool (x.vertex * y.vertex + 1) = true
          · have htail : pairCachedFloorRowBool sieve x ys ks = true := by
              simpa only [pairCachedFloorRowBool, if_neg heq, if_pos hcache,
                if_pos hobs] using hcheck
            have hpair := pairCachedHasSquareRoot_eq_false_of_no_root hd sieve x y
              (pairNegativeIntegerObstructionBool_sound _ hobs)
            simpa [heq, hpair] using ih ks htail
          · cases ks with
            | nil =>
                simp only [pairCachedFloorRowBool, if_neg heq, if_pos hcache,
                  if_neg hobs, Bool.false_eq_true] at hcheck
            | cons k rest =>
                have hparts : QuadInt.floorObstructionBool (x.vertex * y.vertex + 1) k = true ∧
                    pairCachedFloorRowBool sieve x ys rest = true :=
                  Bool.and_eq_true_iff.mp (by
                    simpa only [pairCachedFloorRowBool, if_neg heq, if_pos hcache,
                      if_neg hobs] using hcheck)
                have hpair := pairCachedHasSquareRoot_eq_false_of_no_root hd sieve x y
                  (QuadInt.floorObstructionBool_sound hd hparts.1)
                simpa [heq, hpair] using ih rest hparts.2
        · have hcfalse :
              pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature = false := by
            cases hc : pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature with
            | false => rfl
            | true => exact False.elim (hcache hc)
          have htail : pairCachedFloorRowBool sieve x ys ks = true := by
            simpa only [pairCachedFloorRowBool, if_neg heq, if_neg hcache] using hcheck
          have hpair : pairCachedHasSquareRoot sieve x y = false := by
            simp only [pairCachedHasSquareRoot, hcfalse, Bool.false_and]
          simpa [heq, hpair] using ih ks htail

/-- There is exactly one witness row for every head, including the final
head's empty tail. Too few or too many rows are rejected. Each row receives
the entire actual tail, so all unordered pairs occur in the traversal. -/
def pairCachedFloorIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (PairResidueVertex tau nu) → List (List ℕ) → Bool
  | [], [] => true
  | x :: xs, ks :: rows =>
      pairCachedFloorRowBool sieve x xs ks && pairCachedFloorIndependentBool sieve xs rows
  | _, _ => false

theorem pairCachedFloorIndependentBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ))
    (hcheck : pairCachedFloorIndependentBool sieve cached rows = true) :
    pairCachedIndependentBool sieve cached = true := by
  induction cached generalizing rows with
  | nil => rfl
  | cons x xs ih =>
      cases rows with
      | nil => simp only [pairCachedFloorIndependentBool, Bool.false_eq_true] at hcheck
      | cons ks rows =>
          have hparts := Bool.and_eq_true_iff.mp hcheck
          apply Bool.and_eq_true_iff.mpr
          exact ⟨pairCachedFloorRowBool_sound hd sieve x xs ks hparts.1,
            ih rows hparts.2⟩

/-- The full certificate retains the exact accepted vertex-list coverage
and signature validation, then checks the sparse witness rows. -/
def pairCachedFloorIndependentCertificateBool {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ)) : Bool :=
  decide (cached.map PairResidueVertex.vertex = vertices) &&
    ((cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) &&
      pairCachedFloorIndependentBool sieve cached rows)

theorem pairCachedFloorIndependentCertificateBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (List ℕ))
    (hcheck : pairCachedFloorIndependentCertificateBool sieve vertices cached rows = true) :
    pairCachedIndependentCertificateBool sieve vertices cached = true := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  have hrest := Bool.and_eq_true_iff.mp hparts.2
  apply Bool.and_eq_true_iff.mpr
  exact ⟨hparts.1, Bool.and_eq_true_iff.mpr
    ⟨hrest.1, pairCachedFloorIndependentBool_sound hd sieve cached rows hrest.2⟩⟩

/-- An accepted sparse certificate implies the exact old independent-class
Boolean. No floor, signature, or coverage claim is assumed as a premise. -/
theorem pairIndependentBool_of_cached_floor_certificate {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (List ℕ))
    (hcheck : pairCachedFloorIndependentCertificateBool sieve vertices cached rows = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_cached_certificate sieve vertices cached
    (pairCachedFloorIndependentCertificateBool_sound hd sieve vertices cached rows hcheck)

end D1Bound5
