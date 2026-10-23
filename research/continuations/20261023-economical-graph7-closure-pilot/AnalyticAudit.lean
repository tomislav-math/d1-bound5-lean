import D1Bound5.SmallPairGraphInputs7
import D1Bound5.SmallPairGraphWitnessData7
import D1Bound5.SmallPairGraphClosure7Chunk00
import D1Bound5.SmallPairGraphClosure7Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairA_7
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 0 1 := smallPairB_7
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairClosure_7
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 0 1) := smallPairLarge_7
end D1Bound5
namespace D1Bound5.PairGraphPrepared7
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example : QuadInt 0 1 := anchorRoot
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example : List (QuadInt 0 1 × QuadInt 0 1) := rootPairs
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example : List (PairRootWitness 0 1) := witnesses
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example :
    decide (anchorRoot * anchorRoot = smallPairA_7 * smallPairB_7 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_7) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared7
run_cmd do
  for name in ([`D1Bound5.smallPairA_7, `D1Bound5.smallPairB_7, `D1Bound5.smallPairClosure_7, `D1Bound5.smallPairLarge_7, `D1Bound5.PairGraphPrepared7.colors, `D1Bound5.PairGraphPrepared7.anchorRoot, `D1Bound5.PairGraphPrepared7.rootPairs, `D1Bound5.PairGraphPrepared7.witnesses, `D1Bound5.PairGraphPrepared7.destinations, `D1Bound5.PairGraphPrepared7.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared7.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
