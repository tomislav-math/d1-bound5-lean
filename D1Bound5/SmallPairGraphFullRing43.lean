import D1Bound5.SmallPairGraphData43

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 43. -/
theorem smallPairGraph_43_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 3)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_43 smallPairB_43 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_43) (hneB : ∀ i, t i ≠ smallPairB_43) : False := by
  have hpos : 0 < discriminant 1 3 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_43*smallPairB_43+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_43 smallPairB_43
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_3 smallPairClosure_43 smallPairLarge_43
    smallPairSieve_1_3 smallPairSieve_1_3_valid ?_
    smallPairSeeds_43_checked smallPairClosure_43_checked smallPairFilter_43_checked
    smallPairNoTriangle_43_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_3_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
