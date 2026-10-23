import D1Bound5.BennettTwoIntegralSummands
import D1Bound5.BennettResiduePolynomials
import Mathlib.Algebra.BigOperators.Fin

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The interpolation nodes for two fixed entries: H=ab, alpha=(0,b,a). -/
def bennettTwoNodes (a b : F) : Fin 3 → F := ![0, b, a]

@[simp] theorem bennettTwoNodes_zero (a b : F) : bennettTwoNodes a b 0 = 0 := rfl
@[simp] theorem bennettTwoNodes_one (a b : F) : bennettTwoNodes a b 1 = b := rfl
@[simp] theorem bennettTwoNodes_two (a b : F) : bennettTwoNodes a b 2 = a := rfl

theorem bennett_delta_sum_three (i : Fin 3) :
    (if i = 0 then 1 else 0) + (if i = 1 then 1 else 0) +
      (if i = 2 then 1 else 0) = (1 : ℕ) := by
  have h : (∑ j : Fin 3, if i = j then 1 else 0) = (1 : ℕ) := by simp
  simpa only [Fin.sum_univ_three] using h

theorem bennettTwoOtherPoles_zero (a b : F) (k : ℕ) (i : Fin 3) :
    bennettOtherPoles Finset.univ (bennettTwoNodes a b) k i 0 =
      bennettPoleSeries (-b) (k + if i = 1 then 1 else 0) *
        bennettPoleSeries (-a) (k + if i = 2 then 1 else 0) := by
  have hs : (Finset.univ : Finset (Fin 3)).erase 0 = {1, 2} := by decide
  simp [bennettOtherPoles, hs]

theorem bennettTwoOtherPoles_one (a b : F) (k : ℕ) (i : Fin 3) :
    bennettOtherPoles Finset.univ (bennettTwoNodes a b) k i 1 =
      bennettPoleSeries b (k + if i = 0 then 1 else 0) *
        bennettPoleSeries (b - a) (k + if i = 2 then 1 else 0) := by
  have hs : (Finset.univ : Finset (Fin 3)).erase 1 = {0, 2} := by decide
  simp [bennettOtherPoles, hs]

theorem bennettTwoOtherPoles_two (a b : F) (k : ℕ) (i : Fin 3) :
    bennettOtherPoles Finset.univ (bennettTwoNodes a b) k i 2 =
      bennettPoleSeries a (k + if i = 0 then 1 else 0) *
        bennettPoleSeries (a - b) (k + if i = 1 then 1 else 0) := by
  have hs : (Finset.univ : Finset (Fin 3)).erase 2 = {0, 1} := by decide
  simp [bennettOtherPoles, hs]

/-- Expanding the two actual reciprocal-pole series gives a finite sum
with exactly the three Taylor indices used in the manuscript. -/
theorem bennettClearedTaylor_two_poles_scaled_eval
    (s ν a N d e : F) (k r p q : ℕ) :
    s * (bennettClearedTaylor k r ν a
      (bennettPoleSeries d p * bennettPoleSeries e q)).eval N =
    ∑ ht ∈ Finset.antidiagonal r, ∑ uv ∈ Finset.antidiagonal ht.2,
      s * ((Ring.choose ((k : F) + ν) ht.1 *
        ((Ring.choose (-(p : F)) uv.1 * (d⁻¹) ^ (p + uv.1)) *
          (Ring.choose (-(q : F)) uv.2 * (e⁻¹) ^ (q + uv.2)))) *
            (N + a) ^ (k - ht.1)) := by
  unfold bennettClearedTaylor
  rw [Polynomial.eval_finsetSum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ht hht
  simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
    Polynomial.eval_add, Polynomial.eval_X, PowerSeries.coeff_mul, bennettPoleSeries_coeff]
  rw [Finset.mul_sum, Finset.sum_mul, Finset.mul_sum]

/-- The actual cleared two-anchor entry. The factor equals the manuscript's
(4 H^2 c Delta^2)^k after absorbing N^-k into the cleared polynomial G. -/
noncomputable def bennettTwoClearedEntry (a b c : F) (k : ℕ) (i j : Fin 3) : F :=
  (4 * a * b * (a - b) ^ 2) ^ k *
    (bennettClearedResidue Finset.univ (bennettTwoNodes a b) k (1 / 2 : F) i j).eval
      (a * b * c)

/-- Integrality of the entire column-zero entry, proved from its actual
finite residue expansion. -/
theorem bennettTwoClearedEntry_zero_integral (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (ha0 : a ≠ 0) (hb0 : b ≠ 0) (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ∃ q ∈ S, bennettTwoClearedEntry a b c k i 0 = 1 * q := by
  unfold bennettTwoClearedEntry bennettClearedResidue
  rw [bennettTwoOtherPoles_zero, bennettTwoNodes_zero,
    bennettClearedTaylor_two_poles_scaled_eval]
  apply bennett_sum_divisible_in_subring
  intro ht hht
  apply bennett_sum_divisible_in_subring
  intro uv huv
  have hts := Finset.mem_antidiagonal.mp hht
  have hus := Finset.mem_antidiagonal.mp huv
  have hd := bennett_delta_sum_three i
  have hh : ht.1 + uv.1 + uv.2 + 1 = k + (if i = 0 then 1 else 0) := by omega
  obtain ⟨q, hq, heq⟩ := bennett_two_integral_summand_zero S a b c ha hb hc ha0 hb0
    k (if i = 0 then 1 else 0) (if i = 1 then 1 else 0) (if i = 2 then 1 else 0)
      ht.1 uv.1 uv.2 hk hd hh
  refine ⟨q, hq, ?_⟩
  convert heq using 1 <;> simp only [add_zero, mul_pow] <;> ring

/-- The entire column-one entry is divisible by a^k in the original subring. -/
theorem bennettTwoClearedEntry_one_integral_divisible (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (hb0 : b ≠ 0) (hab : a ≠ b) (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ∃ q ∈ S, bennettTwoClearedEntry a b c k i 1 = a ^ k * q := by
  unfold bennettTwoClearedEntry bennettClearedResidue
  rw [bennettTwoOtherPoles_one, bennettTwoNodes_one,
    bennettClearedTaylor_two_poles_scaled_eval]
  apply bennett_sum_divisible_in_subring
  intro ht hht
  apply bennett_sum_divisible_in_subring
  intro uv huv
  have hts := Finset.mem_antidiagonal.mp hht
  have hus := Finset.mem_antidiagonal.mp huv
  have hd := bennett_delta_sum_three i
  have hh : uv.1 + ht.1 + uv.2 + 1 = k + (if i = 1 then 1 else 0) := by omega
  obtain ⟨q, hq, heq⟩ := bennett_two_integral_summand_one S a b c ha hb hc hb0 hab
    k (if i = 0 then 1 else 0) (if i = 1 then 1 else 0) (if i = 2 then 1 else 0)
      uv.1 ht.1 uv.2 hk hd hh
  refine ⟨q, hq, ?_⟩
  convert heq using 1 <;> simp only [mul_pow] <;> ring

/-- The entire column-two entry is divisible by b^k in the original subring. -/
theorem bennettTwoClearedEntry_two_integral_divisible (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (ha0 : a ≠ 0) (hab : a ≠ b) (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ∃ q ∈ S, bennettTwoClearedEntry a b c k i 2 = b ^ k * q := by
  unfold bennettTwoClearedEntry bennettClearedResidue
  rw [bennettTwoOtherPoles_two, bennettTwoNodes_two,
    bennettClearedTaylor_two_poles_scaled_eval]
  apply bennett_sum_divisible_in_subring
  intro ht hht
  apply bennett_sum_divisible_in_subring
  intro uv huv
  have hts := Finset.mem_antidiagonal.mp hht
  have hus := Finset.mem_antidiagonal.mp huv
  have hd := bennett_delta_sum_three i
  have hh : uv.1 + uv.2 + ht.1 + 1 = k + (if i = 2 then 1 else 0) := by omega
  obtain ⟨q, hq, heq⟩ := bennett_two_integral_summand_two S a b c ha hb hc ha0 hab
    k (if i = 0 then 1 else 0) (if i = 1 then 1 else 0) (if i = 2 then 1 else 0)
      uv.1 uv.2 ht.1 hk hd hh
  refine ⟨q, hq, ?_⟩
  convert heq using 1 <;> simp only [mul_pow] <;> ring

/-- Exact identification with the manuscript's clearing factor applied to
the original residue coefficient f=P(1/N), with H=ab and N=abc. -/
theorem bennettTwoClearedEntry_eq_scaled_residue
    (a b c : F) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0)
    (k : ℕ) (i j : Fin 3) :
    bennettTwoClearedEntry a b c k i j =
      (4 * (a * b) ^ 2 * c * (a - b) ^ 2) ^ k *
        (bennettPolynomialResidue Finset.univ (bennettTwoNodes a b) k (1 / 2 : F)
          i j).eval ((a * b * c)⁻¹) := by
  have hN : a * b * c ≠ 0 := mul_ne_zero (mul_ne_zero ha hb) hc
  have hs : 4 * (a * b) ^ 2 * c * (a - b) ^ 2 =
      (4 * a * b * (a - b) ^ 2) * (a * b * c) := by ring
  rw [hs, mul_pow, mul_assoc, bennettPolynomialResidue_homogenize
    Finset.univ (bennettTwoNodes a b) k (1 / 2 : F) (a * b * c) i j hN] <;> rfl

/-- Every actual two-anchor row lifts to the original ring, with the exact
column powers retained. Instantiating R with the full ring of integers gives
the arithmetic integrality/divisibility bridge without unique factorization. -/
theorem bennettTwoClearedEntry_row_lift
    {R : Type*} [CommRing R] (f : R →+* F) (a b c : R)
    (ha0 : f a ≠ 0) (hb0 : f b ≠ 0) (hab : f a ≠ f b)
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ∃ q0 q1 q2 : R,
      f q0 = bennettTwoClearedEntry (f a) (f b) (f c) k i 0 ∧
      f (a ^ k * q1) = bennettTwoClearedEntry (f a) (f b) (f c) k i 1 ∧
      f (b ^ k * q2) = bennettTwoClearedEntry (f a) (f b) (f c) k i 2 := by
  have ha : f a ∈ f.range := ⟨a, rfl⟩
  have hb : f b ∈ f.range := ⟨b, rfl⟩
  have hc : f c ∈ f.range := ⟨c, rfl⟩
  obtain ⟨u0, hu0, he0⟩ := bennettTwoClearedEntry_zero_integral f.range
    (f a) (f b) (f c) ha hb hc ha0 hb0 k hk i
  obtain ⟨u1, hu1, he1⟩ := bennettTwoClearedEntry_one_integral_divisible f.range
    (f a) (f b) (f c) ha hb hc hb0 hab k hk i
  obtain ⟨u2, hu2, he2⟩ := bennettTwoClearedEntry_two_integral_divisible f.range
    (f a) (f b) (f c) ha hb hc ha0 hab k hk i
  obtain ⟨q0, hq0⟩ := hu0
  obtain ⟨q1, hq1⟩ := hu1
  obtain ⟨q2, hq2⟩ := hu2
  refine ⟨q0, q1, q2, ?_, ?_, ?_⟩
  · rw [hq0, he0, one_mul]
  · rw [map_mul, map_pow, hq1, he1]
  · rw [map_mul, map_pow, hq2, he2]

end D1Bound5
