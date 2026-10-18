import D1Bound5.SquareTest
import Mathlib.Data.ZMod.Basic

namespace D1Bound5
open QuadInt

/-- Each finite mask records square coordinates modulo k+1. The use of k+1
ensures the residue ring is finite even when the sieve is computed from data. -/
def coordinateSquareMaskBool {tau nu : ℤ} (k mask : ℕ)
    (z : QuadInt tau nu) : Bool :=
  mask.testBit ((z.re : ZMod (k+1)).val*(k+1)+(z.im : ZMod (k+1)).val)

/-- A finite, kernel-checkable completeness assertion for one coordinate mask.
It requires every modular square to be accepted, including the zero square. -/
def CoordinateSquareMaskValid (tau nu : ℤ) (k mask : ℕ) : Prop :=
  ∀ x y : ZMod (k+1),
    mask.testBit ((x*x+(-(nu : ZMod (k+1)))*y*y).val*(k+1)+
      (x*y+y*x+(tau : ZMod (k+1))*y*y).val) = true

/-- Reduction of an actual integral square is accepted by a valid finite mask.
No primality, positive discriminant or nonzero-root hypothesis is needed. -/
theorem coordinateSquareMaskBool_of_square {tau nu : ℤ}
    (k mask : ℕ) (htable : CoordinateSquareMaskValid tau nu k mask)
    (z r : QuadInt tau nu) (hr : r*r = z) :
    coordinateSquareMaskBool k mask z = true := by
  unfold coordinateSquareMaskBool
  rw [← hr]
  simpa only [QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
    Int.cast_add, Int.cast_mul, Int.cast_neg] using
      htable (r.re : ZMod (k+1)) (r.im : ZMod (k+1))

def CoordinateSquareSieveValid (tau nu : ℤ) (sieve : List (ℕ × ℕ)) : Prop :=
  ∀ item ∈ sieve, CoordinateSquareMaskValid tau nu item.1 item.2

def coordinateSquareSieveBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (z : QuadInt tau nu) : Bool :=
  sieve.all fun item => coordinateSquareMaskBool item.1 item.2 z

theorem coordinateSquareSieveBool_of_square {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (hvalid : CoordinateSquareSieveValid tau nu sieve)
    (z : QuadInt tau nu) (hz : ∃ r, r*r = z) :
    coordinateSquareSieveBool sieve z = true := by
  obtain ⟨r, hr⟩ := hz
  apply List.all_eq_true.mpr
  intro item hi
  exact coordinateSquareMaskBool_of_square item.1 item.2 (hvalid item hi) z r hr

/-- The finite-ring sieve is only a rejection prefilter. Passing is followed
by the full exact root procedure, so no modular pseudoroot is accepted. -/
def hasSquareRootFast {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (z : QuadInt tau nu) : Bool :=
  coordinateSquareSieveBool sieve z && hasSquareRoot z

theorem hasSquareRootFast_iff {tau nu : ℤ}
    (hd : 0 < discriminant tau nu)
    (sieve : List (ℕ × ℕ)) (hvalid : CoordinateSquareSieveValid tau nu sieve)
    (z : QuadInt tau nu) : hasSquareRootFast sieve z = true ↔ ∃ r, r*r = z := by
  simp only [hasSquareRootFast, Bool.and_eq_true]
  constructor
  · intro h
    exact (hasSquareRoot_iff hd z).1 h.2
  · intro h
    exact ⟨coordinateSquareSieveBool_of_square sieve hvalid z h,
      (hasSquareRoot_iff hd z).2 h⟩

end D1Bound5
