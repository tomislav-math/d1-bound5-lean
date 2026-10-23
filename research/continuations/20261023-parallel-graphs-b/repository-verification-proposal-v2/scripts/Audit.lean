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

-- Preserve the historical target-definition inspection alongside the theorem checks below.
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

#print axioms D1Bound5.QuadInt.hasSquareRoot_iff
#check @D1Bound5.QuadInt.hasSquareRoot_iff

#print axioms D1Bound5.QuadInt.mem_disk_iff
#check @D1Bound5.QuadInt.mem_disk_iff

#print axioms D1Bound5.smallTailCheck_of_explicit_list
#check @D1Bound5.smallTailCheck_of_explicit_list

#print axioms D1Bound5.smallTailCheck_rectangular
#check @D1Bound5.smallTailCheck_rectangular

#print axioms D1Bound5.IsD1Tuple.tail_irregular_and_growth
#check @D1Bound5.IsD1Tuple.tail_irregular_and_growth

#print axioms D1Bound5.even_root_matrix_det_sq_char_two
#check @D1Bound5.even_root_matrix_det_sq_char_two

#print axioms D1Bound5.even_root_matrix_det_ne_zero
#check @D1Bound5.even_root_matrix_det_ne_zero

#print axioms D1Bound5.even_root_matrix_one_le_norm
#check @D1Bound5.even_root_matrix_one_le_norm

/- The historical broad audit and diagnostic commands above are retained.
The following release checks additionally cover the exact theorem and private
project declarations. This optional compatibility gate has its own result. -/

open scoped NumberField
universe u
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Independent explicit back-translation of the target definition. -/
example : D1Bound5.MainStatement.{u} =
    (∀ (K : Type u) [Field K] [NumberField K] [NumberField.IsTotallyComplex K],
      Module.finrank ℚ K = 2 → ∀ A : Finset (𝓞 K),
      ((∀ x ∈ A, x ≠ 0) ∧
        ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∃ r : 𝓞 K, r * r = x * y + 1) →
      A.card ≤ 5) := by
  rfl

/-- No estimate, classification, coordinate-model or certificate premise is added. -/
example (K : Type u) [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : Module.finrank ℚ K = 2) (A : Finset (𝓞 K))
    (hnonzero : ∀ x ∈ A, x ≠ 0)
    (hsquares : ∀ x ∈ A, ∀ y ∈ A, x ≠ y → ∃ r : 𝓞 K, r * r = x * y + 1) :
    A.card ≤ 5 := by
  exact D1Bound5.main_statement K hK A ⟨hnonzero, hsquares⟩

run_cmd do
  for name in ([`D1Bound5.MainStatement, `D1Bound5.IsD1,
      `D1Bound5.IsD1Tuple, `D1Bound5.main_statement] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n =>
      !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"FINAL_TARGET_AXIOMS_PASS {name}: {ax}"

/-- Optional broad compatibility audit. This is distinct from the 114-declaration
release audit and the four independent target checks above. -/
run_cmd do
  let env ← Lean.getEnv
  let names := env.constants.toList.filterMap fun (n, _) =>
    if (`D1Bound5).isPrefixOf n || (`_private.D1Bound5).isPrefixOf n then some n else none
  if names.isEmpty then Lean.throwError "No project declarations found"
  let allowed : List Lean.Name := [`propext, `Classical.choice, `Quot.sound]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !allowed.contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
  Lean.logInfo m!"BROAD_PROJECT_AXIOM_AUDIT_PASS {names.length} declarations"
