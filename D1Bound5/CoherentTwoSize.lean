import D1Bound5.CoherentTwoVanishing
import D1Bound5.CoherentQuotientForms

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- A denominator-free numerical estimate underlying the two-anchor
nonvanishing argument.  The safe bound `5/4` on the scaled product of
three roots is slightly weaker than its exact square-root value, but
still gives the manuscript's strict constant five. -/
theorem coherent_two_scalar_size_bound
    (A B P U Q : ℝ)
    (hA : 1 ≤ A) (hB : 3 ≤ B) (hP : 5 * B ≤ P) (hU0 : 0 ≤ U)
    (hU : U ^ 2 ≤ (A * B + 1) * (A * P + 1) * (B * P + 1))
    (hQ : Q ≤ A + B + P + 2 * A * B * P + 2 * U) :
    Q < 5 * A * B * P := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := by linarith
  have hP15 : 15 ≤ P := by linarith
  have hP0 : 0 < P := by linarith
  have hAB : 3 ≤ A * B := by
    have h := mul_le_mul hA hB (by norm_num : (0 : ℝ) ≤ 3) hA0.le
    nlinarith only [h]
  have hAP : 15 ≤ A * P := by
    have h := mul_le_mul hA hP15 (by norm_num : (0 : ℝ) ≤ 15) hA0.le
    nlinarith only [h]
  have hBP : 45 ≤ B * P := by
    have h := mul_le_mul hB hP15 (by norm_num : (0 : ℝ) ≤ 15) hB0.le
    nlinarith only [h]
  have h1 : A * B + 1 ≤ (4 / 3 : ℝ) * (A * B) := by linarith
  have h2 : A * P + 1 ≤ (16 / 15 : ℝ) * (A * P) := by linarith
  have h3 : B * P + 1 ≤ (46 / 45 : ℝ) * (B * P) := by linarith
  have hprod : (A * B + 1) * (A * P + 1) * (B * P + 1) ≤
      ((4 / 3 : ℝ) * (A * B)) * ((16 / 15 : ℝ) * (A * P)) *
        ((46 / 45 : ℝ) * (B * P)) :=
    mul_le_mul (mul_le_mul h1 h2 (by positivity) (by positivity)) h3
      (by positivity) (by positivity)
  have hscaled : U ^ 2 ≤ (2944 / 2025 : ℝ) * (A * B * P) ^ 2 := by
    calc
      U ^ 2 ≤ (A * B + 1) * (A * P + 1) * (B * P + 1) := hU
      _ ≤ _ := hprod
      _ = (2944 / 2025 : ℝ) * (A * B * P) ^ 2 := by ring
  have hT : 0 < A * B * P := by positivity
  have hUsq : U ^ 2 < ((5 / 4 : ℝ) * (A * B * P)) ^ 2 := by
    nlinarith only [hscaled, sq_pos_of_pos hT]
  have hUbound : U < (5 / 4 : ℝ) * (A * B * P) :=
    (sq_lt_sq₀ hU0 (by positivity)).mp hUsq
  have hAbound : 45 * A ≤ A * B * P := by
    have h := mul_le_mul_of_nonneg_left hBP hA0.le
    nlinarith only [h]
  have hBbound : 15 * B ≤ A * B * P := by
    have h := mul_le_mul_of_nonneg_left hAP hB0.le
    nlinarith only [h]
  have hPbound : 3 * P ≤ A * B * P := by
    have h := mul_le_mul_of_nonneg_right hAB hP0.le
    nlinarith only [h]
  have hsum : A + B + P ≤ (19 / 45 : ℝ) * (A * B * P) := by
    nlinarith only [hAbound, hBbound, hPbound]
  nlinarith only [hQ, hsum, hUbound, hT]

/-- The regular equation gives the usual two algebraic extensions of
a triple.  No division or nonzero-square-root hypothesis is used. -/
theorem regular_quadruple_eq_extensions
    {F : Type*} [Field F] (a b p q r s t : F)
    (hr : r ^ 2 = a * b + 1) (hs : s ^ 2 = a * p + 1)
    (ht : t ^ 2 = b * p + 1)
    (hreg : (a + b - p - q) ^ 2 = 4 * (a * b + 1) * (p * q + 1)) :
    q = a + b + p + 2 * a * b * p + 2 * (r * s * t) ∨
    q = a + b + p + 2 * a * b * p - 2 * (r * s * t) := by
  have hsq : (q - (a + b + p + 2 * a * b * p)) ^ 2 =
      (2 * (r * s * t)) ^ 2 := by
    linear_combination hreg - 4 * s ^ 2 * t ^ 2 * hr -
      4 * (a * b + 1) * t ^ 2 * hs -
      4 * (a * b + 1) * (a * p + 1) * ht
  rcases sq_eq_sq_iff_eq_or_eq_neg.mp hsq with h | h
  · left
    linear_combination h
  · right
    linear_combination h

/-- A regular complex quadruple with the size hypotheses used in the
strong two-anchor lemma has `Q < 5 A B P`. -/
theorem regular_quadruple_norm_lt_five
    (a b p q r s t : ℂ)
    (hr : r ^ 2 = a * b + 1) (hs : s ^ 2 = a * p + 1)
    (ht : t ^ 2 = b * p + 1)
    (hreg : (a + b - p - q) ^ 2 = 4 * (a * b + 1) * (p * q + 1))
    (hA : 1 ≤ ‖a‖) (hB : 3 ≤ ‖b‖) (hP : 5 * ‖b‖ ≤ ‖p‖) :
    ‖q‖ < 5 * ‖a‖ * ‖b‖ * ‖p‖ := by
  have hroot (u v w : ℂ) (hw : w ^ 2 = u * v + 1) :
      ‖w‖ ^ 2 ≤ ‖u‖ * ‖v‖ + 1 := by
    calc
      ‖w‖ ^ 2 = ‖w ^ 2‖ := (norm_pow w 2).symm
      _ = ‖u * v + 1‖ := by rw [hw]
      _ ≤ ‖u‖ * ‖v‖ + 1 := by
        simpa only [norm_mul, norm_one] using norm_add_le (u * v) (1 : ℂ)
  have hnr := hroot a b r hr
  have hns := hroot a p s hs
  have hnt := hroot b p t ht
  have hU : ‖r * s * t‖ ^ 2 ≤
      (‖a‖ * ‖b‖ + 1) * (‖a‖ * ‖p‖ + 1) * (‖b‖ * ‖p‖ + 1) := by
    rw [norm_mul, norm_mul, mul_pow, mul_pow]
    exact mul_le_mul (mul_le_mul hnr hns (sq_nonneg _) (by positivity)) hnt
      (sq_nonneg _) (by positivity)
  have hcenter : ‖a + b + p + 2 * a * b * p‖ ≤
      ‖a‖ + ‖b‖ + ‖p‖ + 2 * ‖a‖ * ‖b‖ * ‖p‖ := by
    have h1 := norm_add_le a b
    have h2 := norm_add_le (a + b) p
    have h3 := norm_add_le (a + b + p) (2 * a * b * p)
    simp only [norm_mul, Complex.norm_two] at h3
    linarith
  have hpert : ‖(2 : ℂ) * (r * s * t)‖ = 2 * ‖r * s * t‖ := by
    rw [norm_mul, Complex.norm_two]
  have hQ : ‖q‖ ≤ ‖a‖ + ‖b‖ + ‖p‖ + 2 * ‖a‖ * ‖b‖ * ‖p‖ +
      2 * ‖r * s * t‖ := by
    rcases regular_quadruple_eq_extensions a b p q r s t hr hs ht hreg with h | h
    · rw [h]
      have hh := norm_add_le (a + b + p + 2 * a * b * p) (2 * (r * s * t))
      rw [hpert] at hh
      linarith
    · rw [h]
      have hh := norm_sub_le (a + b + p + 2 * a * b * p) (2 * (r * s * t))
      rw [hpert] at hh
      linarith
  exact coherent_two_scalar_size_bound ‖a‖ ‖b‖ ‖p‖ ‖r * s * t‖ ‖q‖
    hA hB hP (norm_nonneg _) hU hQ

/-- The manuscript's actual large-terminal size hypothesis forces the
two-anchor coherent form nonzero, with no nonvanishing premise. -/
theorem coherent_analytic_two_ne_zero_of_large_terminal
    (a b p q eta r s t : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hp : p ≠ 0) (hq : q ≠ 0) (hab : a ≠ b)
    (heta : eta ^ 2 = p * q)
    (hr : r ^ 2 = a * b + 1) (hs : s ^ 2 = a * p + 1)
    (ht : t ^ 2 = b * p + 1)
    (hA : 1 ≤ ‖a‖) (hB : 3 ≤ ‖b‖) (hP : 5 * ‖b‖ ≤ ‖p‖)
    (hQ : 5 * ‖a‖ * ‖b‖ * ‖p‖ ≤ ‖q‖) :
    coherentAnchorRoot a p q eta - coherentAnchorRoot b p q eta -
      (a - b) * coherentTerminalRoot p q eta ≠ 0 := by
  apply coherent_analytic_two_ne_zero_of_not_regular a b p q eta ha hb hp hq hab heta
  intro hreg
  exact (not_lt_of_ge hQ) (regular_quadruple_norm_lt_five a b p q r s t
    hr hs ht hreg hA hB hP)

/-- The arithmetic and analytic bridges combined for actual tuple
entries.  The paper's size assumptions force the coherent form nonzero
and therefore give its integral lower bound, with neither fact assumed. -/
theorem full_ring_coherent_two_nonzero_and_one_le_norm
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) (a b p q : 𝓞 K)
    (ha : a ∈ T) (hb : b ∈ T) (hp : p ∈ T) (hq : q ∈ T)
    (hab : a ≠ b) (hap : a ≠ p) (haq : a ≠ q)
    (hbp : b ≠ p) (hbq : b ≠ q) (hpq : p ≠ q)
    (eta : ℂ) (heta : eta ^ 2 = phi (p : K) * phi (q : K))
    (hB : 3 ≤ ‖phi (b : K)‖) (hP : 5 * ‖phi (b : K)‖ ≤ ‖phi (p : K)‖)
    (hQ : 5 * ‖phi (a : K)‖ * ‖phi (b : K)‖ * ‖phi (p : K)‖ ≤ ‖phi (q : K)‖) :
    let L := coherentAnchorRoot (phi (a : K)) (phi (p : K)) (phi (q : K)) eta -
      coherentAnchorRoot (phi (b : K)) (phi (p : K)) (phi (q : K)) eta -
      (phi (a : K) - phi (b : K)) *
        coherentTerminalRoot (phi (p : K)) (phi (q : K)) eta
    L ≠ 0 ∧ 1 ≤ ‖L‖ := by
  dsimp only
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hnz (u : 𝓞 K) (hu : u ∈ T) : f u ≠ 0 := by
    intro h
    exact hT.1 u hu (hf (by simpa only [map_zero] using h))
  obtain ⟨r, hr⟩ := hT.2 a ha b hb hab
  obtain ⟨s, hs⟩ := hT.2 a ha p hp hap
  obtain ⟨t, ht⟩ := hT.2 b hb p hp hbp
  have hr' : (f r) ^ 2 = f a * f b + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f hr
  have hs' : (f s) ^ 2 = f a * f p + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f hs
  have ht' : (f t) ^ 2 = f b * f p + 1 := by
    simpa only [pow_two, map_mul, map_add, map_one] using congrArg f ht
  have hnonzero := coherent_analytic_two_ne_zero_of_large_terminal
    (f a) (f b) (f p) (f q) eta (f r) (f s) (f t)
    (hnz a ha) (hnz b hb) (hnz p hp) (hnz q hq) (fun h => hab (hf h))
    heta hr' hs' ht' (one_le_norm_integer hK phi (hT.1 a ha)) hB hP hQ
  refine ⟨hnonzero, ?_⟩
  let av : Fin 2 → 𝓞 K := ![a, b]
  let cv : Fin 2 → 𝓞 K := ![1, -1]
  have hav : ∀ i, av i ∈ T := by
    intro i
    fin_cases i <;> simp [av, ha, hb]
  have havp : ∀ i, av i ≠ p := by
    intro i
    fin_cases i <;> simp [av, hap, hbp]
  have havq : ∀ i, av i ≠ q := by
    intro i
    fin_cases i <;> simp [av, haq, hbq]
  have hE :
      -phi ((a - b : 𝓞 K) : K) * coherentTerminalRoot (f p) (f q) eta +
        (∑ i : Fin 2, phi (cv i : K) * coherentAnchorRoot (phi (av i : K)) (f p) (f q) eta) =
      coherentAnchorRoot (f a) (f p) (f q) eta -
        coherentAnchorRoot (f b) (f p) (f q) eta -
        (f a - f b) * coherentTerminalRoot (f p) (f q) eta := by
    change -f (a - b) * coherentTerminalRoot (f p) (f q) eta +
      (∑ i : Fin 2, f (cv i) * coherentAnchorRoot (f (av i)) (f p) (f q) eta) = _
    simp [Fin.sum_univ_two, av, cv]
    ring
  have hE0 :
      -phi ((a - b : 𝓞 K) : K) * coherentTerminalRoot (f p) (f q) eta +
        (∑ i : Fin 2, phi (cv i : K) * coherentAnchorRoot (phi (av i : K)) (f p) (f q) eta) ≠ 0 := by
    rw [hE]
    exact hnonzero
  have hlow := full_ring_coherent_linear_form_one_le_norm hK phi hT hp hq hpq
    av cv (a - b) hav havp havq eta heta hE0
  change 1 ≤ ‖-phi ((a - b : 𝓞 K) : K) * coherentTerminalRoot (f p) (f q) eta +
    (∑ i : Fin 2, phi (cv i : K) * coherentAnchorRoot (phi (av i : K)) (f p) (f q) eta)‖ at hlow
  rw [hE] at hlow
  exact hlow

end D1Bound5

