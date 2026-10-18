import D1Bound5.PairCachedResidues

namespace D1Bound5

/-- Check the first `n` rows of the cached independence computation. Every
checked row compares its vertex with the entire remaining tail, including
vertices beyond the prefix. This is not independence of `xs.take n`. -/
def pairCachedIndependentPrefixBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    Nat → List (PairResidueVertex tau nu) → Bool
  | 0, _ => true
  | _ + 1, [] => true
  | n + 1, x :: xs =>
      (xs.all fun y => if decide (x.vertex = y.vertex) then true
        else !(pairCachedHasSquareRoot sieve x y)) &&
          pairCachedIndependentPrefixBool sieve n xs

/-- Exact decomposition of the accepted checker. No pair crossing the
prefix boundary is dropped: it occurs in the earlier vertex's full row. -/
theorem pairCachedIndependentBool_eq_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (n : Nat) (xs : List (PairResidueVertex tau nu)) :
    pairCachedIndependentBool sieve xs =
      (pairCachedIndependentPrefixBool sieve n xs &&
        pairCachedIndependentBool sieve (xs.drop n)) := by
  induction n generalizing xs with
  | zero =>
      simp only [pairCachedIndependentPrefixBool, List.drop_zero, Bool.true_and]
  | succ n ih =>
      cases xs with
      | nil => rfl
      | cons x xs =>
          change
            ((xs.all fun y => if decide (x.vertex = y.vertex) then true
              else !(pairCachedHasSquareRoot sieve x y)) &&
                pairCachedIndependentBool sieve xs) =
            (((xs.all fun y => if decide (x.vertex = y.vertex) then true
              else !(pairCachedHasSquareRoot sieve x y)) &&
                pairCachedIndependentPrefixBool sieve n xs) &&
                  pairCachedIndependentBool sieve (xs.drop n))
          rw [ih xs, Bool.and_assoc]

/-- Two independently kernel-checked pieces reconstruct the exact original
cached independence assertion, for every cut position (also past the end). -/
theorem pairCachedIndependentBool_of_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (n : Nat) (xs : List (PairResidueVertex tau nu))
    (hprefix : pairCachedIndependentPrefixBool sieve n xs = true)
    (htail : pairCachedIndependentBool sieve (xs.drop n) = true) :
    pairCachedIndependentBool sieve xs = true := by
  exact (pairCachedIndependentBool_eq_prefix_drop sieve n xs).trans
    (Bool.and_eq_true_iff.mpr ⟨hprefix, htail⟩)

/-- Retain the original full coverage and signature validation, replacing
only the large independence check by its two exact pieces. -/
theorem pairCachedIndependentCertificateBool_of_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (n : Nat)
    (hcover : cached.map PairResidueVertex.vertex = vertices)
    (hvalid : (cached.all fun x =>
      decide (x.signature = pairCoordinateSignature sieve x.vertex)) = true)
    (hprefix : pairCachedIndependentPrefixBool sieve n cached = true)
    (htail : pairCachedIndependentBool sieve (cached.drop n) = true) :
    pairCachedIndependentCertificateBool sieve vertices cached = true := by
  have hindependent := pairCachedIndependentBool_of_prefix_drop sieve n cached hprefix htail
  apply Bool.and_eq_true_iff.mpr
  refine ⟨?_, Bool.and_eq_true_iff.mpr ⟨hvalid, hindependent⟩⟩
  simp [hcover]

/-- The final mathematical checker is exactly the existing one; cached
residue soundness and every original coverage check are reused unchanged. -/
theorem pairIndependentBool_of_cached_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (n : Nat)
    (hcover : cached.map PairResidueVertex.vertex = vertices)
    (hvalid : (cached.all fun x =>
      decide (x.signature = pairCoordinateSignature sieve x.vertex)) = true)
    (hprefix : pairCachedIndependentPrefixBool sieve n cached = true)
    (htail : pairCachedIndependentBool sieve (cached.drop n) = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_cached_certificate sieve vertices cached
    (pairCachedIndependentCertificateBool_of_prefix_drop sieve vertices cached n
      hcover hvalid hprefix htail)

end D1Bound5
