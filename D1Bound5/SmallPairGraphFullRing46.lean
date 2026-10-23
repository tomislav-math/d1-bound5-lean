import D1Bound5.SmallPairGraphData46

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 46. -/
theorem smallPairGraph_46_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_46 smallPairB_46 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_46) (hneB : ∀ i, t i ≠ smallPairB_46) : False := by
  have hpos : 0 < discriminant 1 6 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_46*smallPairB_46+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_46 smallPairB_46
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_6 smallPairClosure_46 smallPairLarge_46
    smallPairSieve_1_6 smallPairSieve_1_6_valid ?_
    smallPairSeeds_46_checked smallPairClosure_46_checked smallPairFilter_46_checked
    smallPairNoTriangle_46_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_6_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
