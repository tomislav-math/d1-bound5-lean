import D1Bound5.FiniteA4Approximation
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual residual retains the evaluated anchor distance. The sole
extra comparison concerns explicit norms, and is verified by fixed-pair data. -/
theorem finiteA4_residual_norm_lt_refined (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (hdelta : ‖x‖ ≤ ‖x-y‖) (R : ℝ)
    (hR : (6363/409600 : ℝ)*‖x-y‖^8 ≤ R*‖y‖^8) (i : Fin 3) :
    ‖finiteA4Residual x y c i‖ < R*‖y‖^4/(‖x‖^5*‖c‖^7) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hrow : ‖x‖ ≤ ‖finiteA4RowFactor x y i‖ := by
    fin_cases i
    · simpa [finiteA4RowFactor] using hdelta
    · simp [finiteA4RowFactor]
    · simpa [finiteA4RowFactor] using hXY
  have hrowpos : 0 < ‖finiteA4RowFactor x y i‖ := hX.trans_le hrow
  have hcoef : (6363/409600 : ℝ)*‖x-y‖^8/‖y‖^8 ≤ R :=
    (div_le_iff₀ (by positivity)).mpr hR
  apply (finiteA4_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ = ((6363/409600 : ℝ)*‖x-y‖^8/(‖x‖^4*‖y‖^4*‖c‖^7))/
        ‖finiteA4RowFactor x y i‖ := by ring
    _ ≤ ((6363/409600 : ℝ)*‖x-y‖^8/(‖x‖^4*‖y‖^4*‖c‖^7))/‖x‖ := by
      apply div_le_div_of_nonneg_left (by positivity) hX hrow
    _ = ((6363/409600 : ℝ)*‖x-y‖^8/‖y‖^8)*
        (‖y‖^4/(‖x‖^5*‖c‖^7)) := by
      field_simp [hX.ne',hY.ne',hC.ne']
      <;> ring
    _ ≤ R*(‖y‖^4/(‖x‖^5*‖c‖^7)) :=
      mul_le_mul_of_nonneg_right hcoef (by positivity)
    _ = _ := by ring

theorem finiteA4RowForm_norm_lt_refined (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) (M R : ℝ)
    (hheight : (101/100 : ℝ)*(‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖) <
      M*‖y‖^9*‖c‖^4)
    (hdelta : ‖x‖ ≤ ‖x-y‖)
    (hR : (6363/409600 : ℝ)*‖x-y‖^8 ≤ R*‖y‖^8) :
    ‖finiteA4RowForm x y c z sX sY i‖ <
      M*‖y‖^9*‖c‖^5/‖z‖ + R*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by
  let L := finiteA4Left x y c i
  let Lright := finiteA4Right x y c i
  let θX : ℂ := (1+1/(x*c))^(1/2 : ℂ)
  let θY : ℂ := (1+1/(y*c))^(1/2 : ℂ)
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hZ := norm_pos_iff.mpr hz
  have hid : finiteA4RowForm x y c z sX sY i =
      z*finiteA4Residual x y c i +
        z*((x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY)) := by
    rw [finiteA4RowForm_explicit,finiteA4Residual_explicit x y c hx hy hc]
    dsimp [L,Lright,θX,θY]
    field_simp [hx,hy,hz]
    <;> ring
  have hnorm : ‖finiteA4RowForm x y c z sX sY i‖ ≤
      ‖z‖*‖finiteA4Residual x y c i‖+
        ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*Lright‖*‖θY-sY/(y*z)‖) := by
    rw [hid]
    calc
      _ ≤ ‖z*finiteA4Residual x y c i‖+
          ‖z*((x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY))‖ := norm_add_le _ _
      _ = ‖z‖*‖finiteA4Residual x y c i‖+
          ‖z‖*‖(x*L)*(sX/(x*z)-θX)+(y*Lright)*(sY/(y*z)-θY)‖ := by
        rw [norm_mul,norm_mul]
      _ ≤ ‖z‖*‖finiteA4Residual x y c i‖+
          ‖z‖*(‖(x*L)*(sX/(x*z)-θX)‖+‖(y*Lright)*(sY/(y*z)-θY)‖) := by
        gcongr
        exact norm_add_le _ _
      _ = _ := by
        simp only [norm_mul, norm_sub_rev (sX/(x*z)) θX,
          norm_sub_rev (sY/(y*z)) θY]
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
        M*‖y‖^9*‖c‖^5/‖z‖ := by
    apply herrors.trans_lt
    calc
      (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖Lright‖)) <
          (‖c‖/‖z‖)*(M*‖y‖^9*‖c‖^4) :=
        mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
      _ = M*‖y‖^9*‖c‖^5/‖z‖ := by ring
  have hres := mul_lt_mul_of_pos_left
    (finiteA4_residual_norm_lt_refined x y c hx hy hc hxy hXY hXC hdelta R hR i) hZ
  have hres' : ‖z‖*‖finiteA4Residual x y c i‖ <
      R*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by
    calc
      ‖z‖*‖finiteA4Residual x y c i‖ <
          ‖z‖*(R*‖y‖^4/(‖x‖^5*‖c‖^7)) := hres
      _ = R*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by ring
  exact hnorm.trans_lt (by linarith only [herr,hres'])

/-- Full-ring root transfer with proved evaluated height and distance constants. -/
theorem full_ring_finiteA4_integer_refined
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
      (101/100 : ℝ)*(‖finiteA4Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteA4Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^9*‖phi (c : K)‖^4)
    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)
    (hR : (6363/409600 : ℝ)*‖phi (x : K)-phi (y : K)‖^8 ≤ R*‖phi (y : K)‖^8) :
    1 < M*‖phi (y : K)‖^9*‖phi (c : K)‖^5/‖phi (z : K)‖ +
      R*‖phi (y : K)‖^4*‖phi (z : K)‖/
        (‖phi (x : K)‖^5*‖phi (c : K)‖^7) := by
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
  obtain ⟨i,hi⟩ := full_ring_finiteA4RowForm_exists_one_le_norm
    hK phi x y c z sX sY hx hy hc hxy hz
  exact hi.trans_lt (finiteA4RowForm_norm_lt_refined (f x) (f y) (f c) (f z) (f sX) (f sY)
    hx' hy' hc' hz' hxy' hXY hXC herrorX herrorY i M R (hheight i) hdelta hR)


/-- Finite-set version of the actual refined A4 inequality. -/
theorem full_ring_finiteA4_inequality_of_height
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
      (101/100 : ℝ)*(‖finiteA4Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteA4Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^9*‖phi (c : K)‖^4)
    (hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖)
    (hR : (6363/409600 : ℝ)*‖phi (x : K)-phi (y : K)‖^8 ≤ R*‖phi (y : K)‖^8) :
    ∃ z : 𝓞 K, z^2=c*d+1 ∧
      1 < M*‖phi (y : K)‖^9*‖phi (c : K)‖^5/‖phi (z : K)‖+
        R*‖phi (y : K)‖^4*‖phi (z : K)‖/(‖phi (x : K)‖^5*‖phi (c : K)‖^7) := by
  obtain ⟨rX,hrX⟩ := hS.2 x hxS c hcS hxc
  obtain ⟨rY,hrY⟩ := hS.2 y hyS c hcS hyc
  obtain ⟨vX,hvX⟩ := hS.2 x hxS d hdS hxd
  obtain ⟨vY,hvY⟩ := hS.2 y hyS d hdS hyd
  obtain ⟨z,hz⟩ := hS.2 c hcS d hdS hcd
  have hz' : z^2=c*d+1 := by simpa only [pow_two] using hz
  refine ⟨z,hz',?_⟩
  exact full_ring_finiteA4_integer_refined hK phi x y c d rX rY vX vY z
    (hS.1 x hxS) (hS.1 y hyS) (hS.1 c hcS) (hS.1 d hdS) hxy
    (by simpa only [pow_two] using hrX) (by simpa only [pow_two] using hrY)
    (by simpa only [pow_two] using hvX) (by simpa only [pow_two] using hvY)
    hz' hXY hXC hCY M R hheight hdelta hR

end D1Bound5
