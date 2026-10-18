import D1Bound5.TwoSmallSextuple
import D1Bound5.TwoSmallLargeSBound
import D1Bound5.TwoSmallLargeTBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The exact finite graphs and actual analytic bounds together force
the remaining nondegenerate two-small branch into T<10^8<C.
The graph cutoff is 10^550, so both the 396 and 549 logarithmic bounds
give contradictions whenever their respective large-entry branch applies. -/
theorem IsD1Tuple.two_small_nondegenerate_reduced_range
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hsmall : ‖phi (t 1 : K)‖ < 3)
    (hlarge : 3 ≤ ‖phi (t 2 : K)‖)
    (hnondeg : t 0*t 1+1 ≠ 0) :
    ‖phi (t 3 : K)‖ < (10 : ℝ)^8 ∧
      (10 : ℝ)^550 < ‖phi (t 4 : K)‖ := by
  have hC := IsD1Tuple.two_small_fifth_large hK phi t ht hmon hsmall hlarge hnondeg
  have hCD := hmon (by decide : (4 : Fin 6) ≤ 5)
  have hS : ‖phi (t 2 : K)‖ < (10 : ℝ)^8 := by
    by_contra h
    have hD := (IsD1Tuple.two_small_large_third_bound hK phi t ht hmon hsmall
      (le_of_not_gt h)).2
    have hD' : ‖phi (t 5 : K)‖ < (10 : ℝ)^550 :=
      hD.trans_le (by norm_num)
    exact (not_lt_of_ge hCD) (hD'.trans hC)
  refine ⟨?_,hC⟩
  by_contra h
  have hD := (IsD1Tuple.two_small_fourth_bound hK phi t ht hmon hsmall hlarge hS).2
    (le_of_not_gt h)
  have hD' : ‖phi (t 5 : K)‖ < (10 : ℝ)^550 := hD.trans_le (by norm_num)
  exact (not_lt_of_ge hCD) (hD'.trans hC)

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.two_small_nondegenerate_reduced_range
