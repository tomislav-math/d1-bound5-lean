import D1Bound5.FiniteN3BennettIdentity
import D1Bound5.BennettTwoResidualBound
import D1Bound5.FiniteEtaBound
import D1Bound5.BennettChooseGamma

open Polynomial

namespace D1Bound5

noncomputable def finiteN3Residual (x y c : ℂ) (i : Fin 3) : ℂ :=
  ∑ j, finiteN3Matrix x y c i j *
    (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)

theorem finiteN3_beta :
    Real.Gamma (9/2 : ℝ)*Real.Gamma (11/2 : ℝ)/
      (Real.pi*Real.Gamma (10 : ℝ)) = 35/65536 := by
  have h := bennett_factorial_mul_abs_choose (7/2 : ℝ) 9
  norm_num [descPochhammer_eval_eq_prod_range,Finset.prod_range_succ] at h
  have hg := bennett_two_residual_choose_abs_Gamma 3 (by decide)
  norm_num only [Nat.cast_ofNat] at hg
  rw [← hg]
  nlinarith only [h]

theorem finiteN3_residual_identity (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    4*finiteN3RowFactor x y i*finiteN3Residual x y c i =
      ∑ j, bennettTwoClearedEntry x y c 3 i j *
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  unfold finiteN3Residual
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [finiteN3_bennett_identity x y c hx hy hxy]
  ring

theorem finiteN3RowFactor_ne_zero (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteN3RowFactor x y i ≠ 0 := by
  fin_cases i <;> simp [finiteN3RowFactor,hx,hy,sub_ne_zero.mpr hxy]

/-- Actual residual with the row factor retained. This sharper form also
supports fixed-anchor and anchor-ratio refinements. -/
theorem finiteN3_residual_norm_lt_point (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (101/100 : ℝ)*(35/65536)*(4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^3 /
        (4*‖finiteN3RowFactor x y i‖) := by
  have hbase : 0 < (4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^3 := by
    have hX := norm_pos_iff.mpr hx
    have hY := norm_pos_iff.mpr hy
    have hC := norm_pos_iff.mpr hc
    have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
    positivity
  have hrow : 0 < ‖finiteN3RowFactor x y i‖ :=
    norm_pos_iff.mpr (finiteN3RowFactor_ne_zero x y hx hy hxy i)
  have hres := bennettTwoClearedEntry_residual_norm_le x y c hx hy hc hxy
    hXY (by linarith) 3 (by decide) i
  norm_num only [Nat.cast_ofNat] at hres
  rw [finiteN3_beta] at hres
  have heta := finite_eta_reciprocal_lt (‖x‖*‖c‖) (11/2 : ℝ) hXC (by norm_num)
  have hbound :
      ‖∑ j, bennettTwoClearedEntry x y c 3 i j *
          (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
        (101/100 : ℝ)*(35/65536)*(4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^3 := by
    apply hres.trans_lt
    have hm := mul_lt_mul_of_pos_left heta
      (mul_pos hbase (by norm_num : (0 : ℝ) < 35/65536))
    convert hm using 1 <;> ring
  rw [← finiteN3_residual_identity x y c hx hy hxy i,
    norm_mul,norm_mul] at hbound
  norm_num only [Complex.norm_ofNat] at hbound
  exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])

private theorem finiteN3_rowfactor_scalar (X Y delta r : ℝ)
    (hX : 0 < X) (hY : 0 < Y) (hD : 0 < delta) (hXY : X ≤ Y)
    (hdelta : delta ≤ X+Y) (hr : r=delta ∨ r=X ∨ r=Y) :
    X*delta^6 ≤ 64*Y^6*r := by
  have hdY : delta ≤ 2*Y := by linarith only [hXY,hdelta]
  have h5 : delta^5 ≤ (2*Y)^5 := by gcongr
  have h6 : delta^6 ≤ (2*Y)^6 := by gcongr
  rcases hr with rfl | rfl | rfl
  · have hh := mul_le_mul hXY h5 (by positivity) hY.le
    have hm := mul_le_mul_of_nonneg_right hh hD.le
    nlinarith only [hm,mul_nonneg (pow_nonneg hY.le 6) hD.le]
  · have hm := mul_le_mul_of_nonneg_left h6 hX.le
    nlinarith only [hm]
  · have hh := mul_le_mul hXY h6 (by positivity) hY.le
    nlinarith only [hh]

/-- Uniform residual35/32, derived from the actual constructed row. -/
theorem finiteN3_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (35/32 : ℝ)*‖y‖^3/(‖x‖^4*‖c‖^6) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrow := norm_pos_iff.mpr (finiteN3RowFactor_ne_zero x y hx hy hxy i)
  have hr : ‖finiteN3RowFactor x y i‖=‖x-y‖ ∨
      ‖finiteN3RowFactor x y i‖=‖x‖ ∨ ‖finiteN3RowFactor x y i‖=‖y‖ := by
    fin_cases i <;> simp [finiteN3RowFactor]
  have hh := finiteN3_rowfactor_scalar ‖x‖ ‖y‖ ‖x-y‖
    ‖finiteN3RowFactor x y i‖ hX hY hD hXY (norm_sub_le _ _) hr
  apply (finiteN3_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  have hfrac : ‖x‖*‖x-y‖^6/(‖y‖^6*‖finiteN3RowFactor x y i‖) ≤ 64 :=
    (div_le_iff₀ (by positivity)).mpr (by nlinarith only [hh])
  have halg :
      (101/100 : ℝ)*(35/65536)*(4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^3 /
        (4*‖finiteN3RowFactor x y i‖) =
      (3535/409600 : ℝ)*(‖x‖*‖x-y‖^6/(‖y‖^6*‖finiteN3RowFactor x y i‖))*
        (‖y‖^3/(‖x‖^4*‖c‖^6)) := by
    field_simp [hX.ne',hY.ne',hC.ne',hrow.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (3535/409600 : ℝ)*64*(‖y‖^3/(‖x‖^4*‖c‖^6)) := by gcongr
    _ ≤ (35/32 : ℝ)*(‖y‖^3/(‖x‖^4*‖c‖^6)) :=
      mul_le_mul_of_nonneg_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
