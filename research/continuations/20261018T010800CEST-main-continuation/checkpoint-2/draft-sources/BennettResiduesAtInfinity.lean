import D1Bound5.BennettLocalResidues
import Mathlib.Algebra.Polynomial.Reverse

open Finset Polynomial

namespace D1Bound5

section Reverse

variable {F : Type*} [Field F]

/-- For a monic polynomial of positive degree, coefficients of its reciprocal
at infinity are the top coefficients of monomial remainders. The proof uses
polynomial reflection, so it introduces no analytic convergence assumption. -/
theorem bennett_inverse_reverse_coeff
    (D : F[X]) (hD : D.Monic) (hd : 0 < D.natDegree)
    (H : PowerSeries F) (hH : (D.reverse : PowerSeries F) * H = 1) (t : ℕ) :
    PowerSeries.coeff t H =
      ((X ^ (D.natDegree - 1 + t)) %ₘ D).coeff (D.natDegree - 1) := by
  classical
  let d := D.natDegree
  let f : F[X] := X ^ (d - 1 + t)
  let r := f %ₘ D
  let q := f /ₘ D
  have hd' : 0 < d := hd
  have hq : q.natDegree ≤ t := by
    dsimp [q, f]
    rw [Polynomial.natDegree_divByMonic _ hD, Polynomial.natDegree_X_pow]
    dsimp [d]
    omega
  have hr : r.degree < (d : ℕ) := by
    have h := Polynomial.degree_modByMonic_lt f hD
    simpa only [Polynomial.degree_eq_natDegree hD.ne_zero] using h
  have hH0 : PowerSeries.coeff 0 H = 1 := by
    have h := congrArg PowerSeries.constantCoeff hH
    simp only [map_mul, Polynomial.constantCoeff_coe, Polynomial.coeff_zero_reverse,
      show D.leadingCoeff = 1 from hD, map_one, one_mul] at h
    simpa only [PowerSeries.coeff_zero_eq_constantCoeff_apply] using h
  have hreflect :
      r.reflect (d + t) + D.reverse * q.reflect t = X := by
    calc
      _ = (r + D * q).reflect (d + t) := by
        rw [Polynomial.reflect_add, Polynomial.reflect_mul D q le_rfl hq]
        rfl
      _ = f.reflect (d + t) :=
        congrArg (Polynomial.reflect (d + t)) (Polynomial.modByMonic_add_div f D)
      _ = X := by
        dsimp [f]
        rw [Polynomial.reflect_monomial, Polynomial.revAt_le (by omega)]
        have he : d + t - (d - 1 + t) = 1 := by omega
        rw [he, pow_one]
  have hqzero : (q.reflect t).coeff (t + 1) = 0 := by
    apply Polynomial.coeff_eq_zero_of_natDegree_lt
    exact (Polynomial.natDegree_reflect_le.trans (max_le le_rfl hq)).trans_lt
      (Nat.lt_succ_self t)
  have hrzero (i : ℕ) (hi : i < t + 1) :
      (r.reflect (d + t)).coeff i = 0 := by
    rw [Polynomial.coeff_reflect, Polynomial.revAt_le (by omega)]
    apply Polynomial.coeff_eq_zero_of_degree_lt
    exact hr.trans_le (WithBot.coe_le_coe.mpr (by omega))
  have hrfirst : (r.reflect (d + t)).coeff (t + 1) = r.coeff (d - 1) := by
    rw [Polynomial.coeff_reflect, Polynomial.revAt_le (by omega)]
    congr 1
    omega
  have hproduct : PowerSeries.coeff (t + 1)
      ((r.reflect (d + t) : PowerSeries F) * H) = r.coeff (d - 1) := by
    rw [PowerSeries.coeff_mul, Finset.sum_eq_single (t + 1, 0)]
    · rw [Polynomial.coeff_coe, hrfirst, hH0, mul_one]
    · rintro ⟨i, j⟩ hij hne
      have hij' := Finset.mem_antidiagonal.mp hij
      have hi : i < t + 1 := by
        by_contra hh
        have he : i = t + 1 ∧ j = 0 := by omega
        exact hne (Prod.ext he.1 he.2)
      rw [Polynomial.coeff_coe, hrzero i hi, zero_mul]
    · intro hnot
      exact (hnot (Finset.mem_antidiagonal.mpr (by omega))).elim
  have hs := congrArg (fun p : F[X] => (p : PowerSeries F) * H) hreflect
  simp only [Polynomial.coe_add, Polynomial.coe_mul, Polynomial.coe_X, add_mul] at hs
  have hreorder : (D.reverse : PowerSeries F) * (q.reflect t : PowerSeries F) * H =
      (q.reflect t : PowerSeries F) * ((D.reverse : PowerSeries F) * H) := by ring
  rw [hreorder, hH, mul_one] at hs
  have hc := congrArg (PowerSeries.coeff (t + 1)) hs
  rw [map_add, hproduct, Polynomial.coeff_coe, hqzero, add_zero] at hc
  have hX : PowerSeries.coeff (t + 1) (PowerSeries.X * H) =
      PowerSeries.coeff t H := by
    simpa only [pow_one] using PowerSeries.coeff_X_pow_mul H 1 t
  exact (hc.trans hX).symm

end Reverse

section Residues

variable {F ι : Type*} [Field F] [CharZero F]
variable [Fintype ι] [DecidableEq ι]

/-- A numerator divisible by the full denominator has zero local residue.
This includes the polynomial part of an improper partial fraction. -/
theorem bennettLocalResidue_eq_zero_of_denominator_dvd
    (a : ι → F) (e : ι → ℕ) (f : F[X])
    (hf : bennettPoleDenominator a e ∣ f) (i : ι) :
    bennettLocalResidue a e f i = 0 := by
  have hdiv : (X - C (a i)) ^ (e i + 1) ∣ f := by
    apply dvd_trans _ hf
    exact Finset.dvd_prod_of_mem
      (fun l : ι => (X - C (a l)) ^ (e l + 1)) (Finset.mem_univ i)
  have hshift : (PowerSeries.X : PowerSeries F) ^ (e i + 1) ∣
      bennettShiftToSeries (a i) f := by
    simpa only [map_pow, bennettShiftToSeries_linear, sub_self, map_zero, zero_add]
      using map_dvd (bennettShiftToSeries (a i)) hdiv
  exact PowerSeries.X_pow_dvd_iff.mp
    (dvd_mul_of_dvd_left hshift (bennettLocalReciprocal a e i))
    (e i) (Nat.lt_succ_self _)

theorem bennettLocalResidue_add (a : ι → F) (e : ι → ℕ)
    (f g : F[X]) (i : ι) :
    bennettLocalResidue a e (f + g) i =
      bennettLocalResidue a e f i + bennettLocalResidue a e g i := by
  simp only [bennettLocalResidue, map_add, add_mul]

/-- For an arbitrary numerator, the sum of the actual local residues is the
coefficient one below the denominator degree in its polynomial remainder.
The required proper partial fractions are constructed, not assumed. -/
theorem bennettLocalResidue_sum_eq_remainder_coeff
    (a : ι → F) (ha : Function.Injective a) (e : ι → ℕ) (f : F[X]) :
    ∑ i, bennettLocalResidue a e f i =
      (f %ₘ bennettPoleDenominator a e).coeff ((∑ i, (e i + 1)) - 1) := by
  let D := bennettPoleDenominator a e
  let r := f %ₘ D
  have hrem : r.degree < (∑ i, (e i + 1) : ℕ) := by
    have h := Polynomial.degree_modByMonic_lt f (bennettPoleDenominator_monic a e)
    simpa only [bennettPoleDenominator_degree] using h
  obtain ⟨c, hc⟩ := exists_clearedPole_decomposition a ha e r hrem
  have hlocal (i : ι) : bennettLocalResidue a e f i =
      bennettLocalResidue a e r i := by
    calc
      _ = bennettLocalResidue a e (r + D * (f /ₘ D)) i :=
        congrArg (fun p => bennettLocalResidue a e p i)
          (Polynomial.modByMonic_add_div f D).symm
      _ = _ := by
        rw [bennettLocalResidue_add,
          bennettLocalResidue_eq_zero_of_denominator_dvd a e _ (dvd_mul_right D _) i,
          add_zero]
  calc
    _ = ∑ i, bennettLocalResidue a e r i := Finset.sum_congr rfl (fun i _ => hlocal i)
    _ = ∑ i, c i (Fin.last (e i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      exact bennettLocalResidue_eq_decomposition_coeff a ha e c r hc i
    _ = _ := (coeff_eq_sum_simple_residues a e c r hc).symm

/-- The explicit power series of the reciprocal denominator at infinity. -/
noncomputable def bennettReciprocalInfinity (a : ι → F) (e : ι → ℕ) : PowerSeries F :=
  ∏ i, PowerSeries.rescale (-a i)
    (PowerSeries.binomialSeries F (-((e i + 1 : ℕ) : F)))

private theorem bennett_reverse_pow (p : F[X]) (n : ℕ) :
    (p ^ n).reverse = p.reverse ^ n := by
  induction n with
  | zero => simp [Polynomial.reverse]
  | succ n ih => rw [pow_succ, Polynomial.reverse_mul_of_domain, ih, pow_succ]

private theorem bennett_reverse_X_sub_C (a : F) :
    (X - C a : F[X]).reverse = 1 - C a * X := by
  have hsub : (X - C a : F[X]) = X + C (-a) := by simp
  have hX : (X : F[X]).reverse = 1 := by
    simp only [Polynomial.reverse, Polynomial.natDegree_X, Polynomial.reflect_one_X]
  rw [hsub, Polynomial.reverse_add_C, hX, Polynomial.natDegree_X, pow_one, map_neg]
  ring

/-- The explicit product at infinity really inverts the reversed denominator. -/
theorem bennettReciprocalInfinity_mul
    (a : ι → F) (e : ι → ℕ) :
    ((bennettPoleDenominator a e).reverse : PowerSeries F) *
      bennettReciprocalInfinity a e = 1 := by
  classical
  have hprod (s : Finset ι) :
      (∏ i ∈ s, (X - C (a i) : F[X]) ^ (e i + 1)).reverse =
        ∏ i ∈ s, ((X - C (a i) : F[X]) ^ (e i + 1)).reverse := by
    induction s using Finset.induction_on with
    | empty => simp [Polynomial.reverse]
    | @insert i s hi ih =>
        rw [Finset.prod_insert hi, Polynomial.reverse_mul_of_domain, ih, Finset.prod_insert hi]
  unfold bennettPoleDenominator bennettReciprocalInfinity
  rw [hprod]
  change Polynomial.coeToPowerSeries.ringHom (∏ i, _) * (∏ i, _) = 1
  rw [map_prod, ← Finset.prod_mul_distrib]
  apply Finset.prod_eq_one
  intro i hi
  rw [bennett_reverse_pow, bennett_reverse_X_sub_C]
  change Polynomial.coeToPowerSeries.ringHom ((1 - C (a i) * X) ^ (e i + 1)) * _ = 1
  simp only [map_pow, map_sub, map_mul, map_one, Polynomial.coeToPowerSeries.ringHom_apply,
    Polynomial.coe_C, Polynomial.coe_X]
  have h := congrArg (PowerSeries.rescale (-a i))
    (bennettNegativeBinomial_mul (F := F) (e i + 1))
  simpa only [map_mul, map_pow, map_add, map_one, PowerSeries.rescale_X,
    map_neg, neg_mul, sub_eq_add_neg] using h

/-- Exact all-orders residue identity above the cancellation threshold.
The low-degree zero-residue theorem and this formula together determine
every coefficient of the actual Bennett row residual. -/
theorem bennettLocalResidue_sum_X_pow_eq_infinity_coeff
    (a : ι → F) (ha : Function.Injective a) (e : ι → ℕ)
    (hd : 0 < ∑ i, (e i + 1)) (t : ℕ) :
    ∑ i, bennettLocalResidue a e (X ^ ((∑ l, (e l + 1)) - 1 + t)) i =
      PowerSeries.coeff t (bennettReciprocalInfinity a e) := by
  rw [bennettLocalResidue_sum_eq_remainder_coeff a ha e]
  have h := bennett_inverse_reverse_coeff
    (bennettPoleDenominator a e) (bennettPoleDenominator_monic a e)
    (by simpa only [bennettPoleDenominator_natDegree] using hd)
    (bennettReciprocalInfinity a e) (bennettReciprocalInfinity_mul a e) t
  simpa only [bennettPoleDenominator_natDegree] using h.symm

end Residues

end D1Bound5
