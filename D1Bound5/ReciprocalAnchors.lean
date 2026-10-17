import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- A product of ordinary Vandermonde differences changes to reciprocal
nodes by an exact product identity. No distinctness is required. -/
theorem reciprocal_vandermonde_product
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0) (i : ι) (hi : i ∈ s) :
    (∏ j ∈ s.erase i, (a i - a j)) =
      (a i) ^ (s.erase i).card *
        (∏ j ∈ s.erase i, a j) *
        (∏ j ∈ s.erase i, ((a j)⁻¹ - (a i)⁻¹)) := by
  have hai : a i ≠ 0 := ha i hi
  calc
    (∏ j ∈ s.erase i, (a i - a j)) =
      ∏ j ∈ s.erase i, (a i * a j * ((a j)⁻¹ - (a i)⁻¹)) := by
        apply Finset.prod_congr rfl
        intro j hj
        have hj0 : a j ≠ 0 := ha j (Finset.mem_of_mem_erase hj)
        field_simp [hai, hj0]
    _ = (a i) ^ (s.erase i).card *
        (∏ j ∈ s.erase i, a j) *
        (∏ j ∈ s.erase i, ((a j)⁻¹ - (a i)⁻¹)) := by
        simp_rw [mul_assoc, Finset.prod_mul_distrib, Finset.prod_const]

/-- Pointwise transfer of barycentric weights from nodes `a` to
reciprocal nodes `a⁻¹`, valid even if some nodes coincide. -/
theorem reciprocal_anchor_weight_term
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0) (i : ι) (hi : i ∈ s) (k : ℕ) :
    ((a i)⁻¹) ^ (k + 1) /
      (∏ j ∈ s.erase i, (a i - a j)) =
      (∏ j ∈ s, a j)⁻¹ *
        ((a i)⁻¹) ^ (k + (s.erase i).card) /
        (∏ j ∈ s.erase i, ((a j)⁻¹ - (a i)⁻¹)) := by
  rw [← Finset.mul_prod_erase s a hi,
    reciprocal_vandermonde_product s a ha i hi]
  simp only [div_eq_mul_inv, mul_inv_rev, inv_pow, pow_add, pow_one]
  ring

/-- Reversing all reciprocal Vandermonde differences gives exactly the
parity sign for a full set of anchors. -/
theorem reciprocal_vandermonde_reverse
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (i : ι) (hi : i ∈ s) :
    (∏ j ∈ s.erase i, ((a j)⁻¹ - (a i)⁻¹)) =
      (-1 : F) ^ (s.card - 1) *
        (∏ j ∈ s.erase i, ((a i)⁻¹ - (a j)⁻¹)) := by
  calc
    (∏ j ∈ s.erase i, ((a j)⁻¹ - (a i)⁻¹)) =
      ∏ j ∈ s.erase i, -((a i)⁻¹ - (a j)⁻¹) := by
        apply Finset.prod_congr rfl
        intro j hj
        ring
    _ = _ := by
      rw [Finset.prod_neg, Finset.card_erase_of_mem hi]

/-- The reciprocal-node transfer with the standard Lagrange orientation.
This is the precise all-order weight reduction used for negative powers
of the original interpolation anchors. -/
theorem reciprocal_anchor_weight_standard
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0) (i : ι) (hi : i ∈ s) (k : ℕ) :
    ((a i)⁻¹) ^ (k + 1) /
      (∏ j ∈ s.erase i, (a i - a j)) =
      (-1 : F) ^ (s.card - 1) * (∏ j ∈ s, a j)⁻¹ *
        ((a i)⁻¹) ^ (k + s.card - 1) /
        (∏ j ∈ s.erase i, ((a i)⁻¹ - (a j)⁻¹)) := by
  rw [reciprocal_anchor_weight_term s a ha i hi k,
    Finset.card_erase_of_mem hi,
    reciprocal_vandermonde_reverse s a i hi]
  have hcard : 0 < s.card := Finset.card_pos.mpr ⟨i, hi⟩
  have hexp : k + s.card - 1 = k + (s.card - 1) := by omega
  have hsign : ((-1 : F) ^ (s.card - 1))⁻¹ = (-1 : F) ^ (s.card - 1) := by
    rw [← inv_pow]
    simp
  simp [div_eq_mul_inv, mul_inv_rev, mul_assoc, pow_add, hexp, hsign]
  ring

/-- For every order, a negative-power barycentric sum at nonzero
anchors transfers to an ordinary positive-power Lagrange moment of their
reciprocals. The sign and total product are exact. -/
theorem reciprocal_anchor_sum_transfer
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0) (k : ℕ) :
    (∑ i ∈ s, ((a i)⁻¹) ^ (k + 1) /
      (∏ j ∈ s.erase i, (a i - a j))) =
      ((-1 : F) ^ (s.card - 1) * (∏ j ∈ s, a j)⁻¹) *
        (∑ i ∈ s, ((a i)⁻¹) ^ (k + s.card - 1) /
          (∏ j ∈ s.erase i, ((a i)⁻¹ - (a j)⁻¹))) := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  simpa only [div_eq_mul_inv, mul_assoc] using
    reciprocal_anchor_weight_standard s a ha i hi k

/-- The first nonzero reciprocal-anchor moment is the signed reciprocal
product. This is the `n = m` boundary in the square-root interpolation
identity of the manuscript. -/
theorem reciprocal_anchor_first_nonzero
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0)
    (hd : Set.InjOn a s) (hs : s.Nonempty) :
    (∑ i ∈ s, (a i)⁻¹ /
      (∏ j ∈ s.erase i, (a i - a j))) =
      (-1 : F) ^ (s.card - 1) * (∏ j ∈ s, a j)⁻¹ := by
  have hinj : Set.InjOn (fun i => (a i)⁻¹) s := by
    intro i hi j hj hij
    apply hd hi hj
    simpa only [inv_inv] using congrArg Inv.inv hij
  have hn : s.card - 1 < s.card := Nat.sub_lt hs.card_pos (by decide)
  have hdeg : ((X : F[X]) ^ (s.card - 1)).degree < (s.card : WithBot ℕ) := by
    simpa using (WithBot.coe_lt_coe.mpr hn :
      ((s.card - 1 : ℕ) : WithBot ℕ) < (s.card : WithBot ℕ))
  have hcoeff := Lagrange.coeff_eq_sum (s := s)
    (v := fun i => (a i)⁻¹) (P := (X : F[X]) ^ (s.card - 1)) hinj hdeg
  have htop :
      (∑ i ∈ s, ((a i)⁻¹) ^ (s.card - 1) /
        (∏ j ∈ s.erase i, ((a i)⁻¹ - (a j)⁻¹))) = 1 := by
    simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow] using hcoeff.symm
  have h := reciprocal_anchor_sum_transfer s a ha 0
  simpa only [zero_add, pow_one, htop, mul_one] using h

end D1Bound5
