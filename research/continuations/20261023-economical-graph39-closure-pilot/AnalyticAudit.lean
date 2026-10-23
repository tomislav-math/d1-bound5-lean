import D1Bound5.SmallPairGraphInputs39
import D1Bound5.SmallPairGraphWitnessData39
import D1Bound5.SmallPairGraphClosure39Chunk00
import D1Bound5.SmallPairGraphClosure39Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairA_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairB_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairClosure_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairLarge_39
end D1Bound5
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example : QuadInt 1 2 := anchorRoot
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example : List (QuadInt 1 2 × QuadInt 1 2) := rootPairs
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example : List (PairRootWitness 1 2) := witnesses
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    decide (anchorRoot * anchorRoot = smallPairA_39 * smallPairB_39 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_39) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared39
run_cmd do
  for name in ([`D1Bound5.smallPairA_39, `D1Bound5.smallPairB_39, `D1Bound5.smallPairClosure_39, `D1Bound5.smallPairLarge_39, `D1Bound5.PairGraphPrepared39.colors, `D1Bound5.PairGraphPrepared39.anchorRoot, `D1Bound5.PairGraphPrepared39.rootPairs, `D1Bound5.PairGraphPrepared39.witnesses, `D1Bound5.PairGraphPrepared39.destinations, `D1Bound5.PairGraphPrepared39.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared39.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
