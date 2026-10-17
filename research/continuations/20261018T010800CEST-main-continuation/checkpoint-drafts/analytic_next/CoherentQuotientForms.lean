import D1Bound5.CoherentIntegralForms
import D1Bound5.CoherentPolynomialWeights

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The actual quotient-weighted coherent form in the manuscript. -/
noncomputable def coherentQuotientForm {m : ℕ} (a : Fin m → ℂ)
    (Delta p q eta : ℂ) : ℂ :=
  -Delta * coherentTerminalRoot p q eta +
    ∑ i, (Delta * (a i) ^ (m - 2) /
      (∏ j ∈ Finset.univ.erase i, (a i - a j))) *
        coherentAnchorRoot (a i) p q eta

/-- An explicit equality with source-ring polynomial weights transfers
the already proved integral lower bound to the manuscript quotient form. -/
theorem full_ring_coherent_quotient_form_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {p q : 𝓞 K}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    {m : ℕ} (a c : Fin m → 𝓞 K) (Delta : 𝓞 K)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (hc : ∀ i, phi (c i : K) =
      phi (Delta : K) * (phi (a i : K)) ^ (m - 2) /
        (∏ j ∈ Finset.univ.erase i, (phi (a i : K) - phi (a j : K))))
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K)) (phi (Delta : K))
      (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 ≤ ‖coherentQuotientForm (fun i => phi (a i : K)) (phi (Delta : K))
      (phi (p : K)) (phi (q : K)) eta‖ := by
  have heq : coherentQuotientForm (fun i => phi (a i : K)) (phi (Delta : K))
      (phi (p : K)) (phi (q : K)) eta =
      -phi (Delta : K) * coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta +
        ∑ i, phi (c i : K) *
          coherentAnchorRoot (phi (a i : K)) (phi (p : K)) (phi (q : K)) eta := by
    unfold coherentQuotientForm
    congr 1
    apply Finset.sum_congr rfl
    intro i hi
    rw [hc i]
  rw [heq] at hL ⊢
  exact full_ring_coherent_linear_form_one_le_norm hK phi hT hp hq hpq
    a c Delta ha hap haq eta heta hL

/-- The true two-anchor form on tuple entries is integral and hence has
modulus at least one whenever nonzero.  No coefficient-integrality or
square-root-lift hypothesis remains. -/
theorem full_ring_coherent_two_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {p q : 𝓞 K}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (a : Fin 2 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde2 a : K)) (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 ≤ ‖coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde2 a : K)) (phi (p : K)) (phi (q : K)) eta‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  exact full_ring_coherent_quotient_form_one_le_norm hK phi hT hp hq hpq
    a (coherentWeights2 a) (coherentVandermonde2 a) ha hap haq
    (fun i => map_coherentWeights2_eq_quotient f a (hf.comp hinj) i) eta heta hL

/-- The true three-anchor coherent form has the full-ring lower bound. -/
theorem full_ring_coherent_three_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {p q : 𝓞 K}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (a : Fin 3 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde3 a : K)) (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 ≤ ‖coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde3 a : K)) (phi (p : K)) (phi (q : K)) eta‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  exact full_ring_coherent_quotient_form_one_le_norm hK phi hT hp hq hpq
    a (coherentWeights3 a) (coherentVandermonde3 a) ha hap haq
    (fun i => map_coherentWeights3_eq_quotient f a (hf.comp hinj) i) eta heta hL

/-- The true four-anchor coherent form has the full-ring lower bound. -/
theorem full_ring_coherent_four_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {p q : 𝓞 K}
    (hp : p ∈ T) (hq : q ∈ T) (hpq : p ≠ q)
    (a : Fin 4 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ T) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde4 a : K)) (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 ≤ ‖coherentQuotientForm (fun i => phi (a i : K))
      (phi (coherentVandermonde4 a : K)) (phi (p : K)) (phi (q : K)) eta‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  exact full_ring_coherent_quotient_form_one_le_norm hK phi hT hp hq hpq
    a (coherentWeights4 a) (coherentVandermonde4 a) ha hap haq
    (fun i => map_coherentWeights4_eq_quotient f a (hf.comp hinj) i) eta heta hL

end D1Bound5

#print axioms D1Bound5.full_ring_coherent_two_one_le_norm
#print axioms D1Bound5.full_ring_coherent_three_one_le_norm
#print axioms D1Bound5.full_ring_coherent_four_one_le_norm
