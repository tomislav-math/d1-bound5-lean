import D1Bound5.TwoSmallMWindow

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The remaining two-small box: when the third and fourth entries
are below10^8, V nonvanishing forces direct-four nonvanishing, whose
seventh-power lower bound falls inside the actual M forbidden window. -/
theorem IsD1Tuple.two_small_bounded_fourth_fifth_lt
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB3 : ‖phi (a 1 : K)‖ < 3) (hS3 : 3 ≤ ‖phi (a 2 : K)‖)
    (hT8 : ‖phi (a 3 : K)‖ < (10 : ℝ)^8) :
    ‖phi (a 4 : K)‖ < (10 : ℝ)^100 := by
  classical
  by_contra hbad
  have hCbig := le_of_not_gt hbad
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let T := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let D := ‖f (a 5)‖
  have hA : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hB : 1 ≤ B := one_le_norm_integer hK phi (ha.2.1 1)
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS3]
  have hST : S ≤ T := hmon (by decide : (2 : Fin 6) ≤ 3)
  have hS8 : S < (10 : ℝ)^8 := hST.trans_lt hT8
  have hT0 : 0 < T := hS0.trans_le hST
  have hC0 : 0 < C := hT0.trans_le (hmon (by decide : (3 : Fin 6) ≤ 4))
  have hD0 : 0 < D := hC0.trans_le (hmon (by decide : (4 : Fin 6) ≤ 5))
  have hg := ha.two_small_growth_inputs hK phi a hmon hS3
  have hp := two_small_large_C_V_parameters A B S T C D hA hB hB3 hS3 hST hS8 hT8 hCbig hg.2.1
  have hw := ha.four_anchor_V_window hK phi a hmon hp.1 hp.2.1 hp.2.2.1 hp.2.2.2.1
  have hV : (2/5 : ℝ)*A^2*C^5/T^2 < D := by
    rcases hw with hw | hw
    · exact False.elim (lt_asymm hw hp.2.2.2.2)
    · exact hw
  have hfour := two_small_large_C_direct_four_parameters A B S T C D hA
    (hmon (by decide : (0 : Fin 6) ≤ 1)) hB0 hB3 hS0 hT0 hS8 hT8 hCbig hV
  obtain ⟨Z,hZ,hCZ,hroot,hform⟩ :=
    ha.direct_four_integer_inequality hK phi a hmon hp.1 hfour.1 hfour.2
  have hseven := two_small_large_C_seventh_power A B S T C D Z hA hB0 hB3 hS0 hT0
    hS8 hT8 hCbig hZ hCZ hroot hform
  have hC8 : (10 : ℝ)^8 ≤ C := by norm_num at hCbig ⊢; linarith only [hCbig]
  have hheight := ha.two_small_ordinary_at hK phi a hmon hB3 4 (by decide) (by decide) hC8
  have hbracket := two_small_M_window_brackets C D hCbig hseven hheight hD0
  have hcontains := two_small_M_window_contains A B S C hA hB0 hB3 hS0 hS8 hC0
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 6) : a i ∈ Tup := Finset.mem_image.mpr ⟨i,Finset.mem_univ i,rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  let b : Fin 3 → 𝓞 K := fun i => a (![0,1,2] i)
  have hb : Function.Injective b :=
    ha.1.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 6))
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    apply hmon
    fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
  have hAC : 1000 ≤ A*C := by
    have hh := mul_le_mul_of_nonneg_right hA hC0.le
    nlinarith only [hh,hp.1]
  exact full_ring_finiteM_closed_interval_excluded hK phi hTup b (a 4) (a 5)
    (fun i => hmem _) (hmem 4) (hmem 5) hb
    (by intro i; exact ha.1.ne (by fin_cases i <;> decide))
    (by intro i; exact ha.1.ne (by fin_cases i <;> decide))
    (ha.1.ne (by decide)) hbmon (by linarith only [hp.2.1,hST])
    (hmon (by decide : (4 : Fin 6) ≤ 5)) hAC
    (hcontains.1.trans hbracket.1) (hbracket.2.trans hcontains.2)

/-- The complete analytic two-small cutoff for the fifth entry of an
actual ordered sextuple over the full integer ring. All finite families,
coherent forms, determinant growth and ordinary height bounds are
constructed internally; the only size assumptions specify the branch. -/
theorem IsD1Tuple.two_small_fifth_lt
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB3 : ‖phi (a 1 : K)‖ < 3) (hS3 : 3 ≤ ‖phi (a 2 : K)‖) :
    ‖phi (a 4 : K)‖ < (10 : ℝ)^550 := by
  have hCD : ‖phi (a 4 : K)‖ ≤ ‖phi (a 5 : K)‖ := hmon (by decide)
  by_cases hS : (10 : ℝ)^8 ≤ ‖phi (a 2 : K)‖
  · have hh := (ha.two_small_large_third_bound hK phi a hmon hB3 hS).2
    exact (hCD.trans_lt hh).trans (by norm_num : (10 : ℝ)^396 < 10^550)
  · have hSsmall : ‖phi (a 2 : K)‖ < (10 : ℝ)^8 := lt_of_not_ge hS
    by_cases hT : (10 : ℝ)^8 ≤ ‖phi (a 3 : K)‖
    · have hh := (ha.two_small_fourth_bound hK phi a hmon hB3 hS3 hSsmall).2 hT
      exact (hCD.trans_lt hh).trans (by norm_num : (10 : ℝ)^549 < 10^550)
    · have hh := ha.two_small_bounded_fourth_fifth_lt hK phi a hmon hB3 hS3 (lt_of_not_ge hT)
      exact hh.trans (by norm_num : (10 : ℝ)^100 < 10^550)

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.two_small_fifth_lt
