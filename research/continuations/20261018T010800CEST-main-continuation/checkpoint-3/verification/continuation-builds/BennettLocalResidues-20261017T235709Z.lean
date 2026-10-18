import D1Bound5.BennettPartialFractions
import D1Bound5.BennettPoleSeries

open Finset

namespace D1Bound5

section Field

variable {F ι : Type*} [Field F] [CharZero F]
variable [Fintype ι] [DecidableEq ι]

/-- Exact polynomial substitution at the local coordinate `b + X`. -/
noncomputable def bennettShiftToSeries (b : F) : Polynomial F →+* PowerSeries F :=
  Polynomial.eval₂RingHom PowerSeries.C (PowerSeries.C b + PowerSeries.X)

@[simp] theorem bennettShiftToSeries_C (b c : F) :
    bennettShiftToSeries b (Polynomial.C c) = PowerSeries.C c := by
  simp [bennettShiftToSeries]

@[simp] theorem bennettShiftToSeries_linear (b c : F) :
    bennettShiftToSeries b (Polynomial.X - Polynomial.C c) =
      PowerSeries.C (b - c) + PowerSeries.X := by
  change Polynomial.eval₂ PowerSeries.C (PowerSeries.C b + PowerSeries.X)
    (Polynomial.X - Polynomial.C c) = _
  rw [Polynomial.eval₂_sub, Polynomial.eval₂_X, Polynomial.eval₂_C, map_sub]
  ring

/-- The explicit reciprocal of the product of the other local pole factors. -/
noncomputable def bennettLocalReciprocal (a : ι → F) (e : ι → ℕ) (i : ι) :
    PowerSeries F :=
  ∏ l ∈ (Finset.univ : Finset ι).erase i,
    bennettPoleSeries (a i - a l) (e l + 1)

/-- The algebraic residue defined by a concrete coefficient of explicit
negative-integer binomial series. -/
noncomputable def bennettLocalResidue (a : ι → F) (e : ι → ℕ)
    (f : Polynomial F) (i : ι) : F :=
  PowerSeries.coeff (e i)
    (bennettShiftToSeries (a i) f * bennettLocalReciprocal a e i)

theorem bennettLocalReciprocal_mul (a : ι → F) (ha : Function.Injective a)
    (e : ι → ℕ) (i : ι) :
    (∏ l ∈ (Finset.univ : Finset ι).erase i,
      (PowerSeries.C (a i - a l) + PowerSeries.X) ^ (e l + 1)) *
        bennettLocalReciprocal a e i = 1 := by
  unfold bennettLocalReciprocal
  rw [← Finset.prod_mul_distrib]
  apply Finset.prod_eq_one
  intro l hl
  apply bennettPoleSeries_mul
  exact sub_ne_zero.mpr (ha.ne (Finset.mem_erase.mp hl).1.symm)

/-- At its own node, multiplication by the explicit local reciprocal cancels
all other factors of a cleared pole numerator. -/
theorem bennettShift_clearedPole_self (a : ι → F) (ha : Function.Injective a)
    (e : ι → ℕ) (i : ι) (j : Fin (e i + 1)) :
    bennettShiftToSeries (a i) (clearedPoleNumerator a e i j) *
      bennettLocalReciprocal a e i = PowerSeries.X ^ j.val := by
  unfold clearedPoleNumerator
  simp only [map_mul, map_pow, bennettShiftToSeries_linear, sub_self, map_zero,
    zero_add, map_prod]
  rw [mul_assoc, bennettLocalReciprocal_mul a ha e i, mul_one]

/-- At another node, the cleared numerator contains the full local pole
factor, so its relevant residue coefficient vanishes. -/
theorem bennettLocalResidue_clearedPole_of_ne (a : ι → F) (e : ι → ℕ)
    (i l : ι) (hil : i ≠ l) (j : Fin (e l + 1)) :
    bennettLocalResidue a e (clearedPoleNumerator a e l j) i = 0 := by
  have hmem : i ∈ (Finset.univ : Finset ι).erase l :=
    Finset.mem_erase.mpr ⟨hil, Finset.mem_univ i⟩
  have hdiv : (Polynomial.X - Polynomial.C (a i)) ^ (e i + 1) ∣
      clearedPoleNumerator a e l j := by
    apply dvd_mul_of_dvd_right
    exact Finset.dvd_prod_of_mem
      (fun q : ι ↦ (Polynomial.X - Polynomial.C (a q)) ^ (e q + 1)) hmem
  have hshift : (PowerSeries.X : PowerSeries F) ^ (e i + 1) ∣
      bennettShiftToSeries (a i) (clearedPoleNumerator a e l j) := by
    simpa only [map_pow, bennettShiftToSeries_linear, sub_self, map_zero, zero_add]
      using map_dvd (bennettShiftToSeries (a i)) hdiv
  exact PowerSeries.X_pow_dvd_iff.mp
    (dvd_mul_of_dvd_left hshift (bennettLocalReciprocal a e i)) (e i) (Nat.lt_succ_self _)

/-- Local residues are compatible with scalar multiplication of the numerator. -/
theorem bennettLocalResidue_C_mul (a : ι → F) (e : ι → ℕ)
    (f : Polynomial F) (i : ι) (c : F) :
    bennettLocalResidue a e (Polynomial.C c * f) i =
      c * bennettLocalResidue a e f i := by
  simp only [bennettLocalResidue, map_mul, bennettShiftToSeries_C, mul_assoc,
    PowerSeries.coeff_C_mul]

/-- The concrete local series coefficient equals the simple-pole coefficient
in any exact cleared decomposition. -/
theorem bennettLocalResidue_eq_decomposition_coeff
    (a : ι → F) (ha : Function.Injective a) (e : ι → ℕ)
    (c : (l : ι) → Fin (e l + 1) → F) (f : Polynomial F)
    (hc : f = ∑ l, ∑ j : Fin (e l + 1),
      Polynomial.C (c l j) * clearedPoleNumerator a e l j) (i : ι) :
    bennettLocalResidue a e f i = c i (Fin.last (e i)) := by
  classical
  rw [hc]
  simp only [bennettLocalResidue, map_sum, Finset.sum_mul]
  change (∑ l, ∑ j : Fin (e l + 1),
    bennettLocalResidue a e (Polynomial.C (c l j) * clearedPoleNumerator a e l j) i) = _
  simp only [bennettLocalResidue_C_mul]
  rw [Finset.sum_eq_single i]
  · simp only [bennettLocalResidue, bennettShift_clearedPole_self a ha,
      PowerSeries.coeff_X_pow]
    have heq (j : Fin (e i + 1)) : e i = j.val ↔ j = Fin.last (e i) := by
      constructor
      · intro h
        exact Fin.ext h.symm
      · intro h
        subst j
        rfl
    simp_rw [heq]
    simp [mul_ite]
  · intro l hl hli
    simp only [bennettLocalResidue_clearedPole_of_ne a e i l hli.symm, mul_zero,
      Finset.sum_const_zero]
  · simp

/-- The sum of the explicitly defined local residues vanishes whenever the
numerator has degree at least two below the full denominator degree.
No decomposition or cancellation identity is assumed. -/
theorem bennettLocalResidue_sum_eq_zero (a : ι → F) (ha : Function.Injective a)
    (e : ι → ℕ) (f : Polynomial F)
    (hdeg : f.degree < ((∑ l, (e l + 1)) - 1 : ℕ)) :
    ∑ i, bennettLocalResidue a e f i = 0 := by
  obtain ⟨c, hc, hsum⟩ :=
    exists_clearedPole_decomposition_zero_residue_sum a ha e f hdeg
  calc
    (∑ i, bennettLocalResidue a e f i) = ∑ i, c i (Fin.last (e i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      exact bennettLocalResidue_eq_decomposition_coeff a ha e c f hc i
    _ = 0 := hsum

end Field

end D1Bound5
