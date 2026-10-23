import D1Bound5.FirstPairThirdBound
import D1Bound5.RationalFirstPairThirdBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The complete third-entry bound after the five unbounded first-pair
regions have been removed. Rational and nonrational fields are covered. -/
theorem IsD1Tuple.one_small_reduced_third_lt_fifteen
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hsize :
      (‖phi (a 0 : K)‖^2=1 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<64) ∨
      (‖phi (a 0 : K)‖^2=2 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<16)) :
    ‖phi (a 2 : K)‖ < 15 := by
  obtain h | h | ⟨tau,nu,e,hmodel,hrow⟩ := full_first_pair_classification hK phi
    (a 0) (a 1) hsize (ha.2.2 0 1 (by decide))
  · exact IsD1Tuple.rational_first_pair_third_lt_fifteen hK phi a ha hmon false
      (by simpa using h.1) (by simpa using h.2)
  · exact IsD1Tuple.rational_first_pair_third_lt_fifteen hK phi a ha hmon true
      (by simpa using h.1) (by simpa using h.2)
  · exact IsD1Tuple.first_pair_third_lt_fifteen_of_table hK phi a ha hmon
      tau nu e hmodel hrow

end D1Bound5
