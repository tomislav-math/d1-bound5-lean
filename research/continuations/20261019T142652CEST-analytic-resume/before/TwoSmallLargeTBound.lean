import D1Bound5.TwoSmallLargeTScalar
import D1Bound5.ThreeAnchorAlternative
import D1Bound5.TwoSmallLargeSBound

open scoped NumberField
open Module

namespace D1Bound5

/-- The fourth-entry bound in the branch where the third entry is below
10^8. The zero and nonzero coherent-form cases are both derived from
the actual quintuple restriction, before the ordinary height contradiction. -/
theorem IsD1Tuple.two_small_fourth_bound
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB3 : ‖phi (a 1 : K)‖ < 3) (hS3 : 3 ≤ ‖phi (a 2 : K)‖)
    (hS8 : ‖phi (a 2 : K)‖ < (10 : ℝ)^8) :
    ‖phi (a 3 : K)‖ < (10 : ℝ)^72 ∧
      ((10 : ℝ)^8 ≤ ‖phi (a 3 : K)‖ → ‖phi (a 5 : K)‖ < (10 : ℝ)^549) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let T := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let D := ‖f (a 5)‖
  change B < 3 at hB3
  change 3 ≤ S at hS3
  change S < (10 : ℝ)^8 at hS8
  have hA : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hB : 1 ≤ B := one_le_norm_integer hK phi (ha.2.1 1)
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS3]
  have hT0 : 0 < T := hS0.trans_le (hmon (by decide : (2 : Fin 6) ≤ 3))
  have hD0 : 0 < D := hT0.trans_le (hmon (by decide : (3 : Fin 6) ≤ 5))
  have hg := ha.two_small_growth_inputs hK phi a hmon hS3
  have hTsmall : T < (10 : ℝ)^72 := by
    by_contra hbad
    have hTbig : (10 : ℝ)^72 ≤ T := le_of_not_gt hbad
    have hT8 : (10 : ℝ)^8 ≤ T := by norm_num at hTbig ⊢; linarith only [hTbig]
    have hAT : 9 ≤ A*T := by
      have hh := mul_le_mul_of_nonneg_right hA hT0.le
      norm_num at hTbig
      nlinarith only [hh,hTbig]
    let e : Fin 5 → Fin 6 := ![0,1,2,3,4]
    have he : Function.Injective e := by decide
    have hb := ha.comp_injective_map a e he
    have hbmon : Monotone (fun i => ‖f (a (e i))‖) := by
      have hidx : Monotone e := by decide
      exact fun i j hij => hmon (hidx hij)
    have hT1000 : 1000 ≤ T := by norm_num at hTbig; linarith only [hTbig]
    have hST4 : 4*S ≤ T := by
      norm_num at hS8 hTbig
      linarith only [hS8,hTbig]
    have halt := hb.three_anchor_general_alternative hK phi (fun i => a (e i))
      hbmon hT1000 hST4
    have hpower : T^8/(10 : ℝ)^27 < D := by
      rcases halt with hquad | hlow | hquintic
      · have hp := two_small_large_T_quadratic_parameters A B S T C D
          hA hB hB3 hS3 hTbig hquad hg.2.1
        have hw := ha.four_anchor_V_window hK phi a hmon hp.1 hp.2.1 hp.2.2.1 hp.2.2.2.1
        have hV : (2/5 : ℝ)*A^2*C^5/T^2 < D := by
          rcases hw with hw | hw
          · exact False.elim (lt_asymm hw hp.2.2.2.2)
          · exact hw
        have hh := two_small_large_T_quadratic_eighth A B S T C D hA hB hS3 hT0 hquad hV
        apply lt_trans _ hh
        apply (div_lt_iff₀ (by positivity : (0 : ℝ) < 10^27)).2
        norm_num
        nlinarith only [pow_pos hT0 8]
      · exact False.elim (two_small_large_T_lower_window_impossible B S T C
          hB0 hB3 hS0 hS8 hTbig (hmon (by decide : (3 : Fin 6) ≤ 4)) hlow)
      · exact two_small_large_T_quintic_eighth A B S T C D hA hB hS0 hS8 hT0
          hquintic (hg.2.2 hAT)
    have hlower : 8*ordinaryLog10 T-27 < ordinaryLog10 D := by
      have hh := ordinaryLog10_strictMono (by positivity : 0 < T^8/(10 : ℝ)^27) hpower
      rw [ordinaryLog10_div _ _ (by positivity) (by positivity),ordinaryLog10_pow,
        ordinaryLog10_pow,ordinaryLog10_ten] at hh
      norm_num at hh
      exact hh
    have hupper := ha.two_small_ordinary_at hK phi a hmon hB3 3 (by decide) (by decide) hT8
    change ordinaryLog10 D < twoSmallHeightEnvelope (ordinaryLog10 T) at hupper
    have hx : 72 ≤ ordinaryLog10 T := by
      have hh := ordinaryLog10_mono (by positivity : (0 : ℝ) < 10^72) hTbig
      simpa only [ordinaryLog10_pow,ordinaryLog10_ten,Nat.cast_ofNat,mul_one] using hh
    have hh := twoSmallHeightEnvelope_lt_eight_mul_sub_twenty_seven (ordinaryLog10 T) hx
    linarith only [hlower,hupper,hh]
  refine ⟨hTsmall,?_⟩
  intro hT8
  have hupper := ha.two_small_ordinary_at hK phi a hmon hB3 3 (by decide) (by decide) hT8
  change ordinaryLog10 D < twoSmallHeightEnvelope (ordinaryLog10 T) at hupper
  have hxlo : 8 ≤ ordinaryLog10 T := by
    have hh := ordinaryLog10_mono (by positivity : (0 : ℝ) < 10^8) hT8
    simpa only [ordinaryLog10_pow,ordinaryLog10_ten,Nat.cast_ofNat,mul_one] using hh
  have hxhi : ordinaryLog10 T < 72 := (ordinaryLog10_lt_nat_iff T hT0 72).2 hTsmall
  apply (ordinaryLog10_lt_nat_iff D hD0 549).1
  exact hupper.trans (twoSmallHeightEnvelope_lt_549 (ordinaryLog10 T) hxlo hxhi.le)

end D1Bound5
