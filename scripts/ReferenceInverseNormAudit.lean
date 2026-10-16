import D1Bound5.ReferenceInverseNorm
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Transitive axiom and exact-type audit for the reference inverse L2 norm. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.referenceReflection,
    `D1Bound5.referenceReflection_sq,
    `D1Bound5.referenceReflection_conjTranspose,
    `D1Bound5.referenceReflection_norm,
    `D1Bound5.halfOffDiagonalInverse_decompose,
    `D1Bound5.halfOffDiagonalInverse_norm_le,
    `D1Bound5.halfOffDiagonalInverse_mul_reflection_plus_one,
    `D1Bound5.halfOffDiagonalInverse_norm_ge,
    `D1Bound5.halfOffDiagonalInverse_norm,
    `D1Bound5.reference_inverse_error_norm_lt_one]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"REFERENCE_INVERSE_AUDIT {n}: {axioms}"
  logInfo m!"REFERENCE_INVERSE_AXIOM_AUDIT_PASS: {names.length} declarations"

#check @D1Bound5.halfOffDiagonalInverse_norm
#check @D1Bound5.reference_inverse_error_norm_lt_one
#print axioms D1Bound5.halfOffDiagonalInverse_norm
#print axioms D1Bound5.reference_inverse_error_norm_lt_one
