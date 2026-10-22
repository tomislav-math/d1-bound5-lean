import D1Bound5.SmallPairGraphInputs3
import D1Bound5.SmallPairGraphWitnessData3
import D1Bound5.SmallPairGraphClosure3Chunk00
import D1Bound5.SmallPairGraphClosure3Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairA_3
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairB_3
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairClosure_3
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairLarge_3
end D1Bound5
namespace D1Bound5.PairGraphPrepared3
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example : QuadInt 0 1 := anchorRoot
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example : List (QuadInt 0 1 × QuadInt 0 1) := rootPairs
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example : List (PairRootWitness 0 1) := witnesses
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example :
    decide (anchorRoot * anchorRoot = smallPairA_3 * smallPairB_3 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_3) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared3
run_cmd do
  for name in ([`D1Bound5.smallPairA_3, `D1Bound5.smallPairB_3, `D1Bound5.smallPairClosure_3, `D1Bound5.smallPairLarge_3, `D1Bound5.PairGraphPrepared3.colors, `D1Bound5.PairGraphPrepared3.anchorRoot, `D1Bound5.PairGraphPrepared3.rootPairs, `D1Bound5.PairGraphPrepared3.witnesses, `D1Bound5.PairGraphPrepared3.destinations, `D1Bound5.PairGraphPrepared3.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared3.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
