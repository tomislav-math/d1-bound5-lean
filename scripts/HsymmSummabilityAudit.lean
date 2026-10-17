import D1Bound5.HsymmSummability
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let target : Name := `D1Bound5.hsymm_aeval_complex_summable
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axioms ← Lean.collectAxioms target
  let unexpected := axioms.filter fun name => !allowed.contains name
  unless unexpected.isEmpty do
    throwError "Unexpected axioms in {target}: {unexpected}"
  logInfo m!"HSYMM_SUMMABILITY_AXIOMS_PASS {target}: {axioms}"

#check @D1Bound5.hsymm_aeval_complex_summable
