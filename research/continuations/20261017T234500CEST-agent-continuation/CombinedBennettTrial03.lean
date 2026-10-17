import Mathlib.LinearAlgebra.Lagrange
import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega
import Mathlib.RingTheory.PowerSeries.Binomial

-- SOURCE: bennett_draft/BennettFirstOrder.lean

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
  simp only [Lagrange.interpolate_apply,
    Polynomial.derivative_sum, Polynomial.derivative_C_mul,
    Polynomial.derivative_X_pow, Polynomial.eval_finsetSum,
    Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow,
    Polynomial.eval_X] at hd
  simpa only [lagrangeDifferentiation, mul_comm] using hd.symm

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
    simp only [bennettFirstOrderMonomial, coeff_sub, coeff_C_mul,
      coeff_X_pow, hj', Ne.symm hj', ite_true, ite_false, mul_one,
      mul_zero, sub_zero]

theorem vandermonde_mul_bennettFirstOrderCoefficients (a : Fin n → F) (N t : F) :
    Matrix.vandermonde a * bennettFirstOrderCoefficients N t =
      Matrix.of (fun i j => (bennettFirstOrderMonomial N t j.val).eval (a i)) := by
  classical
  ext i j
  have hd : (bennettFirstOrderMonomial N t j.val).natDegree < n :=
    lt_of_le_of_lt (bennettFirstOrderMonomial_natDegree_le N t j.val) j.isLt
  simp only [Matrix.mul_apply, Matrix.vandermonde_apply,
    bennettFirstOrderCoefficients, Matrix.of_apply]
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
  change (bennettFirstOrderOperator a N t * Matrix.vandermonde a) i j =
    (bennettFirstOrderMonomial N t j.val).eval (a i)
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


-- SOURCE: bennett_draft/BennettFirstOrderResidues.lean

open Finset Polynomial Matrix

namespace D1Bound5

section Field

variable {F : Type*} [Field F] {n : ℕ}

theorem eval_derivative_basisDivisor (x y z : F) :
    (Lagrange.basisDivisor x y).derivative.eval z = (x - y)⁻¹ := by
  simp [Lagrange.basisDivisor, Polynomial.derivative_C_mul]

/-- The diagonal entry is the logarithmic derivative of the nodal product
with its vanishing factor omitted. -/
theorem lagrangeDifferentiation_diagonal (a : Fin n → F)
    (ha : Function.Injective a) (i : Fin n) :
    lagrangeDifferentiation a i i =
      ∑ j ∈ Finset.univ.erase i, (a i - a j)⁻¹ := by
  classical
  unfold lagrangeDifferentiation Lagrange.basis
  rw [Polynomial.derivative_prod_finset, Polynomial.eval_finsetSum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [Polynomial.eval_mul, Polynomial.eval_prod, eval_derivative_basisDivisor]
  have hp : (∏ l ∈ (Finset.univ.erase i).erase j,
      (Lagrange.basisDivisor (a i) (a l)).eval (a i)) = 1 := by
    apply Finset.prod_eq_one
    intro l hl
    apply Lagrange.eval_basisDivisor_left_of_ne
    exact fun h => (Finset.mem_erase.mp (Finset.mem_erase.mp hl).2).1 (ha h).symm
  rw [hp, one_mul]

theorem lagrange_basis_eq_weight_mul_nodal_erase (a : Fin n → F) (j : Fin n) :
    Lagrange.basis Finset.univ a j =
      C (Lagrange.nodalWeight Finset.univ a j) *
        Lagrange.nodal (Finset.univ.erase j) a := by
  classical
  simp only [Lagrange.basis, Lagrange.basisDivisor, Lagrange.nodalWeight,
    Lagrange.nodal, Finset.prod_mul_distrib, map_prod]

/-- The off-diagonal derivative identity in the normalization appearing
in Bennett's residue matrix. -/
theorem nodalWeight_mul_lagrangeDifferentiation_offDiagonal
    (a : Fin n → F) (ha : Function.Injective a) (i j : Fin n) (hij : i ≠ j) :
    Lagrange.nodalWeight Finset.univ a i * lagrangeDifferentiation a i j =
      Lagrange.nodalWeight Finset.univ a j / (a i - a j) := by
  classical
  have hi : i ∈ Finset.univ.erase j := by simp [hij]
  have hj : j ∈ Finset.univ.erase i := by simp [Ne.symm hij]
  have hdiff : a i - a j ≠ 0 := sub_ne_zero.mpr (fun h => hij (ha h))
  have hprod : (∏ l ∈ Finset.univ.erase i, (a i - a l)) ≠ 0 := by
    apply Finset.prod_ne_zero_iff.mpr
    intro l hl
    apply sub_ne_zero.mpr
    exact fun h => (Finset.mem_erase.mp hl).1 (ha h).symm
  have hweight : Lagrange.nodalWeight Finset.univ a i *
      ((a i - a j) * ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) = 1 := by
    rw [Finset.mul_prod_erase (Finset.univ.erase i) (fun l => a i - a l) hj,
      Lagrange.nodalWeight,
      Finset.prod_inv_distrib]
    exact inv_mul_cancel₀ hprod
  have hcancel : Lagrange.nodalWeight Finset.univ a i *
      (∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) = (a i - a j)⁻¹ := by
    apply mul_right_cancel₀ hdiff
    calc
      (Lagrange.nodalWeight Finset.univ a i *
          (∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l))) * (a i - a j) =
        Lagrange.nodalWeight Finset.univ a i *
          ((a i - a j) * ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) := by ring
      _ = 1 := hweight
      _ = (a i - a j)⁻¹ * (a i - a j) := (inv_mul_cancel₀ hdiff).symm
  unfold lagrangeDifferentiation
  rw [lagrange_basis_eq_weight_mul_nodal_erase,
    Polynomial.derivative_C_mul, Polynomial.eval_mul, Polynomial.eval_C,
    Lagrange.eval_nodal_derivative_eval_node_eq hi, Lagrange.eval_nodal]
  rw [Finset.erase_right_comm]
  calc
    _ = Lagrange.nodalWeight Finset.univ a j *
        (Lagrange.nodalWeight Finset.univ a i *
          ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) := by ring
    _ = _ := by rw [hcancel, div_eq_mul_inv]

/-- The explicit k=1 residue matrix, including both diagonal derivatives
and the simple off-diagonal reciprocal-difference expression. -/
noncomputable def bennettFirstOrderExplicit (a : Fin n → F) (N t : F) :
    Matrix (Fin n) (Fin n) F := fun i j =>
  if i = j then
    N⁻¹ * Lagrange.nodalWeight Finset.univ a i *
      (t - (N + a i) * ∑ l ∈ Finset.univ.erase i, (a i - a l)⁻¹)
  else
    N⁻¹ * (N + a j) * Lagrange.nodalWeight Finset.univ a j / (a j - a i)

theorem bennettFirstOrderResidue_eq_explicit (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    bennettFirstOrderResidue a N t = bennettFirstOrderExplicit a N t := by
  classical
  ext i j
  simp only [bennettFirstOrderResidue, Matrix.diagonal_mul, Matrix.mul_diagonal,
    Matrix.sub_apply, Matrix.scalar_apply, Matrix.diagonal_apply,
    bennettFirstOrderExplicit]
  split_ifs with hij
  · subst j
    rw [lagrangeDifferentiation_diagonal a ha]
    ring
  · have h := nodalWeight_mul_lagrangeDifferentiation_offDiagonal a ha i j hij
    have hs : a j - a i = -(a i - a j) := by ring
    rw [hs, div_neg]
    calc
      _ = -(N⁻¹ * (N + a j) *
        (Lagrange.nodalWeight Finset.univ a i * lagrangeDifferentiation a i j)) := by ring
      _ = _ := by rw [h]; ring

/-- Arbitrary-size k=1 Bennett determinant for the explicit residue entries. -/
theorem bennettFirstOrderExplicit_det (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    (bennettFirstOrderExplicit a N t).det =
      (N⁻¹) ^ n * (∏ i : Fin n, Lagrange.nodalWeight Finset.univ a i) *
        ∏ j : Fin n, (t - (j.val : F)) := by
  rw [← bennettFirstOrderResidue_eq_explicit a ha]
  exact bennettFirstOrderResidue_det a ha N t

/-- At the manuscript parameter `t=3/2`, no diagonal spectral factor can
vanish in characteristic zero. -/
theorem three_halves_sub_natCast_ne_zero [CharZero F] (j : ℕ) :
    (3 / 2 : F) - (j : F) ≠ 0 := by
  intro h
  have htwo : (2 : F) ≠ 0 := by norm_num
  have heq : (3 : F) = (j : F) * 2 :=
    (div_eq_iff htwo).mp (sub_eq_zero.mp h)
  have hi : (3 : ℤ) = (j : ℤ) * 2 := by exact_mod_cast heq
  omega

/-- Genuine nonvanishing of the explicit arbitrary-size k=1 residue matrix
at the square-root parameter. -/
theorem bennettFirstOrderExplicit_det_ne_zero [CharZero F]
    (a : Fin n → F) (ha : Function.Injective a) (N : F) (hN : N ≠ 0) :
    (bennettFirstOrderExplicit a N (3 / 2)).det ≠ 0 := by
  rw [bennettFirstOrderExplicit_det a ha]
  apply mul_ne_zero
  · apply mul_ne_zero
    · exact pow_ne_zero n (inv_ne_zero hN)
    · apply Finset.prod_ne_zero_iff.mpr
      intro i _
      exact Lagrange.nodalWeight_ne_zero ha.injOn (Finset.mem_univ i)
  · apply Finset.prod_ne_zero_iff.mpr
    intro j _
    exact three_halves_sub_natCast_ne_zero j.val

end Field

end D1Bound5


-- SOURCE: bennett_draft/BennettPoleSeries.lean

open PowerSeries

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The formal inverse-power expansion around a nonzero pole displacement. -/
noncomputable def bennettPoleSeries (d : F) (k : ℕ) : PowerSeries F :=
  PowerSeries.C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))

/-- Exact Taylor coefficients of the local reciprocal pole factor. -/
theorem bennettPoleSeries_coeff (d : F) (k h : ℕ) :
    PowerSeries.coeff h (bennettPoleSeries d k) =
      Ring.choose (-(k : F)) h * (d⁻¹) ^ (k + h) := by
  simp only [bennettPoleSeries, PowerSeries.coeff_C_mul, PowerSeries.coeff_rescale,
    binomialSeries_coeff, smul_eq_mul, mul_one, pow_add]
  ring

/-- The negative-integer binomial series is the formal inverse of `(1+X)^k`. -/
theorem bennettNegativeBinomial_mul (k : ℕ) :
    (1 + PowerSeries.X : PowerSeries F) ^ k * binomialSeries F (-(k : F)) = 1 := by
  rw [← binomialSeries_nat (R := F), ← binomialSeries_add]
  simp

/-- The explicit binomial coefficients really invert the reciprocal pole
factor, rather than merely satisfying a guessed recurrence. -/
theorem bennettPoleSeries_mul (d : F) (hd : d ≠ 0) (k : ℕ) :
    (PowerSeries.C d + PowerSeries.X : PowerSeries F) ^ k * bennettPoleSeries d k = 1 := by
  have hs := congrArg (rescale d⁻¹) (bennettNegativeBinomial_mul (F := F) k)
  simp only [map_mul, map_pow, map_add, map_one, PowerSeries.rescale_X] at hs
  have hf : (PowerSeries.C d + PowerSeries.X : PowerSeries F) =
      PowerSeries.C d * (1 + PowerSeries.C d⁻¹ * PowerSeries.X) := by
    rw [mul_add, mul_one, ← mul_assoc, ← map_mul, mul_inv_cancel₀ hd,
      map_one, one_mul]
  rw [hf, mul_pow, bennettPoleSeries]
  calc
    (PowerSeries.C d) ^ k * (1 + PowerSeries.C d⁻¹ * PowerSeries.X) ^ k *
        (PowerSeries.C ((d⁻¹) ^ k) * rescale d⁻¹ (binomialSeries F (-(k : F)))) =
      PowerSeries.C (d ^ k * (d⁻¹) ^ k) *
        ((1 + PowerSeries.C d⁻¹ * PowerSeries.X) ^ k *
          rescale d⁻¹ (binomialSeries F (-(k : F)))) := by
          rw [map_mul, map_pow]
          ring
    _ = 1 := by
      rw [hs, ← mul_pow, mul_inv_cancel₀ hd, one_pow, map_one, mul_one]

end D1Bound5
