import D1Bound5.SmallPairGraphInputs43
import D1Bound5.SmallPairGraphWitnessData43
import D1Bound5.SmallPairGraphClosure43Chunk00
import D1Bound5.SmallPairGraphClosure43Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 1 3 := smallPairA_43
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 1 3 := smallPairB_43
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 3) := smallPairClosure_43
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 3) := smallPairLarge_43
end D1Bound5
namespace D1Bound5.PairGraphPrepared43
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example : QuadInt 1 3 := anchorRoot
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example : List (QuadInt 1 3 × QuadInt 1 3) := rootPairs
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example : List (PairRootWitness 1 3) := witnesses
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example :
    pairIndexedWitnessesPrefixBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example :
    decide (anchorRoot * anchorRoot = smallPairA_43 * smallPairB_43 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_43) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared43
run_cmd do
  for name in ([`D1Bound5.smallPairA_43, `D1Bound5.smallPairB_43, `D1Bound5.smallPairClosure_43, `D1Bound5.smallPairLarge_43, `D1Bound5.PairGraphPrepared43.colors, `D1Bound5.PairGraphPrepared43.anchorRoot, `D1Bound5.PairGraphPrepared43.rootPairs, `D1Bound5.PairGraphPrepared43.witnesses, `D1Bound5.PairGraphPrepared43.destinations, `D1Bound5.PairGraphPrepared43.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared43.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
