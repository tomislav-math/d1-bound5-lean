import Mathlib.RingTheory.PowerSeries.Binomial
import Mathlib.Tactic.Ring

open PowerSeries

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The formal inverse-power expansion around a nonzero pole displacement. -/
noncomputable def bennettPoleSeries (d : F) (k : ℕ) : PowerSeries F :=
  C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))

/-- Exact Taylor coefficients of the local reciprocal pole factor. -/
theorem bennettPoleSeries_coeff (d : F) (k h : ℕ) :
    coeff h (bennettPoleSeries d k) =
      Ring.choose (-(k : F)) h * (d⁻¹) ^ (k + h) := by
  simp only [bennettPoleSeries, coeff_C_mul, coeff_rescale,
    binomialSeries_coeff, smul_eq_mul, mul_one, pow_add]
  ring

/-- The negative-integer binomial series is the formal inverse of `(1+X)^k`. -/
theorem bennettNegativeBinomial_mul (k : ℕ) :
    (1 + X : PowerSeries F) ^ k * binomialSeries F (-(k : F)) = 1 := by
  rw [← binomialSeries_nat (R := F), ← binomialSeries_add]
  simp

/-- The explicit binomial coefficients really invert the reciprocal pole
factor, rather than merely satisfying a guessed recurrence. -/
theorem bennettPoleSeries_mul (d : F) (hd : d ≠ 0) (k : ℕ) :
    (C d + X : PowerSeries F) ^ k * bennettPoleSeries d k = 1 := by
  have hs := congrArg (rescale d⁻¹) (bennettNegativeBinomial_mul (F := F) k)
  simp only [map_mul, map_pow, map_add, map_one, rescale_X] at hs
  have hf : (C d + X : PowerSeries F) = C d * (1 + C d⁻¹ * X) := by
    rw [mul_add, mul_one, ← mul_assoc, ← map_mul, mul_inv_cancel₀ hd,
      map_one, one_mul]
  rw [hf, mul_pow, bennettPoleSeries]
  calc
    (C d) ^ k * (1 + C d⁻¹ * X) ^ k *
        (C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))) =
      C (d ^ k * (d⁻¹) ^ k) *
        ((1 + C d⁻¹ * X) ^ k * rescale d⁻¹ (binomialSeries F (-(k : F)))) := by
          rw [map_mul, map_pow]
          ring
    _ = 1 := by
      rw [hs, ← mul_pow, mul_inv_cancel₀ hd, one_pow, map_one, mul_one]

end D1Bound5
