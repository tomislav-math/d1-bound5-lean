import Mathlib.RingTheory.PowerSeries.Binomial
import Mathlib.Tactic.Ring

open PowerSeries

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The formal inverse-power expansion around a nonzero pole displacement. -/
noncomputable def bennettPoleSeries (d : F) (k : ℕ) : PowerSeries F :=
  PowerSeries.C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))

/-- Exact Taylor coefficients of the local reciprocal pole factor. -/
theorem bennettPoleSeries_coeff (d : F) (k h : ℕ) :
    PowerSeries.coeff h (bennettPoleSeries d k) =
      Ring.choose (-(k : F)) h * (d⁻¹) ^ (k + h) := by
  simp only [bennettPoleSeries, PowerSeries.coeff_C_mul, PowerSeries.coeff_rescale,
    binomialSeries_coeff, smul_eq_mul, mul_one, pow_add]
  ring

/-- The negative-integer binomial series is the formal inverse of `(1+X)^k`. -/
theorem bennettNegativeBinomial_mul (k : ℕ) :
    (1 + PowerSeries.X : PowerSeries F) ^ k * binomialSeries F (-(k : F)) = 1 := by
  rw [← binomialSeries_nat (R := F), ← binomialSeries_add]
  simp

/-- The explicit binomial coefficients really invert the reciprocal pole
factor, rather than merely satisfying a guessed recurrence. -/
theorem bennettPoleSeries_mul (d : F) (hd : d ≠ 0) (k : ℕ) :
    (PowerSeries.C d + PowerSeries.X : PowerSeries F) ^ k * bennettPoleSeries d k = 1 := by
  have hs := congrArg (rescale d⁻¹) (bennettNegativeBinomial_mul (F := F) k)
  simp only [map_mul, map_pow, map_add, map_one, PowerSeries.rescale_X] at hs
  have hf : (PowerSeries.C d + PowerSeries.X : PowerSeries F) =
      PowerSeries.C d * (1 + PowerSeries.C d⁻¹ * PowerSeries.X) := by
    rw [mul_add, mul_one, ← mul_assoc, ← map_mul, mul_inv_cancel₀ hd,
      map_one, one_mul]
  rw [hf, mul_pow, bennettPoleSeries]
  calc
    (PowerSeries.C d) ^ k * (1 + PowerSeries.C d⁻¹ * PowerSeries.X) ^ k *
        (PowerSeries.C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))) =
      PowerSeries.C (d ^ k * (d⁻¹) ^ k) *
        ((1 + PowerSeries.C d⁻¹ * PowerSeries.X) ^ k *
          rescale d⁻¹ (binomialSeries F (-(k : F)))) := by
          rw [map_mul, map_pow]
          ring
    _ = 1 := by
      rw [hs, ← mul_pow, mul_inv_cancel₀ hd, one_pow, map_one, mul_one]

end D1Bound5
