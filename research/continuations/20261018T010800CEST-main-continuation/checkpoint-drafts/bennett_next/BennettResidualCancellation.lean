import D1Bound5.BennettResiduePolynomials
import D1Bound5.BennettBinomialTransfer
import D1Bound5.BennettLocalResidues
import D1Bound5.BennettResidualDeterminant
import Mathlib.RingTheory.PowerSeries.Trunc

open Finset

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- Multiplying the actual local residue polynomial by its binomial series
transfers each coefficient to the residue of a polynomial monomial. -/
theorem bennettResidueTaylor_coeff_mul_binomial (k t r : ℕ) (ht : t ≤ k)
    (ν a : F) (B : PowerSeries F) :
    PowerSeries.coeff r
      ((bennettResidueTaylor k t ν a B : PowerSeries F) *
        PowerSeries.rescale a (PowerSeries.binomialSeries F ν)) =
      Ring.choose ((k : F) + ν) r *
        PowerSeries.coeff t (((PowerSeries.C a + PowerSeries.X) ^ r) * B) := by
  have hp : (bennettResidueTaylor k t ν a B : PowerSeries F) =
      ∑ hu ∈ Finset.antidiagonal t,
        PowerSeries.C (Ring.choose ((k : F) + ν) hu.1 * PowerSeries.coeff hu.2 B) *
          (PowerSeries.X ^ hu.1 *
            (1 + PowerSeries.C a * PowerSeries.X) ^ (k - hu.1)) := by
    change Polynomial.coeToPowerSeries.ringHom (bennettResidueTaylor k t ν a B) = _
    unfold bennettResidueTaylor
    simp only [map_sum, Polynomial.coeToPowerSeries.ringHom_apply,
      Polynomial.coe_mul, Polynomial.coe_C, Polynomial.coe_pow,
      Polynomial.coe_X, Polynomial.coe_add, Polynomial.coe_one]
  rw [hp, Finset.sum_mul, map_sum]
  calc
    _ = ∑ hu ∈ Finset.antidiagonal t,
        Ring.choose ((k : F) + ν) r *
          (PowerSeries.coeff hu.1 ((PowerSeries.C a + PowerSeries.X) ^ r) *
            PowerSeries.coeff hu.2 B) := by
      apply Finset.sum_congr rfl
      intro hu hhu
      have hsum := Finset.mem_antidiagonal.mp hhu
      have hh : hu.1 ≤ k := by omega
      rw [mul_assoc, PowerSeries.coeff_C_mul]
      calc
        _ = PowerSeries.coeff hu.2 B *
            (Ring.choose ((k : F) + ν) hu.1 *
              PowerSeries.coeff r
                ((PowerSeries.X ^ hu.1 *
                  (1 + PowerSeries.C a * PowerSeries.X) ^ (k - hu.1)) *
                    PowerSeries.rescale a (PowerSeries.binomialSeries F ν))) := by ring
        _ = _ := by
          rw [bennettBinomial_coefficient_transfer k hu.1 r hh ν a]
          ring
    _ = _ := by rw [PowerSeries.coeff_mul, Finset.mul_sum]

section Nodes

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- The genuine Bennett residual has a zero of order at least `card I * k`.
The cancellation is deduced from exact partial fractions, not assumed. -/
theorem bennettPolynomialResidue_residual_coeff_zero
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (i : I) (r : ℕ) (hr : r < Fintype.card I * k) :
    PowerSeries.coeff r
      (∑ j, (bennettPolynomialResidue Finset.univ a k ν i j : PowerSeries F) *
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) = 0 := by
  let e : I → ℕ := fun l ↦ k + (if i = l then 1 else 0) - 1
  have he (l : I) : e l + 1 = k + (if i = l then 1 else 0) := by
    dsimp [e]
    split_ifs <;> omega
  have he_le (j : I) : e j ≤ k := by
    dsimp [e]
    split_ifs <;> omega
  have htotal : (∑ l, (e l + 1)) - 1 = Fintype.card I * k := by
    simp_rw [he]
    rw [Finset.sum_add_distrib]
    simp
  have hdeg : (Polynomial.X ^ r : Polynomial F).degree <
      ((∑ l, (e l + 1)) - 1 : ℕ) := by
    rw [Polynomial.degree_X_pow, htotal]
    exact WithBot.coe_lt_coe.mpr hr
  have hzero := bennettLocalResidue_sum_eq_zero a ha e (Polynomial.X ^ r) hdeg
  have hB (j : I) : bennettOtherPoles Finset.univ a k i j =
      bennettLocalReciprocal a e j := by
    unfold bennettOtherPoles bennettLocalReciprocal
    simp_rw [he]
  have hshift (j : I) :
      bennettShiftToSeries (a j) (Polynomial.X ^ r) =
        (PowerSeries.C (a j) + PowerSeries.X) ^ r := by
    simp [bennettShiftToSeries]
  rw [map_sum]
  calc
    _ = Ring.choose ((k : F) + ν) r *
        ∑ j, bennettLocalResidue a e (Polynomial.X ^ r) j := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j hj
      change PowerSeries.coeff r
        ((bennettResidueTaylor k (e j) ν (a j)
          (bennettOtherPoles Finset.univ a k i j) : PowerSeries F) *
            PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) = _
      rw [bennettResidueTaylor_coeff_mul_binomial k (e j) r (he_le j)]
      simp only [bennettLocalResidue, hshift, hB]
    _ = 0 := by rw [hzero, mul_zero]

/-- Truncating a multiplier preserves every coefficient below the truncation
order, even when the other factor is an infinite series. -/
theorem bennett_coeff_mul_trunc (P θ : PowerSeries F) (D r : ℕ) (hr : r < D) :
    PowerSeries.coeff r (P * (PowerSeries.trunc D θ : PowerSeries F)) =
      PowerSeries.coeff r (P * θ) := by
  calc
    _ = PowerSeries.coeff r
        (PowerSeries.trunc D (P * (PowerSeries.trunc D θ : PowerSeries F)) :
          PowerSeries F) := (PowerSeries.coeff_coe_trunc_of_lt hr).symm
    _ = PowerSeries.coeff r (PowerSeries.trunc D (P * θ) : PowerSeries F) := by
      rw [PowerSeries.trunc_mul_trunc]
    _ = _ := PowerSeries.coeff_coe_trunc_of_lt hr

/-- Polynomial form of the actual residual cancellation, suitable for the
column-replacement determinant argument. -/
theorem bennettPolynomialResidue_residual_dvd
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (i : I) :
    (Polynomial.X : Polynomial F) ^ (Fintype.card I * k) ∣
      ∑ j, PowerSeries.trunc (Fintype.card I * k)
        (PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) *
          bennettPolynomialResidue Finset.univ a k ν i j := by
  apply Polynomial.X_pow_dvd_iff.mpr
  intro r hr
  rw [← Polynomial.coeff_coe]
  change PowerSeries.coeff r (Polynomial.coeToPowerSeries.ringHom (∑ j, _)) = 0
  simp only [map_sum, Polynomial.coeToPowerSeries.ringHom_apply, Polynomial.coe_mul]
  calc
    _ = ∑ j, PowerSeries.coeff r
        ((bennettPolynomialResidue Finset.univ a k ν i j : PowerSeries F) *
          PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) := by
      apply Finset.sum_congr rfl
      intro j hj
      rw [mul_comm]
      exact bennett_coeff_mul_trunc _ _ _ _ hr
    _ = 0 := by
      simpa only [map_sum] using
        bennettPolynomialResidue_residual_coeff_zero a ha k hk ν i r hr

/-- The original arbitrary-order matrix of polynomial residues. -/
noncomputable def bennettPolynomialMatrix (a : I → F) (k : ℕ) (ν : F) :
    Matrix I I (Polynomial F) :=
  Matrix.of fun i j ↦ bennettPolynomialResidue Finset.univ a k ν i j

/-- The determinant of the actual arbitrary-order Bennett matrix is a single
monomial. This proves its exact possible degree without assuming residual
cancellation; the value and nonvanishing of its coefficient are separate. -/
theorem bennettPolynomialMatrix_det_monomial
    (a : I → F) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν : F) (q : I) (hq : a q = 0) :
    (bennettPolynomialMatrix a k ν).det =
      Polynomial.C ((bennettPolynomialMatrix a k ν).det.coeff (Fintype.card I * k)) *
        Polynomial.X ^ (Fintype.card I * k) := by
  apply polynomial_det_eq_monomial_of_uniform_residual
    (θ := fun j ↦ PowerSeries.trunc (Fintype.card I * k)
      (PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν))) (q := q)
  · have hD : 0 < Fintype.card I * k :=
      Nat.mul_pos (Fintype.card_pos_iff.mpr ⟨q⟩) hk
    obtain ⟨d, hd⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt hD)
    rw [hq, PowerSeries.rescale_zero_apply, PowerSeries.binomialSeries_constantCoeff,
      map_one, hd]
    exact PowerSeries.trunc_one d
  · intro i j
    exact bennettPolynomialResidue_natDegree_le Finset.univ a k ν i j
  · intro i
    exact bennettPolynomialResidue_residual_dvd a ha k hk ν i

end Nodes

end D1Bound5
