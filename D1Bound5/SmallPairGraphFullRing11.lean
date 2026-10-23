import D1Bound5.SmallPairGraphData11

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 11. -/
theorem smallPairGraph_11_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_11 smallPairB_11 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_11) (hneB : ∀ i, t i ≠ smallPairB_11) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_11*smallPairB_11+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_11 smallPairB_11
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_11 smallPairLarge_11
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_11_checked smallPairClosure_11_checked smallPairFilter_11_checked
    smallPairNoTriangle_11_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
