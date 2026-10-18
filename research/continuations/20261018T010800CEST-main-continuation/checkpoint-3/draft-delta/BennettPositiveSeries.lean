import D1Bound5.BennettResidualMajorant
import D1Bound5.BennettPoleSeries
import Mathlib.Analysis.Normed.Ring.InfiniteSum
import Mathlib.Topology.Algebra.InfiniteSum.Order
import Mathlib.Tactic.FieldSimp

open Finset

namespace D1Bound5

/-- The coefficientwise absolute majorant of an actual local pole factor.
Writing the coefficients explicitly avoids any implicit choice of signs. -/
noncomputable def bennettPoleMajorant (d : ℝ) (p : ℕ) : PowerSeries ℝ :=
  PowerSeries.mk (fun n => |Ring.choose (-(p : ℝ)) n| * (d⁻¹) ^ (p + n))

@[simp] theorem bennettPoleMajorant_coeff (d : ℝ) (p n : ℕ) :
    PowerSeries.coeff n (bennettPoleMajorant d p) =
      |Ring.choose (-(p : ℝ)) n| * (d⁻¹) ^ (p + n) := by
  exact PowerSeries.coeff_mk _ _

theorem bennettPoleMajorant_coeff_nonneg (d : ℝ) (hd : 0 ≤ d) (p n : ℕ) :
    0 ≤ PowerSeries.coeff n (bennettPoleMajorant d p) := by
  rw [bennettPoleMajorant_coeff]
  exact mul_nonneg (abs_nonneg _) (pow_nonneg (inv_nonneg.mpr hd) _)

/-- The majorant coefficients equal the norms of the actual complex pole
series coefficients, with exactly the same pole order and displacement. -/
theorem bennettPoleSeries_coeff_norm_eq_majorant (z : ℂ) (p n : ℕ) :
    ‖PowerSeries.coeff n (bennettPoleSeries z p)‖ =
      PowerSeries.coeff n (bennettPoleMajorant ‖z‖ p) := by
  have hcast : Ring.choose (-(p : ℂ)) n = (Ring.choose (-(p : ℝ)) n : ℂ) := by
    simpa using (Ring.map_choose (algebraMap ℝ ℂ) (-(p : ℝ)) n).symm
  rw [bennettPoleSeries_coeff, norm_mul, norm_pow, norm_inv,
    bennettPoleMajorant_coeff, hcast, Complex.norm_real, Real.norm_eq_abs]

/-- The actual weighted sum of the positive pole majorant, including pole
order zero. The radius is strictly smaller than the positive displacement. -/
theorem bennettPoleMajorant_hasSum
    (d r : ℝ) (p : ℕ) (hd : 0 < d) (hr0 : 0 ≤ r) (hrd : r < d) :
    HasSum (fun n : ℕ => PowerSeries.coeff n (bennettPoleMajorant d p) * r ^ n)
      ((d-r)⁻¹ ^ p) := by
  cases p with
  | zero =>
      convert (hasSum_ite_eq (0 : ℕ) (1 : ℝ)) using 1
      · ext n
        by_cases hn : n = 0
        · subst n
          simp
        · simp [bennettPoleMajorant_coeff, Ring.choose_zero_ite, hn]
      · simp
  | succ p =>
      have hratio0 : 0 ≤ r/d := div_nonneg hr0 hd.le
      have hratio1 : r/d < 1 := (div_lt_one hd).2 hrd
      have hp : (0 : ℝ) < ((p + 1 : ℕ) : ℝ) := by positivity
      have hs := bennett_negative_binomial_abs_hasSum
        ((p + 1 : ℕ) : ℝ) (r/d) hp hratio0 hratio1
      have hscaled := hs.mul_left (d⁻¹ ^ (p+1))
      have hbase : 0 < 1-r/d := sub_pos.mpr hratio1
      have hsub : 0 < d-r := sub_pos.mpr hrd
      have hinner : d⁻¹*(1-r/d)⁻¹ = (d-r)⁻¹ := by
        field_simp [hd.ne', hbase.ne', hsub.ne']
        ring
      have htotal : d⁻¹ ^ (p+1) * (1/(1-r/d)^((p+1 : ℕ) : ℝ)) =
          (d-r)⁻¹ ^ (p+1) := by
        rw [Real.rpow_natCast]
        calc
          _ = (d⁻¹ * (1-r/d)⁻¹) ^ (p+1) := by
            simp only [mul_pow, inv_pow, one_div]
          _ = _ := by rw [hinner]
      rw [htotal] at hscaled
      have hfun :
          (fun n : ℕ => PowerSeries.coeff n (bennettPoleMajorant d (p+1)) * r^n) =
          (fun n : ℕ => d⁻¹ ^ (p+1) *
            (|Ring.choose (-((p+1 : ℕ) : ℝ)) n| * (r/d)^n)) := by
        funext n
        simp only [bennettPoleMajorant_coeff, pow_add, div_eq_mul_inv, mul_pow]
        ring
      rw [hfun]
      exact hscaled

/-- Multiplying two series with nonnegative coefficients preserves
coefficient nonnegativity. -/
theorem bennett_positive_coeff_mul
    (P Q : PowerSeries ℝ)
    (hP : ∀ n, 0 ≤ PowerSeries.coeff n P)
    (hQ : ∀ n, 0 ≤ PowerSeries.coeff n Q) (n : ℕ) :
    0 ≤ PowerSeries.coeff n (P*Q) := by
  rw [PowerSeries.coeff_mul]
  exact Finset.sum_nonneg (fun ij _ => mul_nonneg (hP ij.1) (hQ ij.2))

/-- Weighted Cauchy multiplication for positive real power series. The two
series are actually summable at the chosen radius; no formal evaluation is
silently treated as an analytic sum. -/
theorem bennett_positive_series_mul_hasSum
    (P Q : PowerSeries ℝ) (r s t : ℝ) (hr : 0 ≤ r)
    (hP : ∀ n, 0 ≤ PowerSeries.coeff n P)
    (hQ : ∀ n, 0 ≤ PowerSeries.coeff n Q)
    (hs : HasSum (fun n : ℕ => PowerSeries.coeff n P * r^n) s)
    (ht : HasSum (fun n : ℕ => PowerSeries.coeff n Q * r^n) t) :
    HasSum (fun n : ℕ => PowerSeries.coeff n (P*Q) * r^n) (s*t) := by
  have hprod := hs.summable.mul_of_nonneg ht.summable
    (fun n => mul_nonneg (hP n) (pow_nonneg hr n))
    (fun n => mul_nonneg (hQ n) (pow_nonneg hr n))
  have hsum := summable_sum_mul_antidiagonal_of_summable_mul hprod
  have heq := hs.summable.tsum_mul_tsum_eq_tsum_sum_antidiagonal ht.summable hprod
  rw [hs.tsum_eq, ht.tsum_eq] at heq
  have hcoeff :
      (fun n : ℕ => ∑ ij ∈ Finset.antidiagonal n,
        (PowerSeries.coeff ij.1 P*r^ij.1) * (PowerSeries.coeff ij.2 Q*r^ij.2)) =
      (fun n : ℕ => PowerSeries.coeff n (P*Q)*r^n) := by
    funext n
    rw [PowerSeries.coeff_mul, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro ij hij
    have hsumij := Finset.mem_antidiagonal.mp hij
    rw [← hsumij, pow_add]
    ring
  rw [hcoeff] at hsum heq
  simpa only [← heq] using hsum.hasSum

/-- Every nonnegative weighted coefficient is bounded by the actual sum. -/
theorem bennett_positive_series_coeff_le_sum
    (P : PowerSeries ℝ) (r s : ℝ) (hr : 0 ≤ r)
    (hP : ∀ n, 0 ≤ PowerSeries.coeff n P)
    (hs : HasSum (fun n : ℕ => PowerSeries.coeff n P * r^n) s) (n : ℕ) :
    PowerSeries.coeff n P * r^n ≤ s := by
  rw [← hs.tsum_eq]
  exact hs.summable.le_tsum n
    (fun m _ => mul_nonneg (hP m) (pow_nonneg hr m))

/-- A useful ready-to-apply two-pole coefficient bound. -/
theorem bennett_two_pole_majorant_coeff_le
    (d e r : ℝ) (p q n : ℕ) (hd : 0 < d) (he : 0 < e)
    (hr : 0 ≤ r) (hrd : r < d) (hre : r < e) :
    PowerSeries.coeff n (bennettPoleMajorant d p * bennettPoleMajorant e q) * r^n ≤
      (d-r)⁻¹ ^ p * (e-r)⁻¹ ^ q := by
  have hP := bennettPoleMajorant_coeff_nonneg d hd.le p
  have hQ := bennettPoleMajorant_coeff_nonneg e he.le q
  exact bennett_positive_series_coeff_le_sum _ _ _ hr
    (bennett_positive_coeff_mul _ _ hP hQ)
    (bennett_positive_series_mul_hasSum _ _ _ _ _ hr hP hQ
      (bennettPoleMajorant_hasSum d r p hd hr hrd)
      (bennettPoleMajorant_hasSum e r q he hr hre)) n

end D1Bound5
