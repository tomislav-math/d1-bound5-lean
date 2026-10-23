import D1Bound5.Basic
import Mathlib.NumberTheory.NumberField.InfinitePlace.TotallyRealComplex

open scoped NumberField

universe u

namespace D1Bound5

/-- The requested theorem as a proposition, not an asserted theorem.
`RingOfIntegers` is mathlib's full integral closure of the integers.
Degree two and totally complex specify an imaginary quadratic number field. -/
def MainStatement : Prop :=
  ∀ (K : Type u) [Field K] [NumberField K] [NumberField.IsTotallyComplex K],
    Module.finrank ℚ K = 2 →
    ∀ A : Finset (𝓞 K), IsD1 A → A.card ≤ 5

/-- A square root in the field of an algebraic integer is integral.
No hypothesis excluding a zero root is imposed. -/
theorem square_integers_iff_field {K : Type*} [Field K] (z : 𝓞 K) :
    (∃ r : 𝓞 K, r * r = z) ↔ ∃ r : K, r * r = (z : K) := by
  constructor
  · rintro ⟨r, hr⟩
    refine ⟨(r : K), ?_⟩
    exact congrArg (algebraMap (𝓞 K) K) hr
  · rintro ⟨r, hr⟩
    have hi : IsIntegral ℤ (r ^ 2) := by
      rw [pow_two, hr]
      exact z.isIntegral_coe
    refine ⟨⟨r, IsIntegral.of_pow (by decide : 0 < 2) hi⟩, ?_⟩
    apply NumberField.RingOfIntegers.ext
    exact hr

/-- Equivalence of the two square-root conventions in Section 1. -/
theorem isD1_iff_field_roots {K : Type*} [Field K] (A : Finset (𝓞 K)) :
    IsD1 A ↔ (∀ x ∈ A, x ≠ 0) ∧
      ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∃ r : K, r * r = (x : K) * (y : K) + 1 := by
  constructor
  · intro h
    refine ⟨h.1, fun x hx y hy hxy => ?_⟩
    simpa only [map_add, map_mul, map_one] using
      (square_integers_iff_field (x * y + 1)).mp (h.2 x hx y hy hxy)
  · intro h
    refine ⟨h.1, fun x hx y hy hxy => ?_⟩
    apply (square_integers_iff_field (x * y + 1)).mpr
    simpa only [map_add, map_mul, map_one] using h.2 x hx y hy hxy

end D1Bound5
