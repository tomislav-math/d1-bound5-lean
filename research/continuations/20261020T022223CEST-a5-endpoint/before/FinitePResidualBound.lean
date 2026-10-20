import D1Bound5.FinitePLeadingBound
import D1Bound5.FinitePTailBound

namespace D1Bound5

/-- The actual four-row P residual has the uniform manuscript constant3.
The proof uses finite Taylor cancellation and a convergent geometric tail. -/
theorem finiteP_residual_norm_lt (a b s c : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finitePResidual a b s c i‖ < 3*‖s‖^2/(‖a‖^3*‖c‖^5) := by
  have hapos : 0 < ‖a‖ := by linarith
  have hbpos : 0 < ‖b‖ := hapos.trans_le hAB
  have hspos : 0 < ‖s‖ := hbpos.trans_le hBS
  have hcpos : 0 < ‖c‖ := by
    by_contra h
    have hz := le_antisymm (le_of_not_gt h) (norm_nonneg c)
    rw [hz,mul_zero] at hAC
    norm_num at hAC
  have hl := finitePLeading_norm_le a b s hA hAB hBS i
  have ht := finitePTail_norm_lt a b s c hA hAB hBS hAC i
  rw [finitePResidual_eq_leading_tail a b s c (norm_pos_iff.mp hapos)
    (norm_pos_iff.mp hbpos) (norm_pos_iff.mp hspos) (norm_pos_iff.mp hcpos) i]
  calc
    _ ≤ ‖finitePLeading a b s i/c^5‖+‖finitePTail a b s c i‖ := norm_add_le _ _
    _ = ‖finitePLeading a b s i‖/‖c‖^5+‖finitePTail a b s c i‖ := by rw [norm_div,norm_pow]
    _ < ((35/16 : ℝ)*‖s‖^2/‖a‖^3)/‖c‖^5+
        (1/8 : ℝ)*‖s‖^2/(‖a‖^3*‖c‖^5) :=
      add_lt_add_of_le_of_lt (div_le_div_of_nonneg_right hl (by positivity)) ht
    _ < 3*‖s‖^2/(‖a‖^3*‖c‖^5) := by
      have hp : 0 < ‖s‖^2/(‖a‖^3*‖c‖^5) := by positivity
      have hh := mul_lt_mul_of_pos_right (by norm_num : (37/16 : ℝ)<3) hp
      convert hh using 1 <;> ring

end D1Bound5
