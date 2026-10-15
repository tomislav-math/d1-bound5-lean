import D1Bound5
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit all exported project declarations, including definitions and generated
helper declarations. The whitelist contains only the usual Lean foundations. -/
run_cmd do
  let env ← getEnv
  let names := env.constants.toList.filterMap fun (n, _) =>
    if (`D1Bound5).isPrefixOf n then some n else none
  if names.isEmpty then
    throwError "No D1Bound5 declarations were found"
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axiom dependencies for {n}: {forbidden}"
    logInfo m!"AUDIT {n}: {axioms}"
  logInfo m!"AXIOM_AUDIT_PASS: {names.length} project declarations"

#print axioms D1Bound5.square_integers_iff_field
#print axioms D1Bound5.card_bound_iff_no_ordered_sextuple
#print axioms D1Bound5.extension_product
#print axioms D1Bound5.QuadInt.discriminant_le_four_bound
#print axioms D1Bound5.mutate_reverse
#print axioms D1Bound5.not_square_of_residues
#print axioms D1Bound5.small_tail_q2_first
#print axioms D1Bound5.small_tail_q2_second
#print axioms D1Bound5.small_tail_q3
#print axioms D1Bound5.small_tail_q6
#print axioms D1Bound5.small_tail_q11
#print axioms D1Bound5.small_tail_q35
#print axioms D1Bound5.geometric_forbidden_interval_chain
#print axioms D1Bound5.QuadInt.three_le_discriminant
#print axioms D1Bound5.one_three_integer_obstruction
#print axioms D1Bound5.one_three_common_extension_is_integer
#print axioms D1Bound5.zero_square_pair
#print axioms D1Bound5.half_integral_basis_square

-- The main theorem is recorded as a proposition, not asserted as a theorem.
#print D1Bound5.MainStatement
#print D1Bound5.IsD1
#print D1Bound5.IsD1Tuple

#print axioms D1Bound5.exists_full_integer_coordinates
#check @D1Bound5.exists_full_integer_coordinates

#print axioms D1Bound5.norm_sq_eq_absolute_norm
#check @D1Bound5.norm_sq_eq_absolute_norm

#print axioms D1Bound5.full_ring_one_three_common_extension_is_integer
#check @D1Bound5.full_ring_one_three_common_extension_is_integer

#print axioms D1Bound5.irregular_quadratic
#check @D1Bound5.irregular_quadratic

#print axioms D1Bound5.irregular_growth
#check @D1Bound5.irregular_growth
