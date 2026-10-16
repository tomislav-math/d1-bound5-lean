import D1Bound5.ReferenceMatrixSpectral
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the exact reference determinant, inverse and adjugate. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.halfOffDiagonalInverse,
    `D1Bound5.halfOffDiagonal_mul_inverse,
    `D1Bound5.inverse_mul_halfOffDiagonal,
    `D1Bound5.halfOffDiagonal_det_ne_zero,
    `D1Bound5.halfOffDiagonal_det,
    `D1Bound5.halfOffDiagonal_adjugate,
    `D1Bound5.halfOffDiagonal_adjugate_apply]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"REFERENCE_MATRIX_AUDIT {n}: {axioms}"
  logInfo m!"REFERENCE_MATRIX_AXIOM_AUDIT_PASS: {names.length} declarations"

#check @D1Bound5.halfOffDiagonal_mul_inverse
#check @D1Bound5.inverse_mul_halfOffDiagonal
#check @D1Bound5.halfOffDiagonal_det
#check @D1Bound5.halfOffDiagonal_adjugate_apply
#print axioms D1Bound5.halfOffDiagonal_det
#print axioms D1Bound5.halfOffDiagonal_adjugate
