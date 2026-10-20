import D1Bound5.FiniteA5IntegralRows
import D1Bound5.FiniteA5Height
import D1Bound5.FiniteA5Residual
import D1Bound5.FiniteRootApproximation

open scoped NumberField
open Module

namespace D1Bound5

theorem finiteA5Residual_explicit (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (i : Fin 3) :
    finiteA5Residual x y c i = finiteA5Constant x y c i +
      x*finiteA5Left x y c i*(1+1/(x*c))^(1/2 : ℂ) +
      y*finiteA5Right x y c i*(1+1/(y*c))^(1/2 : ℂ) := by
  obtain ⟨h1,h2⟩ := bennettTwoNodes_branch_one_two x y c hx hy hc
  rw [finiteA5Residual,Fin.sum_univ_three,h1,h2]
  simp [bennettTwoNodes_zero]

theorem finiteA5RowForm_explicit {R : Type*} [CommRing R]
    (x y c z sX sY : R) (i : Fin 3) :
    finiteA5RowForm x y c z sX sY i =
      finiteA5Constant x y c i*z+finiteA5Left x y c i*sX+
        finiteA5Right x y c i*sY := by
  simp [finiteA5RowForm,finiteA5DividedMatrix,Matrix.mulVec,dotProduct,
    Fin.sum_univ_three]

theorem finiteA5RowForm_norm_lt (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteA5RowForm x y c z sX sY i‖ <
      3113013*‖y‖^12*‖c‖^6/‖z‖ + (495/64 : ℝ)*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
  let L := finiteA5Left x y c i
  let R := finiteA5Right x y c i
  let θX : ℂ := (1+1/(x*c))^(1/2 : ℂ)
  let θY : ℂ := (1+1/(y*c))^(1/2 : ℂ)
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hZ := norm_pos_iff.mpr hz
  have hid : finiteA5RowForm x y c z sX sY i =
      z*finiteA5Residual x y c i +
        z*((x*L)*(sX/(x*z)-θX)+(y*R)*(sY/(y*z)-θY)) := by
    rw [finiteA5RowForm_explicit,finiteA5Residual_explicit x y c hx hy hc]
    dsimp [L,R,θX,θY]
    field_simp [hx,hy,hz]
    <;> ring
  have hnorm : ‖finiteA5RowForm x y c z sX sY i‖ ≤
      ‖z‖*‖finiteA5Residual x y c i‖+
        ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) := by
    rw [hid]
    calc
      _ ≤ ‖z*finiteA5Residual x y c i‖+
          ‖z*((x*L)*(sX/(x*z)-θX)+(y*R)*(sY/(y*z)-θY))‖ := norm_add_le _ _
      _ = ‖z‖*‖finiteA5Residual x y c i‖+
          ‖z‖*‖(x*L)*(sX/(x*z)-θX)+(y*R)*(sY/(y*z)-θY)‖ := by
        rw [norm_mul,norm_mul]
      _ ≤ ‖z‖*‖finiteA5Residual x y c i‖+
          ‖z‖*(‖(x*L)*(sX/(x*z)-θX)‖+‖(y*R)*(sY/(y*z)-θY)‖) := by
        gcongr
        exact norm_add_le _ _
      _ = _ := by rw [norm_mul,norm_mul,norm_sub_rev (sX/(x*z)),
          norm_sub_rev (sY/(y*z))]
  have herrors :
      ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) ≤
        (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) := by
    calc
      _ ≤ ‖z‖*(‖x*L‖*((101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))+
          ‖y*R‖*((101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2))) := by
        gcongr
      _ = _ := by
        rw [norm_mul,norm_mul]
        field_simp [hX.ne',hY.ne',hZ.ne']
        <;> ring
  have hYC : 1000 ≤ ‖y‖*‖c‖ :=
    hXC.trans (mul_le_mul_of_nonneg_right hXY hC.le)
  have hheight := finiteA5_height_scaled x y c hy hXY hYC i
  have herr :
      ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) <
        3113013*‖y‖^12*‖c‖^6/‖z‖ := by
    apply herrors.trans_lt
    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
    convert hm using 1 <;> dsimp [L,R] <;> ring
  have hres := mul_lt_mul_of_pos_left
    (finiteA5_residual_norm_lt x y c hx hy hc hxy hXY hXC i) hZ
  have hres' : ‖z‖*‖finiteA5Residual x y c i‖ <
      (495/64 : ℝ)*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
    convert hres using 1 <;> ring
  exact hnorm.trans_lt (by linarith only [herr,hres'])

/-- The actual A5 inequality for arbitrary full imaginary quadratic
integer rings. All row rank, integrality, root signs, residual and height
estimates are proved from the displayed matrix. -/
theorem full_ring_finiteA5_integer
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c d rX rY vX vY z : 𝓞 K)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hd : d ≠ 0) (hxy : x ≠ y)
    (hrX : rX^2=x*c+1) (hrY : rY^2=y*c+1)
    (hvX : vX^2=x*d+1) (hvY : vY^2=y*d+1) (hzsq : z^2=c*d+1)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) :
    1 < 3113013*‖phi (y : K)‖^12*‖phi (c : K)‖^6/‖phi (z : K)‖ +
      (495/64 : ℝ)*‖phi (y : K)‖^5*‖phi (z : K)‖/
        (‖phi (x : K)‖^6*‖phi (c : K)‖^9) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro a b hab
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hab
  have hnonzero (a : 𝓞 K) (ha : a ≠ 0) : f a ≠ 0 := by
    intro h
    apply ha
    apply hf
    simpa only [map_zero] using h
  have hx' := hnonzero x hx
  have hy' := hnonzero y hy
  have hc' := hnonzero c hc
  have hxy' : f x ≠ f y := fun h => hxy (hf h)
  change ‖f x‖ ≤ ‖f y‖ at hXY
  change 1000 ≤ ‖f x‖*‖f c‖ at hXC
  change 200*‖f y‖ ≤ ‖f c‖ at hC
  have hz : z ≠ 0 := by
    intro hz0
    have hzC : (f z)^2=f c*f d+1 := by
      simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hzsq
    rw [hz0,map_zero,zero_pow (by decide : 2 ≠ 0)] at hzC
    have hcd : f c*f d = -1 := by linear_combination -hzC
    have hnorm : ‖f c‖*‖f d‖=1 := by rw [← norm_mul,hcd]; norm_num
    have hY1 : 1 ≤ ‖f y‖ := one_le_norm_integer hK phi hy
    have hD1 : 1 ≤ ‖f d‖ := one_le_norm_integer hK phi hd
    have hm := mul_le_mul_of_nonneg_left hD1 (norm_nonneg (f c))
    nlinarith only [hC,hY1,hnorm,hm]
  have hz' := hnonzero z hz
  have hYC : 1000 ≤ ‖f y‖*‖f c‖ :=
    hXC.trans (mul_le_mul_of_nonneg_right hXY (norm_nonneg _))
  have hCx : 200*‖f x‖ ≤ ‖f c‖ := by linarith only [hXY,hC]
  obtain ⟨sX,_,herrorX⟩ := bennett_exists_integral_root_ratio_bound_finite
    f x c d z rX vX hx' hc' hz' hrX hvX hzsq hXC hCx
  obtain ⟨sY,_,herrorY⟩ := bennett_exists_integral_root_ratio_bound_finite
    f y c d z rY vY hy' hc' hz' hrY hvY hzsq hYC hC
  obtain ⟨i,hi⟩ := full_ring_finiteA5RowForm_exists_one_le_norm
    hK phi x y c z sX sY hx hy hc hxy hz
  exact hi.trans_lt (finiteA5RowForm_norm_lt (f x) (f y) (f c) (f z) (f sX) (f sY)
    hx' hy' hc' hz' hxy' hXY hXC herrorX herrorY i)

end D1Bound5
