import D1Bound5.WeightedPoleFiniteTail
import Mathlib.Analysis.SpecificLimits.Normed

open Filter Finset

namespace D1Bound5

/-- The rational remainder in the finite weighted-pole Taylor formula tends
to zero on the common open convergence disk. The finite node set may be empty,
nodes may coincide, and weights may vanish. -/
theorem weighted_poles_tail_tendsto_zero
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a w : ι → ℂ) (z : ℂ)
    (hsmall : ∀ i ∈ s, ‖z‖ < ‖a i‖) :
    Tendsto
      (fun n : ℕ => z ^ n *
        (∑ i ∈ s, w i / ((a i) ^ n * (a i - z))))
      atTop (𝓝 (0 : ℂ)) := by
  have hterm (i : ι) (hi : i ∈ s) :
      Tendsto
        (fun n : ℕ => (z / a i) ^ n * (w i / (a i - z)))
        atTop (𝓝 (0 : ℂ)) := by
    have hpos : 0 < ‖a i‖ :=
      lt_of_le_of_lt (norm_nonneg z) (hsmall i hi)
    have hr : ‖z / a i‖ < 1 := by
      rw [norm_div]
      exact (div_lt_one hpos).2 (hsmall i hi)
    simpa using
      (tendsto_pow_atTop_nhds_zero_of_norm_lt_one hr).mul_const
        (w i / (a i - z))
  have hsum :
      Tendsto
        (fun n : ℕ => ∑ i ∈ s,
          (z / a i) ^ n * (w i / (a i - z)))
        atTop (𝓝 (0 : ℂ)) := by
    simpa using (tendsto_finsetSum s (fun i hi => hterm i hi))
  have heq (n : ℕ) :
      (∑ i ∈ s, (z / a i) ^ n * (w i / (a i - z))) =
      z ^ n * (∑ i ∈ s, w i / ((a i) ^ n * (a i - z))) := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    simp only [div_pow, div_eq_mul_inv, mul_inv_rev]
    ring
  convert hsum using 1
  funext n
  exact (heq n).symm

#print axioms D1Bound5.weighted_poles_tail_tendsto_zero
