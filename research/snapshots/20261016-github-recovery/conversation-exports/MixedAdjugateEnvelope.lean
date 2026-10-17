import D1Bound5.WeightedSchur
import D1Bound5.AdjugateCoverage
import Lean.Util.CollectAxioms

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

noncomputable def mixedAdjEnvelope (i j : Fin 4) : ℝ :=
  if i = j then (if i = 0 then 1/40 else 7/100)
  else if i = 0 ∨ j = 0 then 53/1000 else 47/1000

theorem mixedAdjEnvelope_nonneg (i j : Fin 4) :
    0 ≤ mixedAdjEnvelope i j := by
  unfold mixedAdjEnvelope
  split_ifs <;> norm_num

theorem mixedAdjEnvelope_symmetric (i j : Fin 4) :
    mixedAdjEnvelope i j = mixedAdjEnvelope j i := by
  by_cases h : i = j
  · subst j
    rfl
  · have h' : j ≠ i := Ne.symm h
    change (if i = j then (if i = 0 then (1/40 : ℝ) else 7/100)
      else if i = 0 ∨ j = 0 then 53/1000 else 47/1000) =
      (if j = i then (if j = 0 then (1/40 : ℝ) else 7/100)
      else if j = 0 ∨ i = 0 then 53/1000 else 47/1000)
    rw [if_neg h, if_neg h']
    by_cases hz : i = 0 ∨ j = 0
    · rw [if_pos hz, if_pos (by tauto)]
    · rw [if_neg hz, if_neg (by tauto)]

theorem mixedAdjEnvelope_rows (i : Fin 4) :
    (∑ j : Fin 4, mixedAdjEnvelope i j * (1 : ℝ)) ≤
      (217/1000 : ℝ) * 1 := by
  fin_cases i <;>
    (norm_num [Fin.sum_univ_four, mixedAdjEnvelope] <;>
      simp <;> norm_num)

theorem mixedFour_adjugate_norm_of_entries
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, ‖(F.adjugate - halfOffDiagonal.adjugate) i i‖ <
      if i = 0 then (1/40 : ℝ) else 7/100)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖(F.adjugate - halfOffDiagonal.adjugate) i j‖ < (53/1000 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖(F.adjugate - halfOffDiagonal.adjugate) i j‖ < (47/1000 : ℝ)) :
    ‖F.adjugate‖ < (155/96 : ℝ) * (59/96)^2 := by
  let E : Matrix (Fin 4) (Fin 4) ℂ :=
    F.adjugate - halfOffDiagonal.adjugate
  have hEb : ∀ i j, ‖E i j‖ ≤ mixedAdjEnvelope i j := by
    intro i j
    by_cases hij : i = j
    · subst j
      simpa [E, mixedAdjEnvelope] using le_of_lt (hdiag i)
    · by_cases hz : i = 0 ∨ j = 0
      · simpa [E, mixedAdjEnvelope, hij, hz] using
          le_of_lt (hfirst i j hij hz)
      · simpa [E, mixedAdjEnvelope, hij, hz] using
          le_of_lt (hlater i j hij hz)
  have hw : ∀ i : Fin 4, (0 : ℝ) < (1 : ℝ) := by
    intro i
    norm_num
  have hnorm : ‖E‖ ≤ (217/1000 : ℝ) :=
    weightedSchur_four_opNorm E mixedAdjEnvelope (fun _ => (1 : ℝ))
      (217/1000) mixedAdjEnvelope_nonneg hw
      (by norm_num) mixedAdjEnvelope_symmetric mixedAdjEnvelope_rows hEb
  have href : ‖halfOffDiagonal.adjugate‖ = (3/8 : ℝ) := by
    rw [halfOffDiagonal_adjugate, norm_smul, halfOffDiagonalInverse_norm]
    norm_num
  have hdecomp : F.adjugate =
      halfOffDiagonal.adjugate + E := by
    dsimp [E]
    abel
  calc
    ‖F.adjugate‖ =
        ‖halfOffDiagonal.adjugate + E‖ := congrArg norm hdecomp
    _ ≤ ‖halfOffDiagonal.adjugate‖ + ‖E‖ := norm_add_le _ _
    _ ≤ (3/8 : ℝ) + 217/1000 := by
      rw [href]
      linarith only [hnorm]
    _ < (155/96 : ℝ) * (59/96)^2 := by norm_num

end D1Bound5

open Lean Elab Command
run_cmd do
  let names : List Name := [
    `D1Bound5.mixedAdjEnvelope_nonneg,
    `D1Bound5.mixedAdjEnvelope_symmetric,
    `D1Bound5.mixedAdjEnvelope_rows,
    `D1Bound5.mixedFour_adjugate_norm_of_entries]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let ax ← Lean.collectAxioms n
    let bad := ax.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms {n}: {bad}"
    logInfo m!"MIXED_ADJ_AXIOMS {n}: {ax}"
  logInfo m!"MIXED_ADJ_AUDIT_PASS: {names.length} declarations"
