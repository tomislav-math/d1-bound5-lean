import D1Bound5.SignedRootAdjugateBound
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check the complete elaborated theorem statements and transitive axiom
dependencies. Root-import coverage is audited separately. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.four_operator_norm_lt_of_entry_bounds,
    `D1Bound5.symmetricZeroFour_adjugate_00,
    `D1Bound5.symmetricZeroFour_adjugate_01,
    `D1Bound5.four_adjugate_numeric_margin,
    `D1Bound5.four_adjugate_bound_of_entry_bounds,
    `D1Bound5.nearHalf_triple_cofactor_bound,
    `D1Bound5.nearHalf_offDiagonal_cofactor_bound,
    `D1Bound5.symmetricFour_adjugate_formula,
    `D1Bound5.symmetricFour_adjugate_norm_lt,
    `D1Bound5.symmetric_zero_four_adjugate_norm_lt,
    `D1Bound5.signed_root_matrix_adjugate_upper,
    `D1Bound5.exists_signed_root_matrix_adjugate_upper]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    unless (axs.filter fun a => !allowed.contains a).isEmpty do
      throwError "Forbidden axioms for {n}: {axs}"
    logInfo m!"ADJUGATE_ROOT_AXIOMS {n}: {axs}"
  logInfo m!"ADJUGATE_ROOT_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.symmetric_zero_four_adjugate_norm_lt
#check @D1Bound5.signed_root_matrix_adjugate_upper
#check @D1Bound5.exists_signed_root_matrix_adjugate_upper
#print axioms D1Bound5.exists_signed_root_matrix_adjugate_upper
