import D1Bound5.CoherentMajorant
import Mathlib.Analysis.Analytic.Binomial
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

/-!
An elementary analytic majorant for the actual binomial/homogeneous tail that
arises in Bennett's simultaneous approximants.  In contrast to a coefficient
envelope interface, every coefficient of the series below is specified.

The algebraic identification of the residue moments with homogeneous
polynomials is a separate theorem.  This file does not assume that an arbitrary
series is a Bennett residual.  Once that identification is available, the
specialization n = 3k, s = k + 1/2 gives exactly the eta exponent in the paper.
-/

namespace D1Bound5

theorem bennett_multichoose_pos (q : ℝ) (hq : 0 < q) (t : ℕ) :
    0 < Ring.multichoose q t := by
  have h := Ring.factorial_nsmul_multichoose_eq_ascPochhammer q t
  rw [nsmul_eq_mul, Polynomial.ascPochhammer_smeval_eq_eval] at h
  have hp := ascPochhammer_pos t q hq
  have hf : 0 < (t.factorial : ℝ) := by positivity
  nlinarith

/-- The sign of a negative-upper binomial coefficient disappears into a
positive multichoose coefficient. -/
theorem bennett_choose_negative_abs (q : ℝ) (hq : 0 < q) (t : ℕ) :
    |Ring.choose (-q) t| = Ring.choose (q + t - 1) t := by
  rw [Ring.choose_neg', Units.smul_def, zsmul_eq_mul,
    Int.cast_negOnePow_natCast, abs_mul, abs_pow]
  simp only [abs_neg, abs_one, one_pow, one_mul]
  rw [abs_of_pos (bennett_multichoose_pos q hq t), Ring.multichoose_eq]

/-- Exact coefficient identity responsible for cancellation of the homogeneous
coefficient counting factor. -/
theorem bennett_choose_tail_identity (s : ℝ) (n t : ℕ) :
    |Ring.choose s (n + t)| * (Nat.choose (n + t) t : ℝ) =
      |Ring.choose s n| * |Ring.choose (s - n) t| := by
  have h := Ring.choose_smul_choose s (n := n + t) (k := n)
    (Nat.le_add_right n t)
  rw [Nat.add_sub_cancel_left, nsmul_eq_mul] at h
  have ha := congrArg abs h
  rw [abs_mul, abs_mul, abs_of_nonneg (Nat.cast_nonneg _)] at ha
  rw [Nat.choose_symm_add] at ha
  simpa only [mul_comm] using ha

/-- Exact real sum of the absolute negative-binomial series, using the analytic
binomial theorem already proved in mathlib. -/
theorem bennett_negative_binomial_abs_hasSum (q r : ℝ)
    (hq : 0 < q) (hr0 : 0 ≤ r) (hr1 : r < 1) :
    HasSum (fun t : ℕ => |Ring.choose (-q) t| * r ^ t)
      (1 / (1 - r) ^ q) := by
  have hrball : r ∈ Metric.eball (0 : ℝ) 1 := by
    rw [← ENNReal.ofReal_one, Metric.eball_ofReal]
    simpa [Metric.mem_ball, dist_eq_norm, Real.norm_eq_abs,
      abs_of_nonneg hr0] using hr1
  have hs := (Real.one_div_one_sub_rpow_hasFPowerSeriesOnBall_zero q).hasSum_sub hrball
  simpa only [sub_zero, FormalMultilinearSeries.ofScalars_apply_eq,
    smul_eq_mul, mul_comm, bennett_choose_negative_abs q hq] using hs

/-- A fully explicit generalized-binomial/homogeneous tail is summable and
satisfies the sharp negative-binomial majorant.  Here the repeated-node count
is n+1, as required for a denominator of degree n+1. -/
theorem bennett_homogeneous_tail_summable_and_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (n : ℕ) (s ρ : ℝ) (x : ℂ)
    (hcard : Fintype.card ι = n + 1)
    (hs : s < n) (hρ0 : 0 ≤ ρ)
    (ha : ∀ i, ‖a i‖ ≤ ρ) (hradius : ρ * ‖x‖ < 1) :
    Summable (fun t : ℕ =>
      (Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)) ∧
    ‖∑' t : ℕ, (Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖ ≤
      |Ring.choose s n| * ‖x‖ ^ n / (1 - ρ * ‖x‖) ^ ((n : ℝ) - s) := by
  let q : ℝ := n - s
  let r : ℝ := ρ * ‖x‖
  have hq : 0 < q := sub_pos.mpr hs
  have hr0 : 0 ≤ r := mul_nonneg hρ0 (norm_nonneg _)
  have hsum := bennett_negative_binomial_abs_hasSum q r hq hr0 hradius
  have hscaled : Summable (fun t : ℕ =>
      (|Ring.choose s n| * ‖x‖ ^ n) *
        (|Ring.choose (-q) t| * r ^ t)) :=
    hsum.summable.mul_left (|Ring.choose s n| * ‖x‖ ^ n)
  have hterm (t : ℕ) :
      ‖(Ring.choose s (n + t) : ℂ) *
          MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖ ≤
        (|Ring.choose s n| * ‖x‖ ^ n) *
          (|Ring.choose (-q) t| * r ^ t) := by
    have hidx : Fintype.card ι + t - 1 = n + t := by omega
    have hid := bennett_choose_tail_identity s n t
    have hsq : s - n = -q := by dsimp [q]; ring
    rw [hsq] at hid
    calc
      ‖(Ring.choose s (n + t) : ℂ) *
          MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖ =
        |Ring.choose s (n + t)| *
          ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t)‖ * ‖x‖ ^ (n + t) := by
            rw [norm_mul, norm_mul, norm_pow, ← Complex.ofReal_choose,
              Complex.norm_real, Real.norm_eq_abs]
      _ ≤ |Ring.choose s (n + t)| *
          ((Nat.choose (n + t) t : ℝ) * ρ ^ t) * ‖x‖ ^ (n + t) := by
            apply mul_le_mul_of_nonneg_right _ (pow_nonneg (norm_nonneg _) _)
            apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
            simpa only [hidx] using hsymm_aeval_complex_norm_le_choose a t ρ hρ0 ha
      _ = (|Ring.choose s (n + t)| * (Nat.choose (n + t) t : ℝ)) *
          (‖x‖ ^ n * r ^ t) := by
            simp only [r, pow_add, mul_pow]
            ring
      _ = (|Ring.choose s n| * ‖x‖ ^ n) *
          (|Ring.choose (-q) t| * r ^ t) := by rw [hid]; ring
  have hcomplex : Summable (fun t : ℕ =>
      (Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)) :=
    Summable.of_norm_bounded hscaled hterm
  have hnorm : Summable (fun t : ℕ =>
      ‖(Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖) :=
    Summable.of_nonneg_of_le (fun _ => norm_nonneg _) hterm hscaled
  refine ⟨hcomplex, ?_⟩
  calc
    ‖∑' t : ℕ, (Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖ ≤
      ∑' t : ℕ, ‖(Ring.choose s (n + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (n + t)‖ :=
          norm_tsum_le_tsum_norm hnorm
    _ ≤ ∑' t : ℕ, (|Ring.choose s n| * ‖x‖ ^ n) *
        (|Ring.choose (-q) t| * r ^ t) :=
          hnorm.tsum_le_tsum hterm hscaled
    _ = |Ring.choose s n| * ‖x‖ ^ n / (1 - ρ * ‖x‖) ^ ((n : ℝ) - s) := by
      rw [tsum_mul_left, hsum.tsum_eq]
      simp only [q, r, div_eq_mul_inv, one_mul]

/-- The two-anchor Bennett exponent is exactly 2k-1/2. -/
theorem bennett_two_homogeneous_tail_summable_and_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (k : ℕ) (ρ : ℝ) (x : ℂ)
    (hk : 1 ≤ k) (hcard : Fintype.card ι = 3 * k + 1)
    (hρ0 : 0 ≤ ρ) (ha : ∀ i, ‖a i‖ ≤ ρ)
    (hradius : ρ * ‖x‖ < 1) :
    Summable (fun t : ℕ =>
      (Ring.choose ((k : ℝ) + 1 / 2) (3 * k + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (3 * k + t)) ∧
    ‖∑' t : ℕ, (Ring.choose ((k : ℝ) + 1 / 2) (3 * k + t) : ℂ) *
        MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ t) * x ^ (3 * k + t)‖ ≤
      |Ring.choose ((k : ℝ) + 1 / 2) (3 * k)| * ‖x‖ ^ (3 * k) /
        (1 - ρ * ‖x‖) ^ (2 * (k : ℝ) - 1 / 2) := by
  have hk' : (1 : ℝ) ≤ k := by exact_mod_cast hk
  have hs : (k : ℝ) + 1 / 2 < (3 * k : ℕ) := by
    push_cast
    linarith
  have hexp : ((3 * k : ℕ) : ℝ) - ((k : ℝ) + 1 / 2) =
      2 * (k : ℝ) - 1 / 2 := by push_cast; ring
  simpa [hexp] using
    bennett_homogeneous_tail_summable_and_norm_le a (3 * k)
      ((k : ℝ) + 1 / 2) ρ x hcard hs hρ0 ha hradius

end D1Bound5
