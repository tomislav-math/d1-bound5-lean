import D1Bound5.CoherentMajorant
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for target in [`D1Bound5.negative_binomial_positive_tail_tsum,
                 `D1Bound5.hsymm_aeval_complex_positive_tail_norm_le] do
    let axioms ← Lean.collectAxioms target
    let unexpected := axioms.filter fun name => !allowed.contains name
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {target}: {unexpected}"
    logInfo m!"COHERENT_MAJORANT_AXIOMS_PASS {target}: {axioms}"

#check @D1Bound5.negative_binomial_positive_tail_tsum
#check @D1Bound5.hsymm_aeval_complex_positive_tail_norm_le
