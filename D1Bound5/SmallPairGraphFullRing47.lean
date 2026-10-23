import D1Bound5.SmallPairGraphData47

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 47. -/
theorem smallPairGraph_47_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_47 smallPairB_47 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_47) (hneB : ∀ i, t i ≠ smallPairB_47) : False := by
  have hpos : 0 < discriminant 1 6 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_47*smallPairB_47+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_47 smallPairB_47
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_6 smallPairClosure_47 smallPairLarge_47
    smallPairSieve_1_6 smallPairSieve_1_6_valid ?_
    smallPairSeeds_47_checked smallPairClosure_47_checked smallPairFilter_47_checked
    smallPairNoTriangle_47_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_6_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
