import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- The barycentric denominator of an old node acquires exactly one
factor when a new, distinct index is adjoined. No injectivity is needed. -/
theorem barycentric_denominator_insert
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (t i : ι)
    (ht : t ∉ s) (hi : i ∈ s) :
    (∏ j ∈ (insert t s).erase i, (a i - a j)) =
      (a i - a t) * ∏ j ∈ s.erase i, (a i - a j) := by
  have hne : t ≠ i := by
    intro heq
    exact ht (by simpa [heq] using hi)
  rw [Finset.erase_insert_of_ne hne]
  rw [Finset.prod_insert (by simp [ht])]

/-- Adding a new interpolation node yields the divided-difference
recursion simultaneously for all power moments. Only the new node
must be distinct in value from the existing nodes; old nodes may
coincide, and zero values are permitted. -/
theorem lagrange_power_moment_insert
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (t : ι)
    (ht : t ∉ s) (hsep : ∀ i ∈ s, a i ≠ a t)
    (n : ℕ) :
    (∑ i ∈ insert t s,
      (a i) ^ (n + 1) / (∏ j ∈ (insert t s).erase i, (a i - a j))) =
      a t * (∑ i ∈ insert t s,
        (a i) ^ n / (∏ j ∈ (insert t s).erase i, (a i - a j))) +
      (∑ i ∈ s,
        (a i) ^ n / (∏ j ∈ s.erase i, (a i - a j))) := by
  have haux :
      (∑ i ∈ insert t s,
        ((a i - a t) * (a i)^n) /
          (∏ j ∈ (insert t s).erase i, (a i - a j))) =
      ∑ i ∈ s,
        (a i)^n / (∏ j ∈ s.erase i, (a i - a j)) := by
    rw [Finset.sum_insert ht]
    simp only [sub_self, zero_mul, zero_div, zero_add]
    apply Finset.sum_congr rfl
    intro i hi
    rw [barycentric_denominator_insert s a t i ht hi]
    exact mul_div_mul_left (a i)^n
      (∏ j ∈ s.erase i, (a i - a j))
      (sub_ne_zero.mpr (hsep i hi))
  calc
    (∑ i ∈ insert t s,
      (a i) ^ (n + 1) / (∏ j ∈ (insert t s).erase i, (a i - a j))) =
      ∑ i ∈ insert t s,
        (a t * ((a i)^n / (∏ j ∈ (insert t s).erase i, (a i - a j))) +
        ((a i - a t) * (a i)^n) /
          (∏ j ∈ (insert t s).erase i, (a i - a j))) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [pow_succ]
      ring
    _ = a t * (∑ i ∈ insert t s,
        (a i)^n / (∏ j ∈ (insert t s).erase i, (a i - a j))) +
        (∑ i ∈ insert t s,
          ((a i - a t) * (a i)^n) /
            (∏ j ∈ (insert t s).erase i, (a i - a j))) := by
      rw [Finset.sum_add_distrib, Finset.mul_sum]
    _ = _ := by rw [haux]

end D1Bound5

#check @D1Bound5.barycentric_denominator_insert
#check @D1Bound5.lagrange_power_moment_insert
#print axioms D1Bound5.barycentric_denominator_insert
#print axioms D1Bound5.lagrange_power_moment_insert
