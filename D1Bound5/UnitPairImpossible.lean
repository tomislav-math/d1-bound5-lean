import D1Bound5.UnitPairFiniteReduction
import D1Bound5.TwoSmallFifthBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual ordered {-1,1} sextuple is impossible in every imaginary
quadratic full integer ring. The one fixed field parameter and complete
norm-two Pell graph force C>10^550, and the analytic two-small argument
forces C<10^550. No field, Pell list, or analytic estimate is assumed. -/
theorem IsD1Tuple.unit_pair_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) : False := by
  have hS := ht.unit_pair_third_norm_ge_eight hK phi t hm hp hmon
  have hB3 : ‖phi (t 1 : K)‖ < 3 := by norm_num [hp]
  have hS3 : 3 ≤ ‖phi (t 2 : K)‖ := by linarith only [hS]
  have hlo := ht.unit_pair_fifth_large hK phi t hm hp hmon
  have hhi := ht.two_small_fifth_lt hK phi t hmon hB3 hS3
  exact lt_asymm hlo hhi

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.unit_pair_impossible
