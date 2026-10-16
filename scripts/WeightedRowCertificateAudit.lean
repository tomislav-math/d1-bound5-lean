import D1Bound5.WeightedRowCertificate
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the elaborated weighted-row certificate with exact transitive
   axiom closure. This is not yet a spectral/operator-norm result. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.weightedFourWeights_pos,
    `D1Bound5.mixedFourEnvelope_nonneg,
    `D1Bound5.mixedFourEnvelope_symmetric,
    `D1Bound5.mixedFourEnvelope_weighted_rows,
    `D1Bound5.mixedFourEnvelope_first_row_strict,
    `D1Bound5.mixedFour_entry_norm_le_envelope,
    `D1Bound5.mixedFour_entrywise_weighted_row_bound]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"WEIGHTED_ROW_AXIOMS {n}: {axs}"
  logInfo m!"WEIGHTED_ROW_AXIOMS_PASS {names.length} theorems"

#check @D1Bound5.mixedFourEnvelope_weighted_rows
#check @D1Bound5.mixedFour_entrywise_weighted_row_bound
#print axioms D1Bound5.mixedFour_entrywise_weighted_row_bound
