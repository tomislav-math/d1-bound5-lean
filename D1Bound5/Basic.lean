import Mathlib.Algebra.Ring.Equiv
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


/-- The indexed form of a tuple, before imposing an order. -/
def IsD1Tuple {R : Type*} [CommRing R] {n : ℕ} (f : Fin n → R) : Prop :=
  Function.Injective f ∧ (∀ i, f i ≠ 0) ∧
  ∀ i j, i ≠ j → ∃ r : R, r * r = f i * f j + 1

/-- Transport through a ring equivalence does not change the square condition. -/
theorem IsD1.map_equiv {R S : Type*} [CommRing R] [CommRing S]
    {A : Finset R} (hA : IsD1 A) (e : R ≃+* S) :
    IsD1 (A.map ⟨e, e.injective⟩) := by
  constructor
  · intro y hy
    obtain ⟨x, hx, rfl⟩ := Finset.mem_map.mp hy
    intro h
    exact hA.1 x hx (e.injective (by simpa using h))
  · intro x hx y hy hxy
    obtain ⟨a, ha, rfl⟩ := Finset.mem_map.mp hx
    obtain ⟨b, hb, rfl⟩ := Finset.mem_map.mp hy
    obtain ⟨r, hr⟩ := hA.2 a ha b hb (fun h => hxy (congrArg e h))
    exact ⟨e r, by simpa using congrArg e hr⟩

/-- Simultaneous negation, not multiplication by an arbitrary unit. -/
theorem IsD1.neg {R : Type*} [CommRing R] {A : Finset R} (hA : IsD1 A) :
    IsD1 (A.map ⟨fun x => -x, neg_injective⟩) := by
  constructor
  · intro y hy
    obtain ⟨x, hx, rfl⟩ := Finset.mem_map.mp hy
    simpa using hA.1 x hx
  · intro x hx y hy hxy
    obtain ⟨a, ha, rfl⟩ := Finset.mem_map.mp hx
    obtain ⟨b, hb, rfl⟩ := Finset.mem_map.mp hy
    obtain ⟨r, hr⟩ := hA.2 a ha b hb (fun h => hxy (congrArg Neg.neg h))
    exact ⟨r, by simpa using hr⟩

end D1Bound5
