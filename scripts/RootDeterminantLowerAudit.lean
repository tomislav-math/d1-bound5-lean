import D1Bound5.RootDeterminantLower
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Verify the precise elaborated statements and transitive axioms of the
new full-ring arithmetic lower bound. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.scaledRootMatrix_det_norm_identity,
    `D1Bound5.scaledRootMatrix_det_norm_lower,
    `D1Bound5.full_ring_scaledRootMatrix_det_norm_lower]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter (fun a => !allowed.contains a)
    unless bad.isEmpty do
      throwError "Unexpected axioms for {n}: {bad}"
    logInfo m!"ROOT_DET_LOWER_AXIOMS {n}: {axs}"
  logInfo m!"ROOT_DET_LOWER_AXIOM_AUDIT_PASS: {names.length} theorems"

#check @D1Bound5.scaledRootMatrix_det_norm_identity
#check @D1Bound5.scaledRootMatrix_det_norm_lower
#check @D1Bound5.full_ring_scaledRootMatrix_det_norm_lower
#print axioms D1Bound5.full_ring_scaledRootMatrix_det_norm_lower
