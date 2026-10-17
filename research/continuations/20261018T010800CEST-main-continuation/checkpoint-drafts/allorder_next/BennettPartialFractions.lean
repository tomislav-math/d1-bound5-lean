import D1Bound5.BennettResidueCoefficient
import Mathlib.Algebra.Polynomial.PartialFractions

open Finset Polynomial

namespace D1Bound5

/-!
This module proves existence of the exact cleared partial-fraction decomposition
used by the residue-sum argument. The decomposition is a conclusion, not an
assumption. Identifying its coefficients with the manuscript's explicit finite
binomial sums remains a separate obligation.
-/

section CommRing

variable {R ι : Type*} [CommRing R] [Nontrivial R]
variable [Fintype ι] [DecidableEq ι]

/-- The common denominator with positive node multiplicities. -/
noncomputable def bennettPoleDenominator (a : ι → R) (e : ι → ℕ) : R[X] :=
  ∏ i, (X - C (a i)) ^ (e i + 1)

theorem bennettPoleDenominator_monic (a : ι → R) (e : ι → ℕ) :
    (bennettPoleDenominator a e).Monic := by
  exact Polynomial.monic_prod_of_monic _ _ fun i _ ↦
    (Polynomial.monic_X_sub_C (a i)).pow (e i + 1)

theorem bennettPoleDenominator_natDegree (a : ι → R) (e : ι → ℕ) :
    (bennettPoleDenominator a e).natDegree = ∑ i, (e i + 1) := by
  unfold bennettPoleDenominator
  rw [Polynomial.natDegree_prod_of_monic
    (h := fun i _ ↦ (Polynomial.monic_X_sub_C (a i)).pow (e i + 1))]
  apply Finset.sum_congr rfl
  intro i hi
  rw [(Polynomial.monic_X_sub_C (a i)).natDegree_pow,
    Polynomial.natDegree_X_sub_C, mul_one]

theorem bennettPoleDenominator_degree (a : ι → R) (e : ι → ℕ) :
    (bennettPoleDenominator a e).degree = (∑ i, (e i + 1) : ℕ) := by
  rw [Polynomial.degree_eq_natDegree (bennettPoleDenominator_monic a e).ne_zero,
    bennettPoleDenominator_natDegree]

/-- Every cleared proper-pole numerator has smaller degree than the denominator. -/
theorem clearedPoleNumerator_degree_lt_total (a : ι → R) (e : ι → ℕ)
    (i : ι) (j : Fin (e i + 1)) :
    (clearedPoleNumerator a e i j).degree < (∑ l, (e l + 1) : ℕ) := by
  apply (Polynomial.natDegree_lt_iff_degree_lt
    (clearedPoleNumerator_monic a e i j).ne_zero).mp
  rw [clearedPoleNumerator_natDegree]
  have hsum := Finset.add_sum_erase (Finset.univ : Finset ι)
    (fun l : ι ↦ e l + 1) (Finset.mem_univ i)
  have hj := j.isLt
  omega

/-- A linear combination of proper-pole numerators is still a proper numerator. -/
theorem clearedPoleSum_degree_lt_total (a : ι → R) (e : ι → ℕ)
    (c : (i : ι) → Fin (e i + 1) → R) :
    (∑ i, ∑ j : Fin (e i + 1), C (c i j) * clearedPoleNumerator a e i j).degree <
      (∑ l, (e l + 1) : ℕ) := by
  apply (Polynomial.degree_sum_le _ _).trans_lt
  apply (Finset.sup_lt_iff (WithBot.bot_lt_coe _)).mpr
  intro i hi
  apply (Polynomial.degree_sum_le _ _).trans_lt
  apply (Finset.sup_lt_iff (WithBot.bot_lt_coe _)).mpr
  intro j hj
  have hmul : (C (c i j) * clearedPoleNumerator a e i j).degree ≤
      (clearedPoleNumerator a e i j).degree := by
    have hn := Polynomial.degree_le_of_natDegree_le
      (Polynomial.natDegree_C_mul_le (c i j) (clearedPoleNumerator a e i j))
    rwa [← Polynomial.degree_eq_natDegree
      (clearedPoleNumerator_monic a e i j).ne_zero] at hn
  exact hmul.trans_lt (clearedPoleNumerator_degree_lt_total a e i j)

end CommRing

section Field

variable {F ι : Type*} [Field F] [Fintype ι] [DecidableEq ι]

/-- Exact partial-fraction existence at distinct nodes with arbitrary positive
multiplicities. No partial-fraction identity is assumed in this theorem. -/
theorem exists_clearedPole_decomposition (a : ι → F) (ha : Function.Injective a)
    (e : ι → ℕ) (f : F[X]) (hdeg : f.degree < (∑ i, (e i + 1) : ℕ)) :
    ∃ c : (i : ι) → Fin (e i + 1) → F,
      f = ∑ i, ∑ j : Fin (e i + 1), C (c i j) * clearedPoleNumerator a e i j := by
  classical
  obtain ⟨q, r, hr, hf⟩ :=
    Polynomial.eq_quo_mul_prod_pow_add_sum_rem_mul_prod_pow
      (s := (Finset.univ : Finset ι)) f
      (g := fun i ↦ X - C (a i))
      (fun i _ ↦ Polynomial.monic_X_sub_C (a i))
      (fun i _ j _ hij ↦ Polynomial.pairwise_coprime_X_sub_C ha hij)
      (fun i ↦ e i + 1)
  have hconst (i : ι) (j : Fin (e i + 1)) : r i j = C ((r i j).coeff 0) := by
    by_cases hzero : r i j = 0
    · simp [hzero]
    apply Polynomial.eq_C_of_natDegree_le_zero
    have hd : (r i j).degree < (1 : ℕ) := by
      simpa using hr i (Finset.mem_univ i) j
    have hn := (Polynomial.natDegree_lt_iff_degree_lt hzero).mpr hd
    omega
  let c : (i : ι) → Fin (e i + 1) → F := fun i j ↦ (r i j).coeff 0
  have heq : f = q * bennettPoleDenominator a e +
      ∑ i, ∑ j : Fin (e i + 1), C (c i j) * clearedPoleNumerator a e i j := by
    rw [hf]
    congr 1
    apply Finset.sum_congr rfl
    intro i hi
    apply Finset.sum_congr rfl
    intro j hj
    rw [hconst i j]
    simp only [c, clearedPoleNumerator, mul_assoc]
  let rem : F[X] := ∑ i, ∑ j : Fin (e i + 1),
    C (c i j) * clearedPoleNumerator a e i j
  have hrem : rem.degree < (bennettPoleDenominator a e).degree := by
    rw [bennettPoleDenominator_degree]
    exact clearedPoleSum_degree_lt_total a e c
  have hdiv : f /ₘ bennettPoleDenominator a e = q :=
    (Polynomial.div_modByMonic_unique q rem (bennettPoleDenominator_monic a e)
      ⟨by simpa only [rem, mul_comm, add_comm] using heq.symm, hrem⟩).1
  have hdivzero : f /ₘ bennettPoleDenominator a e = 0 := by
    apply (Polynomial.divByMonic_eq_zero_iff (bennettPoleDenominator_monic a e)).mpr
    rwa [bennettPoleDenominator_degree]
  have hq : q = 0 := hdiv.symm.trans hdivzero
  exact ⟨c, by simpa only [hq, zero_mul, zero_add] using heq⟩

/-- Algebraic residue cancellation for an existing exact decomposition, now
obtained without any assumed decomposition identity. -/
theorem exists_clearedPole_decomposition_zero_residue_sum
    (a : ι → F) (ha : Function.Injective a) (e : ι → ℕ) (f : F[X])
    (hdeg : f.degree < ((∑ i, (e i + 1)) - 1 : ℕ)) :
    ∃ c : (i : ι) → Fin (e i + 1) → F,
      (f = ∑ i, ∑ j : Fin (e i + 1), C (c i j) * clearedPoleNumerator a e i j) ∧
      ∑ i, c i (Fin.last (e i)) = 0 := by
  obtain ⟨c, hc⟩ := exists_clearedPole_decomposition a ha e f
    (hdeg.trans_le (WithBot.coe_le_coe.mpr (Nat.sub_le _ _)))
  exact ⟨c, hc, sum_simple_residues_eq_zero_of_degree_gap a e c f hc hdeg⟩

end Field

end D1Bound5
