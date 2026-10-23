import D1Bound5.SmallPairGraphInputs5
import D1Bound5.SmallPairGraphWitnessData5
import D1Bound5.SmallPairGraphClosure5Chunk00
import D1Bound5.SmallPairGraphClosure5Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairA_5
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairB_5
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairClosure_5
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairLarge_5
end D1Bound5
namespace D1Bound5.PairGraphPrepared5
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example : QuadInt 0 1 := anchorRoot
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example : List (QuadInt 0 1 × QuadInt 0 1) := rootPairs
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example : List (PairRootWitness 0 1) := witnesses
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    decide (anchorRoot * anchorRoot = smallPairA_5 * smallPairB_5 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_5) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared5
run_cmd do
  for name in ([`D1Bound5.smallPairA_5, `D1Bound5.smallPairB_5, `D1Bound5.smallPairClosure_5, `D1Bound5.smallPairLarge_5, `D1Bound5.PairGraphPrepared5.colors, `D1Bound5.PairGraphPrepared5.anchorRoot, `D1Bound5.PairGraphPrepared5.rootPairs, `D1Bound5.PairGraphPrepared5.witnesses, `D1Bound5.PairGraphPrepared5.destinations, `D1Bound5.PairGraphPrepared5.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared5.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
