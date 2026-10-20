import D1Bound5.FiniteA5ResidueRow0
import D1Bound5.FiniteA5ResidueRow1
import D1Bound5.FiniteA5ResidueRow2

namespace D1Bound5
variable {F : Type*} [Field F] [CharZero F]

set_option maxHeartbeats 12000000 in
/-- Every actual integral A5 entry equals its unequal-pole residue.
The finite sums, row factors and common divisor g are all verified here. -/
theorem finiteA5_residue_identity (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 i j =
      4*finiteA5RowFactor x y i*finiteA5Matrix x y c i j := by
  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
  rcases hi with rfl | rfl | rfl
  · exact finiteA5_residue_row0 x y c hx hy hxy j
  · exact finiteA5_residue_row1 x y c hx hy hxy j
  · exact finiteA5_residue_row2 x y c hx hy hxy j

end D1Bound5
