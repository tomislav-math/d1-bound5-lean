import D1Bound5.CoherentAnalyticInterpolation

open Finset

namespace D1Bound5

/-- A geometric bound for the actual principal half-power remainder.
This follows from its convergent binomial series and the coefficient
bound `|b_n| <= 1/2`, without selecting a new square-root sign. -/
theorem coherent_cpow_half_sub_one_norm_le
    (w : ℂ) (hw : ‖w‖ < 1) :
    ‖((1 + w) ^ (1 / 2 : ℂ)) - 1‖ ≤
      (1 / 2 : ℝ) * ‖w‖ / (1 - ‖w‖) := by
  have hb0 : (halfBinomialCoeff 0 : ℂ) = 1 := by simp [halfBinomialCoeff]
  have htail : HasSum
      (fun n : ℕ => (halfBinomialCoeff (n + 1) : ℂ) * w ^ (n + 1))
      (((1 + w) ^ (1 / 2 : ℂ)) - 1) := by
    simpa only [Finset.sum_range_one, pow_zero, mul_one, hb0] using
      (hasSum_nat_add_iff' 1).2 (halfBinomialCoeff_hasSum_cpow w hw)
  have hr : ‖(‖w‖ : ℝ)‖ < 1 := by
    simpa only [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg w)] using hw
  have hmajor : HasSum (fun n : ℕ => (1 / 2 : ℝ) * ‖w‖ ^ (n + 1))
      ((1 / 2 : ℝ) * ‖w‖ / (1 - ‖w‖)) := by
    have h := (hasSum_geometric_of_norm_lt_one hr).mul_left ((1 / 2 : ℝ) * ‖w‖)
    refine h.congr_fun ?_
    intro n
    rw [pow_succ]
    ring
  have hterm (n : ℕ) :
      ‖(halfBinomialCoeff (n + 1) : ℂ) * w ^ (n + 1)‖ ≤
        (1 / 2 : ℝ) * ‖w‖ ^ (n + 1) := by
    calc
      ‖(halfBinomialCoeff (n + 1) : ℂ) * w ^ (n + 1)‖ =
        |halfBinomialCoeff (n + 1)| * ‖w‖ ^ (n + 1) := by
          simp [Real.norm_eq_abs]
      _ ≤ _ := mul_le_mul_of_nonneg_right
        (halfBinomialCoeff_abs_le_half (n + 1) (by omega)) (by positivity)
  calc
    ‖((1 + w) ^ (1 / 2 : ℂ)) - 1‖ =
      ‖∑' n : ℕ, (halfBinomialCoeff (n + 1) : ℂ) * w ^ (n + 1)‖ := by
        rw [htail.tsum_eq]
    _ ≤ ∑' n : ℕ, ‖(halfBinomialCoeff (n + 1) : ℂ) * w ^ (n + 1)‖ :=
      norm_tsum_le_tsum_norm htail.summable.norm
    _ ≤ ∑' n : ℕ, (1 / 2 : ℝ) * ‖w‖ ^ (n + 1) :=
      htail.summable.norm.tsum_le_tsum hterm hmajor.summable
    _ = _ := hmajor.tsum_eq

/-- The four near-one estimates in the manuscript, for the actual
analytic branch.  Rationalization uses its exact square and the small
binomial remainder, rather than any assumed sign of a square root. -/
theorem coherent_cpow_half_near_one
    (w : ℂ) (hw0 : w ≠ 0) (hw : ‖w‖ < (1 / 10000 : ℝ)) :
    (99 / 100 : ℝ) < ‖(1 + w) ^ (1 / 2 : ℂ)‖ ∧
    ‖(1 + w) ^ (1 / 2 : ℂ)‖ < (101 / 100 : ℝ) ∧
    (100 / 201 : ℝ) * ‖w‖ < ‖1 - (1 + w) ^ (1 / 2 : ℂ)‖ ∧
    ‖1 - (1 + w) ^ (1 / 2 : ℂ)‖ < (100 / 199 : ℝ) * ‖w‖ := by
  let u : ℂ := (1 + w) ^ (1 / 2 : ℂ)
  let d : ℝ := ‖u - 1‖
  have hw1 : ‖w‖ < 1 := by linarith
  have hd0 : 0 ≤ d := norm_nonneg _
  have hd : d < (1 / 100 : ℝ) := by
    have hb := coherent_cpow_half_sub_one_norm_le w hw1
    have hrat : (1 / 2 : ℝ) * ‖w‖ / (1 - ‖w‖) < (1 / 100 : ℝ) := by
      apply (div_lt_iff₀ (by linarith : 0 < 1 - ‖w‖)).2
      nlinarith only [hw]
    exact hb.trans_lt hrat
  have hdrev : ‖(1 : ℂ) - u‖ = d := norm_sub_rev _ _
  have huupper : ‖u‖ ≤ 1 + d := by
    have h := norm_add_le (1 : ℂ) (u - 1)
    have heq : (1 : ℂ) + (u - 1) = u := by ring
    rw [heq, norm_one] at h
    exact h
  have hulower : 1 ≤ ‖u‖ + d := by
    have h := norm_sub_le u (u - 1)
    have heq : u - (u - 1) = (1 : ℂ) := by ring
    rw [heq, norm_one] at h
    exact h
  have hBupper : ‖(1 : ℂ) + u‖ < (201 / 100 : ℝ) := by
    have h := norm_add_le (2 : ℂ) (u - 1)
    have heq : (2 : ℂ) + (u - 1) = 1 + u := by ring
    rw [heq, Complex.norm_two] at h
    change ‖(1 : ℂ) + u‖ ≤ 2 + d at h
    linarith
  have hBlower : (199 / 100 : ℝ) < ‖(1 : ℂ) + u‖ := by
    have h := norm_sub_le ((1 : ℂ) + u) (u - 1)
    have heq : (1 : ℂ) + u - (u - 1) = 2 := by ring
    rw [heq, Complex.norm_two] at h
    change 2 ≤ ‖(1 : ℂ) + u‖ + d at h
    linarith
  have hsq : u ^ 2 = 1 + w := coherent_cpow_half_sq (1 + w)
  have hprod : ((1 : ℂ) - u) * (1 + u) = -w := by
    linear_combination -hsq
  have hnorm : d * ‖(1 : ℂ) + u‖ = ‖w‖ := by
    have h := congrArg norm hprod
    simpa only [norm_mul, norm_neg, hdrev] using h
  have hdpos : 0 < d := by
    have hwpos : 0 < ‖w‖ := norm_pos_iff.mpr hw0
    by_contra h
    have hz : d = 0 := by linarith
    rw [hz, zero_mul] at hnorm
    linarith
  have hdistlower : (100 / 201 : ℝ) * ‖w‖ < d := by
    have h := mul_lt_mul_of_pos_left hBupper hdpos
    rw [hnorm] at h
    linarith
  have hdistupper : d < (100 / 199 : ℝ) * ‖w‖ := by
    have h := mul_lt_mul_of_pos_left hBlower hdpos
    rw [hnorm] at h
    linarith
  change (99 / 100 : ℝ) < ‖u‖ ∧ ‖u‖ < (101 / 100 : ℝ) ∧
    (100 / 201 : ℝ) * ‖w‖ < ‖1 - u‖ ∧
    ‖1 - u‖ < (100 / 199 : ℝ) * ‖w‖
  rw [hdrev]
  exact ⟨by linarith, by linarith, hdistlower, hdistupper⟩

end D1Bound5

#print axioms D1Bound5.coherent_cpow_half_sub_one_norm_le
#print axioms D1Bound5.coherent_cpow_half_near_one
