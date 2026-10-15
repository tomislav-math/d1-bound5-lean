import D1Bound5.Basic
import D1Bound5.Coordinates
import Mathlib.Tactic.NormNum

namespace D1Bound5

/-- This valid pair has product plus one equal to zero. It also has equal
absolute values, so it tests two important boundary conventions. -/
theorem zero_square_pair : IsD1 ({-1, 1} : Finset ℤ) := by
  constructor
  · intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl <;> norm_num
  · intro x hx y hy hxy
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx hy
    rcases hx with rfl | rfl <;> rcases hy with rfl | rfl
    · exact (hxy rfl).elim
    · exact ⟨0, by norm_num⟩
    · exact ⟨0, by norm_num⟩
    · exact (hxy rfl).elim

/-- Half-integral-basis arithmetic: omega=(1+sqrt(-3))/2 satisfies
omega^2=omega-1, not omega^2=-3. This tests the coordinate convention. -/
theorem half_integral_basis_square :
    (⟨0, 1⟩ : QuadInt 1 1)^2 = ⟨-1, 1⟩ := by
  ext <;> norm_num [pow_two]

end D1Bound5
