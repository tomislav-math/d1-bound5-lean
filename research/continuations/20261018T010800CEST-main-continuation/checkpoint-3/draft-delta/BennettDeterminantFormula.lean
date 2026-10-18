import D1Bound5.BennettNodeRemoval

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The generalized binomial product in the all-order determinant formula. -/
noncomputable def bennettBinomialProduct (n k : ℕ) (ν : F) : F :=
  ∏ v ∈ Finset.range n, Ring.choose ((k : F) + ν - (v : F) * (k : F)) k

/-- Every ordered pair of distinct nodes contributes its reciprocal difference. -/
noncomputable def bennettDirectedProduct {I : Type*} [Fintype I] [DecidableEq I]
    (a : I → F) (k : ℕ) : F :=
  ∏ i, ∏ j ∈ Finset.univ.erase i, ((a i - a j)⁻¹) ^ k

theorem bennettBinomialProduct_succ (n k : ℕ) (ν : F) :
    bennettBinomialProduct (n + 1) k ν =
      Ring.choose ((k : F) + ν) k * bennettBinomialProduct n k (ν - (k : F)) := by
  unfold bennettBinomialProduct
  rw [Finset.prod_range_succ']
  simp only [Nat.cast_zero, zero_mul, sub_zero]
  rw [mul_comm]
  congr 1
  apply Finset.prod_congr rfl
  intro v hv
  congr 1
  simp only [Nat.cast_add, Nat.cast_one]
  ring

/-- Splitting the ordered-pair product exposes the two directions involving
the removed node and leaves the ordered-pair product on the prefix. -/
theorem bennettDirectedProduct_succ (n : ℕ) (a : Fin (n + 1) → F) (k : ℕ) :
    bennettDirectedProduct a k =
      (∏ j : Fin n, ((a (Fin.last n) - a j.castSucc)⁻¹) ^ k) *
        (∏ j : Fin n, ((a j.castSucc - a (Fin.last n))⁻¹) ^ k) *
          bennettDirectedProduct (fun j : Fin n ↦ a j.castSucc) k := by
  have hinner (i : Fin n) :
      (∏ j ∈ (Finset.univ : Finset (Fin (n + 1))).erase i.castSucc,
        ((a i.castSucc - a j)⁻¹) ^ k) =
        ((a i.castSucc - a (Fin.last n))⁻¹) ^ k *
          ∏ j ∈ (Finset.univ : Finset (Fin n)).erase i,
            ((a i.castSucc - a j.castSucc)⁻¹) ^ k := by
    have hmem : Fin.last n ∈ (Finset.univ : Finset (Fin (n + 1))).erase i.castSucc := by
      apply Finset.mem_erase.mpr
      refine ⟨?_, Finset.mem_univ _⟩
      intro h
      have hv := congrArg (fun j : Fin (n + 1) => j.val) h
      change n = i.val at hv
      have hi := i.isLt
      omega
    rw [← Finset.mul_prod_erase (Finset.univ.erase i.castSucc)
      (fun j ↦ ((a i.castSucc - a j)⁻¹) ^ k) hmem]
    rw [Finset.erase_right_comm, bennett_prod_erase_last_erase]
  unfold bennettDirectedProduct
  rw [Fin.prod_univ_castSucc, bennett_prod_erase_last]
  simp_rw [hinner]
  rw [Finset.prod_mul_distrib]
  ring

/-- Exact all-order determinant evaluation. In the induction the final node
is removed, retaining the distinguished zero node in every nonempty prefix. -/
theorem bennettClearedMatrix_det_eval_zero_formula (k : ℕ) (hk : 1 ≤ k) :
    ∀ (n : ℕ) (a : Fin (n + 1) → F), Function.Injective a →
      ∀ (ν : F), a 0 = 0 →
        (bennettClearedMatrix a k ν).det.eval 0 =
          bennettBinomialProduct (n + 1) k ν * bennettDirectedProduct a k := by
  intro n
  induction n with
  | zero =>
      intro a ha ν h0
      rw [Matrix.det_fin_one]
      change (bennettClearedResidue Finset.univ a k ν 0 0).eval 0 = _
      have hdiag := bennettClearedResidue_diagonal_at_node Finset.univ a k ν (0 : Fin 1)
      rw [h0, neg_zero] at hdiag
      rw [hdiag]
      simp [bennettBinomialProduct, bennettDirectedProduct]
  | succ n ih =>
      intro a ha ν h0
      let b : Fin (n + 1) → F := fun j ↦ a j.castSucc
      have hb : Function.Injective b := ha.comp (Fin.castSucc_injective (n + 1))
      have hb0 : b 0 = 0 := h0
      calc
        _ = (bennettClearedMatrix a k ν).det.eval (-a (Fin.last (n + 1))) :=
          bennettClearedMatrix_det_eval_eq a ha k hk ν 0 h0 0 _
        _ = Ring.choose ((k : F) + ν) k *
            (∏ j : Fin (n + 1), ((a (Fin.last (n + 1)) - a j.castSucc)⁻¹) ^ k) *
            (∏ j : Fin (n + 1), ((a j.castSucc - a (Fin.last (n + 1)))⁻¹) ^ k) *
            (bennettClearedMatrix b k (ν - (k : F))).det.eval
              (-a (Fin.last (n + 1))) :=
          bennettClearedMatrix_det_remove_last (n + 1) a ha k hk ν
        _ = Ring.choose ((k : F) + ν) k *
            (∏ j : Fin (n + 1), ((a (Fin.last (n + 1)) - a j.castSucc)⁻¹) ^ k) *
            (∏ j : Fin (n + 1), ((a j.castSucc - a (Fin.last (n + 1)))⁻¹) ^ k) *
            (bennettBinomialProduct (n + 1) k (ν - (k : F)) *
              bennettDirectedProduct b k) := by
          rw [bennettClearedMatrix_det_eval_eq b hb k hk (ν - (k : F)) 0 hb0
            (-a (Fin.last (n + 1))) 0, ih b hb (ν - (k : F)) hb0]
        _ = _ := by
          rw [bennettBinomialProduct_succ (n + 1) k ν,
            bennettDirectedProduct_succ (n + 1) a k]
          dsimp [b]
          ring

/-- The cleared determinant equals the explicit product as a polynomial,
including its value at every possible evaluation point. -/
theorem bennettClearedMatrix_det_formula
    (n : ℕ) (a : Fin (n + 1) → F) (ha : Function.Injective a)
    (k : ℕ) (hk : 1 ≤ k) (ν : F) (h0 : a 0 = 0) :
    (bennettClearedMatrix a k ν).det =
      Polynomial.C (bennettBinomialProduct (n + 1) k ν * bennettDirectedProduct a k) := by
  calc
    _ = Polynomial.C ((bennettClearedMatrix a k ν).det.eval 0) := by
      rw [bennettClearedMatrix_det_constant a ha k hk ν 0 h0]
      simp
    _ = _ := by rw [bennettClearedMatrix_det_eval_zero_formula k hk n a ha ν h0]

/-- The exact determinant of the original polynomial residue matrix. The
constant is the binomial product times every directed node difference. -/
theorem bennettPolynomialMatrix_det_formula
    (n : ℕ) (a : Fin (n + 1) → F) (ha : Function.Injective a)
    (k : ℕ) (hk : 1 ≤ k) (ν : F) (h0 : a 0 = 0) :
    (bennettPolynomialMatrix a k ν).det =
      Polynomial.C (bennettBinomialProduct (n + 1) k ν * bennettDirectedProduct a k) *
        Polynomial.X ^ ((n + 1) * k) := by
  have hc := bennettClearedMatrix_det_eval_zero_formula k hk n a ha ν h0
  rw [bennettClearedMatrix_det_constant a ha k hk ν 0 h0, Polynomial.eval_C] at hc
  rw [bennettPolynomialMatrix_det_monomial a ha k hk ν 0 h0, hc]
  simp

end D1Bound5
