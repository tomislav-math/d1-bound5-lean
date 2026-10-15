import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace D1Bound5

/-- The real error estimate needed for a regular tail with C>=4.
The variables x,y,z are the moduli of square roots of a,b,c. -/
theorem tail_error_sum_lt_one (x y z er eu ev ew : ℝ)
    (hx : 1 ≤ x) (hy : (12/7 : ℝ) ≤ y) (hz : 2 ≤ z) (hxy : x ≤ y)
    (her : 0 ≤ er) (heu : 0 ≤ eu) (hev : 0 ≤ ev) (_hew : 0 ≤ ew)
    (hr : (39/20 : ℝ)*y*z*er < 1)
    (hu : (9/5 : ℝ)*x*y*eu < 1)
    (hv : (13/7 : ℝ)*x*z*ev < 1)
    (hw : (216/125 : ℝ)*x*z*ew < 1+2*x^2*er) : eu+ev+ew < 1 := by
  have hx0 : 0 < x := by linarith
  have hy0 : 0 < y := by linarith
  have hz0 : 0 < z := by linarith
  have hYZ : (24/7 : ℝ) ≤ y*z := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hy) (sub_nonneg.mpr hz)]
  have hr0 : er < (35/234 : ℝ) := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hYZ) her]
  have hXZ : 2 ≤ x*z := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hx) (sub_nonneg.mpr hz)]
  have hXY : (12/7 : ℝ) ≤ x*y := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hx) (sub_nonneg.mpr hy)]
  have hcoef : 0 < (216/125 : ℝ)*x*z := by positivity
  by_cases hsmall : x ≤ (8/7 : ℝ)
  · have hu' : eu < (35/108 : ℝ) := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hXY) heu]
    have hv' : ev < (7/26 : ℝ) := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hXZ) hev]
    have hxr : x*er < (20/117 : ℝ) := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hsmall) her]
    have hterm : 2*x^2*er < (20/117 : ℝ)*x*z := by
      have h1 := mul_lt_mul_of_pos_left hxr (show 0 < 2*x by positivity)
      have h2 := mul_le_mul_of_nonneg_left hz (show 0 ≤ (20/117 : ℝ)*x by positivity)
      nlinarith only [h1,h2]
    have hw' : ew < (19625/50544 : ℝ) := by
      by_contra hbad
      have hmul := mul_nonneg hcoef.le (sub_nonneg.mpr (le_of_not_gt hbad))
      nlinarith only [hw,hterm,hXZ,hmul]
    linarith
  · have hxlarge : (8/7 : ℝ) ≤ x := le_of_lt (lt_of_not_ge hsmall)
    have hXY' : (96/49 : ℝ) ≤ x*y := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hxlarge) (sub_nonneg.mpr hy)]
    have hXZ' : (16/7 : ℝ) ≤ x*z := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hxlarge) (sub_nonneg.mpr hz)]
    have hu' : eu < (245/864 : ℝ) := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hXY') heu]
    have hv' : ev < (49/208 : ℝ) := by
      nlinarith [mul_nonneg (sub_nonneg.mpr hXZ') hev]
    have hxrZ : x*er*z < (20/39 : ℝ) := by
      have h := mul_nonneg (sub_nonneg.mpr hxy) (mul_nonneg hz0.le her)
      nlinarith only [hr,h]
    have hxr : x*er < (5/39 : ℝ)*z := by
      by_contra hbad
      have hmul := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hz0.le
      nlinarith only [hxrZ, sq_nonneg (z-2), hz, hmul]
    have hterm : 2*x^2*er < (10/39 : ℝ)*x*z := by
      have h := mul_lt_mul_of_pos_left hxr (show 0 < 2*x by positivity)
      nlinarith only [h]
    have hw' : ew < (54125/134784 : ℝ) := by
      by_contra hbad
      have hmul := mul_nonneg hcoef.le (sub_nonneg.mpr (le_of_not_gt hbad))
      nlinarith only [hw,hterm,hXZ',hmul]
    linarith

/-- The tail perturbation also bounds the modulus of beta+gamma away
from zero, and leaves enough room for a second square-root perturbation. -/
theorem tail_sum_root_bounds (x y z p er : ℝ)
    (hx : 1 ≤ x) (hy : (12/7 : ℝ) ≤ y) (hz : 2 ≤ z)
    (hp : 0 ≤ p) (her : 0 ≤ er) (hr : (39/20 : ℝ)*y*z*er < 1)
    (horder : z^2 ≤ p^2+2*er) :
    (24/25 : ℝ)*z < p ∧ 1+2*x^2*er < (9/25 : ℝ)*(x*p)^2 := by
  have hYZ : (24/7 : ℝ) ≤ y*z := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hy) (sub_nonneg.mpr hz)]
  have hr0 : er < (35/234 : ℝ) := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hYZ) her]
  have hp2 : (12/13 : ℝ)*z^2 < p^2 := by
    nlinarith [sq_nonneg (z-2)]
  constructor
  · nlinarith [sq_nonneg (p-(24/25 : ℝ)*z)]
  · have hx2 : 1 ≤ x^2 := by nlinarith [sq_nonneg (x-1)]
    have hm1 := mul_lt_mul_of_pos_left hr0 (show 0 < x^2 by positivity)
    have hm2 := mul_lt_mul_of_pos_left hp2 (show 0 < x^2 by positivity)
    have hz2 : 4 ≤ z^2 := by nlinarith [sq_nonneg (z-2)]
    have hm3 := mul_le_mul_of_nonneg_left hz2 (sq_nonneg x)
    nlinarith only [hm1,hm2,hm3,hx2]

end D1Bound5
