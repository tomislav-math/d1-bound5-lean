import Mathlib.RingTheory.Binomial
import Mathlib.Algebra.BigOperators.NatAntidiagonal
import D1Bound5.CoherentWeightedRemainder

open Finset

namespace D1Bound5

private noncomputable def hb (n : ℕ) : ℝ := Ring.choose (1 / 2 : ℝ) n

theorem half_binomial_choose_recurrence (n : ℕ) :
    (n + 1 : ℝ) * hb (n + 1) = hb n * ((1 / 2 : ℝ) - n) := by
  have h := Ring.choose_smul_choose (r := (1 / 2 : ℝ))
    (n := n + 1) (k := n) (Nat.le_succ n)
  simpa [hb, Nat.choose_succ_self_right, nsmul_eq_mul,
    Ring.choose_one_right] using h

theorem half_binomial_convolution_vanishes (n : ℕ) (hn : 2 ≤ n) :
    (∑ ij ∈ Finset.antidiagonal n,
        Ring.choose (1 / 2 : ℝ) ij.1 * Ring.choose (1 / 2 : ℝ) ij.2) = 0 := by
  have h := Ring.add_choose_eq
    (r := (1 / 2 : ℝ)) (s := (1 / 2 : ℝ)) n (Commute.all _ _)
  have hs : (1 / 2 : ℝ) + 1 / 2 = 1 := by ring
  rw [hs] at h
  have hz : Nat.choose 1 n = 0 := Nat.choose_eq_zero_of_lt (by omega)
  have hb0 : Ring.choose (1 : ℝ) n = 0 := by
    simpa [hz] using (Ring.choose_natCast (R := ℝ) 1 n)
  simpa [hb0] using h.symm

end D1Bound5

#check D1Bound5.half_binomial_choose_recurrence
#check D1Bound5.half_binomial_convolution_vanishes
#print axioms D1Bound5.half_binomial_choose_recurrence
#print axioms D1Bound5.half_binomial_convolution_vanishes
