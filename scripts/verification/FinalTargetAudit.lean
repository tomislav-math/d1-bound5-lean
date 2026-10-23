import D1Bound5.MainTheorem
import Lean.Util.CollectAxioms
import Lean.Elab.Command

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
