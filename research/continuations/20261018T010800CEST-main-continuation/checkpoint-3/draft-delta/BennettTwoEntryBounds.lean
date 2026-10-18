import D1Bound5.BennettLocalCoefficientBound
import D1Bound5.BennettTwoIntegralEntries

namespace D1Bound5

/-- Actual column one of the integral Q-matrix obeys the local positive-series
bound, with its directed pole displacements and exact clearing factor. -/
theorem bennettTwoClearedEntry_one_norm_le_local
    (a b c : ℂ) (k : ℕ) (hk : 1 ≤ k) (i : Fin 3)
    (r : ℝ) (hr : 0 < r) (hU : 0 < ‖a * b * c + b‖)
    (hb : 2 * r ≤ ‖b‖) (hab : 2 * r ≤ ‖a - b‖) :
    ‖bennettTwoClearedEntry a b c k i 1‖ ≤
      (4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2) ^ k *
        ((‖a * b * c + b‖ + r) / ‖a * b * c + b‖) *
          ((‖a * b * c + b‖ + r) /
            (r * (‖b‖ - r) * (‖a - b‖ - r))) ^ k := by
  have hrow : (if i = 1 then 1 else 0) + (if i = 0 then 1 else 0) +
      (if i = 2 then 1 else 0) = (1 : ℕ) := by
    simpa only [Nat.add_comm, Nat.add_left_comm] using bennett_delta_sum_three i
  have h := bennettClearedTaylor_two_poles_norm_le b (a * b * c) b (b - a) k
    (if i = 1 then 1 else 0) (if i = 0 then 1 else 0) (if i = 2 then 1 else 0)
    hk hrow r hr hU hb (by simpa only [norm_sub_rev] using hab)
  rw [norm_sub_rev] at h
  unfold bennettTwoClearedEntry bennettClearedResidue
  rw [bennettTwoOtherPoles_one, bennettTwoNodes_one, norm_mul, norm_pow]
  have hscale : ‖(4 : ℂ) * a * b * (a - b) ^ 2‖ =
      4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2 := by simp [norm_mul, norm_pow]
  rw [hscale]
  simpa only [mul_assoc] using mul_le_mul_of_nonneg_left h
    (pow_nonneg (by positivity : 0 ≤ 4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2) k)

/-- Actual column two of the integral Q-matrix obeys the same estimate at
the other interpolation node. -/
theorem bennettTwoClearedEntry_two_norm_le_local
    (a b c : ℂ) (k : ℕ) (hk : 1 ≤ k) (i : Fin 3)
    (r : ℝ) (hr : 0 < r) (hU : 0 < ‖a * b * c + a‖)
    (ha : 2 * r ≤ ‖a‖) (hab : 2 * r ≤ ‖a - b‖) :
    ‖bennettTwoClearedEntry a b c k i 2‖ ≤
      (4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2) ^ k *
        ((‖a * b * c + a‖ + r) / ‖a * b * c + a‖) *
          ((‖a * b * c + a‖ + r) /
            (r * (‖a‖ - r) * (‖a - b‖ - r))) ^ k := by
  have hrow : (if i = 2 then 1 else 0) + (if i = 0 then 1 else 0) +
      (if i = 1 then 1 else 0) = (1 : ℕ) := by
    simpa only [Nat.add_comm, Nat.add_left_comm] using bennett_delta_sum_three i
  have h := bennettClearedTaylor_two_poles_norm_le a (a * b * c) a (a - b) k
    (if i = 2 then 1 else 0) (if i = 0 then 1 else 0) (if i = 1 then 1 else 0)
    hk hrow r hr hU ha hab
  unfold bennettTwoClearedEntry bennettClearedResidue
  rw [bennettTwoOtherPoles_two, bennettTwoNodes_two, norm_mul, norm_pow]
  have hscale : ‖(4 : ℂ) * a * b * (a - b) ^ 2‖ =
      4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2 := by simp [norm_mul, norm_pow]
  rw [hscale]
  simpa only [mul_assoc] using mul_le_mul_of_nonneg_left h
    (pow_nonneg (by positivity : 0 ≤ 4 * ‖a‖ * ‖b‖ * ‖a - b‖ ^ 2) k)

end D1Bound5
