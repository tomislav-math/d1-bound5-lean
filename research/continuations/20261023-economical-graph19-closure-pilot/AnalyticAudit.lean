import D1Bound5.SmallPairGraphInputs19
import D1Bound5.SmallPairGraphWitnessData19
import D1Bound5.SmallPairGraphClosure19Chunk00
import D1Bound5.SmallPairGraphClosure19Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairA_19
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairB_19
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairClosure_19
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairLarge_19
end D1Bound5
namespace D1Bound5.PairGraphPrepared19
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example :
    decide (anchorRoot * anchorRoot = smallPairA_19 * smallPairB_19 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_19) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared19
run_cmd do
  for name in ([`D1Bound5.smallPairA_19, `D1Bound5.smallPairB_19, `D1Bound5.smallPairClosure_19, `D1Bound5.smallPairLarge_19, `D1Bound5.PairGraphPrepared19.colors, `D1Bound5.PairGraphPrepared19.anchorRoot, `D1Bound5.PairGraphPrepared19.rootPairs, `D1Bound5.PairGraphPrepared19.witnesses, `D1Bound5.PairGraphPrepared19.destinations, `D1Bound5.PairGraphPrepared19.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared19.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
