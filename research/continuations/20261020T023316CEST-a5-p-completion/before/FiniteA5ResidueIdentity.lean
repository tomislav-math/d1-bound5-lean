import D1Bound5.FiniteA5Matrix
import D1Bound5.FiniteUnequalEntry
import D1Bound5.FiniteChooseFive

namespace D1Bound5
variable {F : Type*} [Field F] [CharZero F]

set_option maxHeartbeats 12000000 in
/-- Every actual integral A5 entry equals its unequal-pole residue.
The finite sums, row factors and common divisor g are all verified here. -/
theorem finiteA5_residue_identity (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 i j =
      4*finiteA5RowFactor x y i*finiteA5Matrix x y c i j := by
  have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
  have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
  have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
  have hanti4 : Finset.antidiagonal 4 = {(0,4),(1,3),(2,2),(3,1),(4,0)} := by decide
  have hanti5 : Finset.antidiagonal 5 = {(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)} := by decide
  have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
  have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
  fin_cases i <;> fin_cases j
  all_goals
    unfold finiteUnequalClearedEntry
    simp only [finiteUnequalOtherPoles_zero x y 5 4 (by decide) (by decide),
      finiteUnequalOtherPoles_one x y 5 4 (by decide) (by decide),
      finiteUnequalOtherPoles_two x y 5 4 (by decide) (by decide),
      bennettTwoNodes_zero,bennettTwoNodes_one,bennettTwoNodes_two]
    rw [bennettClearedTaylor_two_poles_scaled_eval]
    norm_num [hanti1,hanti2,hanti3,hanti4,hanti5,Finset.antidiagonal_zero,
      finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
      finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
      finiteA5RowFactor,finiteA5Matrix,finiteA5DividedMatrix,Matrix.mul_diagonal,
      finiteA5Constant,finiteA5Left,finiteA5Right]
    field_simp [hx,hy,hd,hd']
    <;> ring

end D1Bound5
