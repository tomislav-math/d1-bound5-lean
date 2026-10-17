import D1Bound5.FullRingBridge
import D1Bound5.Regular

open scoped NumberField
open Module

namespace D1Bound5

/-- The exact quadratic inequality (irregular-quadratic), with the
arithmetic input isolated as the lower bounds for the two extensions. -/
theorem extension_norm_quadratic (a b c u v : ℂ)
    (hs : u+v = 2*(a+b+(1+2*a*b)*c))
    (hp : u*v = regularDefect a b c) (hu : 1 ≤ ‖u‖) (hv : 1 ≤ ‖v‖) :
    0 ≤ ‖c‖^2-2*(‖1+2*a*b‖-‖a+b‖)*‖c‖ + ‖(a-b)^2-4‖ + 2*‖a+b‖+1 := by
  have hprod : ‖u‖+‖v‖ ≤ ‖regularDefect a b c‖+1 := by
    rw [← hp, norm_mul]
    nlinarith [mul_nonneg (sub_nonneg.mpr hu) (sub_nonneg.mpr hv)]
  have hdid : regularDefect a b c = c^2-2*(a+b)*c+((a-b)^2-4) := by
    unfold regularDefect
    ring
  have hd : ‖regularDefect a b c‖ ≤ ‖c‖^2+2*‖a+b‖*‖c‖+‖(a-b)^2-4‖ := by
    rw [hdid]
    have h1 := norm_add_le (c^2-2*(a+b)*c) ((a-b)^2-4)
    have h2 := norm_sub_le (c^2) (2*(a+b)*c)
    simp only [norm_pow, norm_mul, Complex.norm_ofNat] at h1 h2
    linarith
  have heq : (2 : ℂ)*(1+2*a*b)*c = u+v-2*(a+b) := by
    linear_combination -hs
  have ht : 2*‖1+2*a*b‖*‖c‖ ≤ ‖u‖+‖v‖+2*‖a+b‖ := by
    calc
      _ = ‖(2 : ℂ)*(1+2*a*b)*c‖ := by simp only [norm_mul, Complex.norm_two]
      _ = ‖u+v-2*(a+b)‖ := congrArg norm heq
      _ ≤ ‖u+v‖+‖(2 : ℂ)*(a+b)‖ := norm_sub_le _ _
      _ ≤ _ := by
        rw [norm_mul, Complex.norm_two]
        linarith [norm_add_le u v]
  nlinarith only [hprod, hd, ht]

/-- The coarser quadratic used to exclude B <= C <= 2AB. -/
theorem extension_coarse_quadratic (a b c u v : ℂ)
    (hs : u+v = 2*(a+b+(1+2*a*b)*c))
    (hp : u*v = regularDefect a b c) (hu : 1 ≤ ‖u‖) (hv : 1 ≤ ‖v‖) :
    0 ≤ (‖a‖+‖b‖+‖c‖+1)^2+4-4*‖a‖*‖b‖*‖c‖ := by
  have hq := extension_norm_quadratic a b c u v hs hp hu hv
  have hP := norm_add_le a b
  have hH : 2*‖a‖*‖b‖ ≤ ‖1+2*a*b‖+1 := by
    calc
      _ = ‖(2 : ℂ)*a*b‖ := by simp only [norm_mul, Complex.norm_two]
      _ = ‖(1+2*a*b)-1‖ := by congr 1; ring
      _ ≤ ‖1+2*a*b‖+1 := by simpa only [norm_one] using norm_sub_le (1+2*a*b) 1
  have hsq : ‖a-b‖^2 ≤ (‖a‖+‖b‖)^2 := by
    have h := mul_nonneg (sub_nonneg.mpr (norm_sub_le a b))
      (add_nonneg (add_nonneg (norm_nonneg a) (norm_nonneg b)) (norm_nonneg (a-b)))
    nlinarith only [h]
  have hT : ‖(a-b)^2-4‖ ≤ (‖a‖+‖b‖)^2+4 := by
    have h := norm_sub_le ((a-b)^2) (4 : ℂ)
    simp only [norm_pow, Complex.norm_ofNat] at h
    linarith
  have hPC := mul_le_mul_of_nonneg_right hP (norm_nonneg c)
  have hHC := mul_le_mul_of_nonneg_right hH (norm_nonneg c)
  nlinarith only [hq, hP, hT, hPC, hHC]

/-- Strict negativity of a monic quadratic on a closed interval from its
two endpoint values. This includes equality at either endpoint. -/
theorem monic_quadratic_neg_between (l u x b c : ℝ) (hlu : l < u)
    (hlx : l ≤ x) (hxu : x ≤ u)
    (hl : l^2+b*l+c < 0) (hu : u^2+b*u+c < 0) : x^2+b*x+c < 0 := by
  by_cases hxl : x = l
  · simpa only [hxl] using hl
  have hlxp : 0 < x-l := sub_pos.mpr (lt_of_le_of_ne hlx (Ne.symm hxl))
  have hlup : 0 < u-l := sub_pos.mpr hlu
  have hxun : 0 ≤ u-x := sub_nonneg.mpr hxu
  have h1 := mul_nonpos_of_nonneg_of_nonpos hxun hl.le
  have h2 := mul_neg_of_pos_of_neg hlxp hu
  have h3 := mul_nonneg (mul_nonneg hlup.le hlxp.le) hxun
  have hid : (u-l)*(x^2+b*x+c) =
      (u-x)*(l^2+b*l+c)+(x-l)*(u^2+b*u+c)-(u-l)*(x-l)*(u-x) := by ring
  have hp : (u-l)*(x^2+b*x+c) < 0 := by nlinarith only [hid, h1, h2, h3]
  by_contra h
  have hn := mul_nonneg hlup.le (le_of_not_gt h)
  linarith

/-- Exact real endpoint estimates behind Lemma irregular-growth. -/
theorem growth_quadratic_negative (A B C : ℝ) (hA : 3 ≤ A) (hAB : A ≤ B)
    (hBC : B ≤ C) (hC : C ≤ 2*A*B) :
    (A+B+C+1)^2+4-4*A*B*C < 0 := by
  have hB : 3 ≤ B := hA.trans hAB
  have hAa := mul_le_mul_of_nonneg_left hB (by linarith : 0 ≤ A)
  have hBb := mul_le_mul_of_nonneg_right hA (by linarith : 0 ≤ B)
  have h9 : 9 ≤ A*B := by nlinarith only [hBb, hB]
  have hS : 9*(A+B+1) ≤ 7*A*B := by nlinarith only [hAa, hBb, h9]
  have hB2 : 9 ≤ B^2 := by nlinarith [sq_nonneg (B-3)]
  have hAB2 : 81 ≤ (A*B)^2 := by nlinarith [sq_nonneg (A*B-9)]
  have hleft : (A+B+B+1)^2+4-4*A*B*B < 0 := by
    have hbnd : 3*(A+2*B+1) ≤ 10*B := by linarith
    have hsq := mul_nonneg (sub_nonneg.mpr hbnd)
      (show 0 ≤ 10*B+3*(A+2*B+1) by linarith)
    have hABsq := mul_le_mul_of_nonneg_right hA (sq_nonneg B)
    nlinarith only [hsq, hABsq, hB2]
  have hright : (A+B+2*A*B+1)^2+4-4*A*B*(2*A*B) < 0 := by
    have hbnd : 9*(A+B+2*A*B+1) ≤ 25*A*B := by nlinarith only [hS]
    have hsq := mul_nonneg (sub_nonneg.mpr hbnd)
      (show 0 ≤ 25*A*B+9*(A+B+2*A*B+1) by nlinarith only [h9, hA, hB])
    nlinarith only [hsq, hAB2]
  have hlu : B < 2*A*B := by nlinarith only [hBb, hB]
  have h := monic_quadratic_neg_between B (2*A*B) C (2*(A+B+1)-4*A*B)
    ((A+B+1)^2+4) hlu hBC hC (by nlinarith only [hleft]) (by nlinarith only [hright])
  nlinarith only [h]

/-- The exact quadratic inequality for an irregular integral triple in any
imaginary quadratic field. The square-root hypotheses include zero roots. -/
theorem irregular_quadratic {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] (hK : finrank ℚ K = 2) (φ : K →+* ℂ)
    (a b c r s t : 𝓞 K) (hr : r^2 = a*b+1) (hs : s^2 = a*c+1)
    (ht : t^2 = b*c+1) (hi : regularDefect a b c ≠ 0) :
    let f := φ.comp (algebraMap (𝓞 K) K)
    0 ≤ ‖f c‖^2-2*(‖1+2*f a*f b‖-‖f a+f b‖)*‖f c‖ +
      ‖(f a-f b)^2-4‖+2*‖f a+f b‖+1 := by
  let f := φ.comp (algebraMap (𝓞 K) K)
  let u := a+b+c+2*a*b*c+2*r*s*t
  let v := a+b+c+2*a*b*c-2*r*s*t
  have hn := irregular_extensions_ne_zero a b c r s t hr hs ht hi
  have hu : 1 ≤ ‖f u‖ := one_le_norm_integer hK φ hn.1
  have hv : 1 ≤ ‖f v‖ := one_le_norm_integer hK φ hn.2
  have hp : f u*f v = regularDefect (f a) (f b) (f c) := by
    have h := congrArg f (extension_product a b c r s t hr hs ht)
    simpa only [u, v, regularDefect, map_mul, map_add, map_sub, map_pow, map_ofNat] using h
  have hsum : f u+f v = 2*(f a+f b+(1+2*f a*f b)*f c) := by
    simp only [u, v, map_add, map_sub, map_mul, map_ofNat]
    ring
  exact extension_norm_quadratic (f a) (f b) (f c) (f u) (f v) hsum hp hu hv

/-- Lemma irregular-growth in the full ring of every imaginary quadratic
field. Ordered moduli may be equal. -/
theorem irregular_growth {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] (hK : finrank ℚ K = 2) (φ : K →+* ℂ)
    (a b c r s t : 𝓞 K) (hr : r^2 = a*b+1) (hs : s^2 = a*c+1)
    (ht : t^2 = b*c+1) (hi : regularDefect a b c ≠ 0)
    (hA : 3 ≤ ‖φ (a : K)‖) (hAB : ‖φ (a : K)‖ ≤ ‖φ (b : K)‖)
    (hBC : ‖φ (b : K)‖ ≤ ‖φ (c : K)‖) :
    2*‖φ (a : K)‖*‖φ (b : K)‖ < ‖φ (c : K)‖ := by
  let f := φ.comp (algebraMap (𝓞 K) K)
  let u := a+b+c+2*a*b*c+2*r*s*t
  let v := a+b+c+2*a*b*c-2*r*s*t
  have hn := irregular_extensions_ne_zero a b c r s t hr hs ht hi
  have hu : 1 ≤ ‖f u‖ := one_le_norm_integer hK φ hn.1
  have hv : 1 ≤ ‖f v‖ := one_le_norm_integer hK φ hn.2
  have hp : f u*f v = regularDefect (f a) (f b) (f c) := by
    have h := congrArg f (extension_product a b c r s t hr hs ht)
    simpa only [u, v, regularDefect, map_mul, map_add, map_sub, map_pow, map_ofNat] using h
  have hsum : f u+f v = 2*(f a+f b+(1+2*f a*f b)*f c) := by
    simp only [u, v, map_add, map_sub, map_mul, map_ofNat]
    ring
  have hq := extension_coarse_quadratic (f a) (f b) (f c) (f u) (f v) hsum hp hu hv
  by_contra h
  have hC : ‖f c‖ ≤ 2*‖f a‖*‖f b‖ := le_of_not_gt h
  have hneg := growth_quadratic_negative ‖f a‖ ‖f b‖ ‖f c‖ hA hAB hBC hC
  linarith

end D1Bound5
