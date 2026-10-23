import D1Bound5.SmallPairGraphClosure5Chunk09
import D1Bound5.SmallPairGraphClosure5Chunk10
import D1Bound5.SmallPairGraphClosure5Chunk11
import D1Bound5.SmallPairGraphClosure5Chunk12
import D1Bound5.SmallPairGraphClosure5Chunk13
import D1Bound5.SmallPairGraphClosure5
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 64
      (witnesses.drop 576) (destinations.drop 576) = true := indexed_chunk09_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 64
      (witnesses.drop 640) (destinations.drop 640) = true := indexed_chunk10_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 64
      (witnesses.drop 704) (destinations.drop 704) = true := indexed_chunk11_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 64
      (witnesses.drop 768) (destinations.drop 768) = true := indexed_chunk12_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5.PairGraphPrepared5

example :
    pairIndexedWitnessesPrefixBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 31
      (witnesses.drop 832) (destinations.drop 832) = true := indexed_chunk13_checked
end D1Bound5.PairGraphPrepared5
namespace D1Bound5
open PairGraphPrepared5
example :
    pairClosureIndexedWitnessBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 witnesses destinations = true := PairGraphPrepared5.indexed_checked
end D1Bound5
namespace D1Bound5
open PairGraphPrepared5
example :
    pairClosureBool smallPairA_5 smallPairB_5
      (10^1100) smallPairClosure_5 = true := smallPairClosure_5_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared5.indexed_chunk09_checked, `D1Bound5.PairGraphPrepared5.indexed_chunk10_checked, `D1Bound5.PairGraphPrepared5.indexed_chunk11_checked, `D1Bound5.PairGraphPrepared5.indexed_chunk12_checked, `D1Bound5.PairGraphPrepared5.indexed_chunk13_checked, `D1Bound5.PairGraphPrepared5.indexed_checked, `D1Bound5.smallPairClosure_5_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
