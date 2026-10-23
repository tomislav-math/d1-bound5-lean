import D1Bound5.SmallPairGraphInputs24
import D1Bound5.SmallPairGraphWitnessData24
import D1Bound5.SmallPairGraphClosure24Chunk00
import D1Bound5.SmallPairGraphClosure24Coverage
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairA_24
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairB_24
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairClosure_24
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairLarge_24
end D1Bound5
namespace D1Bound5.PairGraphPrepared24
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example :
    pairIndexedWitnessesPrefixBool smallPairA_24 smallPairB_24 anchorRoot
      (10^1100) smallPairClosure_24 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared24
namespace D1Bound5.PairGraphPrepared24

example :
    decide (anchorRoot * anchorRoot = smallPairA_24 * smallPairB_24 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_24) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared24
run_cmd do
  for name in ([`D1Bound5.smallPairA_24, `D1Bound5.smallPairB_24, `D1Bound5.smallPairClosure_24, `D1Bound5.smallPairLarge_24, `D1Bound5.PairGraphPrepared24.colors, `D1Bound5.PairGraphPrepared24.anchorRoot, `D1Bound5.PairGraphPrepared24.rootPairs, `D1Bound5.PairGraphPrepared24.witnesses, `D1Bound5.PairGraphPrepared24.destinations, `D1Bound5.PairGraphPrepared24.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared24.indexed_coverage_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
