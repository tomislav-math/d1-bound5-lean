import D1Bound5.SmallPairGraphClosure3Chunk09
import D1Bound5.SmallPairGraphClosure3Chunk10
import D1Bound5.SmallPairGraphClosure3Chunk11
import D1Bound5.SmallPairGraphClosure3Chunk12
import D1Bound5.SmallPairGraphClosure3
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared3

example :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 576) (destinations.drop 576) = true := indexed_chunk09_checked
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 640) (destinations.drop 640) = true := indexed_chunk10_checked
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 64
      (witnesses.drop 704) (destinations.drop 704) = true := indexed_chunk11_checked
end D1Bound5.PairGraphPrepared3
namespace D1Bound5.PairGraphPrepared3

example :
    pairIndexedWitnessesPrefixBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 61
      (witnesses.drop 768) (destinations.drop 768) = true := indexed_chunk12_checked
end D1Bound5.PairGraphPrepared3
namespace D1Bound5
open PairGraphPrepared3
example :
    pairClosureIndexedWitnessBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 witnesses destinations = true := PairGraphPrepared3.indexed_checked
end D1Bound5
namespace D1Bound5
open PairGraphPrepared3
example :
    pairClosureBool smallPairA_3 smallPairB_3
      (10^1100) smallPairClosure_3 = true := smallPairClosure_3_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared3.indexed_chunk09_checked, `D1Bound5.PairGraphPrepared3.indexed_chunk10_checked, `D1Bound5.PairGraphPrepared3.indexed_chunk11_checked, `D1Bound5.PairGraphPrepared3.indexed_chunk12_checked, `D1Bound5.PairGraphPrepared3.indexed_checked, `D1Bound5.smallPairClosure_3_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
