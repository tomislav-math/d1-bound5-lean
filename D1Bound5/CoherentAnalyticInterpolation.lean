import D1Bound5.ComplexHalfBinomial
import D1Bound5.HalfBinomialAnalytic
import D1Bound5.InterpolationWeights
import Mathlib.Analysis.Complex.Basic


open Finset Polynomial

namespace D1Bound5

/-- The low-degree moments in the coherent interpolation identity.  The
inverse-power form is the one obtained directly from a convergent Taylor
series at each anchor. -/
theorem coherent_anchor_power_moment_low
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hs : s.Nonempty)
    (ha : ∀ i ∈ s, a i ≠ 0) (hinj : Set.InjOn a s)
    (n : ℕ) (hn : n < s.card) :
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
      (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ n) =
      if n = 0 then 1 else 0 := by
  have hterm (i : ι) (hi : i ∈ s) :
      (a i) ^ (s.card - 1) * ((a i)⁻¹) ^ n =
        (a i) ^ (s.card - 1 - n) := by
    rw [inv_pow, ← div_eq_mul_inv]
    apply (div_eq_iff (pow_ne_zero n (ha i hi))).2
    rw [← pow_add]
    congr 1
    omega
  have hsum :
      (∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ n) =
      ∑ i ∈ s, (a i) ^ (s.card - 1 - n) /
        (∏ j ∈ s.erase i, (a i - a j)) := by
    apply Finset.sum_congr rfl
    intro i hi
    calc
      ((a i) ^ (s.card - 1) /
          (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ n =
        ((a i) ^ (s.card - 1) * ((a i)⁻¹) ^ n) /
          (∏ j ∈ s.erase i, (a i - a j)) := by ring
      _ = _ := by rw [hterm i hi]
  rw [hsum]
  have hdeg : ((X : F[X]) ^ (s.card - 1 - n)).degree <
      (s.card : WithBot ℕ) := by
    rw [Polynomial.degree_X_pow]
    exact_mod_cast (show s.card - 1 - n < s.card by omega)
  have h := Lagrange.coeff_eq_sum (s := s) (v := a)
    (P := (X : F[X]) ^ (s.card - 1 - n)) hinj hdeg
  by_cases hn0 : n = 0
  · subst n
    simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow] using h.symm
  · have hne : s.card - 1 - n ≠ s.card - 1 := by omega
    simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow, hne, Ne.symm hne, hn0]
      using h.symm

/-- Every remaining Taylor moment is a complete homogeneous polynomial
in the reciprocal anchors, with the exact sign and product denominator. -/
theorem coherent_anchor_power_moment_high
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hs : s.Nonempty)
    (ha : ∀ i ∈ s, a i ≠ 0) (hinj : Set.InjOn a s) (k : ℕ) :
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
      (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ (s.card + k)) =
      ((-1 : F) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
        MvPolynomial.aeval (fun i : s => (a i)⁻¹)
          (MvPolynomial.hsymm s F k) := by
  have hcard : 0 < s.card := hs.card_pos
  have hexp : s.card + k = (s.card - 1) + (k + 1) := by omega
  have hterm (i : ι) (hi : i ∈ s) :
      (a i) ^ (s.card - 1) * ((a i)⁻¹) ^ (s.card + k) =
        ((a i)⁻¹) ^ (k + 1) := by
    rw [hexp, pow_add, ← mul_assoc, ← mul_pow]
    simp [ha i hi]
  calc
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ (s.card + k)) =
      ∑ i ∈ s, ((a i)⁻¹) ^ (k + 1) /
        (∏ j ∈ s.erase i, (a i - a j)) := by
      apply Finset.sum_congr rfl
      intro i hi
      calc
        ((a i) ^ (s.card - 1) /
            (∏ j ∈ s.erase i, (a i - a j))) * ((a i)⁻¹) ^ (s.card + k) =
          ((a i) ^ (s.card - 1) * ((a i)⁻¹) ^ (s.card + k)) /
            (∏ j ∈ s.erase i, (a i - a j)) := by ring
        _ = _ := by rw [hterm i hi]
    _ = _ := reciprocal_anchor_sum_eq_hsymm s a hs ha hinj k

/-- Exact interpolation of a convergent complex Taylor series.  This
proves convergence of the homogeneous tail from convergence at the finitely
many distinct nonzero anchors.  No majorant or desired interpolation
identity is included among the hypotheses. -/
theorem coherent_interpolation_series_exact
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (hs : s.Nonempty)
    (ha : ∀ i ∈ s, a i ≠ 0) (hinj : Set.InjOn a s)
    (c : ℕ → ℂ) (g : ι → ℂ)
    (hc : ∀ i ∈ s, HasSum (fun n : ℕ => c n * ((a i)⁻¹) ^ n) (g i)) :
    Summable (fun k : ℕ => c (s.card + k) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ k)) ∧
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
      (∏ j ∈ s.erase i, (a i - a j))) * g i) =
      c 0 + ((-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
        ∑' k : ℕ, c (s.card + k) *
          MvPolynomial.aeval (fun i : s => (a i)⁻¹)
            (MvPolynomial.hsymm s ℂ k) := by
  let w : ι → ℂ := fun i =>
    (a i) ^ (s.card - 1) / (∏ j ∈ s.erase i, (a i - a j))
  let M : ℕ → ℂ := fun n => ∑ i ∈ s, w i * ((a i)⁻¹) ^ n
  let H : ℕ → ℂ := fun k =>
    MvPolynomial.aeval (fun i : s => (a i)⁻¹) (MvPolynomial.hsymm s ℂ k)
  let A : ℂ := (-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹
  let lhs : ℂ := ∑ i ∈ s, w i * g i
  have hfull : HasSum (fun n : ℕ => c n * M n) lhs := by
    have h := hasSum_sum (s := s) (fun i hi => (hc i hi).mul_left (w i))
    refine h.congr_fun ?_
    intro n
    dsimp only [M]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    ring
  have hprefix : (∑ n ∈ Finset.range s.card, c n * M n) = c 0 := by
    calc
      (∑ n ∈ Finset.range s.card, c n * M n) =
        ∑ n ∈ Finset.range s.card, if n = 0 then c 0 else 0 := by
        apply Finset.sum_congr rfl
        intro n hn
        have hm : M n = if n = 0 then 1 else 0 :=
          coherent_anchor_power_moment_low s a hs ha hinj n (Finset.mem_range.mp hn)
        rw [hm]
        by_cases hn0 : n = 0 <;> simp [hn0]
      _ = c 0 := by simp [hs.card_pos]
  have htailRaw := (hasSum_nat_add_iff' s.card).2 hfull
  rw [hprefix] at htailRaw
  have htail : HasSum (fun k : ℕ => A * (c (s.card + k) * H k)) (lhs - c 0) := by
    refine htailRaw.congr_fun ?_
    intro k
    have hm : M (s.card + k) = A * H k :=
      coherent_anchor_power_moment_high s a hs ha hinj k
    rw [Nat.add_comm k s.card, hm]
    ring
  have hA : A ≠ 0 := by
    apply mul_ne_zero (pow_ne_zero _ (by norm_num))
    exact inv_ne_zero (Finset.prod_ne_zero_iff.mpr ha)
  have hsum : Summable (fun k : ℕ => c (s.card + k) * H k) :=
    (summable_mul_left_iff hA).mp htail.summable
  refine ⟨hsum, ?_⟩
  have heq := htail.tsum_eq
  rw [tsum_mul_left] at heq
  change lhs = c 0 + A * ∑' k : ℕ, c (s.card + k) * H k
  calc
    lhs = c 0 + (lhs - c 0) := by ring
    _ = _ := by rw [heq]

/-- The manuscript's exact coherent interpolation identity for the actual
principal square-root products, before multiplying by the Vandermonde and
the chosen square root of `pq`.  All analytic convergence is proved. -/
theorem coherent_half_binomial_exact
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (hs : s.Nonempty)
    (ha : ∀ i ∈ s, a i ≠ 0) (hinj : Set.InjOn a s)
    (x y : ℂ)
    (hx : ∀ i ∈ s, ‖x * (a i)⁻¹‖ < 1)
    (hy : ∀ i ∈ s, ‖y * (a i)⁻¹‖ < 1) :
    Summable (fun k : ℕ => halfBinomialWeightedCoeff x y (s.card + k) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ k)) ∧
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
      (∏ j ∈ s.erase i, (a i - a j))) *
        (((1 + x * (a i)⁻¹) ^ (1 / 2 : ℂ)) *
          ((1 + y * (a i)⁻¹) ^ (1 / 2 : ℂ)))) =
      1 + ((-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
        ∑' k : ℕ, halfBinomialWeightedCoeff x y (s.card + k) *
          MvPolynomial.aeval (fun i : s => (a i)⁻¹)
            (MvPolynomial.hsymm s ℂ k) := by
  have h := coherent_interpolation_series_exact s a hs ha hinj
    (halfBinomialWeightedCoeff x y)
    (fun i => ((1 + x * (a i)⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + y * (a i)⁻¹) ^ (1 / 2 : ℂ)))
    (fun i hi => halfBinomialCoeff_weighted_hasSum x y (a i)⁻¹ (hx i hi) (hy i hi))
  simpa [halfBinomialWeightedCoeff, halfBinomialCoeff] using h

/-- The exact coherent identity with its leading coefficient separated
from the positive-degree homogeneous tail.  The left side is the analytic
normalization of the paper's `L_m / (Delta_m * eta)`. -/
theorem coherent_half_binomial_exact_split
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (hs : s.Nonempty)
    (ha : ∀ i ∈ s, a i ≠ 0) (hinj : Set.InjOn a s)
    (x y : ℂ)
    (hx : ∀ i ∈ s, ‖x * (a i)⁻¹‖ < 1)
    (hy : ∀ i ∈ s, ‖y * (a i)⁻¹‖ < 1) :
    (∑ i ∈ s, ((a i) ^ (s.card - 1) /
      (∏ j ∈ s.erase i, (a i - a j))) *
        (((1 + x * (a i)⁻¹) ^ (1 / 2 : ℂ)) *
          ((1 + y * (a i)⁻¹) ^ (1 / 2 : ℂ)))) -
        ((1 + x * y) ^ (1 / 2 : ℂ)) =
      1 - ((1 + x * y) ^ (1 / 2 : ℂ)) +
        ((-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
          (halfBinomialWeightedCoeff x y s.card +
            ∑' j : ℕ, halfBinomialWeightedCoeff x y (s.card + (j + 1)) *
              MvPolynomial.aeval (fun i : s => (a i)⁻¹)
                (MvPolynomial.hsymm s ℂ (j + 1))) := by
  have h := coherent_half_binomial_exact s a hs ha hinj x y hx hy
  have hsplit := h.1.tsum_eq_zero_add
  simp only [Nat.add_zero, MvPolynomial.hsymm_zero, map_one, mul_one] at hsplit
  rw [h.2, hsplit]
  ring

/-- The full homogeneous tail is summable, and its difference from the
leading coefficient satisfies precisely the paper's sharp remainder
bound.  This is the `F_m - f_m` form of the existing positive-tail bound. -/
theorem coherent_half_binomial_full_tail_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (x y : ℂ) (m : ℕ) (ρ t : ℝ)
    (hm : 1 ≤ m) (hρ0 : 0 ≤ ρ) (ht : 0 ≤ t)
    (ha : ∀ i, ‖a i‖ ≤ ρ)
    (hx : ‖x‖ ≤ t) (hy : ‖y‖ ≤ t)
    (hradius : ρ * t < 1) :
    Summable (fun j : ℕ => halfBinomialWeightedCoeff x y (m + j) *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) ∧
    ‖(∑' j : ℕ, halfBinomialWeightedCoeff x y (m + j) *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) -
        halfBinomialWeightedCoeff x y m‖ ≤
      (4 * |halfBinomialCoeff (m + 1)|) * t ^ m *
        (1 / (1 - ρ * t) ^ Fintype.card ι - 1) := by
  have h := coherent_half_binomial_tail_summable_and_norm_le
    a x y m ρ t hm hρ0 ht ha hx hy hradius
  have hfull : Summable (fun j : ℕ => halfBinomialWeightedCoeff x y (m + j) *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) :=
    (summable_nat_add_iff 1).mp h.1
  refine ⟨hfull, ?_⟩
  have hsplit := hfull.tsum_eq_zero_add
  simp only [Nat.add_zero, MvPolynomial.hsymm_zero, map_one, mul_one] at hsplit
  rw [hsplit, add_sub_cancel_left]
  exact h.2

end D1Bound5




open Finset

namespace D1Bound5

/-- Algebraic normalization of the paper's coherent form.  Here `g i`
denotes the product of the two analytic square-root factors and `q`
denotes the remaining square-root factor.  The result applies to any
nonzero choice of Vandermonde factor `Delta` and square-root scale `eta`.
No denominator at an individual anchor is cancelled in this proof. -/
theorem coherent_interpolation_normalization
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a g : ι → ℂ) (q Delta eta : ℂ)
    (hm : 2 ≤ s.card) (hDelta : Delta ≠ 0) (heta : eta ≠ 0) :
    (-Delta * (eta * q) +
      ∑ i ∈ s, (Delta * (a i) ^ (s.card - 2) /
        (∏ j ∈ s.erase i, (a i - a j))) * (a i * eta * g i)) /
      (Delta * eta) =
      (∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * g i) - q := by
  have hexp : s.card - 1 = (s.card - 2) + 1 := by omega
  have hsum :
      (∑ i ∈ s, (Delta * (a i) ^ (s.card - 2) /
        (∏ j ∈ s.erase i, (a i - a j))) * (a i * eta * g i)) =
      Delta * eta * ∑ i ∈ s, ((a i) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, (a i - a j))) * g i := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i hi
    rw [hexp, pow_succ]
    ring
  rw [hsum]
  apply (div_eq_iff (mul_ne_zero hDelta heta)).2
  ring

end D1Bound5




open Finset

namespace D1Bound5

/-- The complete homogeneous remainder estimate in the manuscript's
parameters.  There are exactly `s.card` reciprocal anchors.  The estimate
applies to the genuine complex half-binomial coefficients, and the full
series defining `F_m` is proved summable. -/
theorem coherent_half_binomial_manuscript_tail_norm_le
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (hs : s.Nonempty)
    (x y : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P)
    (ha : ∀ i ∈ s, A ≤ ‖a i‖)
    (hx : ‖x‖ ≤ 1 / P) (hy : ‖y‖ ≤ 1 / P)
    (hAP : 1 < A * P) :
    Summable (fun j : ℕ => halfBinomialWeightedCoeff x y (s.card + j) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ j)) ∧
    ‖(∑' j : ℕ, halfBinomialWeightedCoeff x y (s.card + j) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ j)) -
      halfBinomialWeightedCoeff x y s.card‖ ≤
      (4 * |halfBinomialCoeff (s.card + 1)|) / P ^ s.card *
        (1 / (1 - 1 / (A * P)) ^ s.card - 1) := by
  letI : Nonempty s := ⟨⟨hs.choose, hs.choose_spec⟩⟩
  have hrecip : ∀ i : s, ‖(a i)⁻¹‖ ≤ 1 / A := by
    intro i
    simpa only [one_div, norm_inv] using
      one_div_le_one_div_of_le hA (ha i i.2)
  have hprod : (1 / A) * (1 / P) = 1 / (A * P) := by
    simp only [one_div, mul_inv_rev]
    ring
  have hradius : (1 / A) * (1 / P) < 1 := by
    rw [hprod]
    exact (div_lt_one (mul_pos hA hP)).2 hAP
  obtain ⟨hfull, hbound⟩ := coherent_half_binomial_full_tail_norm_le
    (fun i : s => (a i)⁻¹) x y s.card (1 / A) (1 / P)
    (by have := hs.card_pos; omega) (by positivity) (by positivity)
    hrecip hx hy hradius
  refine ⟨hfull, ?_⟩
  rw [hprod, Fintype.card_coe] at hbound
  simpa only [one_div, inv_pow, div_eq_mul_inv, one_mul] using hbound

/-- The manuscript's size assumptions place every anchor evaluation
strictly inside the disk of convergence of the half-binomial series. -/
theorem coherent_half_binomial_manuscript_anchor_radius
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (x : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P)
    (ha : ∀ i ∈ s, A ≤ ‖a i‖)
    (hx : ‖x‖ ≤ 1 / P) (hAP : 1 < A * P) :
    ∀ i ∈ s, ‖x * (a i)⁻¹‖ < 1 := by
  intro i hi
  have hai : ‖(a i)⁻¹‖ ≤ 1 / A := by
    simpa only [one_div, norm_inv] using
      one_div_le_one_div_of_le hA (ha i hi)
  have hprod : (1 / P) * (1 / A) = 1 / (A * P) := by
    simp only [one_div, mul_inv_rev]
  calc
    ‖x * (a i)⁻¹‖ = ‖x‖ * ‖(a i)⁻¹‖ := norm_mul _ _
    _ ≤ (1 / P) * (1 / A) :=
      mul_le_mul hx hai (norm_nonneg _) (by positivity)
    _ = 1 / (A * P) := hprod
    _ < 1 := (div_lt_one (mul_pos hA hP)).2 hAP

end D1Bound5




namespace D1Bound5

/-- Squaring the principal half power recovers its argument, including
zero.  No change of logarithm branch is used. -/
theorem coherent_cpow_half_sq (z : ℂ) :
    (z ^ (1 / 2 : ℂ)) ^ (2 : ℕ) = z := by
  simpa [one_div] using
    (Complex.cpow_nat_inv_pow z (n := 2) (by decide))

/-- The chosen coherent terminal root has square `pq + 1`, for either
choice of the square root `eta` of `pq`. -/
theorem coherent_analytic_terminal_root_sq
    (p q eta : ℂ) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q) :
    (eta * ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))) ^ 2 = p * q + 1 := by
  rw [mul_pow, coherent_cpow_half_sq, heta]
  field_simp [hp, hq] <;> ring

/-- The coherent analytic anchor root has precisely the product square
claimed in the manuscript.  Consequently any integral product root of
the same expression agrees with it up to sign. -/
theorem coherent_analytic_anchor_root_sq
    (a p q eta : ℂ) (ha : a ≠ 0) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q) :
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) ^ 2 =
      (a * p + 1) * (a * q + 1) := by
  simp only [mul_pow, coherent_cpow_half_sq, heta]
  field_simp [ha, hp, hq] <;> ring

/-- An independently chosen product of square roots agrees with the
coherent analytic anchor root up to sign.  This includes vanishing roots. -/
theorem coherent_analytic_anchor_root_eq_or_eq_neg
    (a p q eta r t : ℂ) (ha : a ≠ 0) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q)
    (hr : r ^ 2 = a * p + 1) (ht : t ^ 2 = a * q + 1) :
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) = r * t ∨
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) = -(r * t) := by
  apply sq_eq_sq_iff_eq_or_eq_neg.mp
  rw [coherent_analytic_anchor_root_sq a p q eta ha hp hq heta, mul_pow, hr, ht]

end D1Bound5
