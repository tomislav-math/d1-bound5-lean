import D1Bound5.Basic
import Mathlib.Tactic.LinearCombination

namespace D1Bound5

/-- The plus transformation in (sm:bs7-mutation). Changing the sign of one
chosen square root gives the minus transformation. -/
def mutate {R : Type*} [CommRing R] (a b z r0 r s : R) : R :=
  a+b+(2*a*b+1)*z+2*r0*r*s

/-- The transformed roots remain integral without any division. -/
theorem mutate_roots {R : Type*} [CommRing R] (a b z r0 r s : R)
    (h0 : r0^2 = a*b+1) (hr : r^2 = a*z+1) (hs : s^2 = b*z+1) :
    (r0*r+a*s)^2 = a*mutate a b z r0 r s+1 ∧
    (b*r+r0*s)^2 = b*mutate a b z r0 r s+1 := by
  unfold mutate
  constructor
  · linear_combination r^2*h0 + (a*b+1)*hr + a^2*hs
  · linear_combination s^2*h0 + b^2*hr + (a*b+1)*hs

/-- The inverse transformation recovers the extension. No nonzero hypothesis
is made on a root, on the extension, or on a transformed value. -/
theorem mutate_reverse {R : Type*} [CommRing R] (a b z r0 r s : R)
    (h0 : r0^2 = a*b+1) (hr : r^2 = a*z+1) (hs : s^2 = b*z+1) :
    a+b+(2*a*b+1)*mutate a b z r0 r s -
      2*r0*(r0*r+a*s)*(b*r+r0*s) = z := by
  unfold mutate
  linear_combination (-2*a*s^2-2*b*r^2-2*r*r0*s)*h0 +
    (-2*a*b^2-2*b)*hr + (-2*a^2*b-2*a)*hs

/-- Reversibility also holds for the chosen square roots themselves. -/
theorem mutate_reverse_roots {R : Type*} [CommRing R] (a b r0 r s : R)
    (h0 : r0^2 = a*b+1) :
    r0*(r0*r+a*s)-a*(b*r+r0*s) = r ∧
    -b*(r0*r+a*s)+r0*(b*r+r0*s) = s := by
  constructor
  · linear_combination r*h0
  · linear_combination s*h0

end D1Bound5
