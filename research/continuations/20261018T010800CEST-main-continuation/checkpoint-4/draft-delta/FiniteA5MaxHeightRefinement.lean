import D1Bound5.FiniteA5Approximation
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- Actual A5 residual without any separation assumption between A
and |a-b|. The maximum preserves all three distinct row factors. -/
theorem finiteA5_residual_norm_lt_max_distance (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (R : ℝ)
    (hR : (9999/2621440 : ℝ)*max (‖x-y‖^10) (‖x‖*‖x-y‖^9) ≤ R*‖y‖^10)
    (i : Fin 3) :
    ‖finiteA5Residual x y c i‖ < R*‖y‖^5/(‖x‖^6*‖c‖^9) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrowpos := norm_pos_iff.mpr (finiteA5RowFactor_ne_zero x y hx hy hxy i)
  let V := max (‖x-y‖^10) (‖x‖*‖x-y‖^9)
  have hleft : ‖x-y‖^10 ≤ V := le_max_left _ _
  have hright : ‖x‖*‖x-y‖^9 ≤ V := le_max_right _ _
  have hV : 0 ≤ V := (pow_nonneg hD.le 10).trans hleft
  have hrow : ‖x‖*‖x-y‖^10 ≤ V*‖finiteA5RowFactor x y i‖ := by
    fin_cases i
    · have hh := mul_le_mul_of_nonneg_right hright hD.le
      simpa only [finiteA5RowFactor,Matrix.cons_val_zero] using
        (show ‖x‖*‖x-y‖^10 ≤ V*‖x-y‖ by nlinarith only [hh])
    · have hh := mul_le_mul_of_nonneg_right hleft hX.le
      simpa [finiteA5RowFactor,mul_comm] using hh
    · have hh := mul_le_mul_of_nonneg_right hleft hX.le
      have hh' := mul_le_mul_of_nonneg_left hXY hV
      simpa [finiteA5RowFactor,mul_comm] using hh.trans hh'
  have hfrac : ‖x‖*‖x-y‖^10/‖finiteA5RowFactor x y i‖ ≤ V :=
    (div_le_iff₀ hrowpos).mpr hrow
  have hcoef : (9999/2621440 : ℝ)*V/‖y‖^10 ≤ R :=
    (div_le_iff₀ (by positivity)).mpr hR
  have hcoef' : (9999/2621440 : ℝ)*(‖x‖*‖x-y‖^10/‖finiteA5RowFactor x y i‖)/‖y‖^10 ≤ R := by
    apply le_trans _ hcoef
    exact div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hfrac (by norm_num)) (by positivity)
  apply (finiteA5_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ = ((9999/2621440 : ℝ)*(‖x‖*‖x-y‖^10/‖finiteA5RowFactor x y i‖)/‖y‖^10)*
        (‖y‖^5/(‖x‖^6*‖c‖^9)) := by
      field_simp [hX.ne',hY.ne',hC.ne',hrowpos.ne']
      <;> ring
    _ ≤ R*(‖y‖^5/(‖x‖^6*‖c‖^9)) :=
      mul_le_mul_of_nonneg_right hcoef' (by positivity)
    _ = _ := by ring

theorem finiteA5RowForm_norm_lt_max_distance (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) (M R : ℝ)
    (hheight : (101/100 : ℝ)*(‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖) <
      M*‖y‖^12*‖c‖^5)
    (hR : (9999/2621440 : ℝ)*max (‖x-y‖^10) (‖x‖*‖x-y‖^9) ≤ R*‖y‖^10) :
    ‖finiteA5RowForm x y c z sX sY i‖ <
      M*‖y‖^12*‖c‖^6/‖z‖ + R*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
  let L := finiteA5Left x y c i
  let Lright := finiteA5Right x y c i
  let θX : ℂ := (1+1/(x*c))^(1/2 : ℂ)
  let θY : ℂ := (1+1/(y*c))^(1/2 : ℂ)
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hZ := norm_pos_iff.mpr hz
  have hid : finiteA5RowForm x y c z sX sY i =
      z*finiteA5Residual x y c i +
        z*((x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY)) := by
    rw [finiteA5RowForm_explicit,finiteA5Residual_explicit x y c hx hy hc]
    dsimp [L,Lright,θX,θY]
    field_simp [hx,hy,hz]
    <;> ring
  have hnorm : ‖finiteA5RowForm x y c z sX sY i‖ ≤
      ‖z‖*‖finiteA5Residual x y c i‖+
        ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*Lright‖*‖θY-sY/(y*z)‖) := by
    rw [hid]
    calc
      _ ≤ ‖z*finiteA5Residual x y c i‖+
          ‖z*((x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY))‖ := norm_add_le _ _
      _ = ‖z‖*‖finiteA5Residual x y c i‖+
          ‖z‖*‖(x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY)‖ := by
        rw [norm_mul,norm_mul]
      _ ≤ ‖z‖*‖finiteA5Residual x y c i‖+
          ‖z‖*(‖(x*L)*(sX/(x*z)-θX)‖+‖(y*Lright)*(sY/(y*z)-θY)‖) := by
        gcongr
        exact norm_add_le _ _
      _ = _ := by rw [norm_mul,norm_mul,norm_sub_rev (sX/(x*z)),
          norm_sub_rev (sY/(y*z))]
  have herrors :
      ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*Lright‖*‖θY-sY/(y*z)‖) ≤
        (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖Lright‖)) := by
    calc
      _ ≤ ‖z‖*(‖x*L‖*((101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))+
          ‖y*Lright‖*((101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2))) := by
        gcongr
      _ = _ := by
        rw [norm_mul,norm_mul]
        field_simp [hX.ne',hY.ne',hZ.ne']
        <;> ring
  have hYC : 1000 ≤ ‖y‖*‖c‖ :=
    hXC.trans (mul_le_mul_of_nonneg_right hXY hC.le)
  have herr :
      ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*Lright‖*‖θY-sY/(y*z)‖) <
        M*‖y‖^12*‖c‖^6/‖z‖ := by
    apply herrors.trans_lt
    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
    convert hm using 1 <;> dsimp [L,Lright] <;> ring
  have hres := mul_lt_mul_of_pos_left
    (finiteA5_residual_norm_lt_max_distance x y c hx hy hc hxy hXY hXC R hR i) hZ
  have hres' : ‖z‖*‖finiteA5Residual x y c i‖ <
      R*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
    convert hres using 1 <;> ring
  exact hnorm.trans_lt (by linarith only [herr,hres'])

/-- Full-ring root transfer with proved evaluated height and distance constants. -/
theorem full_ring_finiteA5_integer_max_distance
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c d rX rY vX vY z : 𝓞 K)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hd : d ≠ 0) (hxy : x ≠ y)
    (hrX : rX^2=x*c+1) (hrY : rY^2=y*c+1)
    (hvX : vX^2=x*d+1) (hvY : vY^2=y*d+1) (hzsq : z^2=c*d+1)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M R : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteA5Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteA5Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^12*‖phi (c : K)‖^5)
    (hR : (9999/2621440 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^10)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^9) ≤ R*‖phi (y : K)‖^10) :
    1 < M*‖phi (y : K)‖^12*‖phi (c : K)‖^6/‖phi (z : K)‖ +
      R*‖phi (y : K)‖^5*‖phi (z : K)‖/
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
  exact hi.trans_lt (finiteA5RowForm_norm_lt_max_distance (f x) (f y) (f c) (f z) (f sX) (f sY)
    hx' hy' hc' hz' hxy' hXY hXC herrorX herrorY i M R (hheight i) hR)


/-- Finite-set version of the actual refined A5 inequality. -/
theorem full_ring_finiteA5_inequality_of_height_max_distance
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M R : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteA5Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteA5Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^12*‖phi (c : K)‖^5)
    (hR : (9999/2621440 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^10)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^9) ≤ R*‖phi (y : K)‖^10) :
    ∃ z : 𝓞 K, z^2=c*d+1 ∧
      1 < M*‖phi (y : K)‖^12*‖phi (c : K)‖^6/‖phi (z : K)‖+
        R*‖phi (y : K)‖^5*‖phi (z : K)‖/(‖phi (x : K)‖^6*‖phi (c : K)‖^9) := by
  obtain ⟨rX,hrX⟩ := hS.2 x hxS c hcS hxc
  obtain ⟨rY,hrY⟩ := hS.2 y hyS c hcS hyc
  obtain ⟨vX,hvX⟩ := hS.2 x hxS d hdS hxd
  obtain ⟨vY,hvY⟩ := hS.2 y hyS d hdS hyd
  obtain ⟨z,hz⟩ := hS.2 c hcS d hdS hcd
  have hz' : z^2=c*d+1 := by simpa only [pow_two] using hz
  refine ⟨z,hz',?_⟩
  exact full_ring_finiteA5_integer_max_distance hK phi x y c d rX rY vX vY z
    (hS.1 x hxS) (hS.1 y hyS) (hS.1 c hcS) (hS.1 d hdS) hxy
    (by simpa only [pow_two] using hrX) (by simpa only [pow_two] using hrY)
    (by simpa only [pow_two] using hvX) (by simpa only [pow_two] using hvY)
    hz' hXY hXC hCY M R hheight hR

end D1Bound5
