import D1Bound5.FinitePMatrix
import D1Bound5.FiniteQResidualIdentity
import Mathlib.Tactic.FieldSimp

open Finset

namespace D1Bound5

attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three

theorem finiteP_half_coefficients :
    halfBinomialCoeff 5 = 7/256 ∧ halfBinomialCoeff 6 = -21/1024 ∧
    halfBinomialCoeff 7 = 33/2048 := by
  have h4 := finiteQ_half_coefficients.2.2.2.2
  have h5 : halfBinomialCoeff 5 = 7/256 := by
    have h := halfBinomialCoeff_recurrence 4
    norm_num [h4] at h
    linarith
  have h6 : halfBinomialCoeff 6 = -21/1024 := by
    have h := halfBinomialCoeff_recurrence 5
    norm_num [h5] at h
    linarith
  have h7 : halfBinomialCoeff 7 = 33/2048 := by
    have h := halfBinomialCoeff_recurrence 6
    norm_num [h6] at h
    linarith
  exact ⟨h5,h6,h7⟩

/-- Degree-six tail estimate for the actual principal half power. -/
theorem finitePHalfRemainder_norm_le (n : ℕ) (z : ℂ)
    (hn : 6 ≤ n) (hz : ‖z‖ < 1) :
    ‖finiteQHalfRemainder n z‖ ≤ (21/1024 : ℝ)*‖z‖^n/(1-‖z‖) := by
  have hs := halfBinomialCoeff_hasSum_cpow z hz
  have htail : HasSum (fun j : ℕ => (halfBinomialCoeff (j+n) : ℂ)*z^(j+n))
      (finiteQHalfRemainder n z) := (hasSum_nat_add_iff' n).2 hs
  have hr : ‖(‖z‖ : ℝ)‖ < 1 := by
    simpa only [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg z)] using hz
  have hgeom := (hasSum_geometric_of_norm_lt_one hr).mul_left
    ((21/1024 : ℝ)*‖z‖^n)
  have hterm (j : ℕ) :
      ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ ≤
        ((21/1024 : ℝ)*‖z‖^n)*‖z‖^j := by
    have hb : |halfBinomialCoeff (j+n)| ≤ (21/1024 : ℝ) := by
      have h := halfBinomialCoeff_abs_antitone (j := 6) (k := j+n)
        (by decide) (by omega)
      rw [finiteP_half_coefficients.2.1] at h
      norm_num at h ⊢
      exact h
    calc
      _ = |halfBinomialCoeff (j+n)| *‖z‖^(j+n) := by
        rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
      _ ≤ (21/1024 : ℝ)*‖z‖^(j+n) :=
        mul_le_mul_of_nonneg_right hb (pow_nonneg (norm_nonneg z) _)
      _ = _ := by rw [pow_add]; ring
  have hnorm : Summable (fun j : ℕ => ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖) :=
    Summable.of_nonneg_of_le (fun _ => norm_nonneg _) hterm hgeom.summable
  calc
    _ = ‖∑' j : ℕ, (halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ := by rw [htail.tsum_eq]
    _ ≤ ∑' j : ℕ, ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ := norm_tsum_le_tsum_norm hnorm
    _ ≤ ∑' j : ℕ, ((21/1024 : ℝ)*‖z‖^n)*‖z‖^j :=
      hnorm.tsum_le_tsum hterm hgeom.summable
    _ = (21/1024 : ℝ)*‖z‖^n/(1-‖z‖) := by rw [hgeom.tsum_eq]; rfl

def finitePPairCoeff {R : Type*} [CommRing R]
    (u v : R) (kind side : Fin 2) : Fin 3 → R :=
  ![![finitePRLeftCoeff u v, finitePRRightCoeff u v],
    ![finitePTLeftCoeff u v, finitePTRightCoeff u v]] kind side

noncomputable def finitePPairResidual (u v c : ℂ) (kind : Fin 2) : ℂ :=
  ![finitePRConstant u v c,finitePTConstant u v c] kind +
    u*finitePairQuadratic (finitePPairCoeff u v kind 0) c*((1+1/(u*c))^(1/2 : ℂ)) +
    v*finitePairQuadratic (finitePPairCoeff u v kind 1) c*((1+1/(v*c))^(1/2 : ℂ))

noncomputable def finitePPairTail (u v c : ℂ) (kind : Fin 2) : ℂ :=
  ∑ side : Fin 2, ∑ l : Fin 3,
    ![u,v] side*finitePPairCoeff u v kind side l*c^(l : ℕ)*
      finiteQHalfRemainder (6+(l : ℕ)) (1/(![u,v] side*c))

/-- The exact first nonzero inverse-power coefficient of R and T. -/
noncomputable def finitePLeadingR (u v : ℂ) : ℂ :=
  5/(128*u^2)-5/(128*v^2)+5*u/(256*v^3)-5*v/(256*u^3)

noncomputable def finitePLeadingT (u v : ℂ) : ℂ :=
  -75/(128*u)+5*v/(16*u^2)-15*v^2/(256*u^3)-35*u/(256*v^2)+15/(32*v)

set_option maxHeartbeats 2000000 in
/-- The actual pair rows cancel every coefficient through c^-4. -/
theorem finitePPairResidual_eq_leading_tail (u v c : ℂ)
    (hu : u ≠ 0) (hv : v ≠ 0) (hc : c ≠ 0) (kind : Fin 2) :
    finitePPairResidual u v c kind =
      ![finitePLeadingR u v,finitePLeadingT u v] kind/c^5+finitePPairTail u v c kind := by
  obtain ⟨h0,h1,h2,h3,h4⟩ := finiteQ_half_coefficients
  obtain ⟨h5,h6,h7⟩ := finiteP_half_coefficients
  fin_cases kind
  all_goals
    simp only [finitePPairResidual, finitePPairTail, finiteQHalfRemainder,
      Fin.sum_univ_succ, Finset.sum_range_succ, Finset.sum_range_zero,
      h0,h1,h2,h3,h4,h5,h6,h7]
    norm_num [finitePPairCoeff, finitePRConstant, finitePTConstant,
      finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
      finitePairQuadratic, finitePLeadingR, finitePLeadingT]
    field_simp [hu,hv,hc]
    <;> ring

noncomputable def finitePResidual (a b s c : ℂ) (i : Fin 4) : ℂ :=
  finitePDividedMatrix a b s c i 0+
    ∑ j : Fin 3, ![a,b,s] j*finitePDividedMatrix a b s c i j.succ*
      ((1+1/(![a,b,s] j*c))^(1/2 : ℂ))

/-- The V leading coefficient is combined before taking absolute values;
its two 15/(32s) terms cancel exactly. -/
noncomputable def finitePLeadingV (a b s : ℂ) : ℂ :=
  -75/(128*a)+5*s/(16*a^2)-15*s^2/(256*a^3)-35*a/(256*s^2)+
    75/(128*b)-5*s/(16*b^2)+15*s^2/(256*b^3)+35*b/(256*s^2)

noncomputable def finitePLeading (a b s : ℂ) : Fin 4 → ℂ :=
  ![finitePLeadingR a b, finitePLeadingR a b+finitePLeadingR b s-finitePLeadingR a s,
    finitePLeadingT a b, finitePLeadingV a b s]

noncomputable def finitePTail (a b s c : ℂ) : Fin 4 → ℂ :=
  ![finitePPairTail a b c 0,
    finitePPairTail a b c 0+finitePPairTail b s c 0-finitePPairTail a s c 0,
    finitePPairTail a b c 1, finitePPairTail a s c 1-finitePPairTail b s c 1]

theorem finitePResidual_eq_pairs (a b s c : ℂ) (i : Fin 4) :
    finitePResidual a b s c i =
      ![finitePPairResidual a b c 0,
        finitePPairResidual a b c 0+finitePPairResidual b s c 0-finitePPairResidual a s c 0,
        finitePPairResidual a b c 1,finitePPairResidual a s c 1-finitePPairResidual b s c 1] i := by
  fin_cases i <;> simp [finitePResidual,finitePDividedMatrix,finitePPairResidual,
    finitePPairCoeff,finitePRLeft,finitePRRight,finitePTLeft,finitePTRight,
    Fin.sum_univ_succ] <;> ring

theorem finitePResidual_eq_leading_tail (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0) (i : Fin 4) :
    finitePResidual a b s c i = finitePLeading a b s i/c^5+finitePTail a b s c i := by
  rw [finitePResidual_eq_pairs]
  simp only [finitePPairResidual_eq_leading_tail _ _ c ha hb hc,
    finitePPairResidual_eq_leading_tail _ _ c hb hs hc,
    finitePPairResidual_eq_leading_tail _ _ c ha hs hc]
  fin_cases i <;> simp [finitePLeading,finitePTail,finitePLeadingV,finitePLeadingT] <;> ring

end D1Bound5
