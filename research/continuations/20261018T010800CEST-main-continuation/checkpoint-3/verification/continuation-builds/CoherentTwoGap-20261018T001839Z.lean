import D1Bound5.CoherentTwoUpper
import D1Bound5.CoherentTwoSize

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The quotient-weighted two-anchor form is exactly the difference
of its two actual coherent anchor roots and its terminal-root term. -/
theorem coherentQuotientForm_two_eq
    (a : Fin 2 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ) :
    coherentQuotientForm a (a 0 - a 1) p q eta =
      coherentAnchorRoot (a 0) p q eta - coherentAnchorRoot (a 1) p q eta -
        (a 0 - a 1) * coherentTerminalRoot p q eta := by
  have hw (i : Fin 2) :
      (a 0 - a 1) * a i ^ (2 - 2) /
          (∏ j ∈ Finset.univ.erase i, (a i - a j)) = coherentWeights2 a i := by
    exact (coherentWeights2_eq_quotient a hinj i).symm
  unfold coherentQuotientForm
  simp_rw [hw]
  simp [Fin.sum_univ_two, coherentWeights2]
  ring

/-- The quantitative two-anchor gap after the analytic upper bound
and integral lower bound have been supplied.  The root-size inputs are
only the elementary consequences of `z^2=pq+1`. -/
theorem coherent_two_strong_gap_scalar
    (A B P Q Z : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B) (hP : 5 * B ≤ P)
    (hAP : 32 ≤ A * P) (hQ : 5 * A * B * P ≤ Q)
    (hPQ : 10000 < P * Q) (hZ : 0 ≤ Z)
    (hZlower : P * Q - 1 ≤ Z ^ 2) (hZupper : Z ^ 2 ≤ P * Q + 1)
    (hbound : 1 < 21 * B / (20 * Z) + Z / (2 * A * P ^ 2)) :
    A ^ 2 * P ^ 3 < (10001 / 10000 : ℝ) * Q := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := by linarith
  have hP0 : 0 < P := by linarith
  have hAP0 : 0 < A * P := by positivity
  have hBP : B ^ 2 ≤ B * P := by
    have h := mul_le_mul_of_nonneg_left (show B ≤ P by linarith) hB0.le
    nlinarith only [h]
  have hPQlower : 5 * (A * P) * B ^ 2 ≤ P * Q := by
    have h1 := mul_le_mul_of_nonneg_left hBP (by positivity : 0 ≤ 5 * (A * P))
    have h2 := mul_le_mul_of_nonneg_left hQ hP0.le
    nlinarith only [h1, h2]
  have h160 : 160 * B ^ 2 ≤ 5 * (A * P) * B ^ 2 := by
    have h := mul_le_mul_of_nonneg_right hAP (by positivity : 0 ≤ 5 * B ^ 2)
    nlinarith only [h]
  have hBsq : 9 ≤ B ^ 2 := by nlinarith only [hB, sq_nonneg (B-3)]
  have hZsq : (3 * B) ^ 2 < Z ^ 2 := by
    nlinarith only [hZlower, hPQlower, h160, hBsq]
  have hZ3 : 3 * B < Z := (sq_lt_sq₀ (by positivity) hZ).mp hZsq
  have hZ0 : 0 < Z := by linarith
  have hfirst : 21 * B / (20 * Z) < (1 / 2 : ℝ) := by
    apply (div_lt_iff₀ (by positivity)).2
    nlinarith only [hZ3, hB0]
  have hsecond : (1 / 2 : ℝ) < Z / (2 * A * P ^ 2) := by
    linarith only [hbound, hfirst]
  have hZgap : A * P ^ 2 < Z := by
    have h := (lt_div_iff₀ (by positivity : 0 < 2 * A * P ^ 2)).mp hsecond
    nlinarith only [h]
  have hsquare : (A * P ^ 2) ^ 2 < Z ^ 2 :=
    (sq_lt_sq₀ (by positivity) hZ).mpr hZgap
  have hPQupper : P * Q + 1 < (10001 / 10000 : ℝ) * (P * Q) := by
    nlinarith only [hPQ]
  apply (mul_lt_mul_iff_of_pos_right hP0).mp
  nlinarith only [hsquare, hZupper, hPQupper]

/-- The strong two-anchor gap for genuine entries of the full ring of
integers.  Nonvanishing, coefficient integrality, coherent branch bounds,
the complete homogeneous tail, and the integral modulus lower bound
are all discharged by the proved preceding results. -/
theorem full_ring_coherent_two_strong_gap
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) {a b p q : 𝓞 K}
    (ha : a ∈ T) (hb : b ∈ T) (hp : p ∈ T) (hq : q ∈ T)
    (hab : a ≠ b) (hap : a ≠ p) (haq : a ≠ q)
    (hbp : b ≠ p) (hbq : b ≠ q) (hpq : p ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hB : 3 ≤ ‖phi (b : K)‖) (hP : 5 * ‖phi (b : K)‖ ≤ ‖phi (p : K)‖)
    (hAP : 32 ≤ ‖phi (a : K)‖ * ‖phi (p : K)‖)
    (hQ : 5 * ‖phi (a : K)‖ * ‖phi (b : K)‖ * ‖phi (p : K)‖ ≤ ‖phi (q : K)‖)
    (hPQ : 10000 < ‖phi (p : K)‖ * ‖phi (q : K)‖) :
    ‖phi (a : K)‖ ^ 2 * ‖phi (p : K)‖ ^ 3 <
      (10001 / 10000 : ℝ) * ‖phi (q : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let av : Fin 2 → ℂ := ![f a, f b]
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hinj : Function.Injective av := by
    intro i j hij
    fin_cases i <;> fin_cases j
    · rfl
    · exact False.elim (hab (hf hij))
    · exact False.elim (hab (hf hij.symm))
    · rfl
  have hA : 1 ≤ ‖f a‖ := one_le_norm_integer hK phi (hT.1 a ha)
  have hA0 : 0 < ‖f a‖ := by linarith
  have hP0 : 0 < ‖f p‖ := by change 0 < ‖phi (p : K)‖; nlinarith only [hB, hP]
  have hQ0 : 0 < ‖f q‖ := by
    have h := one_le_norm_integer hK phi (hT.1 q hq)
    change 0 < ‖phi (q : K)‖
    linarith
  have hQ4 : 4 * ‖f p‖ ≤ ‖f q‖ := by
    have hAB3 : 3 ≤ ‖f a‖ * ‖f b‖ := by
      have h := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 3) hA0.le
      nlinarith only [h]
    have h := mul_le_mul_of_nonneg_right hAB3 hP0.le
    change 4 * ‖phi (p : K)‖ ≤ ‖phi (q : K)‖
    nlinarith only [h, hQ, hP0]
  have hlow := (full_ring_coherent_two_nonzero_and_one_le_norm hK phi hT
    a b p q ha hb hp hq hab hap haq hbp hbq hpq eta heta hB hP hQ).2
  have hupp := coherent_two_norm_lt av (f p) (f q) eta hinj hA0 hP0 hAB
    hAP hQ4 hPQ heta
  rw [coherentQuotientForm_two_eq av hinj] at hupp
  have hbound : 1 < 21 * ‖f b‖ / (20 * ‖coherentTerminalRoot (f p) (f q) eta‖) +
      ‖coherentTerminalRoot (f p) (f q) eta‖ / (2 * ‖f a‖ * ‖f p‖ ^ 2) := by
    exact hlow.trans_lt hupp
  have hzsq : (coherentTerminalRoot (f p) (f q) eta) ^ 2 = f p * f q + 1 :=
    coherent_analytic_terminal_root_sq (f p) (f q) eta
      (norm_pos_iff.mp hP0) (norm_pos_iff.mp hQ0) heta
  have hnorm : ‖coherentTerminalRoot (f p) (f q) eta‖ ^ 2 = ‖f p * f q + 1‖ := by
    simpa only [norm_pow] using congrArg norm hzsq
  have hZupper : ‖coherentTerminalRoot (f p) (f q) eta‖ ^ 2 ≤ ‖f p‖ * ‖f q‖ + 1 := by
    rw [hnorm]
    simpa only [norm_mul, norm_one] using norm_add_le (f p * f q) (1 : ℂ)
  have hZlower : ‖f p‖ * ‖f q‖ - 1 ≤ ‖coherentTerminalRoot (f p) (f q) eta‖ ^ 2 := by
    have h := norm_sub_le (f p * f q + 1) (1 : ℂ)
    simp only [add_sub_cancel_right, norm_mul, norm_one, ← hnorm] at h
    linarith
  exact coherent_two_strong_gap_scalar ‖f a‖ ‖f b‖ ‖f p‖ ‖f q‖
    ‖coherentTerminalRoot (f p) (f q) eta‖ hA hB hP hAP hQ hPQ
    (norm_nonneg _) hZlower hZupper hbound

end D1Bound5

