import D1Bound5.BennettTwoIntegralEntries
import Mathlib.Tactic

namespace D1Bound5
variable {F : Type*} [Field F] [CharZero F]

theorem finiteA_choose_two (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  have h := Ring.choose_smul_choose (r := r) (n := 2) (k := 1) (by decide)
  norm_num [nsmul_eq_mul,Ring.choose_one_right] at h
  apply (eq_div_iff (by norm_num : (2 : F) ≠ 0)).mpr
  linear_combination h

theorem finiteA_choose_three (r : F) : Ring.choose r 3 = r*(r-1)*(r-2)/6 := by
  have h := Ring.choose_smul_choose (r := r) (n := 3) (k := 1) (by decide)
  norm_num [nsmul_eq_mul,Ring.choose_one_right,finiteA_choose_two] at h
  apply (eq_div_iff (by norm_num : (6 : F) ≠ 0)).mpr
  linear_combination 2*h

theorem finiteA_choose_four (r : F) : Ring.choose r 4 = r*(r-1)*(r-2)*(r-3)/24 := by
  have h := Ring.choose_smul_choose (r := r) (n := 4) (k := 1) (by decide)
  norm_num [nsmul_eq_mul,Ring.choose_one_right,finiteA_choose_three] at h
  apply (eq_div_iff (by norm_num : (24 : F) ≠ 0)).mpr
  linear_combination 6*h

theorem finiteA_choose_five (r : F) : Ring.choose r 5 = r*(r-1)*(r-2)*(r-3)*(r-4)/120 := by
  have h := Ring.choose_smul_choose (r := r) (n := 5) (k := 1) (by decide)
  norm_num [nsmul_eq_mul,Ring.choose_one_right,finiteA_choose_four] at h
  apply (eq_div_iff (by norm_num : (120 : F) ≠ 0)).mpr
  linear_combination 24*h

end D1Bound5
