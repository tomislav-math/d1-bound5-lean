import D1Bound5.BennettResidualEvaluation
import D1Bound5.BennettResidualMajorant
import D1Bound5.BennettRepeatedHsymm

open Finset

namespace D1Bound5

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- The actual local residue polynomial with arbitrary positive pole
multiplicities e_j+1. Each Taylor order must be at most the polynomial
degree k; equal multiplicities are not required. -/
noncomputable def unequalPolePolynomial {F : Type*} [Field F] [CharZero F]
    (a : I → F) (e : I → ℕ) (k : ℕ) (ν : F) (j : I) : Polynomial F :=
  bennettResidueTaylor k (e j) ν (a j) (bennettLocalReciprocal a e j)

theorem unequalPolePolynomial_residual_hasSum
    (a : I → ℂ) (e : I → ℕ) (k : ℕ) (ν x : ℂ)
    (hx : ∀ j, ‖a j*x‖ < 1) :
    HasSum (fun r : ℕ => PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries ℂ)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν))*x^r)
      (∑ j, (unequalPolePolynomial a e k ν j).eval x*(1+a j*x)^ν) := by
  have hh (j : I) :=
    bennett_rescaled_binomial_hasSum (a j) ν x (hx j)
  have hp (j : I) := bennett_polynomial_series_hasSum
    (unequalPolePolynomial a e k ν j)
    (PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν))
    x ((1+a j*x)^ν) (hh j).1 (hh j).2
  simpa only [map_sum,Finset.sum_mul] using
    hasSum_sum (s := (univ : Finset I)) (fun j _ => hp j)

theorem unequalPolePolynomial_residual_coeff
    {F : Type*} [Field F] [CharZero F]
    (a : I → F) (e : I → ℕ) (k : ℕ) (he : ∀ j, e j ≤ k)
    (ν : F) (r : ℕ) :
    PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries F)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) =
      Ring.choose ((k : F)+ν) r *
        ∑ j, bennettLocalResidue a e (Polynomial.X^r) j := by
  rw [map_sum,Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  unfold unequalPolePolynomial
  rw [bennettResidueTaylor_coeff_mul_binomial k (e j) r (he j)]
  simp [bennettLocalResidue,bennettShiftToSeries]

/-- Exact cancellation through one less than the total pole order. -/
theorem unequalPolePolynomial_residual_coeff_zero
    {F : Type*} [Field F] [CharZero F]
    (a : I → F) (ha : Function.Injective a) (e : I → ℕ)
    (k : ℕ) (he : ∀ j, e j ≤ k) (ν : F)
    (r : ℕ) (hr : r < (∑ j, (e j+1))-1) :
    PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries F)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) = 0 := by
  rw [unequalPolePolynomial_residual_coeff a e k he ν r]
  have hdeg : (Polynomial.X^r : Polynomial F).degree <
      ((∑ j, (e j+1))-1 : ℕ) := by
    rw [Polynomial.degree_X_pow]
    exact WithBot.coe_lt_coe.mpr hr
  rw [bennettLocalResidue_sum_eq_zero a ha e (Polynomial.X^r) hdeg,mul_zero]

theorem unequalPolePolynomial_residual_tail_hasSum
    (a : I → ℂ) (ha : Function.Injective a) (e : I → ℕ)
    (k : ℕ) (he : ∀ j, e j ≤ k) (ν x : ℂ)
    (hx : ∀ j, ‖a j*x‖ < 1) :
    HasSum (fun t : ℕ =>
      (Ring.choose ((k : ℂ)+ν) ((∑ j,(e j+1))-1+t) *
        ∑ j, bennettLocalResidue a e
          (Polynomial.X^((∑ j,(e j+1))-1+t)) j)*
            x^((∑ j,(e j+1))-1+t))
      (∑ j, (unequalPolePolynomial a e k ν j).eval x*(1+a j*x)^ν) := by
  let D : ℕ := (∑ j,(e j+1))-1
  let R : PowerSeries ℂ :=
    ∑ j, (unequalPolePolynomial a e k ν j : PowerSeries ℂ)*
      PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν)
  have hzero : (∑ r ∈ range D, PowerSeries.coeff r R*x^r) = 0 := by
    apply Finset.sum_eq_zero
    intro r hr
    rw [show PowerSeries.coeff r R = 0 from
      unequalPolePolynomial_residual_coeff_zero a ha e k he ν r
        (Finset.mem_range.mp hr),zero_mul]
  have htail : HasSum (fun t : ℕ => PowerSeries.coeff (t+D) R*x^(t+D))
      (∑ j, (unequalPolePolynomial a e k ν j).eval x*(1+a j*x)^ν) := by
    apply (hasSum_nat_add_iff
      (f := fun r : ℕ => PowerSeries.coeff r R*x^r) D).mpr
    rw [hzero,add_zero]
    exact unequalPolePolynomial_residual_hasSum a e k ν x hx
  simpa only [R,D,Nat.add_comm,unequalPolePolynomial_residual_coeff a e k he ν] using htail

/-- General multiplicity version of the proved Bennett residual estimate.
This is an actual bound on explicit polynomials, with no contour formula,
residual assumption or unverified finite coefficient assertion. -/
theorem unequalPolePolynomial_residual_norm_le
    (a : I → ℂ) (ha : Function.Injective a) (e : I → ℕ)
    (q : I) (k : ℕ) (he : ∀ j, e j ≤ k) (ν ρ : ℝ) (x : ℂ)
    (hs : (k : ℝ)+ν < ((∑ j,(e j+1))-1 : ℕ))
    (hρ0 : 0 ≤ ρ) (hρ : ∀ j, ‖a j‖ ≤ ρ) (hradius : ρ*‖x‖ < 1) :
    ‖∑ j, (unequalPolePolynomial a e k (ν : ℂ) j).eval x*
      (1+a j*x)^(ν : ℂ)‖ ≤
      |Ring.choose ((k : ℝ)+ν) ((∑ j,(e j+1))-1)| *
        ‖x‖^((∑ j,(e j+1))-1) /
          (1-ρ*‖x‖)^((((∑ j,(e j+1))-1 : ℕ) : ℝ)-((k : ℝ)+ν)) := by
  let D : ℕ := (∑ j,(e j+1))-1
  let A : BennettRepeatedNodes e → ℂ := fun j => a j.1
  letI : Nonempty (BennettRepeatedNodes e) := ⟨⟨q,0⟩⟩
  have htotal : 0 < ∑ j,(e j+1) := by
    have hh : e q+1 ≤ ∑ j,(e j+1) := Finset.single_le_sum (f := fun j : I => e j+1)
      (fun j _ => Nat.zero_le (e j+1)) (Finset.mem_univ q)
    omega
  have hcard : Fintype.card (BennettRepeatedNodes e) = D+1 := by
    rw [bennettRepeatedNodes_card]
    dsimp [D]
    omega
  have hA (j : BennettRepeatedNodes e) : ‖A j‖ ≤ ρ := hρ j.1
  have hmoment (t : ℕ) :
      (∑ j, bennettLocalResidue a e (Polynomial.X^(D+t)) j) =
      MvPolynomial.aeval A (MvPolynomial.hsymm (BennettRepeatedNodes e) ℂ t) :=
    bennettLocalResidue_sum_X_pow_eq_hsymm a ha e htotal t
  have hx (j : I) : ‖a j*x‖ < 1 := by
    rw [norm_mul]
    exact (mul_le_mul_of_nonneg_right (hρ j) (norm_nonneg x)).trans_lt hradius
  have htail := unequalPolePolynomial_residual_tail_hasSum a ha e k he (ν : ℂ) x hx
  change HasSum (fun t : ℕ =>
      (Ring.choose ((k : ℂ)+(ν : ℂ)) (D+t) *
        ∑ j, bennettLocalResidue a e (Polynomial.X^(D+t)) j)*x^(D+t)) _ at htail
  simp_rw [hmoment] at htail
  have hbound := bennett_homogeneous_tail_summable_and_norm_le A D
    ((k : ℝ)+ν) ρ x hcard hs hρ0 hA hradius
  rw [← htail.tsum_eq]
  simpa only [D, Complex.ofReal_add, Complex.ofReal_natCast] using hbound.2

end D1Bound5
