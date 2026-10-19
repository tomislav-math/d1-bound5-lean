import D1Bound5.FiniteA3ResidueIdentity
import D1Bound5.FiniteEtaBound
import D1Bound5.BennettChooseGamma

namespace D1Bound5

noncomputable def finiteA3Residual (x y c : ℂ) (i : Fin 3) : ℂ :=
  ∑ j, finiteA3Matrix x y c i j*
    (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)

theorem finiteA3_beta : |Ring.choose (7/2 : ℝ) 8| = 35/32768 := by
  have h := bennett_factorial_mul_abs_choose (7/2 : ℝ) 8
  norm_num [descPochhammer_eval_eq_prod_range,Finset.prod_range_succ] at h
  nlinarith only [h]

theorem finiteA3_residual_sum_identity (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    4*finiteA3RowFactor x y i*finiteA3Residual x y c i =
      ∑ j, finiteUnequalClearedEntry x y c 3 2 i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  unfold finiteA3Residual
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [finiteA3_residue_identity x y c hx hy hxy]
  ring

theorem finiteA3RowFactor_ne_zero (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteA3RowFactor x y i ≠ 0 := by
  fin_cases i <;> simp [finiteA3RowFactor,hx,hy,sub_ne_zero.mpr hxy]

/-- Exact pointwise residual with the actual row factor retained, suitable
for the fixed-anchor refinement as well as the uniform family bound. -/
theorem finiteA3_residual_norm_lt_point (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA3Residual x y c i‖ <
      (101/100 : ℝ)*(35/32768)*(4^3*‖x-y‖^6/(‖x‖^3*‖y‖^3*‖c‖^5)) /
        (4*‖finiteA3RowFactor x y i‖) := by
  have hbase : 0 < 4^3*‖x-y‖^6/(‖x‖^3*‖y‖^3*‖c‖^5) := by
    have hX := norm_pos_iff.mpr hx
    have hY := norm_pos_iff.mpr hy
    have hC := norm_pos_iff.mpr hc
    have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
    positivity
  have hrow : 0 < ‖finiteA3RowFactor x y i‖ :=
    norm_pos_iff.mpr (finiteA3RowFactor_ne_zero x y hx hy hxy i)
  have hres := finiteUnequalClearedEntry_residual_norm_le x y c hx hy hc hxy
    hXY (by linarith) 3 2 (by decide) (by decide) (by decide) (by norm_num) i
  norm_num only [Nat.cast_ofNat] at hres
  rw [finiteA3_beta] at hres
  have heta := finite_eta_reciprocal_lt (‖x‖*‖c‖) (9/2 : ℝ) hXC (by norm_num)
  have hbound :
      ‖∑ j, finiteUnequalClearedEntry x y c 3 2 i j*
          (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
        (101/100 : ℝ)*(35/32768)*(4^3*‖x-y‖^6/(‖x‖^3*‖y‖^3*‖c‖^5)) := by
    apply hres.trans_lt
    have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < 35/32768))
    convert hm using 1 <;> ring
  rw [← finiteA3_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
  norm_num only [Complex.norm_ofNat] at hbound
  exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])

private theorem finiteA3_rowfactor_scalar (X Y delta r : ℝ)
    (hX : 0 < X) (hY : 0 < Y) (hD : 0 < delta) (hXY : X ≤ Y)
    (hdelta : delta ≤ X+Y) (hr : r=delta ∨ r=X ∨ r=Y) :
    X*delta^6 ≤ 64*Y^6*r := by
  have hdY : delta ≤ 2*Y := by linarith only [hXY,hdelta]
  have hprev : delta^5 ≤ (2*Y)^5 := by gcongr
  have hpow : delta^6 ≤ (2*Y)^6 := by gcongr
  rcases hr with rfl | rfl | rfl
  · have hh := mul_le_mul hXY hprev (by positivity) hY.le
    have hm := mul_le_mul_of_nonneg_right hh hD.le
    nlinarith only [hm,mul_nonneg (pow_nonneg hY.le 6) hD.le]
  · have hm := mul_le_mul_of_nonneg_left hpow hX.le
    nlinarith only [hm]
  · have hh := mul_le_mul hXY hpow (by positivity) hY.le
    nlinarith only [hh]

/-- The manuscript's uniform R*=35/16, derived from the actual residual. -/
theorem finiteA3_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA3Residual x y c i‖ < (35/16 : ℝ)*‖y‖^3/(‖x‖^4*‖c‖^5) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrow := norm_pos_iff.mpr (finiteA3RowFactor_ne_zero x y hx hy hxy i)
  have hr : ‖finiteA3RowFactor x y i‖=‖x-y‖ ∨
      ‖finiteA3RowFactor x y i‖=‖x‖ ∨ ‖finiteA3RowFactor x y i‖=‖y‖ := by
    fin_cases i <;> simp [finiteA3RowFactor]
  have hh := finiteA3_rowfactor_scalar ‖x‖ ‖y‖ ‖x-y‖ ‖finiteA3RowFactor x y i‖
    hX hY hD hXY (norm_sub_le _ _) hr
  apply (finiteA3_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  have hfrac : ‖x‖*‖x-y‖^6/(‖y‖^6*‖finiteA3RowFactor x y i‖) ≤ 64 :=
    (div_le_iff₀ (by positivity)).mpr (by nlinarith only [hh])
  have halg :
      (101/100 : ℝ)*(35/32768)*(4^3*‖x-y‖^6/(‖x‖^3*‖y‖^3*‖c‖^5)) /
        (4*‖finiteA3RowFactor x y i‖) =
      (707/40960 : ℝ)*(‖x‖*‖x-y‖^6/(‖y‖^6*‖finiteA3RowFactor x y i‖))*
        (‖y‖^3/(‖x‖^4*‖c‖^5)) := by
    field_simp [hX.ne',hY.ne',hC.ne',hrow.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (707/40960 : ℝ)*64*(‖y‖^3/(‖x‖^4*‖c‖^5)) := by gcongr
    _ ≤ (35/16 : ℝ)*(‖y‖^3/(‖x‖^4*‖c‖^5)) :=
      mul_le_mul_of_nonneg_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
