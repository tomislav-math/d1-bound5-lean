import D1Bound5.Coordinates
import Mathlib.Data.Int.Sqrt

namespace D1Bound5.QuadInt

variable {tau nu : ℤ}

/-- Algebraic identities underlying the full-ring square test. -/
theorem square_coordinates (r : QuadInt tau nu) :
    (r*r).norm = r.norm^2 ∧
    (2*r.re+tau*r.im)^2 = 2*r.norm+(2*(r*r).re+tau*(r*r).im) ∧
    discriminant tau nu*r.im^2 = 2*r.norm-(2*(r*r).re+tau*(r*r).im) ∧
    (2*r.re+tau*r.im)*r.im = (r*r).im := by
  refine ⟨by rw [map_mul, pow_two], ?_, ?_, ?_⟩
  all_goals simp only [norm_formula, QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul, discriminant]
  all_goals ring

/-- A square root can be given nonnegative doubled real part; if that part
is zero, its second coordinate may also be chosen nonnegative. -/
theorem exists_normalized_root {z : QuadInt tau nu} (hz : ∃ r, r*r = z) :
    ∃ r : QuadInt tau nu, r*r = z ∧ 0 ≤ 2*r.re+tau*r.im ∧
      (2*r.re+tau*r.im = 0 → 0 ≤ r.im) := by
  obtain ⟨r, hr⟩ := hz
  by_cases he : 0 ≤ 2*r.re+tau*r.im
  · by_cases he0 : 2*r.re+tau*r.im = 0
    · by_cases hi : 0 ≤ r.im
      · exact ⟨r, hr, he, fun _ => hi⟩
      · refine ⟨-r, by simpa only [neg_mul_neg] using hr, ?_, ?_⟩
        · change 0 ≤ 2*(-r.re)+tau*(-r.im)
          nlinarith only [he0]
        · intro _
          change 0 ≤ -r.im
          omega
    · exact ⟨r, hr, he, fun h => False.elim (he0 h)⟩
  · refine ⟨-r, by simpa only [neg_mul_neg] using hr, ?_, ?_⟩
    · change 0 ≤ 2*(-r.re)+tau*(-r.im)
      nlinarith
    · intro h
      change 2*(-r.re)+tau*(-r.im) = 0 at h
      exfalso
      nlinarith

/-- Exact candidate produced by three integer square roots and integer
arithmetic. Every candidate is checked by multiplication before acceptance. -/
def rootCandidate (z : QuadInt tau nu) : QuadInt tau nu :=
  let n := Int.sqrt z.norm
  let p := 2*z.re+tau*z.im
  let e := Int.sqrt (2*n+p)
  let f0 := Int.sqrt ((2*n-p)/discriminant tau nu)
  let f := if z.im < 0 then -f0 else f0
  ⟨(e-tau*f)/2,f⟩

/-- Deterministic square-root procedure, including zero. -/
def squareRoot (z : QuadInt tau nu) : Option (QuadInt tau nu) :=
  let r := rootCandidate z
  if r*r = z then some r else none

/-- A returned root is an actual root without any discriminant hypothesis. -/
theorem squareRoot_sound {z r : QuadInt tau nu} (h : squareRoot z = some r) : r*r = z := by
  change (if rootCandidate z*rootCandidate z = z then some (rootCandidate z) else none) = some r at h
  split_ifs at h with hc
  · simp only [Option.some.injEq] at h
    rw [← h]
    exact hc

/-- Completeness of the exact candidate, for every positive-discriminant
coordinate ring and arbitrary input size. No nonzero-root assumption occurs. -/
theorem rootCandidate_complete (hd : 0 < discriminant tau nu)
    {z : QuadInt tau nu} (hz : ∃ r, r*r = z) : rootCandidate z*rootCandidate z = z := by
  obtain ⟨r, hr, hE, haxis⟩ := exists_normalized_root hz
  obtain ⟨hN, he, hf, hI⟩ := square_coordinates r
  rw [hr] at hN he hf hI
  have hn : Int.sqrt z.norm = r.norm := by
    rw [hN, pow_two, Int.sqrt_eq, Int.natCast_natAbs, abs_of_nonneg (norm_nonneg hd r)]
  have he' : Int.sqrt (2*r.norm+(2*z.re+tau*z.im)) = 2*r.re+tau*r.im := by
    rw [← he, pow_two, Int.sqrt_eq, Int.natCast_natAbs, abs_of_nonneg hE]
  have hf' : Int.sqrt ((2*r.norm-(2*z.re+tau*z.im))/discriminant tau nu) = |r.im| := by
    rw [← hf]
    simp only [Int.mul_ediv_cancel_left _ (ne_of_gt hd), pow_two, Int.sqrt_eq, Int.natCast_natAbs]
  have hisign : (if z.im < 0 then -|r.im| else |r.im|) = r.im := by
    by_cases hneg : z.im < 0
    · have hrneg : r.im < 0 := by
        by_contra h
        have hmul := mul_nonneg hE (le_of_not_gt h)
        rw [hI] at hmul
        omega
      simp [hneg, abs_of_neg hrneg]
    · have hrnonneg : 0 ≤ r.im := by
        by_cases he0 : 2*r.re+tau*r.im = 0
        · exact haxis he0
        · have hep : 0 < 2*r.re+tau*r.im := by omega
          by_contra h
          have hmul := mul_neg_of_pos_of_neg hep (lt_of_not_ge h)
          rw [hI] at hmul
          exact hneg hmul
      simp [hneg, abs_of_nonneg hrnonneg]
  have hc : rootCandidate z = r := by
    unfold rootCandidate
    dsimp only
    rw [hn, he', hf', hisign]
    apply QuadraticAlgebra.ext
    · change (2*r.re+tau*r.im-tau*r.im)/2 = r.re
      omega
    · rfl
  rw [hc]
  exact hr

/-- A square always yields a returned root. -/
theorem squareRoot_complete (hd : 0 < discriminant tau nu)
    {z : QuadInt tau nu} (hz : ∃ r, r*r = z) :
    squareRoot z = some (rootCandidate z) := by
  simp only [squareRoot, rootCandidate_complete hd hz, if_true]

/-- The computable predicate used by later finite certificates. -/
def hasSquareRoot (z : QuadInt tau nu) : Bool := (squareRoot z).isSome

/-- The checker is necessary and sufficient, not merely a source of
positive witnesses or a one-sided modular obstruction. -/
theorem hasSquareRoot_iff (hd : 0 < discriminant tau nu) (z : QuadInt tau nu) :
    hasSquareRoot z = true ↔ ∃ r : QuadInt tau nu, r*r = z := by
  cases h : squareRoot z with
  | none =>
    simp only [hasSquareRoot, h, Option.isSome_none, Bool.false_eq_true, false_iff]
    intro hz
    have hc := squareRoot_complete hd hz
    rw [h] at hc
    contradiction
  | some r =>
    simp only [hasSquareRoot, h, Option.isSome_some, true_iff]
    exact ⟨r, squareRoot_sound h⟩

/-- Regression: zero is an allowed square. -/
theorem square_test_zero : hasSquareRoot (0 : QuadInt 1 1) = true := by decide +kernel

/-- Regression: zero doubled real part must not divide out a root. -/
theorem square_test_pure_imaginary : hasSquareRoot (⟨-2,0⟩ : QuadInt 0 2) = true := by decide +kernel

/-- Regression: a square in the half-integral basis. -/
theorem square_test_half_integral : hasSquareRoot (⟨-1,1⟩ : QuadInt 1 1) = true := by decide +kernel

end D1Bound5.QuadInt
