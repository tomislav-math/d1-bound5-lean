import D1Bound5.MatrixOperatorNorm
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

namespace D1Bound5

/-- Positive weights for the mixed first-row perturbation estimate. -/
noncomputable def weightedFourWeights (i : Fin 4) : ℝ :=
  if i = 0 then 3 / 2 else 1

/-- Symmetric real entrywise envelope for the mixed root error. -/
noncomputable def mixedFourEnvelope (i j : Fin 4) : ℝ :=
  if i = j then 0 else if i = 0 ∨ j = 0 then 1 / 18 else 1 / 64

theorem weightedFourWeights_pos (i : Fin 4) : 0 < weightedFourWeights i := by
  fin_cases i <;> norm_num [weightedFourWeights]

theorem mixedFourEnvelope_nonneg (i j : Fin 4) : 0 ≤ mixedFourEnvelope i j := by
  unfold mixedFourEnvelope
  split_ifs <;> norm_num

theorem mixedFourEnvelope_symmetric (i j : Fin 4) :
    mixedFourEnvelope i j = mixedFourEnvelope j i := by
  by_cases h : i = j
  · subst j
    rfl
  · have h' : j ≠ i := Ne.symm h
    change (if i = j then (0 : ℝ) else if i = 0 ∨ j = 0 then 1 / 18 else 1 / 64) =
      (if j = i then (0 : ℝ) else if j = 0 ∨ i = 0 then 1 / 18 else 1 / 64)
    rw [if_neg h, if_neg h']
    by_cases k : i = 0 ∨ j = 0
    · rw [if_pos k, if_pos (by tauto)]
    · rw [if_neg k, if_neg (by tauto)]

/-- Exact weighted-row certificate for the mixed product-four branch. -/
theorem mixedFourEnvelope_weighted_rows (i : Fin 4) :
    (∑ j : Fin 4, mixedFourEnvelope i j * weightedFourWeights j) ≤
      (11 / 96 : ℝ) * weightedFourWeights i := by
  fin_cases i <;>
    (norm_num [Fin.sum_univ_four, mixedFourEnvelope, weightedFourWeights] <;>
      simp <;> norm_num)

/-- Strict slack in the first row of the weighted certificate. -/
theorem mixedFourEnvelope_first_row_strict :
    (∑ j : Fin 4, mixedFourEnvelope 0 j * weightedFourWeights j) <
      (11 / 96 : ℝ) * weightedFourWeights 0 := by
  norm_num [Fin.sum_univ_four, mixedFourEnvelope, weightedFourWeights] <;>
    simp <;> norm_num

end D1Bound5

namespace D1Bound5

/-- Any complex matrix obeying the mixed first-row and lower-block entry
bounds is entrywise dominated by the exact rational envelope. -/
theorem mixedFour_entry_norm_le_envelope
    (E : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, E i i = 0)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖E i j‖ < (1 / 18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖E i j‖ < (1 / 64 : ℝ))
    (i j : Fin 4) :
    ‖E i j‖ ≤ mixedFourEnvelope i j := by
  by_cases hij : i = j
  · subst j
    simp [mixedFourEnvelope, hdiag]
  · by_cases hzero : i = 0 ∨ j = 0
    · simpa [mixedFourEnvelope, hij, hzero] using
        (le_of_lt (hfirst i j hij hzero))
    · simpa [mixedFourEnvelope, hij, hzero] using
        (le_of_lt (hlater i j hij hzero))

/-- The complete weighted-row estimate for the mixed four-by-four
perturbation, with no symmetry assumption. It is an algebraic row bound;
passing to the spectral/operator norm is a separate obligation. -/
theorem mixedFour_entrywise_weighted_row_bound
    (E : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, E i i = 0)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖E i j‖ < (1 / 18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖E i j‖ < (1 / 64 : ℝ))
    (i : Fin 4) :
    (∑ j : Fin 4, ‖E i j‖ * weightedFourWeights j) ≤
      (11 / 96 : ℝ) * weightedFourWeights i := by
  calc
    (∑ j : Fin 4, ‖E i j‖ * weightedFourWeights j) ≤
        ∑ j : Fin 4, mixedFourEnvelope i j * weightedFourWeights j := by
      apply Finset.sum_le_sum
      intro j _
      exact mul_le_mul_of_nonneg_right
        (mixedFour_entry_norm_le_envelope E hdiag hfirst hlater i j)
        (le_of_lt (weightedFourWeights_pos j))
    _ ≤ (11 / 96 : ℝ) * weightedFourWeights i :=
      mixedFourEnvelope_weighted_rows i

end D1Bound5
