import Mathlib.Data.Finset.Card
import Mathlib.Algebra.Ring.Basic

namespace D1Bound5

/-- Distinct nonzero entries; zero is permitted as a square value. -/
def IsD1 {R : Type*} [CommRing R] (A : Finset R) : Prop :=
  (∀ x ∈ A, x ≠ 0) ∧
  ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∃ r : R, r * r = x * y + 1

theorem IsD1.subset {R : Type*} [CommRing R] {A B : Finset R}
    (hA : IsD1 A) (hBA : B ⊆ A) : IsD1 B := by
  exact ⟨fun x hx => hA.1 x (hBA hx),
    fun x hx y hy hxy => hA.2 x (hBA hx) y (hBA hy) hxy⟩

end D1Bound5
