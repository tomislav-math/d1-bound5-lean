import D1Bound5.PairCachedFloorWitnesses

namespace D1Bound5

/-- Check at most `n` head rows of the accepted sparse-floor checker.
Every row is evaluated against its entire actual remaining vertex tail.
The corresponding witness row is consumed in lockstep with its head;
unequal remaining list lengths reject as soon as they are encountered. -/
def pairCachedFloorPrefixBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    Nat → List (PairResidueVertex tau nu) → List (List ℕ) → Bool
  | 0, _, _ => true
  | _ + 1, [], [] => true
  | n + 1, x :: xs, ks :: rows =>
      pairCachedFloorRowBool sieve x xs ks &&
        pairCachedFloorPrefixBool sieve n xs rows
  | _ + 1, _, _ => false

/-- Literal Boolean factorization of the accepted sparse-floor checker.
No pair crossing the cut is lost: the earlier head is checked against
the full tail, including every vertex after the cut. Both the vertex and
witness lists are dropped by the same amount. -/
theorem pairCachedFloorIndependentBool_eq_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (n : Nat)
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ)) :
    pairCachedFloorIndependentBool sieve cached rows =
      (pairCachedFloorPrefixBool sieve n cached rows &&
        pairCachedFloorIndependentBool sieve (cached.drop n) (rows.drop n)) := by
  induction n generalizing cached rows with
  | zero =>
      simp only [pairCachedFloorPrefixBool, List.drop_zero, Bool.true_and]
  | succ n ih =>
      cases cached with
      | nil => cases rows <;> rfl
      | cons x xs =>
          cases rows with
          | nil => rfl
          | cons ks rows =>
              change
                (pairCachedFloorRowBool sieve x xs ks &&
                  pairCachedFloorIndependentBool sieve xs rows) =
                ((pairCachedFloorRowBool sieve x xs ks &&
                    pairCachedFloorPrefixBool sieve n xs rows) &&
                  pairCachedFloorIndependentBool sieve (xs.drop n) (rows.drop n))
              rw [ih xs rows, Bool.and_assoc]

/-- Assemble two independently checked pieces into exactly the previous
checker. This can be repeated for arbitrary block widths, including zero
or a width beyond the end; the final remainder must still be certified. -/
theorem pairCachedFloorIndependentBool_of_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (n : Nat)
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ))
    (hprefix : pairCachedFloorPrefixBool sieve n cached rows = true)
    (htail : pairCachedFloorIndependentBool sieve (cached.drop n) (rows.drop n) = true) :
    pairCachedFloorIndependentBool sieve cached rows = true :=
  (pairCachedFloorIndependentBool_eq_prefix_drop sieve n cached rows).trans
    (Bool.and_eq_true_iff.mpr ⟨hprefix, htail⟩)

/-- A final prefix covering both lists leaves the original empty checker.
Length equality is not assumed: malformed unequal-length lists still fail
inside the checked prefix, including an extra final witness row. -/
theorem pairCachedFloorIndependentBool_of_prefix_cover {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (n : Nat)
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ))
    (hcached : cached.length ≤ n) (hrows : rows.length ≤ n)
    (hprefix : pairCachedFloorPrefixBool sieve n cached rows = true) :
    pairCachedFloorIndependentBool sieve cached rows = true := by
  apply pairCachedFloorIndependentBool_of_prefix_drop sieve n cached rows hprefix
  rw [List.drop_eq_nil_of_le hcached, List.drop_eq_nil_of_le hrows]
  rfl

/-- Only independence is split. The original exact vertex projection and
the original full signature validation remain separate checked inputs. -/
theorem pairCachedFloorIndependentCertificateBool_of_prefix_drop {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ)) (n : Nat)
    (hcover : cached.map PairResidueVertex.vertex = vertices)
    (hvalid : (cached.all fun x =>
      decide (x.signature = pairCoordinateSignature sieve x.vertex)) = true)
    (hprefix : pairCachedFloorPrefixBool sieve n cached rows = true)
    (htail : pairCachedFloorIndependentBool sieve (cached.drop n) (rows.drop n) = true) :
    pairCachedFloorIndependentCertificateBool sieve vertices cached rows = true := by
  have hindependent :=
    pairCachedFloorIndependentBool_of_prefix_drop sieve n cached rows hprefix htail
  apply Bool.and_eq_true_iff.mpr
  refine ⟨?_, Bool.and_eq_true_iff.mpr ⟨hvalid, hindependent⟩⟩
  simp [hcover]

/-- Chunk composition reaches the exact original independent-class Boolean
through the accepted sparse-floor soundness theorem, preserving the full
meaning of every downstream graph certificate. -/
theorem pairIndependentBool_of_cached_floor_prefix_drop {tau nu : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (List ℕ)) (n : Nat)
    (hcover : cached.map PairResidueVertex.vertex = vertices)
    (hvalid : (cached.all fun x =>
      decide (x.signature = pairCoordinateSignature sieve x.vertex)) = true)
    (hprefix : pairCachedFloorPrefixBool sieve n cached rows = true)
    (htail : pairCachedFloorIndependentBool sieve (cached.drop n) (rows.drop n) = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_cached_floor_certificate hd sieve vertices cached rows
    (pairCachedFloorIndependentCertificateBool_of_prefix_drop sieve vertices cached rows n
      hcover hvalid hprefix htail)

end D1Bound5
