import D1Bound5.CoherentThreeGeneral
import D1Bound5.FourAnchorVWindow

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- Closed general-three forbidden interval, with slightly weaker
rational endpoints so that all root errors are absorbed. -/
theorem three_general_window_scalar
    (A B S P Q Z : ℝ) (hA : 0 < A) (hB : 0 < B) (hS : 0 < S)
    (hP : 0 < P) (hZ : 0 < Z)
    (hlo : (1-1/4000 : ℝ)*P*Q ≤ Z^2)
    (hhi : Z^2 ≤ (1+1/4000 : ℝ)*P*Q)
    (hform : 1 < 5*B*S^2/Z+3*S*Z/(A*P^3)) :
    Q < 101*B^2*S^4/P ∨ A^2*P^5/(37*S^2) < Q := by
  by_contra hbad
  push_neg at hbad
  have hlow : 4*(5*B*S^2)^2/(P*(1-1/4000)) ≤ Q := by
    apply le_trans _ hbad.1
    apply (div_le_div_iff₀ (by positivity) hP).2
    have hh : 0 ≤ B^2*S^4*P := by positivity
    nlinarith only [hh]
  have hupp : Q ≤ 1/(4*(3*S/(A*P^3))^2*P*(1+1/4000)) := by
    apply le_trans hbad.2
    have heq : 1/(4*(3*S/(A*P^3))^2*P*(1+1/4000)) =
        (1000/36009 : ℝ)*A^2*P^5/S^2 := by field_simp; ring
    rw [heq]
    have hp : 0 ≤ A^2*P^5/S^2 := by positivity
    have heq' : A^2*P^5/(37*S^2) = (1/37 : ℝ)*(A^2*P^5/S^2) := by ring
    rw [heq']
    nlinarith only [hp]
  exact finite_closed_window_incompatible P Q Z (5*B*S^2) (3*S/(A*P^3))
    (1/4000) hP hZ (by positivity) (by positivity) (by norm_num) (by norm_num)
    hlo hhi (by convert hform using 1 <;> ring) hlow hupp

/-- Nonzero general three-anchor forms in the full integer ring exclude
the general-three window. Integrality is supplied from actual D(1)
entries and the coherent square roots; it is not an external premise. -/
theorem full_ring_three_general_window
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {Tup : Finset (𝓞 K)} (hTup : IsD1 Tup) {p q : 𝓞 K}
    (hp : p ∈ Tup) (hq : q ∈ Tup) (hpq : p ≠ q)
    (a : Fin 3 → 𝓞 K) (hinj : Function.Injective a)
    (ha : ∀ i, a i ∈ Tup) (hap : ∀ i, a i ≠ p) (haq : ∀ i, a i ≠ q)
    (hAB : ‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hBS : ‖phi (a 1 : K)‖ ≤ ‖phi (a 2 : K)‖)
    (hP : 4*‖phi (a 2 : K)‖ ≤ ‖phi (p : K)‖)
    (hAP : 9 ≤ ‖phi (a 0 : K)‖*‖phi (p : K)‖)
    (hQ : ‖phi (p : K)‖ ≤ ‖phi (q : K)‖)
    (hPQ : 4000 ≤ ‖phi (p : K)‖*‖phi (q : K)‖)
    (eta : ℂ) (heta : eta^2 = phi (p : K)*phi (q : K))
    (hL : coherentQuotientForm (fun i => phi (a i : K))
      (coherentVandermonde3 (fun i => phi (a i : K)))
        (phi (p : K)) (phi (q : K)) eta ≠ 0) :
    ‖phi (q : K)‖ < 101*‖phi (a 1 : K)‖^2*‖phi (a 2 : K)‖^4/‖phi (p : K)‖ ∨
      ‖phi (a 0 : K)‖^2*‖phi (p : K)‖^5/(37*‖phi (a 2 : K)‖^2) < ‖phi (q : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hn (i : Fin 3) : 0 < ‖f (a i)‖ := by
    have hh := one_le_norm_integer hK phi (hTup.1 _ (ha i))
    change 1 ≤ ‖f (a i)‖ at hh
    linarith only [hh]
  have hp0 : 0 < ‖f p‖ := by have hh := hn 2; linarith only [hP,hh]
  have hq0 : 0 < ‖f q‖ := hp0.trans_le hQ
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
  have hupper := coherent_three_general_norm_lt (fun i => f (a i))
    (f p) (f q) eta (hf.comp hinj) (hn 0) hAB hBS hP hAP hQ heta
  let z := coherentTerminalRoot (f p) (f q) eta
  have hz : z^2 = f p*f q+1 := coherent_analytic_terminal_root_sq (f p) (f q) eta
    (norm_pos_iff.mp hp0) (norm_pos_iff.mp hq0) heta
  have hrel := finite_tuple_root_relative_norm (f p) (f q) z hz hPQ
  have hZ : 0 < ‖z‖ := by
    have hh := hrel.1
    have hn := norm_nonneg z
    nlinarith only [hh,hPQ,hn]
  exact three_general_window_scalar ‖f (a 0)‖ ‖f (a 1)‖ ‖f (a 2)‖
    ‖f p‖ ‖f q‖ ‖z‖ (hn 0) (hn 1) (hn 2) hp0 hZ hrel.1 hrel.2
    (hlower.trans_lt hupper)

end D1Bound5
