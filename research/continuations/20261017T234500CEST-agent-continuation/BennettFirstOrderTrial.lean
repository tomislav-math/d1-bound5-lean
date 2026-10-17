import Mathlib.LinearAlgebra.Lagrange
import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

open Finset Polynomial Matrix

namespace D1Bound5

section Field

variable {F : Type*} [Field F] {n : ℕ}

/-- Differentiation in the Lagrange interpolation basis at distinct nodes. -/
noncomputable def lagrangeDifferentiation (a : Fin n → F) :
    Matrix (Fin n) (Fin n) F :=
  fun i j => ((Lagrange.basis Finset.univ a j).derivative).eval (a i)

/-- The interpolation differentiation matrix differentiates every monomial
of degree strictly smaller than the number of nodes. -/
theorem lagrangeDifferentiation_moment (a : Fin n → F)
    (ha : Function.Injective a) (i j : Fin n) :
    (∑ k : Fin n, lagrangeDifferentiation a i k * a k ^ j.val) =
      (j.val : F) * a i ^ (j.val - 1) := by
  classical
  have hdeg : (X ^ j.val : F[X]).degree < (Finset.univ : Finset (Fin n)).card := by
    simpa using (show (j.val : WithBot ℕ) < (n : WithBot ℕ) from
      WithBot.coe_lt_coe.mpr j.isLt)
  have heq := Lagrange.eq_interpolate (s := (Finset.univ : Finset (Fin n)))
    (v := a) (f := (X ^ j.val : F[X])) ha.injOn hdeg
  have hd := congrArg (fun p : F[X] => p.derivative.eval (a i)) heq
  simpa [Lagrange.interpolate_apply, lagrangeDifferentiation,
    Polynomial.derivative_sum, Polynomial.derivative_C_mul,
    Polynomial.derivative_X_pow, Polynomial.eval_finsetSum, mul_comm] using hd.symm

/-- The monomial image under `t - (N+X) d/dX`, written without a derivative. -/
noncomputable def bennettFirstOrderMonomial (N t : F) (j : ℕ) : F[X] :=
  C (t - (j : F)) * X ^ j - C (N * (j : F)) * X ^ (j - 1)

theorem bennettFirstOrderMonomial_natDegree_le (N t : F) (j : ℕ) :
    (bennettFirstOrderMonomial N t j).natDegree ≤ j := by
  unfold bennettFirstOrderMonomial
  exact (Polynomial.natDegree_sub_le _ _).trans
    (max_le (Polynomial.natDegree_C_mul_X_pow_le _ _)
      ((Polynomial.natDegree_C_mul_X_pow_le _ _).trans (Nat.sub_le _ _)))

theorem bennettFirstOrderMonomial_eval (N t x : F) (j : ℕ) :
    (bennettFirstOrderMonomial N t j).eval x =
      t * x ^ j - (N + x) * ((j : F) * x ^ (j - 1)) := by
  cases j with
  | zero => simp [bennettFirstOrderMonomial]
  | succ j =>
    simp only [bennettFirstOrderMonomial, eval_sub, eval_mul, eval_C,
      eval_pow, eval_X, Nat.add_sub_cancel]
    rw [pow_succ]
    ring

/-- Coefficient matrix of the monomial images; it is upper bidiagonal. -/
noncomputable def bennettFirstOrderCoefficients (N t : F) :
    Matrix (Fin n) (Fin n) F :=
  fun i j => (bennettFirstOrderMonomial N t j.val).coeff i.val

theorem bennettFirstOrderCoefficients_det (N t : F) :
    (bennettFirstOrderCoefficients (n := n) N t).det =
      ∏ j : Fin n, (t - (j.val : F)) := by
  classical
  have htri : (bennettFirstOrderCoefficients (n := n) N t).IsUpperTriangular := by
    intro i j hij
    apply Polynomial.coeff_eq_zero_of_natDegree_lt
    exact lt_of_le_of_lt (bennettFirstOrderMonomial_natDegree_le N t j.val) hij
  rw [Matrix.det_of_isUpperTriangular htri]
  apply Finset.prod_congr rfl
  intro j _
  change (bennettFirstOrderMonomial N t j.val).coeff j.val = _
  by_cases hj : j.val = 0
  · simp [bennettFirstOrderMonomial, hj]
  · have hj' : j.val - 1 ≠ j.val := by omega
    simp [bennettFirstOrderMonomial, coeff_C_mul, coeff_X_pow, hj']

theorem vandermonde_mul_bennettFirstOrderCoefficients (a : Fin n → F) (N t : F) :
    Matrix.vandermonde a * bennettFirstOrderCoefficients N t =
      fun i j => (bennettFirstOrderMonomial N t j.val).eval (a i) := by
  classical
  ext i j
  have hd : (bennettFirstOrderMonomial N t j.val).natDegree < n :=
    lt_of_le_of_lt (bennettFirstOrderMonomial_natDegree_le N t j.val) j.isLt
  simp only [Matrix.mul_apply, Matrix.vandermonde_apply,
    bennettFirstOrderCoefficients]
  rw [Polynomial.eval_eq_sum_range' hd, ← Fin.sum_univ_eq_sum_range]
  apply Finset.sum_congr rfl
  intro k _
  exact mul_comm _ _

/-- The first-order differential operator in the evaluation basis. -/
noncomputable def bennettFirstOrderOperator (a : Fin n → F) (N t : F) :
    Matrix (Fin n) (Fin n) F :=
  Matrix.scalar (Fin n) t -
    Matrix.diagonal (fun i => N + a i) * lagrangeDifferentiation a

/-- Interpolation conjugates the differential operator to its upper triangular
monomial coefficient matrix. This is valid in arbitrary characteristic. -/
theorem bennettFirstOrderOperator_mul_vandermonde (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    bennettFirstOrderOperator a N t * Matrix.vandermonde a =
      Matrix.vandermonde a * bennettFirstOrderCoefficients N t := by
  classical
  rw [vandermonde_mul_bennettFirstOrderCoefficients]
  ext i j
  rw [bennettFirstOrderMonomial_eval]
  simp only [bennettFirstOrderOperator, Matrix.sub_mul, Matrix.mul_assoc,
    Matrix.sub_apply, Matrix.diagonal_mul, Matrix.scalar_apply,
    Matrix.vandermonde_apply]
  change t * a i ^ j.val - (N + a i) *
    (∑ k : Fin n, lagrangeDifferentiation a i k * a k ^ j.val) = _
  rw [lagrangeDifferentiation_moment a ha]

/-- The all-size first-order Bennett operator determinant. No distinctness of
`N+a i`, nonzero-node hypothesis, or characteristic-zero assumption is required. -/
theorem bennettFirstOrderOperator_det (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    (bennettFirstOrderOperator a N t).det =
      ∏ j : Fin n, (t - (j.val : F)) := by
  have h := congrArg Matrix.det
    (bennettFirstOrderOperator_mul_vandermonde a ha N t)
  rw [Matrix.det_mul, Matrix.det_mul, bennettFirstOrderCoefficients_det] at h
  apply mul_right_cancel₀ (Matrix.det_vandermonde_ne_zero_iff.mpr ha)
  simpa [mul_comm] using h

/-- The opposite product has the same characteristic determinant. This is the
orientation used by the residue coefficients after row normalization. -/
theorem bennettFirstOrderReverse_det (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    (Matrix.scalar (Fin n) t - lagrangeDifferentiation a *
      Matrix.diagonal (fun i => N + a i)).det =
      ∏ j : Fin n, (t - (j.val : F)) := by
  have h := congrArg (fun p : F[X] => p.eval t)
    (Matrix.charpoly_mul_comm (lagrangeDifferentiation a)
      (Matrix.diagonal (fun i => N + a i)))
  rw [Matrix.eval_charpoly, Matrix.eval_charpoly] at h
  exact h.trans (bennettFirstOrderOperator_det a ha N t)

/-- The k=1 residue matrix in its intrinsic Lagrange derivative form. The
explicit reciprocal-difference residue formula is a separate identification. -/
noncomputable def bennettFirstOrderResidue (a : Fin n → F) (N t : F) :
    Matrix (Fin n) (Fin n) F :=
  Matrix.diagonal (fun i => N⁻¹ * Lagrange.nodalWeight Finset.univ a i) *
    (Matrix.scalar (Fin n) t - lagrangeDifferentiation a *
      Matrix.diagonal (fun i => N + a i))

/-- Exact arbitrary-size determinant of the first-order Lagrange residue
matrix, including the full product of reciprocal node differences. -/
theorem bennettFirstOrderResidue_det (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    (bennettFirstOrderResidue a N t).det =
      (N⁻¹) ^ n * (∏ i : Fin n, Lagrange.nodalWeight Finset.univ a i) *
        ∏ j : Fin n, (t - (j.val : F)) := by
  rw [bennettFirstOrderResidue, Matrix.det_mul, Matrix.det_diagonal,
    bennettFirstOrderReverse_det a ha, Finset.prod_mul_distrib]
  simp [mul_assoc]

end Field

end D1Bound5
