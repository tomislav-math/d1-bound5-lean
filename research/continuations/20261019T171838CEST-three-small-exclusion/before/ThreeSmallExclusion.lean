import D1Bound5.ThreeSmallFixedExtension
import D1Bound5.ThreeSmallSextuple

open scoped NumberField
open Module

namespace D1Bound5

/-- No ordered full-ring D(1) sextuple has three entries below three.
The finite closed-disk classification and both actual analytic branches
are joined here without any bounded-extension or approximation premise. -/
theorem IsD1Tuple.not_three_small
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hsmall : ‖phi (a 2 : K)‖ < 3) : False := by
  obtain ⟨hC,hT⟩ := ha.three_small_fifth_large hK phi a hmon hsmall
  rcases hT with hT | hT
  · exact ha.three_small_not_fixed_and_two_large hK phi a hmon hsmall hT hC.le
  · exact ha.three_small_not_three_large_extensions hK phi a hmon hsmall hT.le

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.not_three_small
