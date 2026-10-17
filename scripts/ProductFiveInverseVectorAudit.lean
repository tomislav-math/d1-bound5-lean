import D1Bound5.ProductFiveInverseVector
import Lean.Util.CollectAxioms

open Lean Elab Command

/- The theorem is a conditional matrix estimate, not product-five itself.
   The two private reference-vector lemmas occur in its transitive proof. -/
run_cmd do
  let n : Name := `D1Bound5.productFive_inverse_vector_bound
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axs ← Lean.collectAxioms n
  let bad := axs.filter fun a => !allowed.contains a
  unless bad.isEmpty do
    throwError "Forbidden axioms for {n}: {bad}"
  logInfo m!"FIVE_INVERSE_VECTOR_AXIOMS_PASS {n}: {axs}"

#check @D1Bound5.productFive_inverse_vector_bound
