import D1Bound5.SmallPairGraphData30

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 30. -/
theorem smallPairGraph_30_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_30 smallPairB_30 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_30) (hneB : ∀ i, t i ≠ smallPairB_30) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_30*smallPairB_30+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_30 smallPairB_30
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_30 smallPairLarge_30
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_30_checked smallPairClosure_30_checked smallPairFilter_30_checked
    smallPairNoTriangle_30_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
