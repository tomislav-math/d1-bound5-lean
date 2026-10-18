import D1Bound5.TwoSmallOrdinaryHeight
import D1Bound5.FourAnchorVWindow
import D1Bound5.CrossBlockTuple
import D1Bound5.FrontierLargeTuple
import D1Bound5.MixedProductFourGrowth

open scoped NumberField
open Module

namespace D1Bound5

theorem IsD1Tuple.comp_injective_map
    {R : Type*} [CommRing R] {n m : ℕ} (a : Fin n → R)
    (ha : IsD1Tuple a) (e : Fin m → Fin n) (he : Function.Injective e) :
    IsD1Tuple (fun i => a (e i)) :=
  ⟨ha.1.comp he,fun i => ha.2.1 (e i),fun i j hij => ha.2.2 (e i) (e j) (he.ne hij)⟩

/-- The determinant growth inputs for the two-small cutoff, with roots
and all subtuple restrictions obtained from the sextuple itself. -/
theorem IsD1Tuple.two_small_growth_inputs
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : 3 ≤ ‖phi (a 2 : K)‖) :
    (3/8 : ℝ)*‖phi (a 0 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ < ‖phi (a 4 : K)‖ ∧
    2*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖*‖phi (a 4 : K)‖ < ‖phi (a 5 : K)‖ ∧
    (9 ≤ ‖phi (a 0 : K)‖*‖phi (a 3 : K)‖ →
      ‖phi (a 0 : K)‖^3*‖phi (a 1 : K)‖*‖phi (a 3 : K)‖^3*‖phi (a 4 : K)‖/
        (7*‖phi (a 2 : K)‖) < ‖phi (a 5 : K)‖) := by
  let b : Fin 4 → 𝓞 K := fun i => a (![0,2,3,4] i)
  let c : Fin 4 → 𝓞 K := fun i => a (![2,3,4,5] i)
  have hb := ha.comp_injective_map a (![0,2,3,4])
    (by decide : Function.Injective (![0,2,3,4] : Fin 4 → Fin 6))
  have hc := ha.comp_injective_map a (![2,3,4,5])
    (by decide : Function.Injective (![2,3,4,5] : Fin 4 → Fin 6))
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    apply hmon
    fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
  have hcmon : Monotone (fun i => ‖phi (c i : K)‖) := by
    intro i j hij
    apply hmon
    fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
  have hA : 1 ≤ ‖phi (a 0 : K)‖ := one_le_norm_integer hK phi (ha.2.1 0)
  have hfirst := hb.productFour_mixed_growth hK phi b hbmon hA hS
  have hsecond := hc.productFour_large_growth hK phi c hcmon hS
  have hA0 : 0 < ‖phi (a 0 : K)‖ := by linarith only [hA]
  have hS0 : 0 < ‖phi (a 2 : K)‖ := by linarith only [hS]
  have hT0 : 0 < ‖phi (a 3 : K)‖ := hS0.trans_le (hmon (by decide))
  refine ⟨?_,hsecond,?_⟩
  · change (3/2 : ℝ)*‖phi (a 0 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ <
      ‖phi (a 4 : K)‖ at hfirst
    have hp : 0 < ‖phi (a 0 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ := by positivity
    nlinarith only [hfirst,hp]
  · intro hlarge
    let p : Fin 3 ↪ Fin 6 := ⟨![0,1,2],by decide⟩
    let q : Fin 3 ↪ Fin 6 := ⟨![3,4,5],by decide⟩
    have hpm : Monotone (fun i => ‖phi (a (p i) : K)‖) := by
      intro i j hij
      apply hmon
      fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
    have hqm : Monotone (fun i => ‖phi (a (q i) : K)‖) := by
      intro i j hij
      apply hmon
      fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
    have hh := ha.crossBlock_growth hK phi a p q
      (by intro i j; fin_cases i <;> fin_cases j <;> decide) hpm hqm hlarge
    apply (div_lt_iff₀ (by positivity : 0 < 7*‖phi (a 2 : K)‖)).2
    change (‖phi (a 0 : K)‖*‖phi (a 3 : K)‖)^3*
      (‖phi (a 1 : K)‖*‖phi (a 4 : K)‖)/7 <
        ‖phi (a 2 : K)‖*‖phi (a 5 : K)‖ at hh
    nlinarith only [hh]

/-- Any of the three intermediate large entries can serve as the
ordinary interpolation entry, with the same terminal sextuple entry. -/
theorem IsD1Tuple.two_small_ordinary_at
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : ‖phi (a 1 : K)‖ < 3) (j : Fin 6) (hjlo : 2 ≤ j) (hjhi : j ≤ 4)
    (hP : (10 : ℝ)^8 ≤ ‖phi (a j : K)‖) :
    ordinaryLog10 ‖phi (a 5 : K)‖ <
      twoSmallHeightEnvelope (ordinaryLog10 ‖phi (a j : K)‖) := by
  let e : Fin 4 → Fin 6 := ![0,1,j,5]
  have he : Function.Injective e := by
    intro i k hik
    fin_cases i <;> fin_cases k <;> simp [e] at hik ⊢ <;> omega
  have hb := ha.comp_injective_map a e he
  have hm : Monotone (fun i => ‖phi (a (e i) : K)‖) := by
    intro i k hik
    apply hmon
    fin_cases i <;> fin_cases k <;> simp [e] at hik ⊢ <;> omega
  exact hb.two_small_ordinary_height hK phi (fun i => a (e i)) hm hB hP

end D1Bound5
