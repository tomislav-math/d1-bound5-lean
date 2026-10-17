import D1Bound5.FiniteTail
namespace D1Bound5
open QuadInt
set_option diagnostics true
set_option maxRecDepth 20000

example (b c d : QuadInt 0 2) : Decidable
    (∀ a ∈ disk 0 2 15, a ≠ 0 → a ≠ b → a ≠ c → a ≠ d →
      a.norm ≤ b.norm → hasSquareRoot (a*b+1) = true →
      hasSquareRoot (a*c+1) = true → hasSquareRoot (a*d+1) = false) := inferInstance

example (b c : QuadInt 0 2) : Decidable
    (∀ d ∈ ({b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)} :
       Finset (QuadInt 0 2)), d ≠ 0 → d ≠ b → d ≠ c → c.norm ≤ d.norm →
      ∀ a ∈ disk 0 2 15, a ≠ 0 → a ≠ b → a ≠ c → a ≠ d →
      a.norm ≤ b.norm → hasSquareRoot (a*b+1) = true →
      hasSquareRoot (a*c+1) = true → hasSquareRoot (a*d+1) = false) := inferInstance

example (b : QuadInt 0 2) : Decidable
    (∀ c ∈ disk 0 2 15, 9 ≤ b.norm → b.norm ≤ c.norm → b ≠ c →
      hasSquareRoot (b*c+1) = true →
      ∀ d ∈ ({b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)} :
       Finset (QuadInt 0 2)), d ≠ 0 → d ≠ b → d ≠ c → c.norm ≤ d.norm →
      ∀ a ∈ disk 0 2 15, a ≠ 0 → a ≠ b → a ≠ c → a ≠ d →
      a.norm ≤ b.norm → hasSquareRoot (a*b+1) = true →
      hasSquareRoot (a*c+1) = true → hasSquareRoot (a*d+1) = false) := inferInstance

example : Decidable (SmallTailCheck 0 2) := by
  unfold SmallTailCheck
  infer_instance
end D1Bound5
