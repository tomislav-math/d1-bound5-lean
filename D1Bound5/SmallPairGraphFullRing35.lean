import D1Bound5.SmallPairGraphData35

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 35. -/
theorem smallPairGraph_35_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_35 smallPairB_35 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_35) (hneB : ∀ i, t i ≠ smallPairB_35) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_35*smallPairB_35+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_35 smallPairB_35
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_35 smallPairLarge_35
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_35_checked smallPairClosure_35_checked smallPairFilter_35_checked
    smallPairNoTriangle_35_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
