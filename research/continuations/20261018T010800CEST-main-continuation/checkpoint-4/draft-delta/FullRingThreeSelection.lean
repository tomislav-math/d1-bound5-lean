import D1Bound5.CoherentThreeSeparated

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The separated three-anchor inequality for actual integral entries.
Only the vanishing decision is left to a subsequent four-anchor lemma. -/
theorem full_ring_three_separated_norm_inequality
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup) {p q : 𝓞 K}
    (hp : p ∈ Tup) (hq : q ∈ Tup) (hpq : p ≠ q)
    (a : Fin 3 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ Tup) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hP : 0 < ‖phi (p : K)‖) (hAP : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (p : K)‖)
    (hQ : 4*‖phi (p : K)‖ ≤ ‖phi (q : K)‖)
    (hPQ : 10000 < ‖phi (p : K)‖*‖phi (q : K)‖)
    (eta : ℂ) (heta : eta^2 = phi (p : K)*phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K))
      (coherentVandermonde3 (fun i => phi (a i : K)))
        (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    1 < 5*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^2/
          ‖coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta‖ +
      3*‖phi (a 2 : K)‖*‖coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta‖/
        (4*‖phi (a 0 : K)‖*‖phi (p : K)‖^3) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hA1 : 1 ≤ ‖f (a 0)‖ := one_le_norm_integer hK phi (hTup.1 _ (ha 0))
  have hdelta : phi ((coherentVandermonde3 a : 𝓞 K) : K) =
      coherentVandermonde3 (fun i => phi (a i : K)) := by
    change f (coherentVandermonde3 a) = coherentVandermonde3 (fun i => f (a i))
    simp [coherentVandermonde3]
  have hL' : coherentQuotientForm (fun i => phi (a i : K))
      (phi ((coherentVandermonde3 a : 𝓞 K) : K))
        (phi (p : K)) (phi (q : K)) eta ≠ 0 := by rwa [hdelta]
  have hlower := full_ring_coherent_three_one_le_norm hK phi hTup hp hq hpq
    a hinj ha hap haq eta heta hL'
  rw [hdelta] at hlower
  have hupper := (coherent_three_separated_bounds (fun i => f (a i))
    (f p) (f q) eta (hf.comp hinj) (by linarith only [hA1]) hAB hBS
    hP hAP hQ hPQ heta).1
  exact hlower.trans_lt hupper

/-- Four actual anchors select a nonzero integral three-anchor form.
Both alternatives use the same analytic terminal root, and the smaller
third anchor is bounded by the fourth. -/
theorem full_ring_four_anchor_three_separated_inequality
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup) {p q : 𝓞 K}
    (hp : p ∈ Tup) (hq : q ∈ Tup) (hpq : p ≠ q)
    (a : Fin 4 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ Tup) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hP : 1000 ≤ ‖phi (p : K)‖)
    (hTP : 4*‖phi (a 3 : K)‖ ≤ ‖phi (p : K)‖)
    (hQ : 4*‖phi (p : K)‖ ≤ ‖phi (q : K)‖)
    (hsize : 32*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖/
      ‖phi (a 0 : K)‖^3 ≤ ‖phi (p : K)‖^2)
    (eta : ℂ) (heta : eta^2 = phi (p : K)*phi (q : K)) :
    1 < 5*‖phi (a 1 : K)‖*‖phi (a 3 : K)‖^2/
          ‖coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta‖ +
      3*‖phi (a 3 : K)‖*‖coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta‖/
        (4*‖phi (a 0 : K)‖*‖phi (p : K)‖^3) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hA1 : 1 ≤ ‖f (a 0)‖ := one_le_norm_integer hK phi (hTup.1 _ (ha 0))
  have hP0 : 0 < ‖f p‖ := by linarith only [hP]
  have hAP : 1000 ≤ ‖f (a 0)‖*‖f p‖ := by
    have hh := mul_le_mul_of_nonneg_right hA1 hP0.le
    nlinarith only [hh,hP]
  have hPQ : 10000 < ‖f p‖*‖f q‖ := by
    have hh := mul_le_mul_of_nonneg_left hQ hP0.le
    nlinarith only [hh,hP,sq_nonneg (‖f p‖-1000)]
  have hn := coherent_three_quotient_forms_not_both_zero (fun i => f (a i))
    (hf.comp hinj) (f p) (f q) eta heta hA1
    (hmon (by decide)) (hmon (by decide)) (hmon (by decide))
    (by have hh := norm_nonneg (f (a 3)); linarith only [hTP,hh])
    (by linarith only [hQ,hP0]) hsize
  let b : Fin 3 → 𝓞 K := coherentTriple012 a
  let c : Fin 3 → 𝓞 K := coherentTriple013 a
  have hb : Function.Injective b :=
    hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 4))
  have hc : Function.Injective c :=
    hinj.comp (by decide : Function.Injective (![0,1,3] : Fin 3 → Fin 4))
  rcases hn with hn | hn
  · have hout := full_ring_three_separated_norm_inequality hK phi hTup hp hq hpq
      b hb (fun i => ha _) (fun i => hap _) (fun i => haq _)
      (hmon (by decide : (0 : Fin 4) ≤ 1)) (hmon (by decide : (1 : Fin 4) ≤ 2))
      hP0 hAP hQ hPQ eta heta hn
    apply hout.trans_le
    dsimp [b,coherentTriple012]
    gcongr <;> exact hmon (by decide : (2 : Fin 4) ≤ 3)
  · exact full_ring_three_separated_norm_inequality hK phi hTup hp hq hpq
      c hc (fun i => ha _) (fun i => hap _) (fun i => haq _)
      (hmon (by decide : (0 : Fin 4) ≤ 1)) (hmon (by decide : (1 : Fin 4) ≤ 3))
      hP0 hAP hQ hPQ eta heta hn

end D1Bound5
