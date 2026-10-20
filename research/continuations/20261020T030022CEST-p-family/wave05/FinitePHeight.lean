import D1Bound5.FinitePMatrix
import D1Bound5.FiniteHomogeneousTwo
import Mathlib.Tactic.GCongr
import Lean.Elab.Tactic.Omega
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Linarith

open Finset

namespace D1Bound5

attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three

/-- Integer coefficient and the three anchor exponents. -/
abbrev FinitePTerm := ℤ × ℕ × ℕ × ℕ

def finitePTermValue {R : Type*} [CommRing R]
    (t : FinitePTerm) (a b s : R) : R :=
  (t.1 : R)*a^t.2.1*b^t.2.2.1*s^t.2.2.2

/-- Terms are obtained after the H and V row cancellations. -/
def finitePRootTerms : Fin 4 → Fin 3 → Fin 3 → Fin 3 → FinitePTerm :=
  ![![![![(7, 2, 0, 0), (-35, 1, 1, 0), (0, 0, 0, 0)], ![(35, 1, 1, 0), (-7, 0, 2, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]], ![![(64, 3, 0, 0), (-140, 2, 1, 0), (0, 0, 0, 0)], ![(140, 1, 2, 0), (-64, 0, 3, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]], ![![(72, 4, 0, 0), (-120, 3, 1, 0), (0, 0, 0, 0)], ![(120, 1, 3, 0), (-72, 0, 4, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]]], ![![![(-35, 1, 1, 0), (35, 1, 0, 1), (0, 0, 0, 0)], ![(35, 1, 1, 0), (-35, 0, 1, 1), (0, 0, 0, 0)], ![(35, 0, 1, 1), (-35, 1, 0, 1), (0, 0, 0, 0)]], ![![(-140, 2, 1, 0), (140, 2, 0, 1), (0, 0, 0, 0)], ![(140, 1, 2, 0), (-140, 0, 2, 1), (0, 0, 0, 0)], ![(140, 0, 1, 2), (-140, 1, 0, 2), (0, 0, 0, 0)]], ![![(-120, 3, 1, 0), (120, 3, 0, 1), (0, 0, 0, 0)], ![(120, 1, 3, 0), (-120, 0, 3, 1), (0, 0, 0, 0)], ![(120, 0, 1, 3), (-120, 1, 0, 3), (0, 0, 0, 0)]]], ![![![(-15, 3, 0, 0), (56, 2, 1, 0), (-105, 1, 2, 0)], ![(70, 1, 2, 0), (-6, 0, 3, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]], ![![(-180, 4, 0, 0), (512, 3, 1, 0), (-420, 2, 2, 0)], ![(100, 1, 3, 0), (-12, 0, 4, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]], ![![(-240, 5, 0, 0), (576, 4, 1, 0), (-360, 3, 2, 0)], ![(24, 0, 5, 0), (0, 0, 0, 0), (0, 0, 0, 0)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]]], ![![![(-15, 3, 0, 0), (56, 2, 0, 1), (-105, 1, 0, 2)], ![(15, 0, 3, 0), (-56, 0, 2, 1), (105, 0, 1, 2)], ![(70, 1, 0, 2), (-70, 0, 1, 2), (0, 0, 0, 0)]], ![![(-180, 4, 0, 0), (512, 3, 0, 1), (-420, 2, 0, 2)], ![(180, 0, 4, 0), (-512, 0, 3, 1), (420, 0, 2, 2)], ![(100, 1, 0, 3), (-100, 0, 1, 3), (0, 0, 0, 0)]], ![![(-240, 5, 0, 0), (576, 4, 0, 1), (-360, 3, 0, 2)], ![(240, 0, 5, 0), (-576, 0, 4, 1), (360, 0, 3, 2)], ![(0, 0, 0, 0), (0, 0, 0, 0), (0, 0, 0, 0)]]]]

def finitePRootCoeff {R : Type*} [CommRing R]
    (a b s : R) (i : Fin 4) (l j : Fin 3) : R :=
  ∑ t, finitePTermValue (finitePRootTerms i l j t) a b s

def finitePRootColumn {R : Type*} [CommRing R]
    (a b s c : R) (i : Fin 4) (j : Fin 3) : R :=
  finitePDividedMatrix a b s c i j.succ

theorem finitePRootColumn_coeff {R : Type*} [CommRing R]
    (a b s c : R) (i : Fin 4) (j : Fin 3) :
    finitePRootColumn a b s c i j = finitePRootCoeff a b s i 0 j +
      finitePRootCoeff a b s i 1 j*c+finitePRootCoeff a b s i 2 j*c^2 := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [finitePRootColumn, finitePDividedMatrix, finitePRootCoeff,
      finitePRootTerms, finitePTermValue, finitePRLeft, finitePRRight,
      finitePTLeft, finitePTRight, finitePairQuadratic, finitePRLeftCoeff,
      finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff, Fin.sum_univ_succ]
    <;> ring

/-- Every actual monomial lies in one of the two height boxes. -/
theorem finitePRootTerms_exponents (i : Fin 4) (l j t : Fin 3) :
    let u := finitePRootTerms i l j t
    (u.2.1+u.2.2.1+u.2.2.2 ≤ 5 ∧ u.2.2.2 ≤ 2) ∨
      (u.2.1+u.2.2.1 ≤ 1 ∧ u.2.2.2 ≤ 3) := by
  fin_cases i <;> fin_cases l <;> fin_cases j <;> fin_cases t <;>
    norm_num [finitePRootTerms]

theorem finiteP_monomial_le (A B S : ℝ) (hA : 1 ≤ A)
    (hAB : A ≤ B) (hBS : B ≤ S) (i j l : ℕ)
    (hexp : (i+j+l ≤ 5 ∧ l ≤ 2) ∨ (i+j ≤ 1 ∧ l ≤ 3)) :
    A^i*B^j*S^l ≤ max (B*S^3) (B^3*S^2) := by
  have hB : 1 ≤ B := hA.trans hAB
  have hS : 1 ≤ S := hB.trans hBS
  have hA0 : 0 ≤ A := by linarith
  have hB0 : 0 ≤ B := by linarith
  have hS0 : 0 ≤ S := by linarith
  have hfirst : A^i*B^j*S^l ≤ B^(i+j)*S^l := by
    rw [pow_add]
    gcongr
  apply hfirst.trans
  rcases hexp with ⟨ht,hl⟩ | ⟨ht,hl⟩
  · apply le_trans _ (le_max_right _ _)
    by_cases hn : i+j ≤ 3
    · gcongr
    · have hsplit : i+j = 3+(i+j-3) := by omega
      have hsmall : i+j-3+l ≤ 2 := by omega
      calc
        B^(i+j)*S^l = B^3*(B^(i+j-3)*S^l) := by rw [← mul_assoc, ← pow_add, ← hsplit]
        _ ≤ B^3*(S^(i+j-3)*S^l) := by gcongr
        _ = B^3*S^(i+j-3+l) := by rw [pow_add]
        _ ≤ B^3*S^2 := by gcongr
  · apply le_trans _ (le_max_left _ _)
    calc
      B^(i+j)*S^l ≤ B^1*S^3 := by gcongr
      _ = B*S^3 := by ring

theorem finitePTermValue_norm_le (a b s : ℂ) (hA : 1 ≤ ‖a‖)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (i : Fin 4) (l j t : Fin 3) :
    ‖finitePTermValue (finitePRootTerms i l j t) a b s‖ ≤
      |((finitePRootTerms i l j t).1 : ℝ)| *
        max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2) := by
  let u := finitePRootTerms i l j t
  have hm := finiteP_monomial_le ‖a‖ ‖b‖ ‖s‖ hA hAB hBS
    u.2.1 u.2.2.1 u.2.2.2 (finitePRootTerms_exponents i l j t)
  have hnorm : ‖(u.1 : ℂ)‖ = |(u.1 : ℝ)| := by simp
  simpa [finitePTermValue, norm_mul, norm_pow, hnorm, mul_assoc, u] using
      mul_le_mul_of_nonneg_left hm (abs_nonneg (u.1 : ℝ))

theorem finitePRootCoeff_norm_le (a b s : ℂ) (hA : 1 ≤ ‖a‖)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (i : Fin 4) (l j : Fin 3) :
    ‖finitePRootCoeff a b s i l j‖ ≤
      (∑ t, |((finitePRootTerms i l j t).1 : ℝ)|)*
        max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2) := by
  apply (norm_sum_le _ _).trans
  rw [Finset.sum_mul]
  exact Finset.sum_le_sum fun t _ => finitePTermValue_norm_le a b s hA hAB hBS i l j t

theorem finitePRootTerms_sums (i : Fin 4) :
    (∑ j, ∑ t, |((finitePRootTerms i 0 j t).1 : ℝ)|) ≤ 492 ∧
    (∑ j, ∑ t, |((finitePRootTerms i 1 j t).1 : ℝ)|) ≤ 2424 ∧
    (∑ j, ∑ t, |((finitePRootTerms i 2 j t).1 : ℝ)|) ≤ 2352 := by
  fin_cases i <;> norm_num [finitePRootTerms, Fin.sum_univ_succ]

/-- Uniform actual root-column height, including the cancellation in H,V. -/
theorem finiteP_root_columns_norm_le (a b s c : ℂ) (hA : 1 ≤ ‖a‖)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (i : Fin 4) :
    (∑ j, ‖finitePRootColumn a b s c i j‖) ≤
      max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*(492+2424*‖c‖+2352*‖c‖^2) := by
  let H := max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)
  have hH : 0 ≤ H := le_trans (by positivity) (le_max_left _ _)
  have hj (j : Fin 3) :
      ‖finitePRootColumn a b s c i j‖ ≤
        (∑ t, |((finitePRootTerms i 0 j t).1 : ℝ)|)*H+
        (∑ t, |((finitePRootTerms i 1 j t).1 : ℝ)|)*H*‖c‖+
        (∑ t, |((finitePRootTerms i 2 j t).1 : ℝ)|)*H*‖c‖^2 := by
    rw [finitePRootColumn_coeff]
    apply (finite_norm_quadratic_le _ _ _ _).trans
    have h0 := finitePRootCoeff_norm_le a b s hA hAB hBS i 0 j
    have h1 := finitePRootCoeff_norm_le a b s hA hAB hBS i 1 j
    have h2 := finitePRootCoeff_norm_le a b s hA hAB hBS i 2 j
    dsimp [H] at *
    gcongr
  have hsum := Finset.sum_le_sum (s := Finset.univ) fun j _ => hj j
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib] at hsum
  simp only [← Finset.sum_mul] at hsum
  obtain ⟨h0,h1,h2⟩ := finitePRootTerms_sums i
  calc
    _ ≤ _ := hsum
    _ ≤ 492*H+2424*H*‖c‖+2352*H*‖c‖^2 := by gcongr
    _ = _ := by ring

theorem finiteP_height_scalar (C : ℝ) (hC : 200 ≤ C) :
    (101/100 : ℝ)*(492+2424*C+2352*C^2) < 2400*C^2 := by
  have hsq := mul_nonneg (sub_nonneg.mpr hC) (show 0 ≤ C by linarith)
  nlinarith only [hsq,hC]

theorem finiteP_height_scaled (a b s c : ℂ) (hA : 1 ≤ ‖a‖)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (hC : 200 ≤ ‖c‖)
    (i : Fin 4) :
    (101/100 : ℝ)*(∑ j, ‖finitePRootColumn a b s c i j‖) <
      2400*max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*‖c‖^2 := by
  have hB : 0 < ‖b‖ := by linarith
  have hS : 0 < ‖s‖ := lt_of_lt_of_le hB hBS
  have hH : 0 < max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2) :=
    lt_of_lt_of_le (by positivity) (le_max_left _ _)
  have hb := mul_le_mul_of_nonneg_left
    (finiteP_root_columns_norm_le a b s c hA hAB hBS i) (by norm_num : (0:ℝ)≤101/100)
  have hs := mul_lt_mul_of_pos_left (finiteP_height_scalar ‖c‖ hC) hH
  nlinarith only [hb,hs]

end D1Bound5
