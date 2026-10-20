import D1Bound5.FiniteN3Residual

namespace D1Bound5

/-- The exact row factors yield the distance-sensitive maximum before
any independent bounds on anchor distances are taken. -/
theorem finiteN3_residual_norm_lt_max (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5)/
        (‖x‖^4*‖y‖^3*‖c‖^6) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrow := norm_pos_iff.mpr (finiteN3RowFactor_ne_zero x y hx hy hxy i)
  let M := max (‖x-y‖^6) (‖x‖*‖x-y‖^5)
  have hM0 : ‖x-y‖^6 ≤ M := le_max_left _ _
  have hM1 : ‖x‖*‖x-y‖^5 ≤ M := le_max_right _ _
  have hscalar : ‖x‖*‖x-y‖^6 ≤ M*‖finiteN3RowFactor x y i‖ := by
    fin_cases i
    · have hh := mul_le_mul_of_nonneg_right hM1 hD.le
      simpa [finiteN3RowFactor,pow_succ,mul_assoc] using hh
    · have hh := mul_le_mul_of_nonneg_left hM0 hX.le
      simpa [finiteN3RowFactor,mul_comm] using hh
    · have hh := mul_le_mul_of_nonneg_left hM0 hY.le
      have hh' := mul_le_mul_of_nonneg_right hXY (pow_nonneg hD.le 6)
      simpa [finiteN3RowFactor,mul_comm] using hh'.trans hh
  have hf : ‖x‖*‖x-y‖^6/‖finiteN3RowFactor x y i‖ ≤ M :=
    (div_le_iff₀ hrow).mpr hscalar
  apply (finiteN3_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ = (3535/409600 : ℝ)*(‖x‖*‖x-y‖^6/‖finiteN3RowFactor x y i‖)/
        (‖x‖^4*‖y‖^3*‖c‖^6) := by
      field_simp [hX.ne',hY.ne',hC.ne',hrow.ne']
      <;> ring
    _ ≤ _ := div_le_div_of_nonneg_right
      (mul_le_mul_of_nonneg_left hf (by norm_num)) (by positivity)

/-- A proved distance enclosure supplies the residual constant for the
actual N3 family. This supports both fixed ab and relabeled bs anchors. -/
theorem finiteN3_residual_norm_lt_refined (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (R : ℝ)
    (hdistance : (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤
      R*‖y‖^6) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ < R*‖y‖^3/(‖x‖^4*‖c‖^6) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  apply (finiteN3_residual_norm_lt_max x y c hx hy hc hxy hXY hXC i).trans_le
  calc
    _ ≤ (R*‖y‖^6)/(‖x‖^4*‖y‖^3*‖c‖^6) :=
      div_le_div_of_nonneg_right hdistance (by positivity)
    _ = _ := by field_simp [hX.ne',hY.ne',hC.ne']

end D1Bound5

#print axioms D1Bound5.finiteN3_residual_norm_lt_max
#print axioms D1Bound5.finiteN3_residual_norm_lt_refined
