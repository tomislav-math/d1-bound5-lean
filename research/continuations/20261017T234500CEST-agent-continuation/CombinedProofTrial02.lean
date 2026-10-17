import D1Bound5.FullRingBridge
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases
import D1Bound5.ComplexHalfBinomial
import D1Bound5.HalfBinomialAnalytic
import D1Bound5.InterpolationWeights
import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Polynomial
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.BigOperators
import Mathlib.Algebra.Polynomial.RingDivision
import Lean.Elab.Tactic.Omega

/- SOURCE CrossBlockTrial.lean -/

open scoped BigOperators NumberField
open Module

namespace D1Bound5

/-- A quadratic over an integral domain that vanishes at three distinct
points has all three coefficients zero. This elementary form is convenient
for the cross-block argument. -/
private theorem crossBlock_quadratic_coefficients
    {K : Type*} [CommRing K] [IsDomain K]
    (A B C x y z : K) (hxy : x ≠ y) (hxz : x ≠ z) (hyz : y ≠ z)
    (hx : A*x^2 + B*x + C = 0)
    (hy : A*y^2 + B*y + C = 0)
    (hz : A*z^2 + B*z + C = 0) :
    A = 0 ∧ B = 0 ∧ C = 0 := by
  have hxy' : (x-y)*(A*(x+y)+B) = 0 := by
    linear_combination hx - hy
  have hxz' : (x-z)*(A*(x+z)+B) = 0 := by
    linear_combination hx - hz
  have hxy'' : A*(x+y)+B = 0 :=
    (mul_eq_zero.mp hxy').resolve_left (sub_ne_zero.mpr hxy)
  have hxz'' : A*(x+z)+B = 0 :=
    (mul_eq_zero.mp hxz').resolve_left (sub_ne_zero.mpr hxz)
  have hA' : A*(y-z) = 0 := by
    linear_combination hxy'' - hxz''
  have hA : A = 0 :=
    (mul_eq_zero.mp hA').resolve_right (sub_ne_zero.mpr hyz)
  have hB : B = 0 := by simpa [hA] using hxy''
  have hC : C = 0 := by simpa [hA, hB] using hx
  exact ⟨hA, hB, hC⟩

/-- Any two rows of a root matrix with distinct row parameters are linearly
independent, provided two column parameters are distinct. Zero root entries
are permitted. -/
private theorem crossBlock_two_rows
    {K : Type*} [CommRing K] [IsDomain K]
    (a c : K) (b r s : Fin 3 → K) (hac : a ≠ c)
    (hb : b 0 ≠ b 1)
    (hr : ∀ j, (r j)^2 = a*b j+1)
    (hs : ∀ j, (s j)^2 = c*b j+1)
    (lam μ : K) (hrel : ∀ j, lam*r j+μ*s j = 0) :
    lam = 0 ∧ μ = 0 := by
  have heq (j : Fin 3) :
      (lam^2*a-μ^2*c)*b j+(lam^2-μ^2) = 0 := by
    linear_combination
      (lam*r j-μ*s j) * hrel j - lam^2 * hr j + μ^2 * hs j
  have hprod : (b 0-b 1)*(lam^2*a-μ^2*c) = 0 := by
    linear_combination heq 0 - heq 1
  have hA : lam^2*a-μ^2*c = 0 :=
    (mul_eq_zero.mp hprod).resolve_left (sub_ne_zero.mpr hb)
  have hC : lam^2-μ^2 = 0 := by
    simpa [hA] using heq 0
  have hlamprod : lam^2*(a-c) = 0 := by
    linear_combination hA - c*hC
  have hlamsq : lam^2 = 0 :=
    (mul_eq_zero.mp hlamprod).resolve_right (sub_ne_zero.mpr hac)
  have hlam : lam = 0 := sq_eq_zero_iff.mp hlamsq
  have hμsq : μ^2 = 0 := by
    linear_combination hlamsq - hC
  exact ⟨hlam, sq_eq_zero_iff.mp hμsq⟩

/-- In a linear relation among three root rows, the product of the first two
coefficients is zero. Squaring the relation twice yields a quadratic in the
column parameter. Its discriminant forces this product to vanish. -/
private theorem crossBlock_relation_product
    {K : Type*} [CommRing K] [IsDomain K] [CharZero K]
    (a b : Fin 3 → K) (R : Matrix (Fin 3) (Fin 3) K)
    (ha : a 0 ≠ a 1) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1)
    (lam μ ν : K)
    (hrel : ∀ j, lam*R 0 j+μ*R 1 j+ν*R 2 j = 0) :
    lam*μ = 0 := by
  let P : K := ν^2*a 2-lam^2*a 0-μ^2*a 1
  let Q : K := ν^2-lam^2-μ^2
  let L : K := 4*lam^2*μ^2
  have hcross (j : Fin 3) :
      2*lam*μ*R 0 j*R 1 j = P*b j+Q := by
    dsimp [P, Q]
    linear_combination
      (lam*R 0 j+μ*R 1 j-ν*R 2 j) * hrel j -
      lam^2 * hroot 0 j - μ^2 * hroot 1 j + ν^2 * hroot 2 j
  have hsquare (j : Fin 3) :
      (P*b j+Q)^2 = L*(a 0*b j+1)*(a 1*b j+1) := by
    calc
      (P*b j+Q)^2 = (2*lam*μ*R 0 j*R 1 j)^2 := by rw [hcross j]
      _ = L*(R 0 j)^2*(R 1 j)^2 := by dsimp [L]; ring
      _ = L*(a 0*b j+1)*(a 1*b j+1) := by rw [hroot 0 j, hroot 1 j]
  have heval (j : Fin 3) :
      (P^2-L*a 0*a 1)*(b j)^2 +
        (2*P*Q-L*(a 0+a 1))*b j + (Q^2-L) = 0 := by
    linear_combination hsquare j
  obtain ⟨hA, hB, hC⟩ := crossBlock_quadratic_coefficients
    (P^2-L*a 0*a 1) (2*P*Q-L*(a 0+a 1)) (Q^2-L)
    (b 0) (b 1) (b 2)
    (hb.ne (by decide)) (hb.ne (by decide)) (hb.ne (by decide))
    (heval 0) (heval 1) (heval 2)
  have hdisc : L^2*(a 0-a 1)^2 = 0 := by
    linear_combination
      4*Q^2*hA - (2*P*Q+L*(a 0+a 1))*hB + 4*L*a 0*a 1*hC
  by_contra hlamμ
  have hlam : lam ≠ 0 := by
    intro h
    apply hlamμ
    simp [h]
  have hμ : μ ≠ 0 := by
    intro h
    apply hlamμ
    simp [h]
  have hL : L ≠ 0 := by
    dsimp [L]
    exact mul_ne_zero (mul_ne_zero (by norm_num) (pow_ne_zero 2 hlam))
      (pow_ne_zero 2 hμ)
  exact (mul_ne_zero (pow_ne_zero 2 hL)
    (pow_ne_zero 2 (sub_ne_zero.mpr ha))) hdisc

/-- The algebraic nonvanishing assertion in the cross-block lemma.

A three-by-three matrix of arbitrarily signed square roots of `a i*b j+1`
has nonzero determinant whenever the three row parameters and three column
parameters are separately distinct. No nonzero-coordinate or nonzero-root
hypothesis is needed. The proof works in every characteristic-zero integral
domain, in particular in the full ring of integers of a number field. -/
theorem crossBlock_rootMatrix_det_ne_zero
    {K : Type*} [CommRing K] [IsDomain K] [CharZero K]
    (a b : Fin 3 → K) (R : Matrix (Fin 3) (Fin 3) K)
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1) :
    R.det ≠ 0 := by
  intro hdet
  obtain ⟨v, hv, hzero⟩ := Matrix.exists_vecMul_eq_zero_iff.mpr hdet
  have hrel (j : Fin 3) :
      v 0*R 0 j+v 1*R 1 j+v 2*R 2 j = 0 := by
    have hj := congrFun hzero j
    simpa [Matrix.vecMul, dotProduct, Fin.sum_univ_succ, add_assoc] using hj
  have hp : v 0*v 1 = 0 := crossBlock_relation_product
    a b R (ha.ne (by decide)) hb hroot (v 0) (v 1) (v 2) hrel
  rcases mul_eq_zero.mp hp with hv0 | hv1
  · obtain ⟨hv1, hv2⟩ := crossBlock_two_rows
      (a 1) (a 2) b (R 1) (R 2)
      (ha.ne (by decide)) (hb.ne (by decide))
      (hroot 1) (hroot 2) (v 1) (v 2)
      (fun j => by simpa [hv0] using hrel j)
    apply hv
    funext i
    fin_cases i <;> simp_all
  · obtain ⟨hv0, hv2⟩ := crossBlock_two_rows
      (a 0) (a 2) b (R 0) (R 2)
      (ha.ne (by decide)) (hb.ne (by decide))
      (hroot 0) (hroot 2) (v 0) (v 2)
      (fun j => by simpa [hv1] using hrel j)
    apply hv
    funext i
    fin_cases i <;> simp_all

/-- The arithmetic lower bound for the cross-block determinant in the full
integer ring of any imaginary quadratic field. This is unconditional on
coordinate bounds and on choices of root signs. -/
theorem full_ring_crossBlock_rootMatrix_one_le_norm
    {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b : Fin 3 → 𝓞 K) (R : Matrix (Fin 3) (Fin 3) (𝓞 K))
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1) :
    1 ≤ ‖phi (R.det : K)‖ := by
  exact one_le_norm_integer hK phi
    (crossBlock_rootMatrix_det_ne_zero a b R ha hb hroot)

end D1Bound5

/- SOURCE CoherentInterpolationTrial02.lean -/

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

/- SOURCE CoherentNormalizationTrial.lean -/

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

#print axioms D1Bound5.coherent_interpolation_normalization

/- SOURCE CoherentSpecializationTrial.lean -/

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
  simpa only [one_div, inv_pow, div_eq_mul_inv] using hbound

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

#print axioms D1Bound5.coherent_half_binomial_manuscript_tail_norm_le
#print axioms D1Bound5.coherent_half_binomial_manuscript_anchor_radius

/- SOURCE CoherentAnalyticRootsTrial.lean -/

namespace D1Bound5

/-- Squaring the principal half power recovers its argument, including
zero.  No change of logarithm branch is used. -/
theorem coherent_cpow_half_sq (z : ℂ) :
    (z ^ (1 / 2 : ℂ)) ^ (2 : ℕ) = z := by
  simpa only [one_div] using
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

#print axioms D1Bound5.coherent_cpow_half_sq
#print axioms D1Bound5.coherent_analytic_terminal_root_sq
#print axioms D1Bound5.coherent_analytic_anchor_root_sq
#print axioms D1Bound5.coherent_analytic_anchor_root_eq_or_eq_neg

/- SOURCE BennettResidualDetTrial.lean -/

open Finset Polynomial Matrix

namespace D1Bound5

/-!
This module isolates an intermediate step in the all-orders Bennett determinant
argument. It does not define the residue polynomials or prove their cancellation.
The required cancellation is an explicit hypothesis of the final theorem.
-/

section CommRing

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

/-- Replacing a distinguished column by a linear combination of columns transfers
a common factor of the residual vector to the determinant. The coefficient of
the distinguished column is assumed to be one. -/
theorem dvd_det_of_dvd_column_combination (A : Matrix ι ι R) (c : ι → R)
    (q : ι) (hc : c q = 1) (z : R)
    (hres : ∀ i, z ∣ ∑ j, c j * A i j) : z ∣ A.det := by
  classical
  choose v hv using hres
  have hcol : (fun i ↦ ∑ j, c j * A i j) = z • v := by
    funext i
    exact hv i
  refine ⟨(A.updateCol q v).det, ?_⟩
  calc
    A.det = (A.updateCol q (fun i ↦ ∑ j, c j * A i j)).det := by
      symm
      simpa only [smul_eq_mul, hc, one_mul] using Matrix.det_updateCol_sum A q c
    _ = z * (A.updateCol q v).det := by
      rw [hcol, Matrix.det_updateCol_smul]

/-- A columnwise degree bound gives the corresponding determinant degree bound,
without any assumption that the coefficient ring is a domain. -/
theorem polynomial_det_natDegree_le_sum (P : Matrix ι ι R[X]) (d : ι → ℕ)
    (hdeg : ∀ i j, (P i j).natDegree ≤ d j) :
    P.det.natDegree ≤ ∑ j, d j := by
  classical
  rw [Matrix.det_apply]
  apply Polynomial.natDegree_sum_le_of_forall_le
  intro σ hσ
  exact (Polynomial.natDegree_smul_le _ _).trans
    ((Polynomial.natDegree_prod_le _ _).trans
      (Finset.sum_le_sum fun i _ ↦ hdeg (σ i) i))

/-- A polynomial whose degree is at most `D` and whose first `D` coefficients
vanish is exactly its degree-`D` monomial, including the zero-polynomial case. -/
theorem polynomial_eq_top_monomial_of_X_pow_dvd (p : R[X]) (D : ℕ)
    (hdeg : p.natDegree ≤ D) (hdiv : (X : R[X]) ^ D ∣ p) :
    p = C (p.coeff D) * X ^ D := by
  rw [Polynomial.C_mul_X_pow_eq_monomial]
  apply Polynomial.ext
  intro l
  rw [Polynomial.coeff_monomial]
  split_ifs with h
  · subst l
    rfl
  · rcases lt_or_gt_of_ne h with hlt | hgt
    · exact Polynomial.coeff_eq_zero_of_natDegree_lt (hdeg.trans_lt hlt)
    · exact Polynomial.X_pow_dvd_iff.mp hdiv l hgt

/-- Intermediate all-orders determinant principle. The residual cancellation is
an explicit input. In the Bennett construction the distinguished node is zero,
so the corresponding (truncated) binomial polynomial is exactly one. -/
theorem polynomial_det_eq_monomial_of_residual (P : Matrix ι ι R[X])
    (d : ι → ℕ) (θ : ι → R[X]) (q : ι) (hθ : θ q = 1)
    (hdeg : ∀ i j, (P i j).natDegree ≤ d j)
    (hres : ∀ i, (X : R[X]) ^ (∑ j, d j) ∣ ∑ j, θ j * P i j) :
    P.det = C (P.det.coeff (∑ j, d j)) * X ^ (∑ j, d j) := by
  apply polynomial_eq_top_monomial_of_X_pow_dvd
  · exact polynomial_det_natDegree_le_sum P d hdeg
  · exact dvd_det_of_dvd_column_combination P θ q hθ _ hres

/-- Uniform-degree form of the preceding intermediate principle. This gives the
`card(ι) * k` exponent appearing in the all-orders Bennett determinant. -/
theorem polynomial_det_eq_monomial_of_uniform_residual (P : Matrix ι ι R[X])
    (k : ℕ) (θ : ι → R[X]) (q : ι) (hθ : θ q = 1)
    (hdeg : ∀ i j, (P i j).natDegree ≤ k)
    (hres : ∀ i, (X : R[X]) ^ (Fintype.card ι * k) ∣ ∑ j, θ j * P i j) :
    P.det = C (P.det.coeff (Fintype.card ι * k)) * X ^ (Fintype.card ι * k) := by
  simpa using polynomial_det_eq_monomial_of_residual P (fun _ ↦ k) θ q hθ hdeg
    (by simpa using hres)

end CommRing

end D1Bound5

/- SOURCE BennettResidueCoefficientTrial.lean -/

open Finset Polynomial

namespace D1Bound5

section CommRing

variable {R ι : Type*} [CommRing R] [Nontrivial R]
variable [Fintype ι] [DecidableEq ι]

/-- The numerator obtained on clearing the pole at node `i`.
The multiplicity at node `l` is `e l + 1`. The index `j = Fin.last (e i)`
is the simple pole, in exactly the indexing used by mathlib partial fractions. -/
noncomputable def clearedPoleNumerator (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) : R[X] :=
  (X - C (a i)) ^ j.val *
    ∏ l ∈ (Finset.univ : Finset ι).erase i, (X - C (a l)) ^ (e l + 1)

theorem clearedPoleNumerator_monic (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) : (clearedPoleNumerator a e i j).Monic := by
  apply Polynomial.Monic.mul ((Polynomial.monic_X_sub_C _).pow _)
  exact Polynomial.monic_prod_of_monic _ _ fun l _ ↦
    (Polynomial.monic_X_sub_C _).pow _

theorem clearedPoleNumerator_natDegree (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) :
    (clearedPoleNumerator a e i j).natDegree =
      j.val + ∑ l ∈ (Finset.univ : Finset ι).erase i, (e l + 1) := by
  unfold clearedPoleNumerator
  rw [((Polynomial.monic_X_sub_C (a i)).pow j.val).natDegree_mul
    (Polynomial.monic_prod_of_monic _ _ fun l _ ↦
      (Polynomial.monic_X_sub_C (a l)).pow (e l + 1))]
  rw [Polynomial.natDegree_prod_of_monic
    (h := fun l _ ↦ (Polynomial.monic_X_sub_C (a l)).pow (e l + 1))]
  rw [(Polynomial.monic_X_sub_C (a i)).natDegree_pow,
    Polynomial.natDegree_X_sub_C, mul_one]
  congr 1
  apply Finset.sum_congr rfl
  intro l hl
  rw [(Polynomial.monic_X_sub_C (a l)).natDegree_pow,
    Polynomial.natDegree_X_sub_C, mul_one]

/-- At degree one below the denominator degree, only the cleared simple pole
has a nonzero coefficient. This calculation does not require distinct nodes. -/
theorem clearedPoleNumerator_top_coeff (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) :
    (clearedPoleNumerator a e i j).coeff ((∑ l, (e l + 1)) - 1) =
      if j = Fin.last (e i) then 1 else 0 := by
  have hsum : e i + 1 + ∑ l ∈ (Finset.univ : Finset ι).erase i, (e l + 1) =
      ∑ l, (e l + 1) :=
    Finset.add_sum_erase _ _ (Finset.mem_univ i)
  split_ifs with hj
  · subst j
    have hd : (clearedPoleNumerator a e i (Fin.last (e i))).natDegree =
        (∑ l, (e l + 1)) - 1 := by
      rw [clearedPoleNumerator_natDegree, Fin.val_last]
      omega
    rw [← hd, Polynomial.coeff_natDegree]
    exact clearedPoleNumerator_monic a e i (Fin.last (e i))
  · apply Polynomial.coeff_eq_zero_of_natDegree_lt
    rw [clearedPoleNumerator_natDegree]
    have hlt := j.isLt
    have hne : j.val ≠ e i := by
      intro heq
      apply hj
      exact Fin.ext heq
    omega

/-- The coefficient one below the denominator degree is the sum of the
simple-pole coefficients in an exact cleared partial-fraction identity.
The identity itself is an explicit hypothesis, not inferred from notation. -/
theorem coeff_eq_sum_simple_residues (a : ι → R) (e : ι → ℕ)
    (c : (i : ι) → Fin (e i + 1) → R) (f : R[X])
    (hdecomp : f = ∑ i, ∑ j : Fin (e i + 1),
      C (c i j) * clearedPoleNumerator a e i j) :
    f.coeff ((∑ l, (e l + 1)) - 1) = ∑ i, c i (Fin.last (e i)) := by
  classical
  rw [hdecomp, Polynomial.finsetSum_coeff]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Polynomial.finsetSum_coeff]
  simp only [Polynomial.coeff_C_mul, clearedPoleNumerator_top_coeff]
  simp

/-- The algebraic residue sum vanishes when an exact cleared decomposition
has numerator degree at least two below the denominator degree. -/
theorem sum_simple_residues_eq_zero_of_degree_gap (a : ι → R) (e : ι → ℕ)
    (c : (i : ι) → Fin (e i + 1) → R) (f : R[X])
    (hdecomp : f = ∑ i, ∑ j : Fin (e i + 1),
      C (c i j) * clearedPoleNumerator a e i j)
    (hdeg : f.degree < ((∑ l, (e l + 1)) - 1 : ℕ)) :
    ∑ i, c i (Fin.last (e i)) = 0 := by
  rw [← coeff_eq_sum_simple_residues a e c f hdecomp]
  exact Polynomial.coeff_eq_zero_of_degree_lt hdeg

end CommRing

end D1Bound5
