import D1Bound5.MixedSignedRootAdjugate
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the exact elaborated types and all transitive axioms of the
independent-radius mixed adjugate proof chain. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.mixed_triple_cofactor_radius,
    `D1Bound5.mixed_triple_later,
    `D1Bound5.mixed_triple_first_first_later,
    `D1Bound5.mixed_offDiagonal_cofactor_radius,
    `D1Bound5.mixed_offDiagonal_first,
    `D1Bound5.mixed_offDiagonal_later,
    `D1Bound5.mixedAdjEnvelope_nonneg,
    `D1Bound5.mixedAdjEnvelope_symmetric,
    `D1Bound5.mixedAdjEnvelope_rows,
    `D1Bound5.mixedFour_adjugate_norm_of_entries,
    `D1Bound5.mixedSymmetricFour_adjugate_norm_lt,
    `D1Bound5.mixed_zero_four_adjugate_norm_lt,
    `D1Bound5.mixed_signed_root_adjugate_upper,
    `D1Bound5.mixed_signed_root_det_and_adjugate_upper]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"MIXED_ADJ_AXIOMS {n}: {axs}"
  logInfo m!"MIXED_ADJ_AXIOMS_PASS: {names.length} theorems"

#print D1Bound5.mixed_zero_four_adjugate_norm_lt
#print D1Bound5.mixed_signed_root_det_and_adjugate_upper
