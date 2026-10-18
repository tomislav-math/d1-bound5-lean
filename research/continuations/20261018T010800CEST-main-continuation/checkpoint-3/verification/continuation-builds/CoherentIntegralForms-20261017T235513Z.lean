import D1Bound5.CoherentAnalyticInterpolation
import D1Bound5.FullRingBridge

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The terminal root with the branch fixed by the analytic construction. -/
noncomputable def coherentTerminalRoot (p q eta : ℂ) : ℂ :=
  eta * ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))

/-- The anchor root with the same coherent analytic branch choices. -/
noncomputable def coherentAnchorRoot (a p q eta : ℂ) : ℂ :=
  a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
    ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))

/-- A complex number whose square agrees with that of a ring element
already lies in the image of that ring.  Zero roots are permitted. -/
theorem complex_square_root_lift
    {R : Type*} [CommRing R] (f : R →+* ℂ) (z : ℂ) (r : R)
    (h : z ^ 2 = (f r) ^ 2) : ∃ t : R, f t = z := by
  rcases sq_eq_sq_iff_eq_or_eq_neg.mp h with h | h
  · exact ⟨r, h.symm⟩
  · exact ⟨-r, by simpa only [map_neg] using h.symm⟩

/-- The coherent terminal root of two actual tuple entries lifts to the
original ring, even though the auxiliary square root `eta` need not do so. -/
theorem IsD1.coherent_terminal_root_lift
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    {T : Finset R} (hT : IsD1 T) {p q : R}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = f p * f q) :
    ∃ z : R, f z = coherentTerminalRoot (f p) (f q) eta := by
  have hp0 : f p ≠ 0 := by
    intro h
    exact hT.1 p hp (hf (by simpa only [map_zero] using h))
  have hq0 : f q ≠ 0 := by
    intro h
    exact hT.1 q hq (hf (by simpa only [map_zero] using h))
  obtain ⟨r, hr⟩ := hT.2 p hp q hq hpq
  have hr' : (f r) ^ 2 = f p * f q + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f hr
  apply complex_square_root_lift f _ r
  rw [hr']
  exact coherent_analytic_terminal_root_sq (f p) (f q) eta hp0 hq0 heta

/-- Every coherent analytic anchor root of actual tuple entries lifts
to their original ring.  The lift is a signed product of the two tuple
square roots; no assumption of a nonzero pair product is required. -/
theorem IsD1.coherent_anchor_root_lift
    {R : Type*} [CommRing R] (f : R →+* ℂ) (hf : Function.Injective f)
    {T : Finset R} (hT : IsD1 T) {a p q : R}
    (ha : a ∈ T) (hp : p ∈ T) (hq : q ∈ T)
    (hap : a ≠ p) (haq : a ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = f p * f q) :
    ∃ r : R, f r = coherentAnchorRoot (f a) (f p) (f q) eta := by
  have hnonzero (u : R) (hu : u ∈ T) : f u ≠ 0 := by
    intro h
    exact hT.1 u hu (hf (by simpa only [map_zero] using h))
  obtain ⟨r, hr⟩ := hT.2 a ha p hp hap
  obtain ⟨t, ht⟩ := hT.2 a ha q hq haq
  have hr' : (f r) ^ 2 = f a * f p + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f hr
  have ht' : (f t) ^ 2 = f a * f q + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f ht
  apply complex_square_root_lift f _ (r * t)
  rw [map_mul, mul_pow, hr', ht']
  exact coherent_analytic_anchor_root_sq (f a) (f p) (f q) eta
    (hnonzero a ha) (hnonzero p hp) (hnonzero q hq) heta

/-- Any polynomial-weighted coherent linear form on actual tuple roots
lifts to the original ring.  This supplies the arithmetic bridge after
the explicit Vandermonde quotient weights have been simplified. -/
theorem IsD1.coherent_linear_form_lift
    {R ι : Type*} [CommRing R] [Fintype ι]
    (f : R →+* ℂ) (hf : Function.Injective f)
    {T : Finset R} (hT : IsD1 T) {p q : R}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (a c : ι → R) (Delta : R)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = f p * f q) :
    ∃ L : R, f L =
      -f Delta * coherentTerminalRoot (f p) (f q) eta +
        ∑ i, f (c i) * coherentAnchorRoot (f (a i)) (f p) (f q) eta := by
  classical
  obtain ⟨z, hz⟩ := hT.coherent_terminal_root_lift f hf hp hq hpq eta heta
  choose r hr using fun i =>
    hT.coherent_anchor_root_lift f hf (ha i) hp hq (hap i) (haq i) eta heta
  refine ⟨-Delta * z + ∑ i, c i * r i, ?_⟩
  simp only [map_add, map_mul, map_neg, map_sum, hz, hr]

/-- For an actual tuple in the FULL integer ring of an imaginary
quadratic field, every nonzero polynomial-weighted coherent linear form
has complex modulus at least one.  Its integrality is derived from the
tuple's square witnesses and the analytic branch identities. -/
theorem full_ring_coherent_linear_form_one_le_norm
    {K ι : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] [Fintype ι]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {p q : 𝓞 K}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (a c : ι → 𝓞 K) (Delta : 𝓞 K)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hL : -phi (Delta : K) * coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta +
      ∑ i, phi (c i : K) *
        coherentAnchorRoot (phi (a i : K)) (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 ≤ ‖-phi (Delta : K) * coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta +
      ∑ i, phi (c i : K) *
        coherentAnchorRoot (phi (a i : K)) (phi (p : K)) (phi (q : K)) eta‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  obtain ⟨L, hLimage⟩ := hT.coherent_linear_form_lift f hf hp hq hpq
    a c Delta ha hap haq eta heta
  have hL0 : L ≠ 0 := by
    intro hzero
    apply hL
    change -f Delta * coherentTerminalRoot (f p) (f q) eta +
      ∑ i, f (c i) * coherentAnchorRoot (f (a i)) (f p) (f q) eta = 0
    rw [← hLimage, hzero, map_zero]
  have hbound := one_le_norm_integer hK phi hL0
  change 1 ≤ ‖f L‖ at hbound
  rw [hLimage] at hbound
  exact hbound

end D1Bound5

#print axioms D1Bound5.IsD1.coherent_terminal_root_lift
#print axioms D1Bound5.IsD1.coherent_anchor_root_lift
#print axioms D1Bound5.IsD1.coherent_linear_form_lift
#print axioms D1Bound5.full_ring_coherent_linear_form_one_le_norm
