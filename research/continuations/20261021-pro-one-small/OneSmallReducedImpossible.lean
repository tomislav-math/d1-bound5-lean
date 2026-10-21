import D1Bound5.OneSmallThirdBound
import D1Bound5.RationalFirstTriple
import D1Bound5.RationalTripleExclusion
import D1Bound5.OneSmallNormalizedImpossible

open scoped NumberField
open Module

namespace D1Bound5

/-- The entire finite first-pair remainder is impossible. This actual
full-ring theorem joins the complete first-pair/third-entry classification,
the analytic S<15 bound, all56 finite fourth complements and the universal
signed rational triple. Only the two remaining first-pair size cases occur
as hypotheses; there are no interval or table-certificate premises. -/
theorem IsD1Tuple.one_small_reduced_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hsize :
      (‖phi (a 0 : K)‖^2=1 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<64) ∨
      (‖phi (a 0 : K)‖^2=2 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<16)) : False := by
  have hS15 := IsD1Tuple.one_small_reduced_third_lt_fifteen hK phi a ha hmon hsize
  let ii : Fin 3 → Fin 6 := ![0,1,2]
  let t : Fin 3 → 𝓞 K := fun i => a (ii i)
  have hi : Function.Injective ii := by decide
  have ht : IsD1Tuple t :=
    ⟨ha.1.comp hi,fun j => ha.2.1 _,fun j k hjk => ha.2.2 _ _ (hi.ne hjk)⟩
  have hbound : ‖phi (a 2 : K)‖^2 < 225 := by
    nlinarith only [hS15,norm_nonneg (phi (a 2 : K))]
  have horder : ‖phi (a 1 : K)‖^2 ≤ ‖phi (a 2 : K)‖^2 := by
    gcongr
    exact hmon (by decide : (1 : Fin 6) ≤ 2)
  obtain h | h | ⟨tau,nu,e,hmodel,hrows⟩ :=
    IsD1Tuple.one_small_first_triple_classification hK phi t ht hsize hbound horder
  · have h0 : a 0 = if false then -1 else 1 := by simpa [t,ii] using h.1
    have h1 : a 1 = if false then -3 else 3 := by simpa [t,ii] using h.2
    have h2 := IsD1Tuple.rational_first_pair_third_eq_eight hK phi a ha hmon false h0 h1
    exact IsD1Tuple.not_rational_one_three_eight hK phi a ha hmon false h0 h1 h2
  · have h0 : a 0 = if true then -1 else 1 := by simpa [t,ii] using h.1
    have h1 : a 1 = if true then -3 else 3 := by simpa [t,ii] using h.2
    have h2 := IsD1Tuple.rational_first_pair_third_eq_eight hK phi a ha hmon true h0 h1
    exact IsD1Tuple.not_rational_one_three_eight hK phi a ha hmon true h0 h1 h2
  · exact IsD1Tuple.one_small_normalized_rows_impossible hK phi a ha hmon e hrows

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.one_small_reduced_impossible
