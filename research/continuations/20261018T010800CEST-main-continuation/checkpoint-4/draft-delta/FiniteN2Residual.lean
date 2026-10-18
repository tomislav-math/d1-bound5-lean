import D1Bound5.FiniteN2BennettIdentity
import D1Bound5.FiniteEtaBound
import D1Bound5.BennettRootApproximation
import D1Bound5.BennettTwoResidualBound

namespace D1Bound5

noncomputable def finiteN2Residual (x y c : ℂ) (i : Fin 3) : ℂ :=
  finiteN2Constant x y c i +
    x*finiteN2Left x y c i*(1+1/(x*c))^(1/2 : ℂ) +
    y*finiteN2Right x y c i*(1+1/(y*c))^(1/2 : ℂ)

theorem finiteN2_residual_identity (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    (∑ j, bennettTwoClearedEntry x y c 2 i j *
      (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)) =
      2*finiteN2RowFactor x y i*finiteN2Residual x y c i := by
  obtain ⟨hX,hY⟩ := bennettTwoNodes_branch_one_two x y c hx hy hc
  simp_rw [finiteN2_bennett_identity x y c hx hy hxy]
  rw [Fin.sum_univ_three, finiteN2Matrix_zero, finiteN2Matrix_one,
    finiteN2Matrix_two, hX, hY]
  simp [bennettTwoNodes_zero, finiteN2Residual]
  <;> ring

theorem finiteN2_choose_abs : |Ring.choose (5/2 : ℝ) 6| = 5/1024 := by
  have h := bennett_factorial_mul_abs_choose (5/2 : ℝ) 6
  rw [descPochhammer_eval_eq_prod_range] at h
  norm_num [Finset.prod_range_succ] at h
  nlinarith only [h]

theorem finiteN2_Gamma_beta :
    Real.Gamma (7/2)*Real.Gamma (7/2)/(Real.pi*Real.Gamma 7) = (5/1024 : ℝ) := by
  have h : |Ring.choose (5/2 : ℝ) 6| =
      Real.Gamma (7/2)*Real.Gamma (7/2)/(Real.pi*Real.Gamma 7) := by
    convert bennett_two_residual_choose_abs_Gamma 2 (by norm_num) using 1 <;> norm_num
  rw [finiteN2_choose_abs] at h
  exact h.symm

/-- A distance-sensitive bound for the actual unnormalized k=2 matrix,
deduced from the proved analytic residual and the rational eta estimate. -/
theorem finiteN2_bennett_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖∑ j, bennettTwoClearedEntry x y c 2 i j *
      (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
      (101/1280 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4) := by
  have hX : 0 < ‖x‖ := norm_pos_iff.mpr hx
  have hY : 0 < ‖y‖ := norm_pos_iff.mpr hy
  have hC : 0 < ‖c‖ := norm_pos_iff.mpr hc
  have hδ : 0 < ‖x-y‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have h := bennettTwoClearedEntry_residual_norm_le x y c hx hy hc hxy
    hXY (by linarith only [hXC]) 2 (by norm_num) i
  have hb : ‖∑ j, bennettTwoClearedEntry x y c 2 i j *
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ ≤
      (4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^2 *
        (Real.Gamma (7/2)*Real.Gamma (7/2)/(Real.pi*Real.Gamma 7)) /
          (1-1/(‖x‖*‖c‖))^(7/2 : ℝ) := by
    convert h using 1 <;> norm_num
  have hscale : (4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^2*(5/1024 : ℝ) =
      (5/64 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4) := by
    field_simp [hX.ne',hY.ne',hC.ne']
    <;> ring
  rw [finiteN2_Gamma_beta,hscale] at hb
  have heta := finite_eta_reciprocal_lt (‖x‖*‖c‖) (7/2) hXC (by norm_num)
  calc
    _ ≤ ((5/64 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4))*
        (1/(1-1/(‖x‖*‖c‖))^(7/2 : ℝ)) := by simpa only [div_eq_mul_inv,one_mul] using hb
    _ < ((5/64 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4))*(101/100) :=
      mul_lt_mul_of_pos_left heta (by positivity)
    _ = _ := by ring

/-- The actual finite N2 point residual, preserving the distance factor
needed by the fixed-anchor interval tables. This is exactly the paper's
max(delta^4,u*delta^3) normalization, with denominators multiplied out. -/
theorem finiteN2_residual_norm_lt_point (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN2Residual x y c i‖ <
      (101/2560 : ℝ)*max (‖x-y‖^4) (‖x‖*‖x-y‖^3) /
        (‖x‖^3*‖y‖^2*‖c‖^4) := by
  have hX : 0 < ‖x‖ := norm_pos_iff.mpr hx
  have hY : 0 < ‖y‖ := norm_pos_iff.mpr hy
  have hC : 0 < ‖c‖ := norm_pos_iff.mpr hc
  have hδ : 0 < ‖x-y‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  let u : Fin 3 → ℝ := ![‖x‖*‖x-y‖^3,‖x-y‖^4,(‖x‖/‖y‖)*‖x-y‖^4]
  have hf : 0 < 2*‖finiteN2RowFactor x y i‖ := by
    fin_cases i
    · simpa [finiteN2RowFactor] using mul_pos (show (0 : ℝ) < 2 by norm_num) hδ
    · simpa [finiteN2RowFactor] using mul_pos (show (0 : ℝ) < 2 by norm_num) hX
    · simpa [finiteN2RowFactor] using mul_pos (show (0 : ℝ) < 2 by norm_num) hY
  have h := finiteN2_bennett_residual_norm_lt x y c hx hy hc hxy hXY hXC i
  rw [finiteN2_residual_identity x y c hx hy hc hxy, norm_mul, norm_mul] at h
  norm_num at h
  have hdiv : ‖finiteN2Residual x y c i‖ <
      ((101/1280 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4)) /
        (2*‖finiteN2RowFactor x y i‖) := by
    apply (lt_div_iff₀ hf).mpr
    nlinarith only [h]
  have hscale : ((101/1280 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4)) /
        (2*‖finiteN2RowFactor x y i‖) =
      (101/2560 : ℝ)*u i/(‖x‖^3*‖y‖^2*‖c‖^4) := by
    fin_cases i <;> simp [finiteN2RowFactor,u]
    all_goals field_simp [hX.ne',hY.ne',hC.ne',hδ.ne']
    all_goals ring
  have hu : u i ≤ max (‖x-y‖^4) (‖x‖*‖x-y‖^3) := by
    fin_cases i
    · exact le_max_right _ _
    · exact le_max_left _ _
    · calc
        _ ≤ 1*‖x-y‖^4 := mul_le_mul_of_nonneg_right
          ((div_le_one hY).mpr hXY) (pow_nonneg (norm_nonneg _) _)
        _ ≤ _ := by simpa only [one_mul] using le_max_left (‖x-y‖^4) (‖x‖*‖x-y‖^3)
  rw [hscale] at hdiv
  exact hdiv.trans_le (div_le_div_of_nonneg_right
    (mul_le_mul_of_nonneg_left hu (by norm_num)) (by positivity))

/-- The table's uniform residual constant5/4 follows with strict slack. -/
theorem finiteN2_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN2Residual x y c i‖ < (5/4 : ℝ)*‖y‖^2/(‖x‖^3*‖c‖^4) := by
  have hX : 0 < ‖x‖ := norm_pos_iff.mpr hx
  have hY : 0 < ‖y‖ := norm_pos_iff.mpr hy
  have hC : 0 < ‖c‖ := norm_pos_iff.mpr hc
  have hδ : ‖x-y‖ ≤ 2*‖y‖ := (norm_sub_le x y).trans (by linarith only [hXY])
  have hδ4 : ‖x-y‖^4 ≤ 16*‖y‖^4 := by
    calc
      _ ≤ (2*‖y‖)^4 := by gcongr
      _ = _ := by ring
  have hδ3 : ‖x-y‖^3 ≤ 8*‖y‖^3 := by
    calc
      _ ≤ (2*‖y‖)^3 := by gcongr
      _ = _ := by ring
  have hxδ : ‖x‖*‖x-y‖^3 ≤ 16*‖y‖^4 := by
    calc
      _ ≤ ‖y‖*(8*‖y‖^3) := mul_le_mul hXY hδ3 (by positivity) (norm_nonneg _)
      _ ≤ _ := by nlinarith only [pow_nonneg (norm_nonneg y) 4]
  have hm := max_le hδ4 hxδ
  have h := finiteN2_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i
  calc
    _ < _ := h
    _ ≤ (101/2560 : ℝ)*(16*‖y‖^4)/(‖x‖^3*‖y‖^2*‖c‖^4) :=
      div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hm (by norm_num)) (by positivity)
    _ = (101/160 : ℝ)*‖y‖^2/(‖x‖^3*‖c‖^4) := by
      field_simp [hX.ne',hY.ne',hC.ne']
      <;> ring
    _ < _ := by
      apply div_lt_div_of_pos_right _ (by positivity)
      exact mul_lt_mul_of_pos_right (by norm_num : (101/160 : ℝ) < 5/4) (by positivity)

end D1Bound5
