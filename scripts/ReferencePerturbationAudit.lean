import D1Bound5.ReferencePerturbation
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit exact statement types and transitive axiom dependencies of the
four proved matrix-perturbation theorems. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.reference_perturbed_det_ne_zero,
    `D1Bound5.reference_perturbed_det_ne_zero_of_near,
    `D1Bound5.reference_perturbed_inverse_norm_lt,
    `D1Bound5.exists_signed_root_matrix_with_bounded_inverse]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"REFERENCE_PERTURBATION_AUDIT {n}: {axioms}"
  logInfo m!"REFERENCE_PERTURBATION_AXIOM_AUDIT_PASS: {names.length} declarations"

#check @D1Bound5.reference_perturbed_det_ne_zero
#check @D1Bound5.reference_perturbed_det_ne_zero_of_near
#check @D1Bound5.reference_perturbed_inverse_norm_lt
#check @D1Bound5.exists_signed_root_matrix_with_bounded_inverse
#print axioms D1Bound5.reference_perturbed_inverse_norm_lt
#print axioms D1Bound5.exists_signed_root_matrix_with_bounded_inverse
