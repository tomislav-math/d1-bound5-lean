import D1Bound5.FullRingOrdinaryHeight
import D1Bound5.BennettRateLower
import D1Bound5.TwoSmallHeightScalar

open scoped NumberField
open Module

namespace D1Bound5

/-- The uniform ordinary height bound for two small anchors, derived
from the actual integral Bennett rows of the given quadruple. -/
theorem IsD1Tuple.two_small_ordinary_height
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : ‖phi (a 1 : K)‖ < 3)
    (hP : (10 : ℝ)^8 ≤ ‖phi (a 2 : K)‖) :
    ordinaryLog10 ‖phi (a 3 : K)‖ <
      twoSmallHeightEnvelope (ordinaryLog10 ‖phi (a 2 : K)‖) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let P := ‖f (a 2)‖
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hB1 : 1 ≤ B := one_le_norm_integer hK phi (ha.2.1 1)
  have hA0 : 0 < A := by linarith only [hA1]
  have hB0 : 0 < B := by linarith only [hB1]
  have hP0 : 0 < P := by change 0 < ‖f (a 2)‖; norm_num at hP; linarith only [hP]
  have hB3 : B < 3 := hB
  have hAP : 1000 ≤ A*P := by
    have hh := mul_le_mul_of_nonneg_right hA1 hP0.le
    change (10 : ℝ)^8 ≤ P at hP
    norm_num at hP
    nlinarith only [hh,hP]
  have hPB : 4*B < P := by
    change (10 : ℝ)^8 ≤ P at hP
    norm_num at hP
    linarith only [hB3,hP]
  have hx : 8 ≤ ordinaryLog10 P := by
    have hh := ordinaryLog10_mono (by positivity : (0 : ℝ) < 10^8) hP
    simpa only [ordinaryLog10_pow,ordinaryLog10_ten,Nat.cast_ofNat,mul_one] using hh
  obtain ⟨hHconst,hRconst,hUconst⟩ := ordinaryLog10_two_small_parameters
  have hHlt : 42*B^3*P < 1134*P := by
    have hb3 : B^3 < (3 : ℝ)^3 := by gcongr
    have hh := mul_lt_mul_of_pos_right hb3 (by positivity : 0 < 42*P)
    nlinarith only [hh]
  have hHlog : ordinaryLog10 (42*B^3*P) < ordinaryLog10 P+31/10 := by
    have hh := ordinaryLog10_strictMono (by positivity : 0 < 42*B^3*P) hHlt
    rw [ordinaryLog10_mul 1134 P (by norm_num) hP0.ne'] at hh
    linarith only [hh,hHconst]
  have hUlog : ordinaryLog10 (253*B^2) < (17/5 : ℝ) := by
    have hb2 : B^2 < (3 : ℝ)^2 := by gcongr
    have hlt : 253*B^2 < 2277 := by nlinarith only [hb2]
    exact (ordinaryLog10_strictMono (by positivity : 0 < 253*B^2) hlt).trans hUconst
  have hrate := bennettTwoResidualRate_norm_lower (f (a 0)) (f (a 1)) (f (a 2))
    (norm_pos_iff.mp hA0) (norm_pos_iff.mp hB0)
    (hf.ne (ha.1.ne (by decide : (0 : Fin 4) ≠ 1)))
    (hmon (by decide : (0 : Fin 4) ≤ 1)) hAP
  have hsimple : (2/15 : ℝ)*P^2 < 2*A*P^2/(5*B) := by
    apply (lt_div_iff₀ (by positivity : 0 < 5*B)).2
    have hAB : B < 3*A := by linarith only [hB3,hA1]
    have hh := mul_lt_mul_of_pos_right hAB (sq_pos_of_pos hP0)
    nlinarith only [hh]
  have hRlog : 2*ordinaryLog10 P-9/10 <
      ordinaryLog10 (bennettTwoResidualRate A B P ‖f (a 0)-f (a 1)‖) := by
    have hh := ordinaryLog10_strictMono (by positivity : 0 < (2/15 : ℝ)*P^2)
      (hsimple.trans hrate)
    rw [ordinaryLog10_mul (2/15) (P^2) (by norm_num) (by positivity),
      ordinaryLog10_pow] at hh
    norm_num only [Nat.cast_ofNat] at hh
    linarith only [hh,hRconst]
  have hout := ha.ordinary_height_envelope hK phi a hmon hAP hPB
    (31/10) (-(9/10)) (17/5) hHlog
    (by simpa only [add_neg_eq_sub] using hRlog) hUlog
    (by norm_num; linarith only [hx]) (by linarith only [hx])
  convert hout using 1 <;> dsimp [twoSmallHeightEnvelope] <;> norm_num <;> ring

end D1Bound5
