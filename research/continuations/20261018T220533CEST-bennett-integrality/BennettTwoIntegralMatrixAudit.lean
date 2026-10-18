import D1Bound5.BennettTwoIntegralMatrix
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennettTwoNodes_injective,
    `D1Bound5.bennettTwoClearedMatrix,
    `D1Bound5.bennettTwoClearedMatrix_det_ne_zero]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"INTEGRALITY_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennettTwoNodes_injective
#check @D1Bound5.bennettTwoClearedMatrix
#check @D1Bound5.bennettTwoClearedMatrix_det_ne_zero
