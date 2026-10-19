import D1Bound5.FiniteN2Matrix
import D1Bound5.BennettTwoIntegralEntries
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The second generalized binomial coefficient, derived from the
actual choose multiplication identity. -/
theorem finite_choose_two (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  have h := Ring.choose_smul_choose (r := r) (n := 2) (k := 1) (by decide)
  norm_num [nsmul_eq_mul, Ring.choose_one_right] at h
  apply (eq_div_iff (by norm_num : (2 : F) ≠ 0)).mpr
  linear_combination h

set_option maxHeartbeats 2000000 in
/-- Exact identification of the N2 integer polynomials with the actual
ordinary Bennett matrix at k=2. The row factors are precisely
2(x-y),2x,2y; no residue identity is supplied as a hypothesis. -/
theorem finiteN2_bennett_identity (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    bennettTwoClearedEntry x y c 2 i j =
      2 * finiteN2RowFactor x y i * finiteN2Matrix x y c i j := by
  have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
  have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
  have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
  have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
  fin_cases i <;> fin_cases j
  all_goals
    unfold bennettTwoClearedEntry bennettClearedResidue
    simp only [bennettTwoOtherPoles_zero, bennettTwoOtherPoles_one,
      bennettTwoOtherPoles_two, bennettTwoNodes_zero, bennettTwoNodes_one,
      bennettTwoNodes_two]
    rw [bennettClearedTaylor_two_poles_scaled_eval]
    norm_num [hanti1, hanti2, Finset.antidiagonal_zero,
      Ring.choose_zero_right, Ring.choose_one_right, finite_choose_two,
      finiteN2RowFactor, finiteN2Matrix, finiteN2DividedMatrix,
      Matrix.mul_diagonal, finiteN2Constant, finiteN2Left, finiteN2Right]
    field_simp [hx, hy, hd, hd']
    <;> ring

end D1Bound5
