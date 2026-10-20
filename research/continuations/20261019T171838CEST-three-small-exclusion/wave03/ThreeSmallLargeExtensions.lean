import D1Bound5.ThreeSmallPairAlternative
import D1Bound5.TwoSmallFifthBound

open scoped NumberField
open Module

namespace D1Bound5

theorem ordinary_height_power_upper (P Q : ℝ) (hP : (10 : ℝ)^40 ≤ P) (hQ : 0 < Q)
    (hh : ordinaryLog10 Q < twoSmallHeightEnvelope (ordinaryLog10 P)) :
    Q < (10 : ℝ)^60*P^7 := by
  have hP0 : 0 < P := by norm_num at hP; linarith only [hP]
  have hx : 40 ≤ ordinaryLog10 P := by
    have hh := ordinaryLog10_mono (by positivity : (0 : ℝ) < 10^40) hP
    simpa only [ordinaryLog10_pow,ordinaryLog10_ten,Nat.cast_ofNat,mul_one] using hh
  have hr : (4047/25 : ℝ)/(ordinaryLog10 P-4) ≤ (4047/25)/36 :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith only [hx])
  have hg : twoSmallHeightEnvelope (ordinaryLog10 P) < 7*ordinaryLog10 P+60 := by
    dsimp [twoSmallHeightEnvelope]
    norm_num at hr
    linarith only [hr]
  have hlog : ordinaryLog10 Q < ordinaryLog10 ((10 : ℝ)^60*P^7) := by
    rw [ordinaryLog10_mul _ _ (by positivity) (by positivity),ordinaryLog10_pow,
      ordinaryLog10_pow,ordinaryLog10_ten]
    norm_num
    linarith only [hh,hg]
  by_contra hbad
  have hrev := ordinaryLog10_mono (by positivity : 0 < (10 : ℝ)^60*P^7) (le_of_not_gt hbad)
  linarith only [hlog,hrev]

theorem three_small_tenth_growth_impossible (U W : ℝ) (hU : (10 : ℝ)^40 ≤ U)
    (hlow : U^10/32000 < W) (hhigh : W < (10 : ℝ)^60*U^7) : False := by
  have hU0 : 0 < U := by norm_num at hU; linarith only [hU]
  have hU3 : (10 : ℝ)^120 ≤ U^3 := by
    have hh : ((10 : ℝ)^40)^3 ≤ U^3 := by gcongr
    norm_num at hh ⊢
    exact hh
  have hh := mul_le_mul_of_nonneg_right hU3 (by positivity : 0 ≤ U^7)
  norm_num at hh hhigh
  nlinarith only [hh,hlow,hhigh,pow_pos hU0 7]

theorem three_small_three_large_impossible
    (U V W : ℝ) (hU : (10 : ℝ)^40 ≤ U)
    (hUV : (5*U^2 < V ∧ V < 405*U^2) ∨ U^5/400 < V)
    (hVW : (5*V^2 < W ∧ W < 405*V^2) ∨ V^5/400 < W)
    (hUW : (5*U^2 < W ∧ W < 405*U^2) ∨ U^5/400 < W)
    (hupper : W < (10 : ℝ)^60*U^7) : False := by
  have hU0 : 0 < U := by norm_num at hU; linarith only [hU]
  have hU1000 : 1000 ≤ U := by norm_num at hU; linarith only [hU]
  have hVgrow := three_small_pair_growth U V hU1000 hUV
  have hV0 : 0 < V := (by positivity : 0 < 5*U^2).trans hVgrow
  have hV1000 : 1000 ≤ V := by nlinarith only [hVgrow,hU1000,sq_nonneg (U-1000)]
  have hWgrow := three_small_pair_growth V W hV1000 hVW
  rcases hUV with hUV | hUV
  · rcases hVW with hVW | hVW
    · have hv2hi : V^2 < (405*U^2)^2 := by
        gcongr
        exact hUV.2
      have hv2lo : (5*U^2)^2 < V^2 := by gcongr
      have hWlo : 125*U^4 < W := by nlinarith only [hVW.1,hv2lo]
      have hWhi : W < 405^3*U^4 := by nlinarith only [hVW.2,hv2hi]
      rcases hUW with hUW | hUW
      · have hU2 : (1000 : ℝ)^2 ≤ U^2 := by gcongr
        have hh := mul_le_mul_of_nonneg_right hU2 (sq_nonneg U)
        norm_num at hh
        nlinarith only [hWlo,hUW.2,hh,sq_pos_of_pos hU0]
      · have hh := mul_le_mul_of_nonneg_right hU (by positivity : 0 ≤ U^4)
        norm_num at hh
        nlinarith only [hWhi,hUW,hh,pow_pos hU0 4]
    · have hv5 : (5*U^2)^5 < V^5 := by gcongr
      have hlow : U^10/32000 < W := by
        nlinarith only [hv5,hVW,pow_pos hU0 10]
      exact three_small_tenth_growth_impossible U W hU hlow hupper
  · have hv2 : (U^5/400)^2 < V^2 := by gcongr
    have hlow : U^10/32000 < W := by nlinarith only [hv2,hWgrow]
    exact three_small_tenth_growth_impossible U W hU hlow hupper

theorem IsD1Tuple.three_small_pair_at
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (i j : Fin 6) (hi : 3 ≤ i) (hij : i < j)
    (hP : 1000 ≤ ‖phi (a i : K)‖) :
    (5*‖phi (a i : K)‖^2 < ‖phi (a j : K)‖ ∧
      ‖phi (a j : K)‖ < 405*‖phi (a i : K)‖^2) ∨
      ‖phi (a i : K)‖^5/400 < ‖phi (a j : K)‖ := by
  let e : Fin 5 → Fin 6 := ![0,1,2,i,j]
  have he : Function.Injective e := by
    intro k l hkl
    fin_cases k <;> fin_cases l <;> simp [e] at hkl ⊢ <;> omega
  have hb := ha.comp_injective_map a e he
  have hm : Monotone (fun k => ‖phi (a (e k) : K)‖) := by
    intro k l hkl
    apply hmon
    fin_cases k <;> fin_cases l <;> simp [e] at hkl ⊢ <;> omega
  exact hb.three_small_pair_alternative hK phi (fun k => a (e k)) hm hS hP

/-- Three extensions above10^40 are impossible for a fixed actual
small triple. All three pair alternatives and the ordinary upper bound
are supplied by restrictions of the sextuple. -/
theorem IsD1Tuple.three_small_not_three_large_extensions
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : ‖phi (a 2 : K)‖ < 3) (hU : (10 : ℝ)^40 ≤ ‖phi (a 3 : K)‖) : False := by
  have hU1000 : 1000 ≤ ‖phi (a 3 : K)‖ := by norm_num at hU; linarith only [hU]
  have hV1000 : 1000 ≤ ‖phi (a 4 : K)‖ := hU1000.trans (hmon (by decide))
  have hUV := ha.three_small_pair_at hK phi a hmon hS 3 4 (by decide) (by decide) hU1000
  have hVW := ha.three_small_pair_at hK phi a hmon hS 4 5 (by decide) (by decide) hV1000
  have hUW := ha.three_small_pair_at hK phi a hmon hS 3 5 (by decide) (by decide) hU1000
  have hB3 := (hmon (by decide : (1 : Fin 6) ≤ 2)).trans_lt hS
  have hU8 : (10 : ℝ)^8 ≤ ‖phi (a 3 : K)‖ := by norm_num at hU ⊢; linarith only [hU]
  have hW : 0 < ‖phi (a 5 : K)‖ := by
    have hh := one_le_norm_integer hK phi (ha.2.1 5)
    linarith only [hh]
  have hheight := ha.two_small_ordinary_at hK phi a hmon hB3 3 (by decide) (by decide) hU8
  have hupper := ordinary_height_power_upper _ _ hU hW hheight
  exact three_small_three_large_impossible _ _ _ hU hUV hVW hUW hupper

end D1Bound5
