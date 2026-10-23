import D1Bound5.SmallPairGraphData31

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 31. -/
theorem smallPairGraph_31_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 5)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_31 smallPairB_31 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_31) (hneB : ∀ i, t i ≠ smallPairB_31) : False := by
  have hpos : 0 < discriminant 0 5 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_31*smallPairB_31+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_31 smallPairB_31
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_5 smallPairClosure_31 smallPairLarge_31
    smallPairSieve_0_5 smallPairSieve_0_5_valid ?_
    smallPairSeeds_31_checked smallPairClosure_31_checked smallPairFilter_31_checked
    smallPairNoTriangle_31_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_5_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
