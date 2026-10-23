import D1Bound5.SmallPairGraphClosure7Chunk05
import D1Bound5.SmallPairGraphClosure7Chunk06
import D1Bound5.SmallPairGraphClosure7Chunk07
import D1Bound5.SmallPairGraphClosure7Chunk08
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared7

example :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 320) (destinations.drop 320) = true := indexed_chunk05_checked
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 384) (destinations.drop 384) = true := indexed_chunk06_checked
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 448) (destinations.drop 448) = true := indexed_chunk07_checked
end D1Bound5.PairGraphPrepared7
namespace D1Bound5.PairGraphPrepared7

example :
    pairIndexedWitnessesPrefixBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 64
      (witnesses.drop 512) (destinations.drop 512) = true := indexed_chunk08_checked
end D1Bound5.PairGraphPrepared7
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared7.indexed_chunk05_checked, `D1Bound5.PairGraphPrepared7.indexed_chunk06_checked, `D1Bound5.PairGraphPrepared7.indexed_chunk07_checked, `D1Bound5.PairGraphPrepared7.indexed_chunk08_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
