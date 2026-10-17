import D1Bound5.FiniteTail

namespace D1Bound5
open QuadInt

set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

/-- Only the two conjugate imaginary pairs survive the large-pair square test. -/
theorem bc_015 :
    ∀ b ∈ disk 0 15 15, ∀ c ∈ disk 0 15 15,
      9 ≤ b.norm → b.norm ≤ c.norm → b ≠ c →
      hasSquareRoot (b*c+1) = true →
      (b = (⟨0,-1⟩ : QuadInt 0 15) ∧ c = ⟨0,1⟩) ∨
      (b = (⟨0,1⟩ : QuadInt 0 15) ∧ c = ⟨0,-1⟩) := by
  decide +kernel

/-- No small nonzero third entry is compatible with both large entries. -/
theorem no_abc_015 :
    ∀ a ∈ disk 0 15 15, a ≠ 0 →
      hasSquareRoot (a*(⟨0,-1⟩ : QuadInt 0 15)+1) = false ∨
      hasSquareRoot (a*(⟨0,1⟩ : QuadInt 0 15)+1) = false := by
  decide +kernel

end D1Bound5
