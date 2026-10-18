import D1Bound5.PairResidueMaskNat
import D1Bound5.PairSelectedFloorWitnesses

namespace D1Bound5

/-- The same aligned selected-mask lookup, evaluated by the exactly equal
natural-arithmetic mask predicate. Missing entries still reject. -/
def pairSelectedCachedMaskNatRejectBool (tau nu : ℤ) (sieve : List (ℕ × ℕ))
    (xs ys : List (ℕ × ℕ)) (i : ℕ) : Bool :=
  match sieve[i]?, xs[i]?, ys[i]? with
  | some (k, mask), some u, some v => !pairResidueMaskNatBool tau nu k mask u v
  | _, _, _ => false

theorem pairSelectedCachedMaskNatRejectBool_eq (tau nu : ℤ)
    (sieve : List (ℕ × ℕ)) (xs ys : List (ℕ × ℕ)) (i : ℕ) :
    pairSelectedCachedMaskNatRejectBool tau nu sieve xs ys i =
      pairSelectedCachedMaskRejectBool tau nu sieve xs ys i := by
  cases hm : sieve[i]? with
  | none =>
      simp only [pairSelectedCachedMaskNatRejectBool, pairSelectedCachedMaskRejectBool, hm]
  | some item =>
      rcases item with ⟨k, mask⟩
      cases hx : xs[i]? <;> cases hy : ys[i]? <;>
        simp only [pairSelectedCachedMaskNatRejectBool, pairSelectedCachedMaskRejectBool,
          hm, hx, hy, pairResidueMaskNatBool_eq]

/-- A copy of the accepted packed row whose only change is the selected
mask evaluation. Tail traversal, tag decoding, duplicate checks, integer
guards, floor values, and all exhaustion conditions are identical. -/
def pairRawSelectedFloorRowBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) :
    List (PairResidueVertex tau nu) → ℕ → List ℕ → Bool
  | [], code, ks => decide (code = 0 ∧ ks = [])
  | y :: ys, code, ks =>
      if code % 32 < 25 then
        pairSelectedCachedMaskNatRejectBool tau nu sieve x.signature y.signature (code % 32) &&
          pairRawSelectedFloorRowBool sieve x ys (code / 32) ks
      else if code % 32 = 30 then
        decide (x.vertex = y.vertex) && pairRawSelectedFloorRowBool sieve x ys (code / 32) ks
      else if code % 32 = 31 then
        if pairNegativeIntegerObstructionBool (x.vertex * y.vertex + 1) = true then
          pairRawSelectedFloorRowBool sieve x ys (code / 32) ks
        else match ks with
          | [] => false
          | k :: rest =>
              QuadInt.floorObstructionBool (x.vertex * y.vertex + 1) k &&
                pairRawSelectedFloorRowBool sieve x ys (code / 32) rest
      else false

/-- Equality holds for arbitrary words, signatures, and floor lists,
including malformed certificates; this is not merely one-way soundness. -/
theorem pairRawSelectedFloorRowBool_eq {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x : PairResidueVertex tau nu) (ys : List (PairResidueVertex tau nu))
    (code : ℕ) (ks : List ℕ) :
    pairRawSelectedFloorRowBool sieve x ys code ks =
      pairSelectedFloorRowBool sieve x ys code ks := by
  induction ys generalizing code ks with
  | nil => rfl
  | cons y ys ih =>
      cases ks <;>
        simp only [pairRawSelectedFloorRowBool, pairSelectedFloorRowBool,
          pairSelectedCachedMaskNatRejectBool_eq, ih]

/-- Exact copy of the accepted outer lockstep traversal. -/
def pairRawSelectedFloorIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (PairResidueVertex tau nu) → List (ℕ × List ℕ) → Bool
  | [], [] => true
  | x :: xs, (code, ks) :: rows =>
      pairRawSelectedFloorRowBool sieve x xs code ks &&
        pairRawSelectedFloorIndependentBool sieve xs rows
  | _, _ => false

theorem pairRawSelectedFloorIndependentBool_eq {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ)) :
    pairRawSelectedFloorIndependentBool sieve cached rows =
      pairSelectedFloorIndependentBool sieve cached rows := by
  induction cached generalizing rows with
  | nil => cases rows <;> rfl
  | cons x xs ih =>
      cases rows with
      | nil => rfl
      | cons item rows =>
          rcases item with ⟨code, ks⟩
          simp only [pairRawSelectedFloorIndependentBool, pairSelectedFloorIndependentBool,
            pairRawSelectedFloorRowBool_eq, ih]

/-- Full original coverage and signature validation, with raw arithmetic
used only in the exactly equal selected-mask evaluation. -/
def pairRawSelectedFloorIndependentCertificateBool {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (ℕ × List ℕ)) : Bool :=
  decide (cached.map PairResidueVertex.vertex = vertices) &&
    ((cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) &&
      pairRawSelectedFloorIndependentBool sieve cached rows)

theorem pairRawSelectedFloorIndependentCertificateBool_eq {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (ℕ × List ℕ)) :
    pairRawSelectedFloorIndependentCertificateBool sieve vertices cached rows =
      pairSelectedFloorIndependentCertificateBool sieve vertices cached rows := by
  simp only [pairRawSelectedFloorIndependentCertificateBool,
    pairSelectedFloorIndependentCertificateBool, pairRawSelectedFloorIndependentBool_eq]

/-- Reuse the accepted selected-certificate soundness theorem through exact
Boolean equality. No new mask or arithmetic hypothesis is introduced. -/
theorem pairIndependentBool_of_raw_selected_floor_certificate {tau nu : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ))
    (hcheck : pairRawSelectedFloorIndependentCertificateBool sieve vertices cached rows = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_selected_floor_certificate hd sieve vertices cached rows
    ((pairRawSelectedFloorIndependentCertificateBool_eq sieve vertices cached rows).symm.trans hcheck)

end D1Bound5
