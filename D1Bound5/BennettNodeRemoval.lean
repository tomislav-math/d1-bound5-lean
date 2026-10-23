import D1Bound5.BennettDeterminantConstant
import Mathlib.Algebra.BigOperators.Fin

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- Products over all nodes except the last are products over the prefix. -/
theorem bennett_prod_erase_last {M : Type*} [CommMonoid M] (n : ℕ)
    (f : Fin (n + 1) → M) :
    (∏ l ∈ (Finset.univ : Finset (Fin (n + 1))).erase (Fin.last n), f l) =
      ∏ l : Fin n, f l.castSucc := by
  rw [← Finset.prod_ite_mem_eq]
  rw [Fin.prod_univ_castSucc]
  simp

/-- The same reindexing with one further local pole omitted. -/
theorem bennett_prod_erase_last_erase {M : Type*} [CommMonoid M] (n : ℕ)
    (j : Fin n) (f : Fin (n + 1) → M) :
    (∏ l ∈ ((Finset.univ : Finset (Fin (n + 1))).erase (Fin.last n)).erase
      j.castSucc, f l) = ∏ l ∈ (Finset.univ : Finset (Fin n)).erase j, f l.castSucc := by
  rw [← Finset.prod_ite_mem_eq, Fin.prod_univ_castSucc,
    ← Finset.prod_ite_mem_eq (Finset.univ.erase j)]
  simp

/-- Removing the final node gives exactly the cleared residue construction on
the prefix, including the distinguished row multiplicity. -/
theorem bennettClearedResidue_prefix (n : ℕ) (a : Fin (n + 1) → F)
    (k : ℕ) (ν : F) (i j : Fin n) :
    bennettClearedResidue (Finset.univ.erase (Fin.last n)) a k ν i.castSucc j.castSucc =
      bennettClearedResidue Finset.univ (fun l : Fin n ↦ a l.castSucc) k ν i j := by
  unfold bennettClearedResidue
  simp only [Fin.castSucc_inj]
  congr 1
  unfold bennettOtherPoles
  rw [bennett_prod_erase_last_erase]
  simp only [Fin.castSucc_inj]

/-- Exact determinant reduction at the removed node. Both directions of every
new node difference are retained, so this identity contains its full sign. -/
theorem bennettClearedMatrix_det_remove_last
    (n : ℕ) (a : Fin (n + 1) → F) (ha : Function.Injective a)
    (k : ℕ) (hk : 1 ≤ k) (ν : F) :
    (bennettClearedMatrix a k ν).det.eval (-a (Fin.last n)) =
      Ring.choose ((k : F) + ν) k *
        (∏ j : Fin n, ((a (Fin.last n) - a j.castSucc)⁻¹) ^ k) *
        (∏ j : Fin n, ((a j.castSucc - a (Fin.last n))⁻¹) ^ k) *
        (bennettClearedMatrix (fun j : Fin n ↦ a j.castSucc) k
          (ν - (k : F))).det.eval (-a (Fin.last n)) := by
  let A : Matrix (Fin (n + 1)) (Fin (n + 1)) F :=
    (bennettClearedMatrix a k ν).map (Polynomial.evalRingHom (-a (Fin.last n)))
  let B : Matrix (Fin n) (Fin n) F :=
    (bennettClearedMatrix (fun j : Fin n ↦ a j.castSucc) k (ν - (k : F))).map
      (Polynomial.evalRingHom (-a (Fin.last n)))
  have hsign : (-1 : F) ^ (n + n) = 1 := by
    calc
      _ = ((-1 : F) * (-1)) ^ n := by rw [pow_add, mul_pow]
      _ = _ := by simp
  have hdiag : A (Fin.last n) (Fin.last n) =
      Ring.choose ((k : F) + ν) k *
        ∏ j : Fin n, ((a (Fin.last n) - a j.castSucc)⁻¹) ^ k := by
    change (bennettClearedResidue Finset.univ a k ν (Fin.last n) (Fin.last n)).eval
      (-a (Fin.last n)) = _
    rw [bennettClearedResidue_diagonal_at_node, bennett_prod_erase_last]
  have hminor : A.submatrix Fin.castSucc Fin.castSucc =
      Matrix.of (fun i j : Fin n ↦ ((a j.castSucc - a (Fin.last n))⁻¹) ^ k * B i j) := by
    apply Matrix.ext
    intro i j
    change (bennettClearedResidue Finset.univ a k ν i.castSucc j.castSucc).eval
      (-a (Fin.last n)) =
        ((a j.castSucc - a (Fin.last n))⁻¹) ^ k *
          (bennettClearedResidue Finset.univ (fun l : Fin n ↦ a l.castSucc) k
            (ν - (k : F)) i j).eval (-a (Fin.last n))
    rw [bennettClearedResidue_remove_node Finset.univ a k ν i.castSucc j.castSucc
      (Fin.last n) (Finset.mem_univ _) (Fin.castSucc_ne_last i)
        (Fin.castSucc_ne_last j) (ha.ne (Fin.castSucc_ne_last j)),
      bennettClearedResidue_prefix]
  have hdet : A.det = A (Fin.last n) (Fin.last n) *
      (A.submatrix Fin.castSucc Fin.castSucc).det := by
    rw [Matrix.det_succ_column A (Fin.last n), Finset.sum_eq_single (Fin.last n)]
    · simp only [Fin.val_last, Fin.succAbove_last, hsign, one_mul]
    · intro i hi hne
      have hz : A i (Fin.last n) = 0 := by
        exact bennettClearedResidue_offDiagonal_at_node Finset.univ a k hk ν i
          (Fin.last n) hne
      rw [hz, mul_zero, zero_mul]
    · simp
  calc
    _ = A.det := (Polynomial.evalRingHom (-a (Fin.last n))).map_det _
    _ = _ := by
      rw [hdet, hdiag, hminor, Matrix.det_mul_row]
      have hB : B.det =
          (bennettClearedMatrix (fun j : Fin n ↦ a j.castSucc) k
            (ν - (k : F))).det.eval (-a (Fin.last n)) :=
        ((Polynomial.evalRingHom (-a (Fin.last n))).map_det _).symm
      rw [hB]
      ring

end D1Bound5
