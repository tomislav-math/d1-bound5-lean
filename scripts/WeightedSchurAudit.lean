import D1Bound5.WeightedSchur
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let names : List Name := [
    `D1Bound5.weightedCS_four_row,
    `D1Bound5.weightedSchur_four_energy,
    `D1Bound5.weightedSchur_four_opNorm,
    `D1Bound5.mixedFour_operator_norm_le]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"WEIGHTED_SCHUR_AXIOMS {n}: {axs}"
  logInfo m!"WEIGHTED_SCHUR_AXIOM_PASS: {names.length} theorems"

#check @D1Bound5.weightedCS_four_row
#check @D1Bound5.weightedSchur_four_energy
#check @D1Bound5.weightedSchur_four_opNorm
#check @D1Bound5.mixedFour_operator_norm_le
