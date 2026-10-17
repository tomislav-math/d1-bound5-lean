import Mathlib.LinearAlgebra.Matrix.Polynomial
import Mathlib.Algebra.Polynomial.Div

open Finset Polynomial Matrix

namespace D1Bound5

/-!
This module isolates an intermediate step in the all-orders Bennett determinant
argument. It does not define the residue polynomials or prove their cancellation.
The required cancellation is an explicit hypothesis of the final theorem.
-/

section CommRing

variable {R ι : Type*} [CommRing R] [Fintype ι] [DecidableEq ι]

/-- Replacing a distinguished column by a linear combination of columns transfers
a common factor of the residual vector to the determinant. The coefficient of
the distinguished column is assumed to be one. -/
theorem dvd_det_of_dvd_column_combination (A : Matrix ι ι R) (c : ι → R)
    (q : ι) (hc : c q = 1) (z : R)
    (hres : ∀ i, z ∣ ∑ j, c j * A i j) : z ∣ A.det := by
  classical
  choose v hv using hres
  have hcol : (fun i ↦ ∑ j, c j * A i j) = z • v := by
    funext i
    exact hv i
  refine ⟨(A.updateCol q v).det, ?_⟩
  calc
    A.det = (A.updateCol q (fun i ↦ ∑ j, c j * A i j)).det := by
      symm
      simpa only [smul_eq_mul, hc, one_mul] using Matrix.det_updateCol_sum A q c
    _ = z * (A.updateCol q v).det := by
      rw [hcol, Matrix.det_updateCol_smul]

/-- A columnwise degree bound gives the corresponding determinant degree bound,
without any assumption that the coefficient ring is a domain. -/
theorem polynomial_det_natDegree_le_sum (P : Matrix ι ι R[X]) (d : ι → ℕ)
    (hdeg : ∀ i j, (P i j).natDegree ≤ d j) :
    P.det.natDegree ≤ ∑ j, d j := by
  classical
  rw [Matrix.det_apply]
  apply Polynomial.natDegree_sum_le_of_forall_le
  intro σ hσ
  exact (Polynomial.natDegree_smul_le _ _).trans
    ((Polynomial.natDegree_prod_le _ _).trans
      (Finset.sum_le_sum fun i _ ↦ hdeg (σ i) i))

/-- A polynomial whose degree is at most `D` and whose first `D` coefficients
vanish is exactly its degree-`D` monomial, including the zero-polynomial case. -/
theorem polynomial_eq_top_monomial_of_X_pow_dvd (p : R[X]) (D : ℕ)
    (hdeg : p.natDegree ≤ D) (hdiv : (X : R[X]) ^ D ∣ p) :
    p = C (p.coeff D) * X ^ D := by
  rw [Polynomial.C_mul_X_pow_eq_monomial]
  apply Polynomial.ext
  intro l
  rw [Polynomial.coeff_monomial]
  split_ifs with h
  · subst l
    rfl
  · rcases lt_or_gt_of_ne h with hlt | hgt
    · exact Polynomial.coeff_eq_zero_of_natDegree_lt (hdeg.trans_lt hlt)
    · exact Polynomial.X_pow_dvd_iff.mp hdiv l hgt

/-- Intermediate all-orders determinant principle. The residual cancellation is
an explicit input. In the Bennett construction the distinguished node is zero,
so the corresponding (truncated) binomial polynomial is exactly one. -/
theorem polynomial_det_eq_monomial_of_residual (P : Matrix ι ι R[X])
    (d : ι → ℕ) (θ : ι → R[X]) (q : ι) (hθ : θ q = 1)
    (hdeg : ∀ i j, (P i j).natDegree ≤ d j)
    (hres : ∀ i, (X : R[X]) ^ (∑ j, d j) ∣ ∑ j, θ j * P i j) :
    P.det = C (P.det.coeff (∑ j, d j)) * X ^ (∑ j, d j) := by
  apply polynomial_eq_top_monomial_of_X_pow_dvd
  · exact polynomial_det_natDegree_le_sum P d hdeg
  · exact dvd_det_of_dvd_column_combination P θ q hθ _ hres

/-- Uniform-degree form of the preceding intermediate principle. This gives the
`card(ι) * k` exponent appearing in the all-orders Bennett determinant. -/
theorem polynomial_det_eq_monomial_of_uniform_residual (P : Matrix ι ι R[X])
    (k : ℕ) (θ : ι → R[X]) (q : ι) (hθ : θ q = 1)
    (hdeg : ∀ i j, (P i j).natDegree ≤ k)
    (hres : ∀ i, (X : R[X]) ^ (Fintype.card ι * k) ∣ ∑ j, θ j * P i j) :
    P.det = C (P.det.coeff (Fintype.card ι * k)) * X ^ (Fintype.card ι * k) := by
  simpa using polynomial_det_eq_monomial_of_residual P (fun _ ↦ k) θ q hθ hdeg
    (by simpa using hres)

end CommRing

end D1Bound5
