import Mathlib.RingTheory.Binomial
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity
import Lean.Elab.Tactic.Omega

open Polynomial

namespace D1Bound5

/-- Positive half-integer Gamma values expressed by the actual ascending
Pochhammer polynomial. Only Gamma's proved recurrence is used. -/
theorem bennett_Gamma_half_add_nat (n : ℕ) :
    Real.Gamma ((1 / 2 : ℝ) + n) =
      Real.Gamma (1 / 2 : ℝ) * (ascPochhammer ℝ n).eval (1 / 2) := by
  induction n with
  | zero => simp
  | succ n ih =>
      have harg : (1 / 2 : ℝ) + (n + 1 : ℕ) = ((1 / 2 : ℝ) + n) + 1 := by
        push_cast
        ring
      rw [harg, Real.Gamma_add_one (show (1 / 2 : ℝ) + n ≠ 0 by positivity),
        ih, ascPochhammer_succ_right]
      simp only [Polynomial.eval_mul, Polynomial.eval_add, Polynomial.eval_X,
        Polynomial.eval_natCast]
      ring

theorem bennett_ascPochhammer_half_pos (n : ℕ) :
    0 < (ascPochhammer ℝ n).eval (1 / 2) := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [ascPochhammer_succ_right]
      simp only [Polynomial.eval_mul, Polynomial.eval_add, Polynomial.eval_X,
        Polynomial.eval_natCast]
      exact mul_pos ih (by positivity)

/-- Absolute generalized choose coefficients retain the ordinary factorial
denominator and the actual descending Pochhammer numerator. -/
theorem bennett_factorial_mul_abs_choose (r : ℝ) (n : ℕ) :
    (n.factorial : ℝ) * |Ring.choose r n| = |(descPochhammer ℝ n).eval r| := by
  have heq : (descPochhammer ℤ n).smeval r = (descPochhammer ℝ n).eval r := by
    rw [descPochhammer_smeval_eq_ascPochhammer, ascPochhammer_smeval_eq_eval,
      descPochhammer_eval_eq_ascPochhammer]
  have h := Ring.descPochhammer_eq_factorial_smul_choose r n
  rw [heq, nsmul_eq_mul] at h
  have ha := congrArg abs h
  have hfacabs : |(n.factorial : ℝ)| = (n.factorial : ℝ) :=
    abs_of_nonneg (Nat.cast_nonneg n.factorial)
  rw [abs_mul, hfacabs] at ha
  exact ha.symm

/-- The positive initial segment in the shifted-half descending product. -/
theorem bennett_shifted_half_initial_abs (k : ℕ) :
    ((k + 1).factorial : ℝ) * |Ring.choose ((k : ℝ) + 1 / 2) (k + 1)| =
      (ascPochhammer ℝ (k + 1)).eval (1 / 2) := by
  rw [bennett_factorial_mul_abs_choose, descPochhammer_eval_eq_ascPochhammer]
  have harg : ((k : ℝ) + 1 / 2) - ((k + 1 : ℕ) : ℝ) + 1 = 1 / 2 := by
    push_cast
    ring
  rw [harg, abs_of_pos (bennett_ascPochhammer_half_pos (k + 1))]

/-- The absolute negative-half tail is the same positive ascending product. -/
theorem bennett_negative_half_abs (m : ℕ) :
    (m.factorial : ℝ) * |Ring.choose (-1 / 2 : ℝ) m| =
      (ascPochhammer ℝ m).eval (1 / 2) := by
  rw [bennett_factorial_mul_abs_choose]
  have h := ascPochhammer_eval_neg_eq_descPochhammer ℝ (-1 / 2 : ℝ) m
  have ha := congrArg abs h
  norm_num only [neg_div, neg_neg] at ha
  rw [abs_of_pos (bennett_ascPochhammer_half_pos m), abs_mul, abs_pow,
    abs_neg, abs_one, one_pow, one_mul] at ha
  simpa only [neg_div] using ha.symm

/-- Exact absolute Gamma formula after the positive part of a shifted
half-binomial coefficient. This is proved from finite choose identities,
factorials, and Gamma at positive half-integers, without reflection or a
contour representation. -/
theorem bennett_shifted_half_tail_abs_Gamma (k m : ℕ) :
    |Ring.choose ((k : ℝ) + 1 / 2) (k + 1 + m)| =
      Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma ((m : ℝ) + 1 / 2) /
        (Real.pi * Real.Gamma (((k + 1 + m : ℕ) : ℝ) + 1)) := by
  let n := k + 1 + m
  have hdiff : ((k : ℝ) + 1 / 2) - ((k + 1 : ℕ) : ℝ) = -1 / 2 := by
    push_cast
    ring
  have hchoose : ((n.choose (k + 1) : ℕ) : ℝ) *
      Ring.choose ((k : ℝ) + 1 / 2) n =
      Ring.choose ((k : ℝ) + 1 / 2) (k + 1) * Ring.choose (-1 / 2 : ℝ) m := by
    have h := Ring.choose_smul_choose (r := (k : ℝ) + 1 / 2)
      (n := n) (k := k + 1) (by dsimp [n]; omega)
    have hsub : n - (k + 1) = m := by dsimp [n]; omega
    simpa only [nsmul_eq_mul, hdiff, hsub] using h
  have habs := congrArg abs hchoose
  rw [abs_mul, abs_of_nonneg (Nat.cast_nonneg _), abs_mul] at habs
  have hfac : ((n.choose (k + 1) : ℕ) : ℝ) * ((k + 1).factorial : ℝ) *
      (m.factorial : ℝ) = (n.factorial : ℝ) := by
    have h := Nat.choose_mul_factorial_mul_factorial
      (n := n) (k := k + 1) (by dsimp [n]; omega)
    have hsub : n - (k + 1) = m := by dsimp [n]; omega
    rw [hsub] at h
    exact_mod_cast h
  have hnum : (n.factorial : ℝ) * |Ring.choose ((k : ℝ) + 1 / 2) n| =
      (ascPochhammer ℝ (k + 1)).eval (1 / 2) *
        (ascPochhammer ℝ m).eval (1 / 2) := by
    calc
      _ = (((k + 1).factorial : ℝ) * |Ring.choose ((k : ℝ) + 1 / 2) (k + 1)|) *
          ((m.factorial : ℝ) * |Ring.choose (-1 / 2 : ℝ) m|) := by
        linear_combination
          (((k + 1).factorial : ℝ) * (m.factorial : ℝ)) * habs -
            |Ring.choose ((k : ℝ) + 1 / 2) n| * hfac
      _ = _ := by rw [bennett_shifted_half_initial_abs, bennett_negative_half_abs]
  have hG1 : Real.Gamma ((k : ℝ) + 3 / 2) = Real.Gamma (1 / 2 : ℝ) *
      (ascPochhammer ℝ (k + 1)).eval (1 / 2) := by
    have harg : (k : ℝ) + 3 / 2 = (1 / 2 : ℝ) + ((k + 1 : ℕ) : ℝ) := by
      push_cast
      ring
    rw [harg]
    exact bennett_Gamma_half_add_nat (k + 1)
  have hG2 : Real.Gamma ((m : ℝ) + 1 / 2) = Real.Gamma (1 / 2 : ℝ) *
      (ascPochhammer ℝ m).eval (1 / 2) := by
    simpa only [add_comm] using bennett_Gamma_half_add_nat m
  have hhalf : Real.Gamma (1 / 2 : ℝ) ^ 2 = Real.pi := by
    rw [Real.Gamma_one_half_eq]
    exact Real.sq_sqrt Real.pi_pos.le
  have hprod : Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma ((m : ℝ) + 1 / 2) =
      Real.pi * ((n.factorial : ℝ) * |Ring.choose ((k : ℝ) + 1 / 2) n|) := by
    rw [hG1, hG2, hnum]
    calc
      _ = Real.Gamma (1 / 2 : ℝ) ^ 2 *
          ((ascPochhammer ℝ (k + 1)).eval (1 / 2) *
            (ascPochhammer ℝ m).eval (1 / 2)) := by ring
      _ = _ := by rw [hhalf]
  have hden : Real.pi * Real.Gamma ((n : ℝ) + 1) ≠ 0 :=
    mul_ne_zero Real.pi_ne_zero (Real.Gamma_pos_of_pos (by positivity)).ne'
  change |Ring.choose ((k : ℝ) + 1 / 2) n| =
    Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma ((m : ℝ) + 1 / 2) /
      (Real.pi * Real.Gamma ((n : ℝ) + 1))
  apply (eq_div_iff hden).2
  rw [Real.Gamma_nat_eq_factorial]
  linear_combination -hprod

/-- The exact coefficient at degree3k in the two-anchor residual is
the beta/Gamma factor used by the manuscript. -/
theorem bennett_two_residual_choose_abs_Gamma (k : ℕ) (hk : 1 ≤ k) :
    |Ring.choose ((k : ℝ) + 1 / 2) (3 * k)| =
      Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
        (Real.pi * Real.Gamma (3 * (k : ℝ) + 1)) := by
  have hn : k + 1 + (2 * k - 1) = 3 * k := by omega
  have hm : (((2 * k - 1 : ℕ) : ℝ) + 1 / 2) = 2 * (k : ℝ) - 1 / 2 := by
    rw [Nat.cast_sub (by omega : 1 ≤ 2 * k)]
    push_cast
    ring
  have h := bennett_shifted_half_tail_abs_Gamma k (2 * k - 1)
  rw [hn, hm] at h
  simpa only [Nat.cast_mul, Nat.cast_ofNat] using h

end D1Bound5
