import D1Bound5.OneSmallFirstPairReduction
import D1Bound5.OneSmallReducedImpossible

open scoped NumberField
open Module

namespace D1Bound5

/-- Complete actual one-small-entry branch: an ordered full-ring
sextuple cannot have first modulus below three and second modulus at
least three. Every analytic and finite-table input is constructed in
the preceding theorem chain. -/
theorem IsD1Tuple.not_one_small
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : ‖phi (a 0 : K)‖ < 3) (hB : 3 ≤ ‖phi (a 1 : K)‖) : False := by
  exact ha.one_small_reduced_impossible hK phi a hmon
    (ha.one_small_first_pair_size hK phi a hmon hA hB)

end D1Bound5
