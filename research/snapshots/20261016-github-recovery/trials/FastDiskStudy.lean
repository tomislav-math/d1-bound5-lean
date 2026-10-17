import D1Bound5.FiniteTail

namespace D1Bound5

open QuadInt

-- Explore a computationally cheaper, unsorted disk enumeration.
/-- Unsorted, quotient-free coordinate enumeration of the closed norm disk. -/
def fastDiskList (tau nu : ℤ) : List (QuadInt tau nu) := Id.run do
  let r := Int.sqrt (4*15)
  let mut xs := []
  for i in [:((2*r+1).toNat)] do
    let e : ℤ := (i : ℤ)-r
    for j in [:((2*r+1).toNat)] do
      let f : ℤ := (j : ℤ)-r
      if decide (e%2 = (tau*f)%2 ∧ e^2+discriminant tau nu*f^2 ≤ 4*15) then
        xs := (⟨(e-tau*f)/2,f⟩ : QuadInt tau nu) :: xs
  return xs

def fastSmallTailCheckBool (tau nu : ℤ) : Bool :=
  let xs := fastDiskList tau nu
  xs.all fun b => xs.all fun c =>
    if decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) && hasSquareRoot (b*c+1) then
      let r := rootCandidate (b*c+1)
      [b+c+2*r,b+c-2*r].all fun d =>
        if decide (d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm) then
          xs.all fun a =>
            if decide (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) &&
                hasSquareRoot (a*b+1) && hasSquareRoot (a*c+1) then
              !(hasSquareRoot (a*d+1))
            else true
        else true
    else true

#eval (fastDiskList 0 15).length
#eval fastSmallTailCheckBool 0 15

set_option maxRecDepth 65536
set_option maxHeartbeats 9000000

theorem fast_test_trace_zero_15 : fastSmallTailCheckBool 0 15 = true := by
  decide +kernel

end D1Bound5
