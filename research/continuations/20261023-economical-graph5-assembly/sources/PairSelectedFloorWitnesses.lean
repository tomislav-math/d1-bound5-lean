import D1Bound5.PairSelectedCachedMask
import D1Bound5.PairCachedFloorWitnesses

namespace D1Bound5
open QuadInt

/-- A base-32 word supplies one tag for every actual tail vertex. Tags 0--24
select one rejecting cached mask, tag 30 checks a repeated vertex, and tag 31
checks the existing integer obstruction or consumes one exact floor witness.
All other tags reject. The full tail drives recursion even when the packed
word is zero, so leading zero tags never omit pairs. At the end both the
remaining word and the floor list must be empty. -/
def pairSelectedFloorRowBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) :
    List (PairResidueVertex tau nu) → ℕ → List ℕ → Bool
  | [], code, ks => decide (code = 0 ∧ ks = [])
  | y :: ys, code, ks =>
      if code % 32 < 25 then
        pairSelectedCachedMaskRejectBool tau nu sieve x.signature y.signature (code % 32) &&
          pairSelectedFloorRowBool sieve x ys (code / 32) ks
      else if code % 32 = 30 then
        decide (x.vertex = y.vertex) && pairSelectedFloorRowBool sieve x ys (code / 32) ks
      else if code % 32 = 31 then
        if pairNegativeIntegerObstructionBool (x.vertex * y.vertex + 1) = true then
          pairSelectedFloorRowBool sieve x ys (code / 32) ks
        else match ks with
          | [] => false
          | k :: rest =>
              QuadInt.floorObstructionBool (x.vertex * y.vertex + 1) k &&
                pairSelectedFloorRowBool sieve x ys (code / 32) rest
      else false

/-- Every accepted tag rejects the exact cached pair test or checks an
actual repeated vertex. Thus all pairs in the entire tail are covered. -/
theorem pairSelectedFloorRowBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) (ys : List (PairResidueVertex tau nu))
    (code : ℕ) (ks : List ℕ)
    (hcheck : pairSelectedFloorRowBool sieve x ys code ks = true) :
    (ys.all fun y => if decide (x.vertex = y.vertex) then true
      else !(pairCachedHasSquareRoot sieve x y)) = true := by
  induction ys generalizing code ks with
  | nil => rfl
  | cons y ys ih =>
      by_cases hindex : code % 32 < 25
      · have hparts :
            pairSelectedCachedMaskRejectBool tau nu sieve x.signature y.signature
                (code % 32) = true ∧
              pairSelectedFloorRowBool sieve x ys (code / 32) ks = true :=
          Bool.and_eq_true_iff.mp (by
            simpa only [pairSelectedFloorRowBool, if_pos hindex] using hcheck)
        have hcache := pairSelectedCachedMaskRejectBool_sound tau nu sieve
          x.signature y.signature (code % 32) hparts.1
        have hpair : pairCachedHasSquareRoot sieve x y = false := by
          simp only [pairCachedHasSquareRoot, hcache, Bool.false_and]
        simpa [hpair] using ih (code / 32) ks hparts.2
      · by_cases hrepeated : code % 32 = 30
        · have hparts : decide (x.vertex = y.vertex) = true ∧
                pairSelectedFloorRowBool sieve x ys (code / 32) ks = true :=
            Bool.and_eq_true_iff.mp (by
              simpa only [pairSelectedFloorRowBool, if_neg hindex,
                if_pos hrepeated] using hcheck)
          have heq : x.vertex = y.vertex := of_decide_eq_true hparts.1
          simpa [heq] using ih (code / 32) ks hparts.2
        · by_cases hfallback : code % 32 = 31
          · by_cases hobs : pairNegativeIntegerObstructionBool (x.vertex * y.vertex + 1) = true
            · have htail : pairSelectedFloorRowBool sieve x ys (code / 32) ks = true := by
                simpa only [pairSelectedFloorRowBool, if_neg hindex,
                  if_neg hrepeated, if_pos hfallback, if_pos hobs] using hcheck
              have hpair := pairCachedHasSquareRoot_eq_false_of_no_root hd sieve x y
                (pairNegativeIntegerObstructionBool_sound _ hobs)
              simpa [hpair] using ih (code / 32) ks htail
            · cases ks with
              | nil =>
                  simp only [pairSelectedFloorRowBool, if_neg hindex,
                    if_neg hrepeated, if_pos hfallback, if_neg hobs,
                    Bool.false_eq_true] at hcheck
              | cons k rest =>
                  have hparts : QuadInt.floorObstructionBool (x.vertex * y.vertex + 1) k = true ∧
                      pairSelectedFloorRowBool sieve x ys (code / 32) rest = true :=
                    Bool.and_eq_true_iff.mp (by
                      simpa only [pairSelectedFloorRowBool, if_neg hindex,
                        if_neg hrepeated, if_pos hfallback, if_neg hobs] using hcheck)
                  have hpair := pairCachedHasSquareRoot_eq_false_of_no_root hd sieve x y
                    (QuadInt.floorObstructionBool_sound hd hparts.1)
                  simpa [hpair] using ih (code / 32) rest hparts.2
          · simp only [pairSelectedFloorRowBool, if_neg hindex,
              if_neg hrepeated, if_neg hfallback, Bool.false_eq_true] at hcheck

/-- Exactly one packed word and floor list is required for each actual head.
Unmatched vertex or witness tails reject the certificate. -/
def pairSelectedFloorIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (PairResidueVertex tau nu) → List (ℕ × List ℕ) → Bool
  | [], [] => true
  | x :: xs, (code, ks) :: rows =>
      pairSelectedFloorRowBool sieve x xs code ks &&
        pairSelectedFloorIndependentBool sieve xs rows
  | _, _ => false

theorem pairSelectedFloorIndependentBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (cached : List (PairResidueVertex tau nu)) (rows : List (ℕ × List ℕ))
    (hcheck : pairSelectedFloorIndependentBool sieve cached rows = true) :
    pairCachedIndependentBool sieve cached = true := by
  induction cached generalizing rows with
  | nil => rfl
  | cons x xs ih =>
      cases rows with
      | nil => simp only [pairSelectedFloorIndependentBool, Bool.false_eq_true] at hcheck
      | cons item rows =>
          rcases item with ⟨code, ks⟩
          have hparts := Bool.and_eq_true_iff.mp hcheck
          apply Bool.and_eq_true_iff.mpr
          exact ⟨pairSelectedFloorRowBool_sound hd sieve x xs code ks hparts.1,
            ih rows hparts.2⟩

/-- The accepted complete color-list coverage and signature validation are
retained exactly, followed by the selected-mask and sparse-floor check. -/
def pairSelectedFloorIndependentCertificateBool {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (ℕ × List ℕ)) : Bool :=
  decide (cached.map PairResidueVertex.vertex = vertices) &&
    ((cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) &&
      pairSelectedFloorIndependentBool sieve cached rows)

theorem pairSelectedFloorIndependentCertificateBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ))
    (hcheck : pairSelectedFloorIndependentCertificateBool sieve vertices cached rows = true) :
    pairCachedIndependentCertificateBool sieve vertices cached = true := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  have hrest := Bool.and_eq_true_iff.mp hparts.2
  apply Bool.and_eq_true_iff.mpr
  exact ⟨hparts.1, Bool.and_eq_true_iff.mpr
    ⟨hrest.1, pairSelectedFloorIndependentBool_sound hd sieve cached rows hrest.2⟩⟩

/-- The final assertion is the unchanged independent-class Boolean. The
selected tags, floor values, signatures, and vertex coverage are all checked. -/
theorem pairIndependentBool_of_selected_floor_certificate {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ))
    (hcheck : pairSelectedFloorIndependentCertificateBool sieve vertices cached rows = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_cached_certificate sieve vertices cached
    (pairSelectedFloorIndependentCertificateBool_sound hd sieve vertices cached rows hcheck)

end D1Bound5
