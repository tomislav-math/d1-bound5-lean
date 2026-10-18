import Mathlib.Tactic.GCongr
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith

namespace D1Bound5

private theorem allLargeMonomial_lower_bound
    (A B S : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hS : 3 ≤ S)
    (c L : ℝ) (p q r : ℕ) (hc : 0 ≤ c)
    (hnum : L < c * (3 : ℝ) ^ (p + q + r)) :
    L < c * (A ^ p * B ^ q * S ^ r) := by
  have hprod : (3 : ℝ) ^ p * 3 ^ q * 3 ^ r ≤ A ^ p * B ^ q * S ^ r := by
    gcongr <;> first | assumption | norm_num
  have hn : L < c * ((3 : ℝ) ^ p * 3 ^ q * 3 ^ r) := by
    simpa only [pow_add] using hnum
  exact hn.trans_le (mul_le_mul_of_nonneg_left hprod hc)

/-- All fifteen sufficient overlap quotients in the no-small-entry branch,
followed by the ordinary-tail ratio. The order is precisely Table pr-overlaps
of the manuscript. Expressions are written as a positive rational coefficient
times a monomial so that monotonicity in A,B,S is explicit. No tuple growth,
interval exclusion, or main theorem is assumed in this numerical certificate. -/
theorem all_large_overlap_constants
    (A B S : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hS : 3 ≤ S) :
    (13 / 10 : ℝ) <
      (1024 * (1 - 1 / 4000) / 12100) * (A ^ 10 * B ^ 10 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (256 / (36 * 243 ^ 2 * (4001 / 3999))) * (A ^ 8 * B ^ 0 * S ^ 4) ∧
    (13 / 10 : ℝ) <
      (400 ^ 2 / (16 * (5 / 4) ^ 2 * 2400 ^ 2 * (4001 / 3999))) *
        (A ^ 20 * B ^ 4 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 2 / (16 * (5 / 4) ^ 2 * 2400 ^ 2 * (4001 / 3999))) *
        (A ^ 20 * B ^ 0 * S ^ 2) ∧
    (13 / 10 : ℝ) <
      (400 ^ 2 / (16 * 3 ^ 2 * 4143 ^ 2 * (4001 / 3999))) *
        (A ^ 20 * B ^ 0 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 2 / (16 * 3 ^ 2 * 2265 ^ 2 * (4001 / 3999))) *
        (A ^ 20 * B ^ 0 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 4 / (16 * (35 / 16) ^ 2 * ((8 / 9) * 608 ^ 2) ^ 2 * (4001 / 3999))) *
        (A ^ 36 * B ^ 0 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 4 / (16 * (3920 / 81) ^ 2 * 4143 ^ 2 * (4001 / 3999))) *
        (A ^ 34 * B ^ 2 * S ^ 2) ∧
    (13 / 10 : ℝ) <
      (400 ^ 2 / (16 * (35 / 32) ^ 2 * 165763 ^ 2 * (4001 / 3999))) *
        (A ^ 22 * B ^ 4 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 4 / (16 * (35 / 32) ^ 2 * 4143 ^ 2 * (4001 / 3999))) *
        (A ^ 36 * B ^ 8 * S ^ 0) ∧
    (7 / 5 : ℝ) <
      ((400 / (35 / 32)) ^ 2 / (16 * 165763 ^ 2 * (4001 / 3999))) *
        (A ^ 14 * B ^ 0 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 4 / (144 * (63 / 8) ^ 2 * 42 ^ 8 * (4001 / 3999))) *
        (A ^ 38 * B ^ 2 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 4 / (4 * 3113013 ^ 2 * (5 / 2) ^ 8 * (4001 / 3999))) *
        (A ^ 36 * B ^ 0 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 6 / (144 * (495 / 64) ^ 2 * 42 ^ 10 * (4001 / 3999))) *
        (A ^ 54 * B ^ 10 * S ^ 0) ∧
    (13 / 10 : ℝ) <
      (400 ^ 6 / (36 * 42 ^ 12 * (5 / 2) ^ 10 * (4001 / 3999))) *
        (A ^ 52 * B ^ 4 * S ^ 0) ∧
    (13 / 10 : ℝ) < (400 / 105) * (A ^ 8 * B ^ 1 * S ^ 3) := by
  repeat' constructor
  all_goals
    apply allLargeMonomial_lower_bound A B S hA hB hS
    · norm_num
    · norm_num

/-- Exact coefficient check in the retained-gap specialization. This is the
number that allows the no-small-entry argument to use G=400. -/
theorem all_large_retained_gap_constant :
    (400 : ℝ) <
      3 ^ 5 * ((9999 / 10000) * (200 / 19) ^ 2) *
        (1 / 8 - (51051 / 400000) / 81) ^ 2 := by
  norm_num

/-- The retained H48 coefficient yields the exact monomial growth used
throughout the no-small-entry overlap table. Its hypotheses are the retained
gap estimate itself and the elementary bounds on its normalized Vandermonde
parameter; the analytic retained estimate is a separate theorem. -/
theorem all_large_retained_gap_monomial
    (A B S C Q : ℝ) (hA : 3 ≤ A) (hB : 3 ≤ B) (hS : 0 < S)
    (hQ : 0 < Q) (hQ8 : Q ≤ 8)
    (hgap :
      3 ^ 5 * ((9999 / 10000) * (200 / 19) ^ 2) *
          (1 / Q - (51051 / 400000) / (A ^ 2 * B ^ 2)) ^ 2 *
          (A ^ 7 * B ^ 5 * S ^ 3) < C) :
    400 * (A ^ 7 * B ^ 5 * S ^ 3) < C := by
  have hAB : (81 : ℝ) ≤ A ^ 2 * B ^ 2 := by
    calc
      (81 : ℝ) = 3 ^ 2 * 3 ^ 2 := by norm_num
      _ ≤ A ^ 2 * B ^ 2 := by
        gcongr <;> first | assumption | norm_num
  have hABpos : 0 < A ^ 2 * B ^ 2 := lt_of_lt_of_le (by norm_num) hAB
  have hinv : (1 / 8 : ℝ) ≤ 1 / Q := by
    apply (div_le_div_iff₀ (by norm_num : (0 : ℝ) < 8) hQ).2
    simpa using hQ8
  have herr : (51051 / 400000 : ℝ) / (A ^ 2 * B ^ 2) ≤
      (51051 / 400000) / 81 := by
    apply (div_le_div_iff₀ hABpos (by norm_num : (0 : ℝ) < 81)).2
    nlinarith only [hAB]
  have hbase : (0 : ℝ) < 1 / 8 - (51051 / 400000) / 81 := by norm_num
  have hdelta : (1 / 8 : ℝ) - (51051 / 400000) / 81 ≤
      1 / Q - (51051 / 400000) / (A ^ 2 * B ^ 2) := by
    linarith only [hinv, herr]
  have hsquare : ((1 / 8 : ℝ) - (51051 / 400000) / 81) ^ 2 ≤
      (1 / Q - (51051 / 400000) / (A ^ 2 * B ^ 2)) ^ 2 := by
    have hp := mul_nonneg (sub_nonneg.mpr hdelta)
      (add_nonneg (hbase.le.trans hdelta) hbase.le)
    nlinarith only [hp]
  have hcoefficient : (400 : ℝ) <
      3 ^ 5 * ((9999 / 10000) * (200 / 19) ^ 2) *
        (1 / Q - (51051 / 400000) / (A ^ 2 * B ^ 2)) ^ 2 := by
    exact all_large_retained_gap_constant.trans_le
      (mul_le_mul_of_nonneg_left hsquare (by norm_num))
  have hApos : 0 < A := lt_of_lt_of_le (by norm_num) hA
  have hBpos : 0 < B := lt_of_lt_of_le (by norm_num) hB
  have hmonomial : 0 < A ^ 7 * B ^ 5 * S ^ 3 :=
    mul_pos (mul_pos (pow_pos hApos _) (pow_pos hBpos _)) (pow_pos hS _)
  exact (mul_lt_mul_of_pos_right hcoefficient hmonomial).trans hgap

end D1Bound5
