import D1Bound5.ScaledRootRankOneBound
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit all six new rank-one bound theorems, including the precise
hypotheses in their elaborated types and the transitive axiom closure. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.bilinear_mulVec_norm_le,
    `D1Bound5.rankOneDeterminant,
    `D1Bound5.adjugate_eq_det_smul_inverse,
    `D1Bound5.rankOneDeterminant_norm_le,
    `D1Bound5.rankOneDeterminant_adjugate_norm_le,
    `D1Bound5.scaledRootMatrix_det_adjugate_norm_le]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"RANK_ONE_AXIOM_AUDIT {n}: {axioms}"
  logInfo m!"RANK_ONE_AXIOM_AUDIT_PASS: {names.length} declarations"

#check @D1Bound5.bilinear_mulVec_norm_le
#check @D1Bound5.rankOneDeterminant
#check @D1Bound5.adjugate_eq_det_smul_inverse
#check @D1Bound5.rankOneDeterminant_norm_le
#check @D1Bound5.rankOneDeterminant_adjugate_norm_le
#check @D1Bound5.scaledRootMatrix_det_adjugate_norm_le
#print axioms D1Bound5.rankOneDeterminant_adjugate_norm_le
#print axioms D1Bound5.scaledRootMatrix_det_adjugate_norm_le
