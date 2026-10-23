import D1Bound5.MainTheorem
import Lean.Util.CollectAxioms
import Lean.Elab.Command

open scoped NumberField Classical
open Module
set_option autoImplicit false
universe u
namespace D1Bound5
open QuadInt

-- Original full-ring transfer declarations, moved without changing any theorem body.
example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_1 smallPairB_1 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_1) (hneB : ∀ i, t i ≠ smallPairB_1), False := @_root_.D1Bound5.smallPairGraph_1_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_2 smallPairB_2 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_2) (hneB : ∀ i, t i ≠ smallPairB_2), False := @_root_.D1Bound5.smallPairGraph_2_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_3 smallPairB_3 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_3) (hneB : ∀ i, t i ≠ smallPairB_3), False := @_root_.D1Bound5.smallPairGraph_3_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_4 smallPairB_4 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_4) (hneB : ∀ i, t i ≠ smallPairB_4), False := @_root_.D1Bound5.smallPairGraph_4_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_5 smallPairB_5 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_5) (hneB : ∀ i, t i ≠ smallPairB_5), False := @_root_.D1Bound5.smallPairGraph_5_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_6 smallPairB_6 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_6) (hneB : ∀ i, t i ≠ smallPairB_6), False := @_root_.D1Bound5.smallPairGraph_6_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_7 smallPairB_7 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_7) (hneB : ∀ i, t i ≠ smallPairB_7), False := @_root_.D1Bound5.smallPairGraph_7_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_8 smallPairB_8 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_8) (hneB : ∀ i, t i ≠ smallPairB_8), False := @_root_.D1Bound5.smallPairGraph_8_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_9 smallPairB_9 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_9) (hneB : ∀ i, t i ≠ smallPairB_9), False := @_root_.D1Bound5.smallPairGraph_9_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_10 smallPairB_10 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_10) (hneB : ∀ i, t i ≠ smallPairB_10), False := @_root_.D1Bound5.smallPairGraph_10_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_11 smallPairB_11 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_11) (hneB : ∀ i, t i ≠ smallPairB_11), False := @_root_.D1Bound5.smallPairGraph_11_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_12 smallPairB_12 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_12) (hneB : ∀ i, t i ≠ smallPairB_12), False := @_root_.D1Bound5.smallPairGraph_12_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_13 smallPairB_13 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_13) (hneB : ∀ i, t i ≠ smallPairB_13), False := @_root_.D1Bound5.smallPairGraph_13_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_14 smallPairB_14 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_14) (hneB : ∀ i, t i ≠ smallPairB_14), False := @_root_.D1Bound5.smallPairGraph_14_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_15 smallPairB_15 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_15) (hneB : ∀ i, t i ≠ smallPairB_15), False := @_root_.D1Bound5.smallPairGraph_15_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_16 smallPairB_16 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_16) (hneB : ∀ i, t i ≠ smallPairB_16), False := @_root_.D1Bound5.smallPairGraph_16_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_17 smallPairB_17 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_17) (hneB : ∀ i, t i ≠ smallPairB_17), False := @_root_.D1Bound5.smallPairGraph_17_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_18 smallPairB_18 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_18) (hneB : ∀ i, t i ≠ smallPairB_18), False := @_root_.D1Bound5.smallPairGraph_18_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_19 smallPairB_19 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_19) (hneB : ∀ i, t i ≠ smallPairB_19), False := @_root_.D1Bound5.smallPairGraph_19_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_20 smallPairB_20 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_20) (hneB : ∀ i, t i ≠ smallPairB_20), False := @_root_.D1Bound5.smallPairGraph_20_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_21 smallPairB_21 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_21) (hneB : ∀ i, t i ≠ smallPairB_21), False := @_root_.D1Bound5.smallPairGraph_21_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_22 smallPairB_22 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_22) (hneB : ∀ i, t i ≠ smallPairB_22), False := @_root_.D1Bound5.smallPairGraph_22_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_23 smallPairB_23 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_23) (hneB : ∀ i, t i ≠ smallPairB_23), False := @_root_.D1Bound5.smallPairGraph_23_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_24 smallPairB_24 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_24) (hneB : ∀ i, t i ≠ smallPairB_24), False := @_root_.D1Bound5.smallPairGraph_24_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_25 smallPairB_25 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_25) (hneB : ∀ i, t i ≠ smallPairB_25), False := @_root_.D1Bound5.smallPairGraph_25_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_26 smallPairB_26 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_26) (hneB : ∀ i, t i ≠ smallPairB_26), False := @_root_.D1Bound5.smallPairGraph_26_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_27 smallPairB_27 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_27) (hneB : ∀ i, t i ≠ smallPairB_27), False := @_root_.D1Bound5.smallPairGraph_27_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_28 smallPairB_28 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_28) (hneB : ∀ i, t i ≠ smallPairB_28), False := @_root_.D1Bound5.smallPairGraph_28_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_29 smallPairB_29 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_29) (hneB : ∀ i, t i ≠ smallPairB_29), False := @_root_.D1Bound5.smallPairGraph_29_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_30 smallPairB_30 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_30) (hneB : ∀ i, t i ≠ smallPairB_30), False := @_root_.D1Bound5.smallPairGraph_30_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 5)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_31 smallPairB_31 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_31) (hneB : ∀ i, t i ≠ smallPairB_31), False := @_root_.D1Bound5.smallPairGraph_31_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_32 smallPairB_32 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_32) (hneB : ∀ i, t i ≠ smallPairB_32), False := @_root_.D1Bound5.smallPairGraph_32_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_33 smallPairB_33 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_33) (hneB : ∀ i, t i ≠ smallPairB_33), False := @_root_.D1Bound5.smallPairGraph_33_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_34 smallPairB_34 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_34) (hneB : ∀ i, t i ≠ smallPairB_34), False := @_root_.D1Bound5.smallPairGraph_34_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_35 smallPairB_35 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_35) (hneB : ∀ i, t i ≠ smallPairB_35), False := @_root_.D1Bound5.smallPairGraph_35_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_36 smallPairB_36 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_36) (hneB : ∀ i, t i ≠ smallPairB_36), False := @_root_.D1Bound5.smallPairGraph_36_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_37 smallPairB_37 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_37) (hneB : ∀ i, t i ≠ smallPairB_37), False := @_root_.D1Bound5.smallPairGraph_37_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_38 smallPairB_38 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_38) (hneB : ∀ i, t i ≠ smallPairB_38), False := @_root_.D1Bound5.smallPairGraph_38_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_39 smallPairB_39 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_39) (hneB : ∀ i, t i ≠ smallPairB_39), False := @_root_.D1Bound5.smallPairGraph_39_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_40 smallPairB_40 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_40) (hneB : ∀ i, t i ≠ smallPairB_40), False := @_root_.D1Bound5.smallPairGraph_40_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_41 smallPairB_41 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_41) (hneB : ∀ i, t i ≠ smallPairB_41), False := @_root_.D1Bound5.smallPairGraph_41_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 3)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_42 smallPairB_42 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_42) (hneB : ∀ i, t i ≠ smallPairB_42), False := @_root_.D1Bound5.smallPairGraph_42_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 3)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_43 smallPairB_43 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_43) (hneB : ∀ i, t i ≠ smallPairB_43), False := @_root_.D1Bound5.smallPairGraph_43_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 4)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_44 smallPairB_44 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_44) (hneB : ∀ i, t i ≠ smallPairB_44), False := @_root_.D1Bound5.smallPairGraph_44_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 5)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_45 smallPairB_45 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_45) (hneB : ∀ i, t i ≠ smallPairB_45), False := @_root_.D1Bound5.smallPairGraph_45_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_46 smallPairB_46 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_46) (hneB : ∀ i, t i ≠ smallPairB_46), False := @_root_.D1Bound5.smallPairGraph_46_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_47 smallPairB_47 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_47) (hneB : ∀ i, t i ≠ smallPairB_47), False := @_root_.D1Bound5.smallPairGraph_47_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 8)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_48 smallPairB_48 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_48) (hneB : ∀ i, t i ≠ smallPairB_48), False := @_root_.D1Bound5.smallPairGraph_48_excludes_three_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_1,smallPairB_1} := @_root_.D1Bound5.smallPairRepresentative_1_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_2,smallPairB_2} := @_root_.D1Bound5.smallPairRepresentative_2_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_3,smallPairB_3} := @_root_.D1Bound5.smallPairRepresentative_3_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_4,smallPairB_4} := @_root_.D1Bound5.smallPairRepresentative_4_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_5,smallPairB_5} := @_root_.D1Bound5.smallPairRepresentative_5_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_6,smallPairB_6} := @_root_.D1Bound5.smallPairRepresentative_6_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_7,smallPairB_7} := @_root_.D1Bound5.smallPairRepresentative_7_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_8,smallPairB_8} := @_root_.D1Bound5.smallPairRepresentative_8_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_9,smallPairB_9} := @_root_.D1Bound5.smallPairRepresentative_9_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_10,smallPairB_10} := @_root_.D1Bound5.smallPairRepresentative_10_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_11,smallPairB_11} := @_root_.D1Bound5.smallPairRepresentative_11_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_12,smallPairB_12} := @_root_.D1Bound5.smallPairRepresentative_12_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_13,smallPairB_13} := @_root_.D1Bound5.smallPairRepresentative_13_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_14,smallPairB_14} := @_root_.D1Bound5.smallPairRepresentative_14_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_15,smallPairB_15} := @_root_.D1Bound5.smallPairRepresentative_15_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_16,smallPairB_16} := @_root_.D1Bound5.smallPairRepresentative_16_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_17,smallPairB_17} := @_root_.D1Bound5.smallPairRepresentative_17_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_18,smallPairB_18} := @_root_.D1Bound5.smallPairRepresentative_18_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_19,smallPairB_19} := @_root_.D1Bound5.smallPairRepresentative_19_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_20,smallPairB_20} := @_root_.D1Bound5.smallPairRepresentative_20_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_21,smallPairB_21} := @_root_.D1Bound5.smallPairRepresentative_21_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_22,smallPairB_22} := @_root_.D1Bound5.smallPairRepresentative_22_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_23,smallPairB_23} := @_root_.D1Bound5.smallPairRepresentative_23_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_24,smallPairB_24} := @_root_.D1Bound5.smallPairRepresentative_24_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_25,smallPairB_25} := @_root_.D1Bound5.smallPairRepresentative_25_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_26,smallPairB_26} := @_root_.D1Bound5.smallPairRepresentative_26_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_27,smallPairB_27} := @_root_.D1Bound5.smallPairRepresentative_27_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_28,smallPairB_28} := @_root_.D1Bound5.smallPairRepresentative_28_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_29,smallPairB_29} := @_root_.D1Bound5.smallPairRepresentative_29_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_30,smallPairB_30} := @_root_.D1Bound5.smallPairRepresentative_30_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_31,smallPairB_31} := @_root_.D1Bound5.smallPairRepresentative_31_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_32,smallPairB_32} := @_root_.D1Bound5.smallPairRepresentative_32_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_33,smallPairB_33} := @_root_.D1Bound5.smallPairRepresentative_33_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_34,smallPairB_34} := @_root_.D1Bound5.smallPairRepresentative_34_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_35,smallPairB_35} := @_root_.D1Bound5.smallPairRepresentative_35_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_36,smallPairB_36} := @_root_.D1Bound5.smallPairRepresentative_36_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_37,smallPairB_37} := @_root_.D1Bound5.smallPairRepresentative_37_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_38,smallPairB_38} := @_root_.D1Bound5.smallPairRepresentative_38_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_39,smallPairB_39} := @_root_.D1Bound5.smallPairRepresentative_39_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_40,smallPairB_40} := @_root_.D1Bound5.smallPairRepresentative_40_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_41,smallPairB_41} := @_root_.D1Bound5.smallPairRepresentative_41_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_42,smallPairB_42} := @_root_.D1Bound5.smallPairRepresentative_42_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_43,smallPairB_43} := @_root_.D1Bound5.smallPairRepresentative_43_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_44,smallPairB_44} := @_root_.D1Bound5.smallPairRepresentative_44_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_45,smallPairB_45} := @_root_.D1Bound5.smallPairRepresentative_45_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_46,smallPairB_46} := @_root_.D1Bound5.smallPairRepresentative_46_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_47,smallPairB_47} := @_root_.D1Bound5.smallPairRepresentative_47_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K), SmallPairGraphProperty {smallPairA_48,smallPairB_48} := @_root_.D1Bound5.smallPairRepresentative_48_graph_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 1), SmallPairGraphProperty (smallCoordinateSet 0 1 row) := @_root_.D1Bound5.smallPairTable_0_1_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 2), SmallPairGraphProperty (smallCoordinateSet 0 2 row) := @_root_.D1Bound5.smallPairTable_0_2_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 5 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 5), SmallPairGraphProperty (smallCoordinateSet 0 5 row) := @_root_.D1Bound5.smallPairTable_0_5_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 0 6), SmallPairGraphProperty (smallCoordinateSet 0 6 row) := @_root_.D1Bound5.smallPairTable_0_6_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 1), SmallPairGraphProperty (smallCoordinateSet 1 1 row) := @_root_.D1Bound5.smallPairTable_1_1_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 2), SmallPairGraphProperty (smallCoordinateSet 1 2 row) := @_root_.D1Bound5.smallPairTable_1_2_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 3), SmallPairGraphProperty (smallCoordinateSet 1 3 row) := @_root_.D1Bound5.smallPairTable_1_3_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 4 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 4), SmallPairGraphProperty (smallCoordinateSet 1 4 row) := @_root_.D1Bound5.smallPairTable_1_4_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 5), SmallPairGraphProperty (smallCoordinateSet 1 5 row) := @_root_.D1Bound5.smallPairTable_1_5_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 6 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 6), SmallPairGraphProperty (smallCoordinateSet 1 6 row) := @_root_.D1Bound5.smallPairTable_1_6_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable 1 8), SmallPairGraphProperty (smallCoordinateSet 1 8 row) := @_root_.D1Bound5.smallPairTable_1_8_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau,nu) ∈ smallPairModels)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable tau nu), SmallPairGraphProperty (smallCoordinateSet tau nu row) := @_root_.D1Bound5.smallPairTable_graph_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 2 → 𝓞 K) (ha : IsD1Tuple a)
    (hsmall : ∀ i, ‖phi (a i : K)‖ < 3)
    (hnondeg : a 0*a 1+1 ≠ 0)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hproper : ∀ i, ProperCommonExtension {a 0,a 1} (t i))
    (hlarge : ∀ i, 3 ≤ ‖phi (t i : K)‖)
    (hbound : ∀ i, ‖phi (t i : K)‖^2 ≤ (10 : ℝ)^1100), False := @_root_.D1Bound5.IsD1Tuple.small_pair_excludes_three_bounded

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 2 → 𝓞 K) (ha : IsD1Tuple a)
    (hsmall : ∀ i, ‖phi (a i : K)‖ < 3)
    (hnondeg : a 0*a 1+1 ≠ 0)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hproper : ∀ i, ProperCommonExtension {a 0,a 1} (t i))
    (hlarge : ∀ i, 3 ≤ ‖phi (t i : K)‖)
    (hbound : ∀ i, ‖phi (t i : K)‖ ≤ (10 : ℝ)^550), False := @_root_.D1Bound5.IsD1Tuple.small_pair_excludes_three_in_disk

example : ∀ {R : Type*} [CommRing R] [DecidableEq R]
    (t : Fin 6 → R) (ht : IsD1Tuple t) (j : Fin 6) (hj : 2 ≤ j), ProperCommonExtension {t 0,t 1} (t j) := @_root_.D1Bound5.IsD1Tuple.properCommonExtension_first_two

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hsmall : ‖phi (t 1 : K)‖ < 3)
    (hlarge : 3 ≤ ‖phi (t 2 : K)‖)
    (hnondeg : t 0*t 1+1 ≠ 0), (10 : ℝ)^550 < ‖phi (t 4 : K)‖ := @_root_.D1Bound5.IsD1Tuple.two_small_fifth_large

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hsmall : ‖phi (t 1 : K)‖ < 3)
    (hlarge : 3 ≤ ‖phi (t 2 : K)‖)
    (hnondeg : t 0*t 1+1 ≠ 0), False := @_root_.D1Bound5.IsD1Tuple.two_small_nondegenerate_impossible

example : MainStatement.{u} := @_root_.D1Bound5.main_statement

-- Independently spell out the requested proposition, including the full ring,
-- distinct nonzero elements, and a square root that is allowed to be zero.
example : ∀ (K : Type u) [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K], Module.finrank ℚ K = 2 →
    ∀ A : Finset (𝓞 K),
      ((∀ x ∈ A, x ≠ 0) ∧
        ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∃ r : 𝓞 K, r * r = x * y + 1) →
      A.card ≤ 5 := @_root_.D1Bound5.main_statement

end D1Bound5

run_cmd do
  for name in ([`D1Bound5.smallPairGraph_1_excludes_three_full_ring, `D1Bound5.smallPairGraph_2_excludes_three_full_ring, `D1Bound5.smallPairGraph_3_excludes_three_full_ring, `D1Bound5.smallPairGraph_4_excludes_three_full_ring, `D1Bound5.smallPairGraph_5_excludes_three_full_ring, `D1Bound5.smallPairGraph_6_excludes_three_full_ring, `D1Bound5.smallPairGraph_7_excludes_three_full_ring, `D1Bound5.smallPairGraph_8_excludes_three_full_ring, `D1Bound5.smallPairGraph_9_excludes_three_full_ring, `D1Bound5.smallPairGraph_10_excludes_three_full_ring, `D1Bound5.smallPairGraph_11_excludes_three_full_ring, `D1Bound5.smallPairGraph_12_excludes_three_full_ring, `D1Bound5.smallPairGraph_13_excludes_three_full_ring, `D1Bound5.smallPairGraph_14_excludes_three_full_ring, `D1Bound5.smallPairGraph_15_excludes_three_full_ring, `D1Bound5.smallPairGraph_16_excludes_three_full_ring, `D1Bound5.smallPairGraph_17_excludes_three_full_ring, `D1Bound5.smallPairGraph_18_excludes_three_full_ring, `D1Bound5.smallPairGraph_19_excludes_three_full_ring, `D1Bound5.smallPairGraph_20_excludes_three_full_ring, `D1Bound5.smallPairGraph_21_excludes_three_full_ring, `D1Bound5.smallPairGraph_22_excludes_three_full_ring, `D1Bound5.smallPairGraph_23_excludes_three_full_ring, `D1Bound5.smallPairGraph_24_excludes_three_full_ring, `D1Bound5.smallPairGraph_25_excludes_three_full_ring, `D1Bound5.smallPairGraph_26_excludes_three_full_ring, `D1Bound5.smallPairGraph_27_excludes_three_full_ring, `D1Bound5.smallPairGraph_28_excludes_three_full_ring, `D1Bound5.smallPairGraph_29_excludes_three_full_ring, `D1Bound5.smallPairGraph_30_excludes_three_full_ring, `D1Bound5.smallPairGraph_31_excludes_three_full_ring, `D1Bound5.smallPairGraph_32_excludes_three_full_ring, `D1Bound5.smallPairGraph_33_excludes_three_full_ring, `D1Bound5.smallPairGraph_34_excludes_three_full_ring, `D1Bound5.smallPairGraph_35_excludes_three_full_ring, `D1Bound5.smallPairGraph_36_excludes_three_full_ring, `D1Bound5.smallPairGraph_37_excludes_three_full_ring, `D1Bound5.smallPairGraph_38_excludes_three_full_ring, `D1Bound5.smallPairGraph_39_excludes_three_full_ring, `D1Bound5.smallPairGraph_40_excludes_three_full_ring, `D1Bound5.smallPairGraph_41_excludes_three_full_ring, `D1Bound5.smallPairGraph_42_excludes_three_full_ring, `D1Bound5.smallPairGraph_43_excludes_three_full_ring, `D1Bound5.smallPairGraph_44_excludes_three_full_ring, `D1Bound5.smallPairGraph_45_excludes_three_full_ring, `D1Bound5.smallPairGraph_46_excludes_three_full_ring, `D1Bound5.smallPairGraph_47_excludes_three_full_ring, `D1Bound5.smallPairGraph_48_excludes_three_full_ring, `D1Bound5.smallPairRepresentative_1_graph_property, `D1Bound5.smallPairRepresentative_2_graph_property, `D1Bound5.smallPairRepresentative_3_graph_property, `D1Bound5.smallPairRepresentative_4_graph_property, `D1Bound5.smallPairRepresentative_5_graph_property, `D1Bound5.smallPairRepresentative_6_graph_property, `D1Bound5.smallPairRepresentative_7_graph_property, `D1Bound5.smallPairRepresentative_8_graph_property, `D1Bound5.smallPairRepresentative_9_graph_property, `D1Bound5.smallPairRepresentative_10_graph_property, `D1Bound5.smallPairRepresentative_11_graph_property, `D1Bound5.smallPairRepresentative_12_graph_property, `D1Bound5.smallPairRepresentative_13_graph_property, `D1Bound5.smallPairRepresentative_14_graph_property, `D1Bound5.smallPairRepresentative_15_graph_property, `D1Bound5.smallPairRepresentative_16_graph_property, `D1Bound5.smallPairRepresentative_17_graph_property, `D1Bound5.smallPairRepresentative_18_graph_property, `D1Bound5.smallPairRepresentative_19_graph_property, `D1Bound5.smallPairRepresentative_20_graph_property, `D1Bound5.smallPairRepresentative_21_graph_property, `D1Bound5.smallPairRepresentative_22_graph_property, `D1Bound5.smallPairRepresentative_23_graph_property, `D1Bound5.smallPairRepresentative_24_graph_property, `D1Bound5.smallPairRepresentative_25_graph_property, `D1Bound5.smallPairRepresentative_26_graph_property, `D1Bound5.smallPairRepresentative_27_graph_property, `D1Bound5.smallPairRepresentative_28_graph_property, `D1Bound5.smallPairRepresentative_29_graph_property, `D1Bound5.smallPairRepresentative_30_graph_property, `D1Bound5.smallPairRepresentative_31_graph_property, `D1Bound5.smallPairRepresentative_32_graph_property, `D1Bound5.smallPairRepresentative_33_graph_property, `D1Bound5.smallPairRepresentative_34_graph_property, `D1Bound5.smallPairRepresentative_35_graph_property, `D1Bound5.smallPairRepresentative_36_graph_property, `D1Bound5.smallPairRepresentative_37_graph_property, `D1Bound5.smallPairRepresentative_38_graph_property, `D1Bound5.smallPairRepresentative_39_graph_property, `D1Bound5.smallPairRepresentative_40_graph_property, `D1Bound5.smallPairRepresentative_41_graph_property, `D1Bound5.smallPairRepresentative_42_graph_property, `D1Bound5.smallPairRepresentative_43_graph_property, `D1Bound5.smallPairRepresentative_44_graph_property, `D1Bound5.smallPairRepresentative_45_graph_property, `D1Bound5.smallPairRepresentative_46_graph_property, `D1Bound5.smallPairRepresentative_47_graph_property, `D1Bound5.smallPairRepresentative_48_graph_property, `D1Bound5.smallPairTable_0_1_graph_property_full_ring, `D1Bound5.smallPairTable_0_2_graph_property_full_ring, `D1Bound5.smallPairTable_0_5_graph_property_full_ring, `D1Bound5.smallPairTable_0_6_graph_property_full_ring, `D1Bound5.smallPairTable_1_1_graph_property_full_ring, `D1Bound5.smallPairTable_1_2_graph_property_full_ring, `D1Bound5.smallPairTable_1_3_graph_property_full_ring, `D1Bound5.smallPairTable_1_4_graph_property_full_ring, `D1Bound5.smallPairTable_1_5_graph_property_full_ring, `D1Bound5.smallPairTable_1_6_graph_property_full_ring, `D1Bound5.smallPairTable_1_8_graph_property_full_ring, `D1Bound5.smallPairTable_graph_property_full_ring, `D1Bound5.IsD1Tuple.small_pair_excludes_three_bounded, `D1Bound5.IsD1Tuple.small_pair_excludes_three_in_disk, `D1Bound5.IsD1Tuple.properCommonExtension_first_two, `D1Bound5.IsD1Tuple.two_small_fifth_large, `D1Bound5.IsD1Tuple.two_small_nondegenerate_impossible, `D1Bound5.main_statement] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"ORIGINAL_TYPE_AXIOMS_PASS {name}: {ax}"

#print D1Bound5.MainStatement
#print D1Bound5.main_statement
#print axioms D1Bound5.main_statement
