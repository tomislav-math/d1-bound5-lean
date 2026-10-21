import D1Bound5.RationalTripleExclusion
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open scoped NumberField
open Module
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let name := `D1Bound5.IsD1Tuple.not_rational_one_three_eight
  let ax ← Lean.collectAxioms name
  let bad := ax.filter fun n =>
    !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
  unless bad.isEmpty do
    Lean.throwError "Unexpected axioms in {name}: {bad}"
  Lean.logInfo m!"RATIONAL_TRIPLE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
{K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (sgn : Bool)
    (h0 : a 0 = if sgn then -1 else 1)
    (h1 : a 1 = if sgn then -3 else 3)
    (h2 : a 2 = if sgn then -8 else 8) : False :=
  IsD1Tuple.not_rational_one_three_eight hK phi a ha hmon sgn h0 h1 h2

end D1Bound5

#check @_root_.D1Bound5.IsD1Tuple.not_rational_one_three_eight
