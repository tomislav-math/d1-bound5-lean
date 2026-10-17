import Mathlib.LinearAlgebra.Lagrange
import Mathlib.RingTheory.Polynomial.Vieta

open Polynomial Finset

namespace D1Bound5

/-- The Lagrange power moments satisfy the characteristic equation
of the nodal polynomial at every order. This algebraic recurrence
holds even for repeated nodes, where division by zero has the
usual totalized field meaning. -/
theorem lagrange_power_moment_nodal_recurrence
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (n : ℕ) :
    (∑ j ∈ Finset.range (s.card + 1),
      (Lagrange.nodal s a).coeff j *
      (∑ i ∈ s, (a i) ^ (n + j) /
        (∏ t ∈ s.erase i, (a i - a t)))) = 0 := by
  let Q : F[X] := Lagrange.nodal s a
  have hd : Q.natDegree = s.card := Lagrange.natDegree_nodal
  calc
    (∑ j ∈ Finset.range (s.card + 1),
      Q.coeff j * (∑ i ∈ s, (a i) ^ (n + j) /
        (∏ t ∈ s.erase i, (a i - a t)))) =
      ∑ i ∈ s, ((a i) ^ n /
        (∏ t ∈ s.erase i, (a i - a t))) *
        (∑ j ∈ Finset.range (s.card + 1), Q.coeff j * (a i) ^ j) := by
          simp only [Finset.mul_sum]
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro i hi
          apply Finset.sum_congr rfl
          intro j hj
          simp only [pow_add, div_eq_mul_inv]
          ring
    _ = ∑ i ∈ s, ((a i) ^ n /
        (∏ t ∈ s.erase i, (a i - a t))) * Q.eval (a i) := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [Polynomial.eval_eq_sum_range, hd]
    _ = 0 := by
          apply Finset.sum_eq_zero
          intro i hi
          rw [Lagrange.eval_nodal_at_node hi]
          ring

/-- Equivalently, the moments obey a monic recurrence of order equal
to the number of interpolation nodes. It is valid at all orders. -/
theorem lagrange_power_moment_monic_recurrence
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (n : ℕ) :
    (∑ i ∈ s, (a i) ^ (n + s.card) /
      (∏ t ∈ s.erase i, (a i - a t))) =
      -∑ j ∈ Finset.range s.card,
        (Lagrange.nodal s a).coeff j *
          (∑ i ∈ s, (a i) ^ (n + j) /
            (∏ t ∈ s.erase i, (a i - a t))) := by
  have htop : (Lagrange.nodal s a).coeff s.card = 1 := by
    have hdeg : (Lagrange.nodal s a).natDegree = s.card :=
      Lagrange.natDegree_nodal
    simpa [hdeg] using
      (Lagrange.nodal_monic (s := s) (v := a)).coeff_natDegree
  have hrec := lagrange_power_moment_nodal_recurrence s a n
  rw [Finset.sum_range_succ, htop, one_mul] at hrec
  exact eq_neg_of_add_eq_zero_right hrec

end D1Bound5

#check @D1Bound5.lagrange_power_moment_nodal_recurrence
#check @D1Bound5.lagrange_power_moment_monic_recurrence
#print axioms D1Bound5.lagrange_power_moment_nodal_recurrence
#print axioms D1Bound5.lagrange_power_moment_monic_recurrence
