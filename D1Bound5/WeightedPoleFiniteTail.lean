import Mathlib.LinearAlgebra.Lagrange

open Finset

namespace D1Bound5

/-- An exact finite geometric expansion of a reciprocal pole, with its
rational remainder. No convergence assumptions or characteristic-zero
hypothesis are needed. -/
theorem reciprocal_pole_finite_tail
    {F : Type*} [Field F] (a z : F) (ha : a ≠ 0)
    (haz : a ≠ z) (n : ℕ) :
    (a - z)⁻¹ =
      (∑ k ∈ Finset.range n, z ^ k / a ^ (k + 1)) +
        z ^ n / (a ^ n * (a - z)) := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      have hsub : a - z ≠ 0 := sub_ne_zero.mpr haz
      have hpow : a ^ n ≠ 0 := pow_ne_zero n ha
      have hstep :
          z ^ n / (a ^ n * (a - z)) =
          z ^ n / a ^ (n + 1) +
            z ^ (n + 1) / (a ^ (n + 1) * (a - z)) := by
        rw [pow_succ, pow_succ]
        field_simp
        ring
      rw [Finset.sum_range_succ, ih, hstep]
      ring

/-- The exact finite reciprocal Taylor remainder for any finite weighted
collection of poles. Coincident node values and zero weights are allowed.
All denominators are nonzero only where explicitly hypothesized. -/
theorem weighted_poles_finite_tail
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a w : ι → F) (z : F)
    (ha : ∀ i ∈ s, a i ≠ 0)
    (haz : ∀ i ∈ s, a i ≠ z) (n : ℕ) :
    (∑ i ∈ s, w i / (a i - z)) =
      (∑ k ∈ Finset.range n, z ^ k *
        (∑ i ∈ s, w i / (a i) ^ (k + 1))) +
      z ^ n * (∑ i ∈ s, w i / ((a i) ^ n * (a i - z))) := by
  calc
    (∑ i ∈ s, w i / (a i - z)) =
      ∑ i ∈ s, w i *
        ((∑ k ∈ Finset.range n, z ^ k / (a i) ^ (k + 1)) +
          z ^ n / ((a i) ^ n * (a i - z))) := by
        apply Finset.sum_congr rfl
        intro i hi
        rw [← reciprocal_pole_finite_tail (a i) z (ha i hi) (haz i hi) n]
        simp only [div_eq_mul_inv]
    _ = _ := by
      simp_rw [mul_add]
      rw [Finset.sum_add_distrib]
      have hmain :
          (∑ i ∈ s, w i *
            (∑ k ∈ Finset.range n, z ^ k / (a i) ^ (k + 1))) =
          ∑ k ∈ Finset.range n, z ^ k *
            (∑ i ∈ s, w i / (a i) ^ (k + 1)) := by
        simp_rw [Finset.mul_sum]
        rw [Finset.sum_comm]
        apply Finset.sum_congr rfl
        intro k hk
        apply Finset.sum_congr rfl
        intro i hi
        ring
      have htail :
          (∑ i ∈ s, w i *
            (z ^ n / ((a i) ^ n * (a i - z)))) =
          z ^ n * (∑ i ∈ s, w i / ((a i) ^ n * (a i - z))) := by
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i hi
        ring
      rw [hmain, htail]

end D1Bound5

#check @D1Bound5.reciprocal_pole_finite_tail
#check @D1Bound5.weighted_poles_finite_tail
#print axioms D1Bound5.reciprocal_pole_finite_tail
#print axioms D1Bound5.weighted_poles_finite_tail
