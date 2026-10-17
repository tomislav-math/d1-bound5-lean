import D1Bound5.BennettPoleSeries
import Mathlib.Algebra.Polynomial.BigOperators
import Mathlib.Algebra.Polynomial.Degree.Operations
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- A cleared local residue polynomial. The coefficient index `r` is the
pole order minus one, and will be either `k-1` or `k`. -/
noncomputable def bennettClearedTaylor (k r : ℕ) (ν a : F)
    (B : PowerSeries F) : Polynomial F :=
  ∑ ht ∈ Finset.antidiagonal r,
    Polynomial.C (Ring.choose ((k : F) + ν) ht.1 * PowerSeries.coeff ht.2 B) *
      (Polynomial.X + Polynomial.C a) ^ (k - ht.1)

/-- Every cleared residue polynomial has degree at most the approximation order. -/
theorem bennettClearedTaylor_natDegree_le (k r : ℕ) (ν a : F)
    (B : PowerSeries F) :
    (bennettClearedTaylor k r ν a B).natDegree ≤ k := by
  unfold bennettClearedTaylor
  apply Polynomial.natDegree_sum_le_of_forall_le
  intro ht _
  apply (Polynomial.natDegree_C_mul_le _ _).trans
  apply Polynomial.natDegree_pow_le.trans
  simpa only [Polynomial.natDegree_X_add_C, mul_one] using (Nat.sub_le k ht.1)

/-- Evaluation away from the local origin is a single exact coefficient of
the rescaled binomial series times the remaining reciprocal poles. -/
theorem bennettClearedTaylor_eval (k r : ℕ) (hr : r ≤ k) (ν a N : F)
    (B : PowerSeries F) (hd : N + a ≠ 0) :
    (bennettClearedTaylor k r ν a B).eval N =
      (N + a) ^ k * PowerSeries.coeff r
        (PowerSeries.rescale (N + a)⁻¹
          (PowerSeries.binomialSeries F ((k : F) + ν)) * B) := by
  unfold bennettClearedTaylor
  rw [Polynomial.eval_finsetSum, PowerSeries.coeff_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro ht hht
  have hsum := Finset.mem_antidiagonal.mp hht
  have hh : ht.1 ≤ k := by omega
  simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
    Polynomial.eval_add, Polynomial.eval_X, PowerSeries.coeff_rescale,
    PowerSeries.binomialSeries_coeff, smul_eq_mul, mul_one]
  rw [pow_sub₀ (N + a) hd hh, inv_pow]
  ring

/-- The single-pole node-removal identity is precisely Chu--Vandermonde,
expressed by multiplication of formal binomial series. -/
theorem bennettClearedTaylor_eval_remove_pole
    (k r : ℕ) (hr : r ≤ k) (ν a N : F) (B : PowerSeries F)
    (hd : N + a ≠ 0) :
    (bennettClearedTaylor k r ν a
      (bennettPoleSeries (N + a) k * B)).eval N =
      ((N + a)⁻¹) ^ k *
        (bennettClearedTaylor k r (ν - (k : F)) a B).eval N := by
  rw [bennettClearedTaylor_eval k r hr ν a N _ hd,
    bennettClearedTaylor_eval k r hr (ν - (k : F)) a N B hd]
  have he : ((k : F) + ν) + -(k : F) = (k : F) + (ν - (k : F)) := by ring
  have hs :
      PowerSeries.rescale (N + a)⁻¹
          (PowerSeries.binomialSeries F ((k : F) + ν)) *
        (bennettPoleSeries (N + a) k * B) =
      PowerSeries.C (((N + a)⁻¹) ^ k) *
        (PowerSeries.rescale (N + a)⁻¹
          (PowerSeries.binomialSeries F ((k : F) + (ν - (k : F)))) * B) := by
    unfold bennettPoleSeries
    calc
      _ = PowerSeries.C (((N + a)⁻¹) ^ k) *
          ((PowerSeries.rescale (N + a)⁻¹
              (PowerSeries.binomialSeries F ((k : F) + ν)) *
            PowerSeries.rescale (N + a)⁻¹
              (PowerSeries.binomialSeries F (-(k : F)))) * B) := by ring
      _ = _ := by rw [← map_mul, ← PowerSeries.binomialSeries_add, he]
  rw [hs, PowerSeries.coeff_C_mul]
  ring

section Nodes

variable {I : Type*} [DecidableEq I]

/-- All local pole factors except the pole whose residue is being extracted. -/
noncomputable def bennettOtherPoles (s : Finset I) (a : I → F)
    (k : ℕ) (i j : I) : PowerSeries F :=
  ∏ l ∈ s.erase j, bennettPoleSeries (a j - a l) (k + if i = l then 1 else 0)

/-- The actual arbitrary-order cleared Bennett residue polynomial.
For positive k this is exactly the finite residue construction in the paper,
with the reciprocal-pole multi-index sum grouped into a formal coefficient. -/
noncomputable def bennettClearedResidue (s : Finset I) (a : I → F)
    (k : ℕ) (ν : F) (i j : I) : Polynomial F :=
  bennettClearedTaylor k (k + (if i = j then 1 else 0) - 1) ν (a j)
    (bennettOtherPoles s a k i j)

theorem bennettClearedResidue_natDegree_le (s : Finset I) (a : I → F)
    (k : ℕ) (ν : F) (i j : I) :
    (bennettClearedResidue s a k ν i j).natDegree ≤ k :=
  bennettClearedTaylor_natDegree_le _ _ _ _ _

/-- Removing a different node splits off exactly its reciprocal pole. -/
theorem bennettOtherPoles_remove (s : Finset I) (a : I → F)
    (k : ℕ) (i j q : I) (hq : q ∈ s) (hiq : i ≠ q) (hjq : j ≠ q) :
    bennettOtherPoles s a k i j =
      bennettPoleSeries (a j - a q) k *
        bennettOtherPoles (s.erase q) a k i j := by
  have hqj : q ∈ s.erase j := Finset.mem_erase.mpr ⟨hjq.symm, hq⟩
  unfold bennettOtherPoles
  rw [← Finset.mul_prod_erase (s.erase j)
    (fun l => bennettPoleSeries (a j - a l) (k + if i = l then 1 else 0)) hqj]
  simp only [if_neg hiq, add_zero, Finset.erase_right_comm]

/-- Exact arbitrary-order node removal, including the parameter shift ν-k
and the full column scaling. No determinant formula is assumed. -/
theorem bennettClearedResidue_remove_node (s : Finset I) (a : I → F)
    (k : ℕ) (ν : F) (i j q : I) (hq : q ∈ s)
    (hiq : i ≠ q) (hjq : j ≠ q) (ha : a j ≠ a q) :
    (bennettClearedResidue s a k ν i j).eval (-a q) =
      ((a j - a q)⁻¹) ^ k *
        (bennettClearedResidue (s.erase q) a k (ν - (k : F)) i j).eval (-a q) := by
  have hr : k + (if i = j then 1 else 0) - 1 ≤ k := by split_ifs <;> omega
  have hd : -a q + a j ≠ 0 := by
    simpa [sub_eq_add_neg, add_comm] using sub_ne_zero.mpr ha
  unfold bennettClearedResidue
  rw [bennettOtherPoles_remove s a k i j q hq hiq hjq]
  have he : a j - a q = -a q + a j := by ring
  rw [he]
  exact bennettClearedTaylor_eval_remove_pole k _ hr ν (a j) (-a q) _ hd

/-- At N=-a_j the off-diagonal part of column j vanishes identically. -/
theorem bennettClearedResidue_offDiagonal_at_node
    (s : Finset I) (a : I → F) (k : ℕ) (hk : 1 ≤ k) (ν : F)
    (i j : I) (hij : i ≠ j) :
    (bennettClearedResidue s a k ν i j).eval (-a j) = 0 := by
  simp only [bennettClearedResidue, if_neg hij, add_zero,
    bennettClearedTaylor, Polynomial.eval_finsetSum]
  apply Finset.sum_eq_zero
  intro ht hht
  have hsum := Finset.mem_antidiagonal.mp hht
  have hp : 0 < k - ht.1 := by omega
  simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
    Polynomial.eval_add, Polynomial.eval_X, neg_add_cancel,
    zero_pow (Nat.ne_of_gt hp), mul_zero]

theorem bennettPoleSeries_constantCoeff (d : F) (k : ℕ) :
    PowerSeries.constantCoeff (bennettPoleSeries d k) = (d⁻¹) ^ k := by
  rw [← PowerSeries.coeff_zero_eq_constantCoeff_apply, bennettPoleSeries_coeff]
  simp

/-- The surviving diagonal entry at the removed node, with its exact
generalized binomial coefficient and every directed node difference. -/
theorem bennettClearedResidue_diagonal_at_node
    (s : Finset I) (a : I → F) (k : ℕ) (ν : F) (i : I) :
    (bennettClearedResidue s a k ν i i).eval (-a i) =
      Ring.choose ((k : F) + ν) k *
        ∏ l ∈ s.erase i, ((a i - a l)⁻¹) ^ k := by
  simp only [bennettClearedResidue, if_pos rfl, ite_true, Nat.add_sub_cancel,
    bennettClearedTaylor, Polynomial.eval_finsetSum]
  rw [Finset.sum_eq_single (k, 0)]
  · simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
      Polynomial.eval_add, Polynomial.eval_X, neg_add_cancel, tsub_self,
      pow_zero, mul_one, PowerSeries.coeff_zero_eq_constantCoeff_apply,
      bennettOtherPoles, map_prod]
    congr 1
    apply Finset.prod_congr rfl
    intro l hl
    have hli : i ≠ l := (Finset.mem_erase.mp hl).1.symm
    simp only [if_neg hli, add_zero, bennettPoleSeries_constantCoeff]
  · intro ht hht hne
    have hsum := Finset.mem_antidiagonal.mp hht
    have hfirst : ht.1 ≠ k := by
      intro heq
      apply hne
      apply Prod.ext
      · exact heq
      · omega
    have hp : 0 < k - ht.1 := by omega
    simp only [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
      Polynomial.eval_add, Polynomial.eval_X, neg_add_cancel,
      zero_pow (Nat.ne_of_gt hp), mul_zero]
  · intro hn
    exact (hn (Finset.mem_antidiagonal.mpr (by omega))).elim

end Nodes

end D1Bound5
