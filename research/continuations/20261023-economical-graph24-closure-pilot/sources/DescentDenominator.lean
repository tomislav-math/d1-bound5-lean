import D1Bound5.FullRingBridge
import Mathlib.Tactic.LinearCombination

open scoped NumberField
open Module

namespace D1Bound5

/-- Three discrete-distance bounds suffice for the hyperbolic denominator
estimate. No classification of imaginary-quadratic units is needed. -/
theorem complex_two_square_sub_one_norm_sq_ge_seven
    (r : ℂ) (hr : 1 ≤ ‖r‖) (hp : 1 ≤ ‖r + 1‖) (hm : 1 ≤ ‖r - 1‖) :
    7 ≤ ‖(2 : ℂ) * r ^ 2 - 1‖ ^ 2 := by
  have hn : 1 ≤ ‖r‖ ^ 2 := by nlinarith [sq_nonneg (‖r‖ - 1)]
  have hp2 : 1 ≤ ‖r + 1‖ ^ 2 := by nlinarith [sq_nonneg (‖r + 1‖ - 1)]
  have hm2 : 1 ≤ ‖r - 1‖ ^ 2 := by nlinarith [sq_nonneg (‖r - 1‖ - 1)]
  have hplus : ‖r + 1‖ ^ 2 = ‖r‖ ^ 2 + 1 + 2 * r.re := by
    simp [Complex.sq_norm, Complex.normSq_apply]
    <;> ring
  have hminus : ‖r - 1‖ ^ 2 = ‖r‖ ^ 2 + 1 - 2 * r.re := by
    simp [Complex.sq_norm, Complex.normSq_apply]
    <;> ring
  have hid : ‖(2 : ℂ) * r ^ 2 - 1‖ ^ 2 =
      4 * (‖r‖ ^ 2) ^ 2 + 4 * ‖r‖ ^ 2 + 1 - 2 * (2 * r.re) ^ 2 := by
    simp only [Complex.sq_norm]
    simp [Complex.normSq_apply, pow_two]
    <;> ring
  have hpos : 0 ≤ ‖r‖ ^ 2 + 2 * r.re := by linarith
  have hneg : 0 ≤ ‖r‖ ^ 2 - 2 * r.re := by linarith
  have htrace : (2 * r.re) ^ 2 ≤ (‖r‖ ^ 2) ^ 2 := by
    nlinarith only [mul_nonneg hpos hneg]
  nlinarith only [hid, htrace, hn, sq_nonneg (‖r‖ ^ 2 - 1)]

/-- In a discrete complex image, a nonzero square root whose square is
not one automatically supplies the three distance bounds. -/
theorem discrete_two_square_sub_one_norm_sq_ge_seven
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (hdiscrete : ∀ x : R, x ≠ 0 → 1 ≤ ‖f x‖)
    (r : R) (hr : r ≠ 0) (hrsq : r ^ 2 ≠ 1) :
    7 ≤ ‖(2 : ℂ) * (f r) ^ 2 - 1‖ ^ 2 := by
  have hp : r + 1 ≠ 0 := by
    intro h
    have he : r = -1 := by linear_combination h
    apply hrsq
    rw [he]
    ring
  have hm : r - 1 ≠ 0 := by
    intro h
    have he : r = 1 := sub_eq_zero.mp h
    apply hrsq
    rw [he]
    ring
  exact complex_two_square_sub_one_norm_sq_ge_seven (f r) (hdiscrete r hr)
    (by simpa only [map_add, map_one] using hdiscrete (r + 1) hp)
    (by simpa only [map_sub, map_one] using hdiscrete (r - 1) hm)

/-- The denominator estimate needed for small-pair descent holds in the
full integer ring. The zero radicand is explicitly the exceptional case;
no smallness, strict norm ordering, or unit classification is assumed. -/
theorem full_ring_descent_denominator_norm_sq_ge_seven
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b r : 𝓞 K) (ha : a ≠ 0) (hb : b ≠ 0)
    (hab : a * b + 1 ≠ 0) (hr : r ^ 2 = a * b + 1) :
    7 ≤ ‖2 * phi (a : K) * phi (b : K) + 1‖ ^ 2 := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hr0 : r ≠ 0 := by
    intro h
    apply hab
    simpa only [h, zero_pow (by decide : 2 ≠ 0)] using hr.symm
  have hr1 : r ^ 2 ≠ 1 := by
    intro h
    apply mul_ne_zero ha hb
    linear_combination -hr + h
  have hbound := discrete_two_square_sub_one_norm_sq_ge_seven f
    (fun x hx => one_le_norm_integer hK phi hx) r hr0 hr1
  have hs : (f r) ^ 2 = f a * f b + 1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hr
  have he : (2 : ℂ) * (f r) ^ 2 - 1 = 2 * f a * f b + 1 := by
    rw [hs]
    ring
  rw [he] at hbound
  exact hbound

end D1Bound5
