import D1Bound5.FiniteTail

namespace D1Bound5
open QuadInt

set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

/-- For omega^2 = -15, the large compatible ordered pairs in the
closed norm-15 disk are exactly the opposite imaginary elements. -/
theorem small_tail_015_pair_cases :
    ∀ b ∈ disk 0 15 15, ∀ c ∈ disk 0 15 15,
      9 ≤ b.norm → b.norm ≤ c.norm → b ≠ c →
      hasSquareRoot (b*c+1) = true →
      (b = (⟨0,-1⟩ : QuadInt 0 15) ∧ c = ⟨0,1⟩) ∨
      (b = (⟨0,1⟩ : QuadInt 0 15) ∧ c = ⟨0,-1⟩) := by
  decide +kernel

/-- Neither opposite imaginary pair has a compatible nonzero third
entry of norm at most fifteen. -/
theorem small_tail_015_no_small_third :
    ∀ a ∈ disk 0 15 15, a ≠ 0 →
      hasSquareRoot (a*(⟨0,-1⟩ : QuadInt 0 15)+1) = false ∨
      hasSquareRoot (a*(⟨0,1⟩ : QuadInt 0 15)+1) = false := by
  decide +kernel

/-- Fully discharged finite-tail certificate for the quadratic order
Z[sqrt(-15)]. This uses kernel reduction on two small finite statements. -/
theorem small_tail_015 : SmallTailCheck 0 15 := by
  intro b hb c hc h9 hbc hne hsq d hd hd0 hdb hdc hcd
    a ha ha0 hab hac had hNa hsab hsac
  rcases small_tail_015_pair_cases b hb c hc h9 hbc hne hsq with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
  · have h := small_tail_015_no_small_third a ha ha0
    simp [hsab, hsac] at h
  · have h := small_tail_015_no_small_third a ha ha0
    simp [hsab, hsac] at h

end D1Bound5
