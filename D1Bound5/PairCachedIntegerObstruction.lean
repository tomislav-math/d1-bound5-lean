import D1Bound5.PairCachedResidues
import D1Bound5.PairNegativeIntegerObstruction

namespace D1Bound5
open QuadInt

/-- A proved negative-integer obstruction is checked before the original
exact root procedure. This does not accept any new square candidates. -/
def pairHasSquareRootAfterIntegerObstruction {tau nu : ℤ}
    (z : QuadInt tau nu) : Bool :=
  if pairNegativeIntegerObstructionBool z then false else QuadInt.hasSquareRoot z

/-- The extra rejection is computationally equivalent to the original exact
root test in positive-discriminant coordinates. -/
theorem pairHasSquareRootAfterIntegerObstruction_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (z : QuadInt tau nu) :
    pairHasSquareRootAfterIntegerObstruction z = QuadInt.hasSquareRoot z := by
  unfold pairHasSquareRootAfterIntegerObstruction
  by_cases hobs : pairNegativeIntegerObstructionBool z = true
  · rw [if_pos hobs]
    have hnot := pairNegativeIntegerObstructionBool_sound z hobs
    cases hs : QuadInt.hasSquareRoot z with
    | false => rfl
    | true => exact False.elim (hnot ((hasSquareRoot_iff hd z).1 hs))
  · rw [if_neg hobs]

/-- Preserve the existing cheap cached sieve as the first stage. Only its
survivors compute the integral product, then the obstruction and exact test. -/
def pairCachedIntegerHasSquareRoot {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x y : PairResidueVertex tau nu) : Bool :=
  pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature &&
    pairHasSquareRootAfterIntegerObstruction (x.vertex * y.vertex + 1)

/-- Equality holds even for unvalidated signatures: both versions use the
same cached sieve, and the replacement of the final test is exact. -/
theorem pairCachedIntegerHasSquareRoot_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (x y : PairResidueVertex tau nu) :
    pairCachedIntegerHasSquareRoot sieve x y = pairCachedHasSquareRoot sieve x y := by
  unfold pairCachedIntegerHasSquareRoot pairCachedHasSquareRoot
  rw [pairHasSquareRootAfterIntegerObstruction_eq hd]

/-- The accepted independence recursion with only its exact pair predicate
replaced by the equal, obstruction-prefiltered predicate. -/
def pairCachedIntegerIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (PairResidueVertex tau nu) → Bool
  | [] => true
  | x :: xs =>
      (xs.all fun y => if decide (x.vertex = y.vertex) then true
        else !(pairCachedIntegerHasSquareRoot sieve x y)) &&
          pairCachedIntegerIndependentBool sieve xs

theorem pairCachedIntegerIndependentBool_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (cached : List (PairResidueVertex tau nu)) :
    pairCachedIntegerIndependentBool sieve cached = pairCachedIndependentBool sieve cached := by
  induction cached with
  | nil => rfl
  | cons x xs ih =>
      simp only [pairCachedIntegerIndependentBool, pairCachedIndependentBool,
        pairCachedIntegerHasSquareRoot_eq hd, ih]

/-- Exact vertex coverage and every canonical signature are checked exactly
as in the accepted cached certificate. No list occurrence is discarded. -/
def pairCachedIntegerIndependentCertificateBool {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) : Bool :=
  decide (cached.map PairResidueVertex.vertex = vertices) &&
    ((cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) &&
      pairCachedIntegerIndependentBool sieve cached)

theorem pairCachedIntegerIndependentCertificateBool_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu)) :
    pairCachedIntegerIndependentCertificateBool sieve vertices cached =
      pairCachedIndependentCertificateBool sieve vertices cached := by
  unfold pairCachedIntegerIndependentCertificateBool pairCachedIndependentCertificateBool
  rw [pairCachedIntegerIndependentBool_eq hd]

/-- The new certificate still proves the exact old independence Boolean.
All downstream graph and full-ring theorems therefore retain their types. -/
theorem pairIndependentBool_of_cached_integer_certificate {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (hcheck : pairCachedIntegerIndependentCertificateBool sieve vertices cached = true) :
    pairIndependentBool sieve vertices = true := by
  apply pairIndependentBool_of_cached_certificate sieve vertices cached
  rw [← pairCachedIntegerIndependentCertificateBool_eq hd]
  exact hcheck

end D1Bound5
