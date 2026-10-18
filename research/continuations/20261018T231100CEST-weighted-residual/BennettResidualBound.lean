import D1Bound5.BennettResidualEvaluation
import D1Bound5.BennettResidualMajorant
import D1Bound5.BennettRepeatedHsymm
import D1Bound5.BennettChooseGamma

open Finset

namespace D1Bound5

/-- An unconditional analytic bound for the actual arbitrary-order Bennett
residual. The proof joins actual polynomial evaluation, exact residue moments,
the repeated-node homogeneous identity, and the convergent binomial majorant.
No contour formula or residual-bound hypothesis occurs in the statement. -/
theorem bennettPolynomialResidue_residual_norm_le
    {I : Type*} [Fintype I] [DecidableEq I]
    (a : I → ℂ) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν ρ : ℝ) (x : ℂ) (i : I)
    (hs : (k : ℝ) + ν < (Fintype.card I * k : ℕ))
    (hρ0 : 0 ≤ ρ) (hρ : ∀ j, ‖a j‖ ≤ ρ) (hradius : ρ * ‖x‖ < 1) :
    ‖∑ j, (bennettPolynomialResidue univ a k (ν : ℂ) i j).eval x *
        (1 + a j * x) ^ (ν : ℂ)‖ ≤
      |Ring.choose ((k : ℝ) + ν) (Fintype.card I * k)| *
        ‖x‖ ^ (Fintype.card I * k) /
          (1 - ρ * ‖x‖) ^ (((Fintype.card I * k : ℕ) : ℝ) - ((k : ℝ) + ν)) := by
  let e : I → ℕ := fun l => k + (if i = l then 1 else 0) - 1
  let A : BennettRepeatedNodes e → ℂ := fun j => a j.1
  letI : Nonempty (BennettRepeatedNodes e) := ⟨⟨i, 0⟩⟩
  have he (j : I) : e j + 1 = k + (if i = j then 1 else 0) := by
    dsimp [e]
    split_ifs <;> omega
  have htotal : (∑ j, (e j + 1)) = Fintype.card I * k + 1 := by
    simp_rw [he]
    rw [Finset.sum_add_distrib]
    simp
  have hd : 0 < ∑ j, (e j + 1) := by rw [htotal]; omega
  have hcard : Fintype.card (BennettRepeatedNodes e) = Fintype.card I * k + 1 := by
    rw [bennettRepeatedNodes_card, htotal]
  have hA (j : BennettRepeatedNodes e) : ‖A j‖ ≤ ρ := hρ j.1
  have hmoment (t : ℕ) :
      (∑ j, bennettLocalResidue a e
        (Polynomial.X ^ (Fintype.card I * k + t)) j) =
      MvPolynomial.aeval A (MvPolynomial.hsymm (BennettRepeatedNodes e) ℂ t) := by
    simpa only [htotal, Nat.add_sub_cancel] using
      bennettLocalResidue_sum_X_pow_eq_hsymm a ha e hd t
  have hx (j : I) : ‖a j * x‖ < 1 := by
    rw [norm_mul]
    exact (mul_le_mul_of_nonneg_right (hρ j) (norm_nonneg x)).trans_lt hradius
  have htail := bennettPolynomialResidue_residual_tail_hasSum a ha k hk (ν : ℂ) x i hx
  change HasSum (fun t : ℕ =>
      (Ring.choose ((k : ℂ) + (ν : ℂ)) (Fintype.card I * k + t) *
        ∑ j, bennettLocalResidue a e
          (Polynomial.X ^ (Fintype.card I * k + t)) j) *
            x ^ (Fintype.card I * k + t)) _ at htail
  simp_rw [hmoment] at htail
  have hbound := bennett_homogeneous_tail_summable_and_norm_le
    A (Fintype.card I * k) ((k : ℝ) + ν) ρ x hcard hs hρ0 hA hradius
  rw [← htail.tsum_eq]
  simpa only [Complex.ofReal_add, Complex.ofReal_natCast] using hbound.2

/-- Exact two-anchor analytic residual estimate, including the manuscript's
Gamma factor and exponent 2k-1/2. This concerns the actual P-matrix. -/
theorem bennett_two_polynomial_residual_norm_le
    (a : Fin 3 → ℂ) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ρ : ℝ) (x : ℂ) (i : Fin 3)
    (hρ0 : 0 ≤ ρ) (hρ : ∀ j, ‖a j‖ ≤ ρ) (hradius : ρ * ‖x‖ < 1) :
    ‖∑ j, (bennettPolynomialResidue univ a k (1 / 2 : ℂ) i j).eval x *
        (1 + a j * x) ^ (1 / 2 : ℂ)‖ ≤
      (Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
        (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))) * ‖x‖ ^ (3 * k) /
          (1 - ρ * ‖x‖) ^ (2 * (k : ℝ) - 1 / 2) := by
  have hk' : (1 : ℝ) ≤ k := by exact_mod_cast hk
  have hs : (k : ℝ) + 1 / 2 < (Fintype.card (Fin 3) * k : ℕ) := by
    simp only [Fintype.card_fin, Nat.cast_mul, Nat.cast_ofNat]
    linarith
  have hexp : ((3 * k : ℕ) : ℝ) - ((k : ℝ) + 1 / 2) =
      2 * (k : ℝ) - 1 / 2 := by push_cast; ring
  have h := bennettPolynomialResidue_residual_norm_le a ha k hk (1 / 2) ρ x i
    hs hρ0 hρ hradius
  simpa only [Fintype.card_fin, Complex.ofReal_div, Complex.ofReal_one,
    Complex.ofReal_ofNat, hexp, bennett_two_residual_choose_abs_Gamma k hk] using h

end D1Bound5
