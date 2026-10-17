import D1Bound5.ComplexHsymmNorm
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check the fully elaborated statement and all transitive axioms. -/
run_cmd do
  let n : Name := `D1Bound5.hsymm_aeval_complex_norm_le_choose
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axs ← Lean.collectAxioms n
  let forbidden := axs.filter fun a => !allowed.contains a
  unless forbidden.isEmpty do
    throwError "Forbidden axioms for {n}: {forbidden}"
  logInfo m!"HSYMM_COMPLEX_NORM_AXIOMS_PASS {n}: {axs}"

#check @D1Bound5.hsymm_aeval_complex_norm_le_choose
