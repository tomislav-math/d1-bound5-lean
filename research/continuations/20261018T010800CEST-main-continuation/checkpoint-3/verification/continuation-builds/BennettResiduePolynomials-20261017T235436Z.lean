import D1Bound5.BennettClearedResidues

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The original polynomial local residue, before the substitution x=1/N. -/
noncomputable def bennettResidueTaylor (k r : ℕ) (ν a : F)
    (B : PowerSeries F) : Polynomial F :=
  ∑ ht ∈ Finset.antidiagonal r,
    Polynomial.C (Ring.choose ((k : F) + ν) ht.1 * PowerSeries.coeff ht.2 B) *
      (Polynomial.X ^ ht.1 *
        (1 + Polynomial.C a * Polynomial.X) ^ (k - ht.1))

theorem bennettResidueTaylor_natDegree_le (k r : ℕ) (hr : r ≤ k)
    (ν a : F) (B : PowerSeries F) :
    (bennettResidueTaylor k r ν a B).natDegree ≤ k := by
  have hlin : (1 + Polynomial.C a * Polynomial.X : Polynomial F).natDegree ≤ 1 := by
    apply (Polynomial.natDegree_add_le _ _).trans
    apply max_le
    · simp
    · exact (Polynomial.natDegree_C_mul_le _ _).trans (by simp)
  unfold bennettResidueTaylor
  apply Polynomial.natDegree_sum_le_of_forall_le
  intro ht hht
  have hsum := Finset.mem_antidiagonal.mp hht
  have hh : ht.1 ≤ k := by omega
  apply (Polynomial.natDegree_C_mul_le _ _).trans
  apply Polynomial.natDegree_mul_le.trans
  have hpow : ((1 + Polynomial.C a * Polynomial.X : Polynomial F) ^
      (k - ht.1)).natDegree ≤ k - ht.1 := by
    simpa using Polynomial.natDegree_pow_le_of_le (k - ht.1) hlin
  calc
    (Polynomial.X ^ ht.1 : Polynomial F).natDegree +
        ((1 + Polynomial.C a * Polynomial.X : Polynomial F) ^
          (k - ht.1)).natDegree ≤ ht.1 + (k - ht.1) := by
      exact add_le_add (by simp) hpow
    _ = k := Nat.add_sub_of_le hh

/-- Exact homogenization of every monomial summand. -/
theorem bennettHomogenizationTerm (k h : ℕ) (hh : h ≤ k)
    (a N : F) (hN : N ≠ 0) :
    N ^ k * ((N⁻¹) ^ h * (1 + a * N⁻¹) ^ (k - h)) =
      (N + a) ^ (k - h) := by
  have hbase : 1 + a * N⁻¹ = (N + a) * N⁻¹ := by
    rw [add_mul, mul_inv_cancel₀ hN]
  rw [hbase, mul_pow]
  calc
    _ = (N ^ k * (N⁻¹) ^ (h + (k - h))) * (N + a) ^ (k - h) := by
      rw [pow_add]
      ring
    _ = _ := by
      rw [Nat.add_sub_of_le hh, ← mul_pow, mul_inv_cancel₀ hN, one_pow, one_mul]

/-- Clearing the common N denominator recovers the polynomial G used in
the node-removal determinant induction. -/
theorem bennettResidueTaylor_homogenize (k r : ℕ) (hr : r ≤ k)
    (ν a N : F) (B : PowerSeries F) (hN : N ≠ 0) :
    N ^ k * (bennettResidueTaylor k r ν a B).eval N⁻¹ =
      (bennettClearedTaylor k r ν a B).eval N := by
  unfold bennettResidueTaylor bennettClearedTaylor
  rw [Polynomial.eval_finsetSum, Polynomial.eval_finsetSum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ht hht
  have hsum := Finset.mem_antidiagonal.mp hht
  have hh : ht.1 ≤ k := by omega
  simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
    Polynomial.eval_add, Polynomial.eval_one, Polynomial.eval_X]
  calc
    _ = (Ring.choose ((k : F) + ν) ht.1 * PowerSeries.coeff ht.2 B) *
        (N ^ k * ((N⁻¹) ^ ht.1 * (1 + a * N⁻¹) ^ (k - ht.1))) := by ring
    _ = _ := by rw [bennettHomogenizationTerm k ht.1 hh a N hN]

section Nodes

variable {I : Type*} [DecidableEq I]

/-- The polynomial matrix entry P_ij(x) of arbitrary positive order. -/
noncomputable def bennettPolynomialResidue (s : Finset I) (a : I → F)
    (k : ℕ) (ν : F) (i j : I) : Polynomial F :=
  bennettResidueTaylor k (k + (if i = j then 1 else 0) - 1) ν (a j)
    (bennettOtherPoles s a k i j)

theorem bennettPolynomialResidue_natDegree_le (s : Finset I) (a : I → F)
    (k : ℕ) (ν : F) (i j : I) :
    (bennettPolynomialResidue s a k ν i j).natDegree ≤ k := by
  apply bennettResidueTaylor_natDegree_le
  split_ifs <;> omega

theorem bennettPolynomialResidue_homogenize (s : Finset I) (a : I → F)
    (k : ℕ) (ν N : F) (i j : I) (hN : N ≠ 0) :
    N ^ k * (bennettPolynomialResidue s a k ν i j).eval N⁻¹ =
      (bennettClearedResidue s a k ν i j).eval N := by
  apply bennettResidueTaylor_homogenize
  · split_ifs <;> omega
  · exact hN

end Nodes

end D1Bound5
