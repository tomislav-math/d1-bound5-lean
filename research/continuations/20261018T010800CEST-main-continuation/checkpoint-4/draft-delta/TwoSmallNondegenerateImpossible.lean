import D1Bound5.TwoSmallSextuple
import D1Bound5.TwoSmallFifthBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The nondegenerate exactly-two-small branch is impossible: its actual
finite extension graphs put the fifth modulus above 10^550, whereas the
actual analytic argument puts it strictly below the same bound. -/
theorem IsD1Tuple.two_small_nondegenerate_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hsmall : ‖phi (t 1 : K)‖ < 3)
    (hlarge : 3 ≤ ‖phi (t 2 : K)‖)
    (hnondeg : t 0*t 1+1 ≠ 0) : False := by
  have hlo := ht.two_small_fifth_large hK phi t hmon hsmall hlarge hnondeg
  have hhi := ht.two_small_fifth_lt hK phi t hmon hsmall hlarge
  exact lt_asymm hlo hhi

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.two_small_nondegenerate_impossible
