import D1Bound5.FiniteA5Matrix
import D1Bound5.FiniteUnequalEntry
import D1Bound5.FiniteChooseFive

namespace D1Bound5
variable {F : Type*} [Field F] [CharZero F]

set_option maxHeartbeats 12000000 in
/-- One complete matrix row of the original A5 residue identity.
All three columns remain quantified and are covered by exact finite cases. -/
theorem finiteA5_residue_row2 (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 2 j =
      4*finiteA5RowFactor x y 2*finiteA5Matrix x y c 2 j := by
  have hfin01 : (0 : Fin 3) ≠ 1 := by decide
  have hfin02 : (0 : Fin 3) ≠ 2 := by decide
  have hfin10 : (1 : Fin 3) ≠ 0 := by decide
  have hfin12 : (1 : Fin 3) ≠ 2 := by decide
  have hfin20 : (2 : Fin 3) ≠ 0 := by decide
  have hfin21 : (2 : Fin 3) ≠ 1 := by decide
  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
  have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
  have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
  have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
  have hanti4 : Finset.antidiagonal 4 = {(0,4),(1,3),(2,2),(3,1),(4,0)} := by decide
  have hanti5 : Finset.antidiagonal 5 = {(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)} := by decide
  have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
  have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
  rcases hj with rfl | rfl | rfl
  all_goals
    unfold finiteUnequalClearedEntry
    first
    | rw [finiteUnequalOtherPoles_zero x y 5 4 (by decide) (by decide),
        bennettTwoNodes_zero, bennettClearedTaylor_two_poles_scaled_eval]
    | rw [finiteUnequalOtherPoles_one x y 5 4 (by decide) (by decide),
        bennettTwoNodes_one, bennettClearedTaylor_two_poles_scaled_eval]
    | rw [finiteUnequalOtherPoles_two x y 5 4 (by decide) (by decide),
        bennettTwoNodes_two, bennettClearedTaylor_two_poles_scaled_eval]
    norm_num [hfin01,hfin02,hfin10,hfin12,hfin20,hfin21,hanti0,hanti1,hanti2,hanti3,hanti4,hanti5,
      finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
      finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
      finiteA5RowFactor,finiteA5Matrix,finiteA5DividedMatrix,Matrix.mul_diagonal,
      Matrix.cons_val_two,Matrix.head_cons,Matrix.tail_cons,
      finiteA5Constant,finiteA5Left,finiteA5Right]
    field_simp [hx,hy,hd,hd']
    <;> ring

end D1Bound5
