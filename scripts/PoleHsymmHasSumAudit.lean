import D1Bound5.PoleHsymmHasSum
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let target : Name := `D1Bound5.reciprocal_pole_hsymm_hasSum_of_majorant
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axioms ← Lean.collectAxioms target
  let unexpected := axioms.filter fun name => !allowed.contains name
  unless unexpected.isEmpty do
    throwError "Unexpected axioms in {target}: {unexpected}"
  logInfo m!"POLE_HSYMM_HAS_SUM_AXIOMS_PASS {target}: {axioms}"

#check @D1Bound5.reciprocal_pole_hsymm_hasSum_of_majorant
