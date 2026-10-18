import D1Bound5.SmallPairGraphData1
import D1Bound5.SmallPairGraphData2
import D1Bound5.SmallPairGraphData3
import D1Bound5.SmallPairGraphData4
import D1Bound5.SmallPairGraphData5
import D1Bound5.SmallPairGraphData6
import D1Bound5.SmallPairGraphData7
import D1Bound5.SmallPairGraphData8
import D1Bound5.SmallPairGraphData9
import D1Bound5.SmallPairGraphData10
import D1Bound5.SmallPairGraphData11
import D1Bound5.SmallPairGraphData12
import D1Bound5.SmallPairGraphData13
import D1Bound5.SmallPairGraphData14
import D1Bound5.SmallPairGraphData15
import D1Bound5.SmallPairGraphData16
import D1Bound5.SmallPairGraphData17
import D1Bound5.SmallPairGraphData18
import D1Bound5.SmallPairGraphData19
import D1Bound5.SmallPairGraphData20
import D1Bound5.SmallPairGraphData21
import D1Bound5.SmallPairGraphData22
import D1Bound5.SmallPairGraphData23
import D1Bound5.SmallPairGraphData24
import D1Bound5.SmallPairGraphData25
import D1Bound5.SmallPairGraphData26
import D1Bound5.SmallPairGraphData27
import D1Bound5.SmallPairGraphData28
import D1Bound5.SmallPairGraphData29
import D1Bound5.SmallPairGraphData30
import D1Bound5.SmallPairGraphData31
import D1Bound5.SmallPairGraphData32
import D1Bound5.SmallPairGraphData33
import D1Bound5.SmallPairGraphData34
import D1Bound5.SmallPairGraphData35
import D1Bound5.SmallPairGraphData36
import D1Bound5.SmallPairGraphData37
import D1Bound5.SmallPairGraphData38
import D1Bound5.SmallPairGraphData39
import D1Bound5.SmallPairGraphData40
import D1Bound5.SmallPairGraphData41
import D1Bound5.SmallPairGraphData42
import D1Bound5.SmallPairGraphData43
import D1Bound5.SmallPairGraphData44
import D1Bound5.SmallPairGraphData45
import D1Bound5.SmallPairGraphData46
import D1Bound5.SmallPairGraphData47
import D1Bound5.SmallPairGraphData48

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 1. -/
theorem smallPairGraph_1_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_1 smallPairB_1 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_1) (hneB : ∀ i, t i ≠ smallPairB_1) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_1*smallPairB_1+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_1 smallPairB_1
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_1 smallPairLarge_1
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_1_checked smallPairClosure_1_checked smallPairFilter_1_checked
    smallPairNoTriangle_1_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 2. -/
theorem smallPairGraph_2_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_2 smallPairB_2 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_2) (hneB : ∀ i, t i ≠ smallPairB_2) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_2*smallPairB_2+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_2 smallPairB_2
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_2 smallPairLarge_2
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_2_checked smallPairClosure_2_checked smallPairFilter_2_checked
    smallPairNoTriangle_2_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 3. -/
theorem smallPairGraph_3_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_3 smallPairB_3 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_3) (hneB : ∀ i, t i ≠ smallPairB_3) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_3*smallPairB_3+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_3 smallPairB_3
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_3 smallPairLarge_3
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_3_checked smallPairClosure_3_checked smallPairFilter_3_checked
    smallPairNoTriangle_3_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 4. -/
theorem smallPairGraph_4_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_4 smallPairB_4 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_4) (hneB : ∀ i, t i ≠ smallPairB_4) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_4*smallPairB_4+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_4 smallPairB_4
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_4 smallPairLarge_4
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_4_checked smallPairClosure_4_checked smallPairFilter_4_checked
    smallPairNoTriangle_4_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 5. -/
theorem smallPairGraph_5_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_5 smallPairB_5 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_5) (hneB : ∀ i, t i ≠ smallPairB_5) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_5*smallPairB_5+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_5 smallPairB_5
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_5 smallPairLarge_5
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_5_checked smallPairClosure_5_checked smallPairFilter_5_checked
    smallPairNoTriangle_5_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 6. -/
theorem smallPairGraph_6_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_6 smallPairB_6 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_6) (hneB : ∀ i, t i ≠ smallPairB_6) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_6*smallPairB_6+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_6 smallPairB_6
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_6 smallPairLarge_6
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_6_checked smallPairClosure_6_checked smallPairFilter_6_checked
    smallPairNoTriangle_6_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 7. -/
theorem smallPairGraph_7_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_7 smallPairB_7 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_7) (hneB : ∀ i, t i ≠ smallPairB_7) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_7*smallPairB_7+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_7 smallPairB_7
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_7 smallPairLarge_7
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_7_checked smallPairClosure_7_checked smallPairFilter_7_checked
    smallPairNoTriangle_7_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 8. -/
theorem smallPairGraph_8_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_8 smallPairB_8 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_8) (hneB : ∀ i, t i ≠ smallPairB_8) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_8*smallPairB_8+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_8 smallPairB_8
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_8 smallPairLarge_8
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_8_checked smallPairClosure_8_checked smallPairFilter_8_checked
    smallPairNoTriangle_8_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 9. -/
theorem smallPairGraph_9_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_9 smallPairB_9 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_9) (hneB : ∀ i, t i ≠ smallPairB_9) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_9*smallPairB_9+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_9 smallPairB_9
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_9 smallPairLarge_9
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_9_checked smallPairClosure_9_checked smallPairFilter_9_checked
    smallPairNoTriangle_9_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 10. -/
theorem smallPairGraph_10_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_10 smallPairB_10 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_10) (hneB : ∀ i, t i ≠ smallPairB_10) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_10*smallPairB_10+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_10 smallPairB_10
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_10 smallPairLarge_10
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_10_checked smallPairClosure_10_checked smallPairFilter_10_checked
    smallPairNoTriangle_10_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

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

/-- Complete large-extension triangle exclusion for pair-table row 12. -/
theorem smallPairGraph_12_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_12 smallPairB_12 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_12) (hneB : ∀ i, t i ≠ smallPairB_12) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_12*smallPairB_12+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_12 smallPairB_12
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_12 smallPairLarge_12
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_12_checked smallPairClosure_12_checked smallPairFilter_12_checked
    smallPairNoTriangle_12_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 13. -/
theorem smallPairGraph_13_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_13 smallPairB_13 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_13) (hneB : ∀ i, t i ≠ smallPairB_13) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_13*smallPairB_13+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_13 smallPairB_13
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_13 smallPairLarge_13
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_13_checked smallPairClosure_13_checked smallPairFilter_13_checked
    smallPairNoTriangle_13_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 14. -/
theorem smallPairGraph_14_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_14 smallPairB_14 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_14) (hneB : ∀ i, t i ≠ smallPairB_14) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_14*smallPairB_14+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_14 smallPairB_14
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_14 smallPairLarge_14
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_14_checked smallPairClosure_14_checked smallPairFilter_14_checked
    smallPairNoTriangle_14_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 15. -/
theorem smallPairGraph_15_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_15 smallPairB_15 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_15) (hneB : ∀ i, t i ≠ smallPairB_15) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_15*smallPairB_15+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_15 smallPairB_15
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_15 smallPairLarge_15
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_15_checked smallPairClosure_15_checked smallPairFilter_15_checked
    smallPairNoTriangle_15_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 16. -/
theorem smallPairGraph_16_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_16 smallPairB_16 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_16) (hneB : ∀ i, t i ≠ smallPairB_16) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_16*smallPairB_16+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_16 smallPairB_16
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_16 smallPairLarge_16
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_16_checked smallPairClosure_16_checked smallPairFilter_16_checked
    smallPairNoTriangle_16_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 17. -/
theorem smallPairGraph_17_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_17 smallPairB_17 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_17) (hneB : ∀ i, t i ≠ smallPairB_17) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_17*smallPairB_17+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_17 smallPairB_17
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_17 smallPairLarge_17
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_17_checked smallPairClosure_17_checked smallPairFilter_17_checked
    smallPairNoTriangle_17_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 18. -/
theorem smallPairGraph_18_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_18 smallPairB_18 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_18) (hneB : ∀ i, t i ≠ smallPairB_18) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_18*smallPairB_18+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_18 smallPairB_18
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_18 smallPairLarge_18
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_18_checked smallPairClosure_18_checked smallPairFilter_18_checked
    smallPairNoTriangle_18_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 19. -/
theorem smallPairGraph_19_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_19 smallPairB_19 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_19) (hneB : ∀ i, t i ≠ smallPairB_19) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_19*smallPairB_19+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_19 smallPairB_19
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_19 smallPairLarge_19
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_19_checked smallPairClosure_19_checked smallPairFilter_19_checked
    smallPairNoTriangle_19_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 20. -/
theorem smallPairGraph_20_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_20 smallPairB_20 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_20) (hneB : ∀ i, t i ≠ smallPairB_20) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_20*smallPairB_20+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_20 smallPairB_20
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_20 smallPairLarge_20
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_20_checked smallPairClosure_20_checked smallPairFilter_20_checked
    smallPairNoTriangle_20_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 21. -/
theorem smallPairGraph_21_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_21 smallPairB_21 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_21) (hneB : ∀ i, t i ≠ smallPairB_21) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_21*smallPairB_21+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_21 smallPairB_21
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_21 smallPairLarge_21
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_21_checked smallPairClosure_21_checked smallPairFilter_21_checked
    smallPairNoTriangle_21_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 22. -/
theorem smallPairGraph_22_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_22 smallPairB_22 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_22) (hneB : ∀ i, t i ≠ smallPairB_22) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_22*smallPairB_22+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_22 smallPairB_22
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_22 smallPairLarge_22
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_22_checked smallPairClosure_22_checked smallPairFilter_22_checked
    smallPairNoTriangle_22_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 23. -/
theorem smallPairGraph_23_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_23 smallPairB_23 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_23) (hneB : ∀ i, t i ≠ smallPairB_23) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_23*smallPairB_23+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_23 smallPairB_23
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_23 smallPairLarge_23
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_23_checked smallPairClosure_23_checked smallPairFilter_23_checked
    smallPairNoTriangle_23_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 24. -/
theorem smallPairGraph_24_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_24 smallPairB_24 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_24) (hneB : ∀ i, t i ≠ smallPairB_24) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_24*smallPairB_24+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_24 smallPairB_24
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_24 smallPairLarge_24
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_24_checked smallPairClosure_24_checked smallPairFilter_24_checked
    smallPairNoTriangle_24_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 25. -/
theorem smallPairGraph_25_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_25 smallPairB_25 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_25) (hneB : ∀ i, t i ≠ smallPairB_25) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_25*smallPairB_25+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_25 smallPairB_25
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_25 smallPairLarge_25
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_25_checked smallPairClosure_25_checked smallPairFilter_25_checked
    smallPairNoTriangle_25_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 26. -/
theorem smallPairGraph_26_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_26 smallPairB_26 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_26) (hneB : ∀ i, t i ≠ smallPairB_26) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_26*smallPairB_26+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_26 smallPairB_26
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_26 smallPairLarge_26
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_26_checked smallPairClosure_26_checked smallPairFilter_26_checked
    smallPairNoTriangle_26_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 27. -/
theorem smallPairGraph_27_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_27 smallPairB_27 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_27) (hneB : ∀ i, t i ≠ smallPairB_27) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_27*smallPairB_27+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_27 smallPairB_27
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_27 smallPairLarge_27
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_27_checked smallPairClosure_27_checked smallPairFilter_27_checked
    smallPairNoTriangle_27_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 28. -/
theorem smallPairGraph_28_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_28 smallPairB_28 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_28) (hneB : ∀ i, t i ≠ smallPairB_28) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_28*smallPairB_28+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_28 smallPairB_28
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_28 smallPairLarge_28
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_28_checked smallPairClosure_28_checked smallPairFilter_28_checked
    smallPairNoTriangle_28_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 29. -/
theorem smallPairGraph_29_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_29 smallPairB_29 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_29) (hneB : ∀ i, t i ≠ smallPairB_29) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_29*smallPairB_29+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_29 smallPairB_29
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_29 smallPairLarge_29
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_29_checked smallPairClosure_29_checked smallPairFilter_29_checked
    smallPairNoTriangle_29_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

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

/-- Complete large-extension triangle exclusion for pair-table row 32. -/
theorem smallPairGraph_32_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_32 smallPairB_32 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_32) (hneB : ∀ i, t i ≠ smallPairB_32) : False := by
  have hpos : 0 < discriminant 0 6 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_32*smallPairB_32+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_32 smallPairB_32
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_6 smallPairClosure_32 smallPairLarge_32
    smallPairSieve_0_6 smallPairSieve_0_6_valid ?_
    smallPairSeeds_32_checked smallPairClosure_32_checked smallPairFilter_32_checked
    smallPairNoTriangle_32_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_6_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 33. -/
theorem smallPairGraph_33_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_33 smallPairB_33 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_33) (hneB : ∀ i, t i ≠ smallPairB_33) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_33*smallPairB_33+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_33 smallPairB_33
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_33 smallPairLarge_33
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_33_checked smallPairClosure_33_checked smallPairFilter_33_checked
    smallPairNoTriangle_33_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 34. -/
theorem smallPairGraph_34_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_34 smallPairB_34 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_34) (hneB : ∀ i, t i ≠ smallPairB_34) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_34*smallPairB_34+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_34 smallPairB_34
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_34 smallPairLarge_34
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_34_checked smallPairClosure_34_checked smallPairFilter_34_checked
    smallPairNoTriangle_34_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

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

/-- Complete large-extension triangle exclusion for pair-table row 36. -/
theorem smallPairGraph_36_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_36 smallPairB_36 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_36) (hneB : ∀ i, t i ≠ smallPairB_36) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_36*smallPairB_36+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_36 smallPairB_36
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_36 smallPairLarge_36
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_36_checked smallPairClosure_36_checked smallPairFilter_36_checked
    smallPairNoTriangle_36_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 37. -/
theorem smallPairGraph_37_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_37 smallPairB_37 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_37) (hneB : ∀ i, t i ≠ smallPairB_37) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_37*smallPairB_37+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_37 smallPairB_37
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_37 smallPairLarge_37
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_37_checked smallPairClosure_37_checked smallPairFilter_37_checked
    smallPairNoTriangle_37_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 38. -/
theorem smallPairGraph_38_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_38 smallPairB_38 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_38) (hneB : ∀ i, t i ≠ smallPairB_38) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_38*smallPairB_38+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_38 smallPairB_38
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_38 smallPairLarge_38
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_38_checked smallPairClosure_38_checked smallPairFilter_38_checked
    smallPairNoTriangle_38_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 39. -/
theorem smallPairGraph_39_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_39 smallPairB_39 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_39) (hneB : ∀ i, t i ≠ smallPairB_39) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_39*smallPairB_39+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_39 smallPairB_39
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_39 smallPairLarge_39
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_39_checked smallPairClosure_39_checked smallPairFilter_39_checked
    smallPairNoTriangle_39_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 40. -/
theorem smallPairGraph_40_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_40 smallPairB_40 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_40) (hneB : ∀ i, t i ≠ smallPairB_40) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_40*smallPairB_40+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_40 smallPairB_40
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_40 smallPairLarge_40
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_40_checked smallPairClosure_40_checked smallPairFilter_40_checked
    smallPairNoTriangle_40_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 41. -/
theorem smallPairGraph_41_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_41 smallPairB_41 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_41) (hneB : ∀ i, t i ≠ smallPairB_41) : False := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_41*smallPairB_41+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_41 smallPairB_41
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_2 smallPairClosure_41 smallPairLarge_41
    smallPairSieve_1_2 smallPairSieve_1_2_valid ?_
    smallPairSeeds_41_checked smallPairClosure_41_checked smallPairFilter_41_checked
    smallPairNoTriangle_41_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 42. -/
theorem smallPairGraph_42_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 3)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_42 smallPairB_42 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_42) (hneB : ∀ i, t i ≠ smallPairB_42) : False := by
  have hpos : 0 < discriminant 1 3 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_42*smallPairB_42+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_42 smallPairB_42
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_3 smallPairClosure_42 smallPairLarge_42
    smallPairSieve_1_3 smallPairSieve_1_3_valid ?_
    smallPairSeeds_42_checked smallPairClosure_42_checked smallPairFilter_42_checked
    smallPairNoTriangle_42_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_3_eq, List.mem_toFinset] at hq
  exact hq

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

/-- Complete large-extension triangle exclusion for pair-table row 44. -/
theorem smallPairGraph_44_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 4)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_44 smallPairB_44 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_44) (hneB : ∀ i, t i ≠ smallPairB_44) : False := by
  have hpos : 0 < discriminant 1 4 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_44*smallPairB_44+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_44 smallPairB_44
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_4 smallPairClosure_44 smallPairLarge_44
    smallPairSieve_1_4 smallPairSieve_1_4_valid ?_
    smallPairSeeds_44_checked smallPairClosure_44_checked smallPairFilter_44_checked
    smallPairNoTriangle_44_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_4_eq, List.mem_toFinset] at hq
  exact hq

/-- Complete large-extension triangle exclusion for pair-table row 45. -/
theorem smallPairGraph_45_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 5)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_45 smallPairB_45 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_45) (hneB : ∀ i, t i ≠ smallPairB_45) : False := by
  have hpos : 0 < discriminant 1 5 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_45*smallPairB_45+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_45 smallPairB_45
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_5 smallPairClosure_45 smallPairLarge_45
    smallPairSieve_1_5 smallPairSieve_1_5_valid ?_
    smallPairSeeds_45_checked smallPairClosure_45_checked smallPairFilter_45_checked
    smallPairNoTriangle_45_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_5_eq, List.mem_toFinset] at hq
  exact hq

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

/-- Complete large-extension triangle exclusion for pair-table row 48. -/
theorem smallPairGraph_48_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 8)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_48 smallPairB_48 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_48) (hneB : ∀ i, t i ≠ smallPairB_48) : False := by
  have hpos : 0 < discriminant 1 8 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_48*smallPairB_48+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_48 smallPairB_48
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_8 smallPairClosure_48 smallPairLarge_48
    smallPairSieve_1_8 smallPairSieve_1_8_valid ?_
    smallPairSeeds_48_checked smallPairClosure_48_checked smallPairFilter_48_checked
    smallPairNoTriangle_48_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_8_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
