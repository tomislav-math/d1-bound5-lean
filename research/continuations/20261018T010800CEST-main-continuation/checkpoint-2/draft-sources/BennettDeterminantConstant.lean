import D1Bound5.BennettResidualCancellation
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.CharZero.Infinite

open Finset

namespace D1Bound5

variable {F I : Type*} [Field F] [CharZero F]
variable [Fintype I] [DecidableEq I]

/-- The arbitrary-order cleared polynomial matrix used in node removal. -/
noncomputable def bennettClearedMatrix (a : I → F) (k : ℕ) (ν : F) :
    Matrix I I (Polynomial F) :=
  Matrix.of fun i j ↦ bennettClearedResidue Finset.univ a k ν i j

/-- Homogenization of the actual matrices, with all scalar powers retained. -/
theorem bennettClearedMatrix_eval (a : I → F) (k : ℕ) (ν N : F) (hN : N ≠ 0) :
    (bennettClearedMatrix a k ν).map (Polynomial.evalRingHom N) =
      N ^ k • (bennettPolynomialMatrix a k ν).map (Polynomial.evalRingHom N⁻¹) := by
  ext i j
  exact (bennettPolynomialResidue_homogenize Finset.univ a k ν N i j hN).symm

/-- The determinant of the cleared matrix evaluates to the single coefficient
of the original determinant at every nonzero value of the variable. -/
theorem bennettClearedMatrix_det_eval_of_ne_zero
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (q : I) (hq : a q = 0) (N : F) (hN : N ≠ 0) :
    (bennettClearedMatrix a k ν).det.eval N =
      (bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k) := by
  calc
    _ = ((bennettClearedMatrix a k ν).map (Polynomial.evalRingHom N)).det :=
      (Polynomial.evalRingHom N).map_det _
    _ = (N ^ k) ^ Fintype.card I *
        (bennettPolynomialMatrix a k ν).det.eval N⁻¹ := by
      rw [bennettClearedMatrix_eval a k ν N hN, Matrix.det_smul]
      exact congrArg (fun z : F => (N ^ k) ^ Fintype.card I * z)
        ((Polynomial.evalRingHom N⁻¹).map_det (bennettPolynomialMatrix a k ν)).symm
    _ = (N ^ k) ^ Fintype.card I *
        ((bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k) *
          (N⁻¹) ^ (Fintype.card I * k)) := by
      conv_lhs => rw [bennettPolynomialMatrix_det_monomial a ha k hk ν q hq]
      rw [Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow, Polynomial.eval_X]
    _ = _ := by
      rw [← pow_mul, Nat.mul_comm k (Fintype.card I)]
      calc
        N ^ (Fintype.card I * k) *
            ((bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k) *
              (N⁻¹) ^ (Fintype.card I * k)) =
            (bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k) *
              (N ^ (Fintype.card I * k) * (N⁻¹) ^ (Fintype.card I * k)) := by ring
        _ = _ := by rw [← mul_pow, mul_inv_cancel₀ hN, one_pow, mul_one]

/-- The cleared determinant is a constant polynomial. Consequently evaluation
at a removed node, including zero, is justified algebraically. -/
theorem bennettClearedMatrix_det_constant
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (q : I) (hq : a q = 0) :
    (bennettClearedMatrix a k ν).det =
      Polynomial.C ((bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k)) := by
  apply Polynomial.eq_of_infinite_eval_eq
  have hinf : Set.Infinite {N : F | N ≠ 0} := by
    simpa using (Set.infinite_univ : Set.Infinite (Set.univ : Set F)).diff
      (Set.finite_singleton (0 : F))
  apply hinf.mono
  intro N hN
  simpa only [Set.mem_setOf_eq, Polynomial.eval_C] using
    bennettClearedMatrix_det_eval_of_ne_zero a ha k hk ν q hq N hN

/-- Any two evaluations of the cleared determinant agree. -/
theorem bennettClearedMatrix_det_eval_eq
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (q : I) (hq : a q = 0) (N M : F) :
    (bennettClearedMatrix a k ν).det.eval N =
      (bennettClearedMatrix a k ν).det.eval M := by
  simp only [bennettClearedMatrix_det_constant a ha k hk ν q hq, Polynomial.eval_C]

end D1Bound5
