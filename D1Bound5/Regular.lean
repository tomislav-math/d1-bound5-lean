import D1Bound5.Basic
import Mathlib.Tactic.Ring

namespace D1Bound5

/-- The symmetric regularity polynomial from Section 2. -/
def regularDefect {R : Type*} [CommRing R] (a b c : R) : R :=
  a ^ 2 + b ^ 2 + c ^ 2 - 2*a*b - 2*a*c - 2*b*c - 4

theorem regularDefect_swap {R : Type*} [CommRing R] (a b c : R) :
    regularDefect a b c = regularDefect b a c := by
  unfold regularDefect
  ring

theorem regularDefect_cycle {R : Type*} [CommRing R] (a b c : R) :
    regularDefect a b c = regularDefect b c a := by
  unfold regularDefect
  ring

/-- The product identity at the start of lem:irregular-growth. -/
theorem extension_product {R : Type*} [CommRing R] (a b c r s t : R)
    (hr : r ^ 2 = a*b+1) (hs : s ^ 2 = a*c+1) (ht : t ^ 2 = b*c+1) :
    (a+b+c+2*a*b*c+2*r*s*t) * (a+b+c+2*a*b*c-2*r*s*t) =
      regularDefect a b c := by
  calc
    _ = (a+b+c+2*a*b*c)^2 - 4*(r^2)*(s^2)*(t^2) := by ring
    _ = (a+b+c+2*a*b*c)^2 - 4*(a*b+1)*(a*c+1)*(b*c+1) := by
      rw [hr, hs, ht]
    _ = regularDefect a b c := by unfold regularDefect; ring

/-- Irregularity makes both algebraic extensions nonzero. -/
theorem irregular_extensions_ne_zero {R : Type*} [CommRing R]
    (a b c r s t : R) (hr : r^2 = a*b+1) (hs : s^2 = a*c+1)
    (ht : t^2 = b*c+1) (hi : regularDefect a b c ≠ 0) :
    a+b+c+2*a*b*c+2*r*s*t ≠ 0 ∧ a+b+c+2*a*b*c-2*r*s*t ≠ 0 := by
  have h := extension_product a b c r s t hr hs ht
  constructor
  · intro hz
    apply hi
    rw [hz, zero_mul] at h
    exact h.symm
  · intro hz
    apply hi
    rw [hz, mul_zero] at h
    exact h.symm

end D1Bound5
