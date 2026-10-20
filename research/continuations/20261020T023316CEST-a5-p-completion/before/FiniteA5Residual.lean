import D1Bound5.FiniteA5ResidueIdentity
import D1Bound5.FiniteEtaBound
import D1Bound5.BennettChooseGamma

namespace D1Bound5

noncomputable def finiteA5Residual (x y c : ℂ) (i : Fin 3) : ℂ :=
  ∑ j, finiteA5Matrix x y c i j*
    (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)

theorem finiteA5_beta : |Ring.choose (11/2 : ℝ) 14| = 495/33554432 := by
  have h := bennett_factorial_mul_abs_choose (11/2 : ℝ) 14
  norm_num [descPochhammer_eval_eq_prod_range,Finset.prod_range_succ] at h
  nlinarith only [h]

theorem finiteA5_residual_sum_identity (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    4*finiteA5RowFactor x y i*finiteA5Residual x y c i =
      ∑ j, finiteUnequalClearedEntry x y c 5 4 i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  unfold finiteA5Residual
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [finiteA5_residue_identity x y c hx hy hxy]
  ring

theorem finiteA5RowFactor_ne_zero (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteA5RowFactor x y i ≠ 0 := by
  fin_cases i <;> simp [finiteA5RowFactor,hx,hy,sub_ne_zero.mpr hxy]

/-- Exact pointwise residual with the actual row factor retained, suitable
for the fixed-anchor refinement as well as the uniform family bound. -/
theorem finiteA5_residual_norm_lt_point (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA5Residual x y c i‖ <
      (101/100 : ℝ)*(495/33554432)*(4^5*‖x-y‖^10/(‖x‖^5*‖y‖^5*‖c‖^9)) /
        (4*‖finiteA5RowFactor x y i‖) := by
  have hbase : 0 < 4^5*‖x-y‖^10/(‖x‖^5*‖y‖^5*‖c‖^9) := by
    have hX := norm_pos_iff.mpr hx
    have hY := norm_pos_iff.mpr hy
    have hC := norm_pos_iff.mpr hc
    have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
    positivity
  have hrow : 0 < ‖finiteA5RowFactor x y i‖ :=
    norm_pos_iff.mpr (finiteA5RowFactor_ne_zero x y hx hy hxy i)
  have hres := finiteUnequalClearedEntry_residual_norm_le x y c hx hy hc hxy
    hXY (by linarith) 5 4 (by decide) (by decide) (by decide) (by norm_num) i
  norm_num only [Nat.cast_ofNat] at hres
  rw [finiteA5_beta] at hres
  have heta := finite_eta_reciprocal_lt (‖x‖*‖c‖) (17/2 : ℝ) hXC (by norm_num)
  have hbound :
      ‖∑ j, finiteUnequalClearedEntry x y c 5 4 i j*
          (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
        (101/100 : ℝ)*(495/33554432)*(4^5*‖x-y‖^10/(‖x‖^5*‖y‖^5*‖c‖^9)) := by
    apply hres.trans_lt
    have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < 495/33554432))
    convert hm using 1 <;> ring
  rw [← finiteA5_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
  norm_num only [norm_ofNat] at hbound
  exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])

private theorem finiteA5_rowfactor_scalar (X Y delta r : ℝ)
    (hX : 0 < X) (hY : 0 < Y) (hD : 0 < delta) (hXY : X ≤ Y)
    (hdelta : delta ≤ X+Y) (hr : r=delta ∨ r=X ∨ r=Y) :
    X*delta^10 ≤ 1024*Y^10*r := by
  have hdY : delta ≤ 2*Y := by linarith only [hXY,hdelta]
  have hprev : delta^9 ≤ (2*Y)^9 := by gcongr
  have hpow : delta^10 ≤ (2*Y)^10 := by gcongr
  rcases hr with rfl | rfl | rfl
  · have hh := mul_le_mul hXY hprev (by positivity) hY.le
    have hm := mul_le_mul_of_nonneg_right hh hD.le
    nlinarith only [hm,mul_nonneg (pow_nonneg hY.le 10) hD.le]
  · have hm := mul_le_mul_of_nonneg_left hpow hX.le
    nlinarith only [hm]
  · have hh := mul_le_mul hXY hpow (by positivity) hY.le
    nlinarith only [hh]

/-- The manuscript's uniform R*=495/64, derived from the actual residual. -/
theorem finiteA5_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA5Residual x y c i‖ < (495/64 : ℝ)*‖y‖^5/(‖x‖^6*‖c‖^9) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrow := norm_pos_iff.mpr (finiteA5RowFactor_ne_zero x y hx hy hxy i)
  have hr : ‖finiteA5RowFactor x y i‖=‖x-y‖ ∨
      ‖finiteA5RowFactor x y i‖=‖x‖ ∨ ‖finiteA5RowFactor x y i‖=‖y‖ := by
    fin_cases i <;> simp [finiteA5RowFactor]
  have hh := finiteA5_rowfactor_scalar ‖x‖ ‖y‖ ‖x-y‖ ‖finiteA5RowFactor x y i‖
    hX hY hD hXY (norm_sub_le _ _) hr
  apply (finiteA5_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  have hfrac : ‖x‖*‖x-y‖^10/(‖y‖^10*‖finiteA5RowFactor x y i‖) ≤ 1024 :=
    (div_le_iff₀ (by positivity)).mpr (by nlinarith only [hh])
  have halg :
      (101/100 : ℝ)*(495/33554432)*(4^5*‖x-y‖^10/(‖x‖^5*‖y‖^5*‖c‖^9)) /
        (4*‖finiteA5RowFactor x y i‖) =
      (9999/2621440 : ℝ)*(‖x‖*‖x-y‖^10/(‖y‖^10*‖finiteA5RowFactor x y i‖))*
        (‖y‖^5/(‖x‖^6*‖c‖^9)) := by
    field_simp [hX.ne',hY.ne',hC.ne',hrow.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (9999/2621440 : ℝ)*1024*(‖y‖^5/(‖x‖^6*‖c‖^9)) := by gcongr
    _ ≤ (495/64 : ℝ)*(‖y‖^5/(‖x‖^6*‖c‖^9)) :=
      mul_le_mul_of_nonneg_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
