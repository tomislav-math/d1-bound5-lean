import D1Bound5.BennettResiduesAtInfinity
import D1Bound5.LagrangeHomogeneous
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma

open Finset

namespace D1Bound5

section Homogeneous

variable {R ι : Type*} [CommRing R] [DecidableEq ι]

/-- The formal generating series of actual complete homogeneous symmetric
polynomials. Values of the variables are allowed to coincide. -/
noncomputable def bennettHomogeneousSeries [Fintype ι] (a : ι → R) : PowerSeries R :=
  PowerSeries.mk (homogeneousMultisetSum a)

private theorem bennettHomogeneousSeries_insert
    (s : Finset ι) (a : ι → R) (i : ι) (hi : i ∉ s) :
    (1 - PowerSeries.C (a i) * PowerSeries.X) *
      bennettHomogeneousSeries (fun j : (insert i s : Finset ι) => a j) =
      bennettHomogeneousSeries (fun j : s => a j) := by
  ext n
  rw [sub_mul, one_mul, mul_assoc, map_sub, PowerSeries.coeff_C_mul]
  cases n with
  | zero =>
      have hzero (G : PowerSeries R) : PowerSeries.coeff 0 (PowerSeries.X * G) = 0 := by
        simpa using PowerSeries.coeff_X_pow_mul' G 1 0
      rw [hzero]
      simp [bennettHomogeneousSeries]
  | succ n =>
      have hsucc (G : PowerSeries R) : PowerSeries.coeff (n + 1) (PowerSeries.X * G) =
          PowerSeries.coeff n G := by
        simpa only [pow_one] using PowerSeries.coeff_X_pow_mul G 1 n
      rw [hsucc]
      simp only [bennettHomogeneousSeries, PowerSeries.coeff_mk]
      rw [homogeneousMultisetSum_insert s a i hi n]
      ring

/-- The exact generating identity for complete homogeneous polynomials over
a finite set, proved by the already established variable-adjunction recursion. -/
theorem bennettHomogeneousSeries_finset_mul
    (s : Finset ι) (a : ι → R) :
    (∏ i ∈ s, (1 - PowerSeries.C (a i) * PowerSeries.X)) *
      bennettHomogeneousSeries (fun i : s => a i) = 1 := by
  classical
  induction s using Finset.induction_on with
  | empty =>
      simp only [Finset.prod_empty, one_mul]
      ext n
      cases n with
      | zero => simp [bennettHomogeneousSeries]
      | succ n => simp [bennettHomogeneousSeries, homogeneousMultisetSum]
  | @insert i s hi ih =>
      rw [Finset.prod_insert hi]
      calc
        _ = (∏ j ∈ s, (1 - PowerSeries.C (a j) * PowerSeries.X)) *
            ((1 - PowerSeries.C (a i) * PowerSeries.X) *
              bennettHomogeneousSeries (fun j : (insert i s : Finset ι) => a j)) := by ring
        _ = _ := by rw [bennettHomogeneousSeries_insert s a i hi, ih]

/-- Whole-type version of the homogeneous generating identity. -/
theorem bennettHomogeneousSeries_mul [Fintype ι] (a : ι → R) :
    (∏ i, (1 - PowerSeries.C (a i) * PowerSeries.X)) *
      bennettHomogeneousSeries a = 1 := by
  have heq : bennettHomogeneousSeries (fun i : (Finset.univ : Finset ι) => a i) =
      bennettHomogeneousSeries a := by
    ext n
    simp only [bennettHomogeneousSeries, PowerSeries.coeff_mk]
    exact homogeneousMultisetSum_equiv
      (Equiv.subtypeUnivEquiv (fun i : ι => Finset.mem_univ i)) a n
  simpa only [heq] using bennettHomogeneousSeries_finset_mul (Finset.univ : Finset ι) a

end Homogeneous

section Repeated

variable {F ι : Type*} [Field F] [CharZero F]
variable [Fintype ι] [DecidableEq ι]

/-- One copy of each pole node for each unit of its positive multiplicity. -/
abbrev BennettRepeatedNodes (e : ι → ℕ) := Σ i, Fin (e i + 1)

theorem bennettRepeatedNodes_card (e : ι → ℕ) :
    Fintype.card (BennettRepeatedNodes e) = ∑ i, (e i + 1) := by
  simp only [BennettRepeatedNodes, Fintype.card_sigma, Fintype.card_fin]

private theorem bennettReciprocalInfinity_explicit_mul
    (a : ι → F) (e : ι → ℕ) :
    (∏ i, (1 - PowerSeries.C (a i) * PowerSeries.X) ^ (e i + 1)) *
      bennettReciprocalInfinity a e = 1 := by
  unfold bennettReciprocalInfinity
  rw [← Finset.prod_mul_distrib]
  apply Finset.prod_eq_one
  intro i hi
  have h := congrArg (PowerSeries.rescale (-a i))
    (bennettNegativeBinomial_mul (F := F) (e i + 1))
  simpa only [map_mul, map_pow, map_add, map_one, PowerSeries.rescale_X,
    map_neg, neg_mul, sub_eq_add_neg] using h

/-- The reciprocal pole product is exactly the generating series of complete
homogeneous polynomials on the repeated nodes. Distinctness is unnecessary. -/
theorem bennettReciprocalInfinity_eq_homogeneous
    (a : ι → F) (e : ι → ℕ) :
    bennettReciprocalInfinity a e =
      bennettHomogeneousSeries (fun i : BennettRepeatedNodes e => a i.1) := by
  classical
  let D : PowerSeries F :=
    ∏ i, (1 - PowerSeries.C (a i) * PowerSeries.X) ^ (e i + 1)
  have hden : (∏ i : BennettRepeatedNodes e,
      (1 - PowerSeries.C (a i.1) * PowerSeries.X)) = D := by
    rw [Fintype.prod_sigma]
    simp [D]
  have hhom : D * bennettHomogeneousSeries (fun i : BennettRepeatedNodes e => a i.1) = 1 := by
    rw [← hden]
    exact bennettHomogeneousSeries_mul _
  have hinf : D * bennettReciprocalInfinity a e = 1 :=
    bennettReciprocalInfinity_explicit_mul a e
  calc
    bennettReciprocalInfinity a e = bennettReciprocalInfinity a e * 1 := by ring
    _ = bennettReciprocalInfinity a e *
        (D * bennettHomogeneousSeries (fun i : BennettRepeatedNodes e => a i.1)) := by
          rw [hhom]
    _ = (D * bennettReciprocalInfinity a e) *
        bennettHomogeneousSeries (fun i : BennettRepeatedNodes e => a i.1) := by ring
    _ = _ := by rw [hinf, one_mul]

theorem bennettReciprocalInfinity_coeff_eq_hsymm
    (a : ι → F) (e : ι → ℕ) (t : ℕ) :
    PowerSeries.coeff t (bennettReciprocalInfinity a e) =
      MvPolynomial.aeval (fun i : BennettRepeatedNodes e => a i.1)
        (MvPolynomial.hsymm (BennettRepeatedNodes e) F t) := by
  rw [bennettReciprocalInfinity_eq_homogeneous]
  simp only [bennettHomogeneousSeries, PowerSeries.coeff_mk]
  exact homogeneousMultisetSum_eq_hsymm _ t

/-- The actual high-degree residue sum is a complete homogeneous polynomial
on repeated nodes, supplying the exact input to the Bennett tail majorant. -/
theorem bennettLocalResidue_sum_X_pow_eq_hsymm
    (a : ι → F) (ha : Function.Injective a) (e : ι → ℕ)
    (hd : 0 < ∑ i, (e i + 1)) (t : ℕ) :
    ∑ i, bennettLocalResidue a e
        (Polynomial.X ^ ((∑ l, (e l + 1)) - 1 + t)) i =
      MvPolynomial.aeval (fun i : BennettRepeatedNodes e => a i.1)
        (MvPolynomial.hsymm (BennettRepeatedNodes e) F t) := by
  rw [bennettLocalResidue_sum_X_pow_eq_infinity_coeff a ha e hd t,
    bennettReciprocalInfinity_coeff_eq_hsymm]

end Repeated

end D1Bound5
