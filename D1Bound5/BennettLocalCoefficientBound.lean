import D1Bound5.BennettCoefficientMajorant
import D1Bound5.BennettPositiveSeries
import D1Bound5.BennettTwoCoefficientConstants

namespace D1Bound5

/-- A genuine two-pole local Taylor coefficient is bounded by the positive
generating-function majorant. No Cauchy coefficient estimate is assumed. -/
theorem bennettClearedTaylor_two_poles_weighted_norm_le
    (a N d e : ℂ) (k t p q : ℕ) (ht : t ≤ k)
    (r : ℝ) (hr : 0 ≤ r) (hU : 0 < ‖N + a‖)
    (hd : r < ‖d‖) (he : r < ‖e‖) :
    ‖(bennettClearedTaylor k t (1 / 2 : ℂ) a
      (bennettPoleSeries d p * bennettPoleSeries e q)).eval N‖ * r ^ t ≤
      ((‖N + a‖ + r) ^ (k + 1) / ‖N + a‖) *
        ((‖d‖ - r)⁻¹ ^ p * (‖e‖ - r)⁻¹ ^ q) := by
  let P := bennettNumeratorMajorant ‖N + a‖ k
  let D := bennettPoleMajorant ‖d‖ p
  let E := bennettPoleMajorant ‖e‖ q
  have hP := bennettNumeratorMajorant_coeff_nonneg ‖N + a‖ hU k
  have hD := bennettPoleMajorant_coeff_nonneg ‖d‖ (norm_nonneg d) p
  have hE := bennettPoleMajorant_coeff_nonneg ‖e‖ (norm_nonneg e) q
  have hDE := bennett_positive_coeff_mul D E hD hE
  have hnorm : ∀ h, ‖PowerSeries.coeff h (bennettPoleSeries d p * bennettPoleSeries e q)‖ ≤
      PowerSeries.coeff h (D * E) := by
    apply bennett_coeff_mul_norm_le
    · intro h
      exact (bennettPoleSeries_coeff_norm_eq_majorant d p h).le
    · intro h
      exact (bennettPoleSeries_coeff_norm_eq_majorant e q h).le
  have hc := bennettClearedTaylor_eval_norm_le_coeff k t ht a N _ (D * E) hU hnorm
  have hsumDE := bennett_positive_series_mul_hasSum D E r
    ((‖d‖ - r)⁻¹ ^ p) ((‖e‖ - r)⁻¹ ^ q) hr hD hE
    (bennettPoleMajorant_hasSum ‖d‖ r p (hr.trans_lt hd) hr hd)
    (bennettPoleMajorant_hasSum ‖e‖ r q (hr.trans_lt he) hr he)
  have hsum := bennett_positive_series_mul_hasSum P (D * E) r
    ((‖N + a‖ + r) ^ (k + 1) / ‖N + a‖)
    ((‖d‖ - r)⁻¹ ^ p * (‖e‖ - r)⁻¹ ^ q) hr hP hDE
    (bennettNumeratorMajorant_hasSum ‖N + a‖ r k) hsumDE
  exact (mul_le_mul_of_nonneg_right hc (pow_nonneg hr _)).trans
    (bennett_positive_series_coeff_le_sum (P * (D * E)) r _ hr
      (bennett_positive_coeff_mul P (D * E) hP hDE) hsum t)

/-- The extra row pole cancels the coefficient radius, yielding a uniform
bound for every actual row. The condition 2r≤both distances holds at r=2u/5. -/
theorem bennettClearedTaylor_two_poles_norm_le
    (a N d e : ℂ) (k d0 d1 d2 : ℕ) (hk : 1 ≤ k)
    (hrow : d0 + d1 + d2 = 1)
    (r : ℝ) (hr : 0 < r) (hU : 0 < ‖N + a‖)
    (hd : 2 * r ≤ ‖d‖) (he : 2 * r ≤ ‖e‖) :
    ‖(bennettClearedTaylor k (k + d0 - 1) (1 / 2 : ℂ) a
      (bennettPoleSeries d (k + d1) * bennettPoleSeries e (k + d2))).eval N‖ ≤
      ((‖N + a‖ + r) / ‖N + a‖) *
        ((‖N + a‖ + r) / (r * (‖d‖ - r) * (‖e‖ - r))) ^ k := by
  have hDr : r ≤ ‖d‖ - r := by linarith
  have hEr : r ≤ ‖e‖ - r := by linarith
  have hD : 0 < ‖d‖ - r := hr.trans_le hDr
  have hE : 0 < ‖e‖ - r := hr.trans_le hEr
  have hbase : 0 < r * (‖d‖ - r) * (‖e‖ - r) := mul_pos (mul_pos hr hD) hE
  have ht : k + d0 - 1 ≤ k := by omega
  have hw := bennettClearedTaylor_two_poles_weighted_norm_le a N d e
    k (k + d0 - 1) (k + d1) (k + d2) ht r hr.le hU (by linarith) (by linarith)
  let Z := ‖(bennettClearedTaylor k (k + d0 - 1) (1 / 2 : ℂ) a
    (bennettPoleSeries d (k + d1) * bennettPoleSeries e (k + d2))).eval N‖
  have hden : Z * (r ^ (k + d0 - 1) * (‖d‖ - r) ^ (k + d1) *
      (‖e‖ - r) ^ (k + d2)) ≤ (‖N + a‖ + r) ^ (k + 1) / ‖N + a‖ := by
    calc
      _ = (Z * r ^ (k + d0 - 1)) *
          ((‖d‖ - r) ^ (k + d1) * (‖e‖ - r) ^ (k + d2)) := by ring
      _ ≤ (((‖N + a‖ + r) ^ (k + 1) / ‖N + a‖) *
          ((‖d‖ - r)⁻¹ ^ (k + d1) * (‖e‖ - r)⁻¹ ^ (k + d2))) *
            ((‖d‖ - r) ^ (k + d1) * (‖e‖ - r) ^ (k + d2)) :=
        mul_le_mul_of_nonneg_right hw (mul_nonneg (pow_nonneg hD.le _) (pow_nonneg hE.le _))
      _ = _ := by
        have hcancel (x : ℝ) (hx : x ≠ 0) (m : ℕ) : (x⁻¹)^m * x^m = 1 := by
          rw [← mul_pow, inv_mul_cancel₀ hx, one_pow]
        calc
          _ = ((‖N + a‖ + r) ^ (k + 1) / ‖N + a‖) *
              (((‖d‖ - r)⁻¹ ^ (k + d1) * (‖d‖ - r) ^ (k + d1)) *
                ((‖e‖ - r)⁻¹ ^ (k + d2) * (‖e‖ - r) ^ (k + d2))) := by ring
          _ = _ := by
            rw [hcancel _ hD.ne' (k + d1), hcancel _ hE.ne' (k + d2), one_mul, mul_one]
  have hpow := bennett_two_row_radius_power_le r (‖d‖ - r) (‖e‖ - r)
    hr hDr hEr k d0 d1 d2 hk hrow
  have hsimple : Z ≤ ((‖N + a‖ + r) ^ (k + 1) / ‖N + a‖) /
      (r * (‖d‖ - r) * (‖e‖ - r)) ^ k := by
    apply (le_div_iff₀ (pow_pos hbase _)).mpr
    exact (mul_le_mul_of_nonneg_left hpow (norm_nonneg _)).trans hden
  calc
    _ = Z := rfl
    _ ≤ _ := hsimple
    _ = _ := by rw [div_pow, pow_succ]; ring

end D1Bound5
