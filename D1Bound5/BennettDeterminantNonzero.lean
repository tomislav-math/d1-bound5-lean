import D1Bound5.BennettDeterminantFormula
import D1Bound5.BennettChooseNonzero

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- None of the binomial factors in the actual nu=1/2 determinant vanishes. -/
theorem bennettBinomialProduct_half_ne_zero (n k : ℕ) :
    bennettBinomialProduct n k (1 / 2 : F) ≠ 0 := by
  unfold bennettBinomialProduct
  apply Finset.prod_ne_zero_iff.mpr
  intro v hv
  exact bennett_halfInteger_choose_ne_zero k v

/-- Distinct nodes make every directed reciprocal-difference factor nonzero. -/
theorem bennettDirectedProduct_ne_zero {I : Type*} [Fintype I] [DecidableEq I]
    (a : I → F) (ha : Function.Injective a) (k : ℕ) :
    bennettDirectedProduct a k ≠ 0 := by
  unfold bennettDirectedProduct
  apply Finset.prod_ne_zero_iff.mpr
  intro i hi
  apply Finset.prod_ne_zero_iff.mpr
  intro j hj
  apply pow_ne_zero
  apply inv_ne_zero
  exact sub_ne_zero.mpr (ha.ne (Finset.mem_erase.mp hj).1.symm)

/-- The actual cleared Bennett matrix is nonsingular at every specialization,
for every positive order and every number of distinct nodes containing zero. -/
theorem bennettClearedMatrix_det_half_eval_ne_zero
    (n : ℕ) (a : Fin (n + 1) → F) (ha : Function.Injective a)
    (k : ℕ) (hk : 1 ≤ k) (h0 : a 0 = 0) (N : F) :
    (bennettClearedMatrix a k (1 / 2 : F)).det.eval N ≠ 0 := by
  rw [bennettClearedMatrix_det_formula n a ha k hk (1 / 2 : F) h0,
    Polynomial.eval_C]
  exact mul_ne_zero (bennettBinomialProduct_half_ne_zero (n + 1) k)
    (bennettDirectedProduct_ne_zero a ha k)

/-- The actual original Bennett matrix is nonsingular away from x=0.
This closes the arbitrary-order determinant obstruction for the residue
construction, independently of the still separate analytic estimates. -/
theorem bennettPolynomialMatrix_det_half_eval_ne_zero
    (n : ℕ) (a : Fin (n + 1) → F) (ha : Function.Injective a)
    (k : ℕ) (hk : 1 ≤ k) (h0 : a 0 = 0) (x : F) (hx : x ≠ 0) :
    (bennettPolynomialMatrix a k (1 / 2 : F)).det.eval x ≠ 0 := by
  rw [bennettPolynomialMatrix_det_formula n a ha k hk (1 / 2 : F) h0,
    Polynomial.eval_mul, Polynomial.eval_C, Polynomial.eval_pow, Polynomial.eval_X]
  exact mul_ne_zero
    (mul_ne_zero (bennettBinomialProduct_half_ne_zero (n + 1) k)
      (bennettDirectedProduct_ne_zero a ha k)) (pow_ne_zero _ hx)

end D1Bound5
