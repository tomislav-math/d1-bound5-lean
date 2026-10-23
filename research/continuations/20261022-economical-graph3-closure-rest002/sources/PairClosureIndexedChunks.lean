import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
open QuadInt

/-- Check a prefix of witness/destination rows. Destination indices always
refer to the complete original vertex list, never to a truncated list. -/
def pairIndexedWitnessesPrefixBool {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu)) :
    ℕ → List (PairRootWitness tau nu) → List (Option Nat × Option Nat) → Bool
  | 0, _, _ => true
  | _ + 1, [], [] => true
  | n + 1, w :: ws, d :: ds =>
      pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
        pairIndexedWitnessesPrefixBool a b r0 bound vertices n ws ds
  | _ + 1, _, _ => false

/-- Exact factorization, including mismatched lists. Both mutation signs
and their lookups in the original vertex list are unchanged. -/
theorem pairIndexedWitnessesCheckedBool_eq_prefix_drop {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)) :
    pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations =
      (pairIndexedWitnessesPrefixBool a b r0 bound vertices n witnesses destinations &&
        pairIndexedWitnessesCheckedBool a b r0 bound vertices
          (witnesses.drop n) (destinations.drop n)) := by
  induction n generalizing witnesses destinations with
  | zero =>
      simp only [pairIndexedWitnessesPrefixBool, List.drop_zero, Bool.true_and]
  | succ n ih =>
      cases witnesses with
      | nil => cases destinations <;> rfl
      | cons w ws =>
          cases destinations with
          | nil => rfl
          | cons d ds =>
              change
                (pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
                  pairIndexedWitnessesCheckedBool a b r0 bound vertices ws ds) =
                ((pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
                    pairIndexedWitnessesPrefixBool a b r0 bound vertices n ws ds) &&
                  pairIndexedWitnessesCheckedBool a b r0 bound vertices
                    (ws.drop n) (ds.drop n))
              rw [ih ws ds, Bool.and_assoc]

/-- Assemble already checked prefixes without evaluating their arithmetic again. -/
theorem pairIndexedWitnessesCheckedBool_of_prefix_drop {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hprefix : pairIndexedWitnessesPrefixBool a b r0 bound vertices n
      witnesses destinations = true)
    (htail : pairIndexedWitnessesCheckedBool a b r0 bound vertices
      (witnesses.drop n) (destinations.drop n) = true) :
    pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations = true :=
  (pairIndexedWitnessesCheckedBool_eq_prefix_drop a b r0 bound vertices n witnesses destinations).trans
    (Bool.and_eq_true_iff.mpr ⟨hprefix, htail⟩)

/-- Join two finite prefixes while preserving global destination indices. -/
theorem pairIndexedWitnessesPrefixBool_add {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (m n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)) :
    pairIndexedWitnessesPrefixBool a b r0 bound vertices (m + n) witnesses destinations =
      (pairIndexedWitnessesPrefixBool a b r0 bound vertices m witnesses destinations &&
        pairIndexedWitnessesPrefixBool a b r0 bound vertices n
          (witnesses.drop m) (destinations.drop m)) := by
  induction m generalizing witnesses destinations with
  | zero =>
      simp only [Nat.zero_add, pairIndexedWitnessesPrefixBool, List.drop_zero, Bool.true_and]
  | succ m ih =>
      cases witnesses with
      | nil =>
          cases destinations <;> cases n <;>
            simp [Nat.succ_add, pairIndexedWitnessesPrefixBool]
      | cons w ws =>
          cases destinations with
          | nil => simp [Nat.succ_add, pairIndexedWitnessesPrefixBool]
          | cons d ds =>
              rw [Nat.succ_add]
              change
                (pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
                  pairIndexedWitnessesPrefixBool a b r0 bound vertices (m+n) ws ds) =
                ((pairIndexedRootWitnessCheckedBool a b r0 bound vertices w d &&
                    pairIndexedWitnessesPrefixBool a b r0 bound vertices m ws ds) &&
                  pairIndexedWitnessesPrefixBool a b r0 bound vertices n
                    (ws.drop m) (ds.drop m))
              rw [ih ws ds, Bool.and_assoc]

/-- Ordered coverage and the anchor-root equation remain separate mandatory
checks when the mutation-witness computation is partitioned. -/
theorem pairClosureIndexedWitnessBool_of_checked_parts {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hcoverage : decide (r0 * r0 = a * b + 1 ∧
      witnesses.map PairRootWitness.vertex = vertices) = true)
    (hwitnesses : pairIndexedWitnessesCheckedBool a b r0 bound vertices
      witnesses destinations = true) :
    pairClosureIndexedWitnessBool a b r0 bound vertices witnesses destinations = true :=
  Bool.and_eq_true_iff.mpr ⟨hcoverage, hwitnesses⟩

end D1Bound5
