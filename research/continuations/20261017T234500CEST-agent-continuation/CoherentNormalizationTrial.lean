import D1Bound5.InterpolationWeights
import Mathlib.Analysis.Complex.Basic

open Finset

namespace D1Bound5

/-- Algebraic normalization of the paper's coherent form.  Here `g i`
denotes the product of the two analytic square-root factors and `q`
denotes the remaining square-root factor.  The result applies to any
nonzero choice of Vandermonde factor `Delta` and square-root scale `eta`.
No denominator at an individual anchor is cancelled in this proof. -/
theorem coherent_interpolation_normalization
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a g : ι → ℂ) (q Delta eta : ℂ)
    (hm : 2 ≤ s.card) (hDelta : Delta ≠ 0) (heta : eta ≠ 0) :
    (-Delta * (eta * q) +
      ∑ i ∈ s, (Delta * (a i) ^ (s.card - 2) /
        (∏ j ∈ s.erase i, (a i - a j))) * (a i * eta * g i)) /
      (Delta * eta) =
      (∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * g i) - q := by
  have hexp : s.card - 1 = (s.card - 2) + 1 := by omega
  have hsum :
      (∑ i ∈ s, (Delta * (a i) ^ (s.card - 2) /
        (∏ j ∈ s.erase i, (a i - a j))) * (a i * eta * g i)) =
      Delta * eta * ∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * g i := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    rw [hexp, pow_succ]
    ring
  rw [hsum]
  apply (div_eq_iff (mul_ne_zero hDelta heta)).2
  ring

end D1Bound5

#print axioms D1Bound5.coherent_interpolation_normalization
