import D1Bound5.ComplexHalfBinomial
import D1Bound5.HalfBinomialAnalytic
import D1Bound5.InterpolationWeights

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

#print axioms D1Bound5.coherent_anchor_power_moment_low
#print axioms D1Bound5.coherent_anchor_power_moment_high
#print axioms D1Bound5.coherent_interpolation_series_exact
#print axioms D1Bound5.coherent_half_binomial_exact
#print axioms D1Bound5.coherent_half_binomial_exact_split
#print axioms D1Bound5.coherent_half_binomial_full_tail_norm_le
