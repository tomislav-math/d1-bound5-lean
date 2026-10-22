import D1Bound5.SmallPairGraphClosure43Chunk13
import D1Bound5.SmallPairGraphClosure43Chunk14
import D1Bound5.SmallPairGraphClosure43Chunk15
import D1Bound5.SmallPairGraphClosure43
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared43

example :
    pairIndexedWitnessesPrefixBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 64
      (witnesses.drop 832) (destinations.drop 832) = true := indexed_chunk13_checked
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example :
    pairIndexedWitnessesPrefixBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 64
      (witnesses.drop 896) (destinations.drop 896) = true := indexed_chunk14_checked
end D1Bound5.PairGraphPrepared43
namespace D1Bound5.PairGraphPrepared43

example :
    pairIndexedWitnessesPrefixBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 3
      (witnesses.drop 960) (destinations.drop 960) = true := indexed_chunk15_checked
end D1Bound5.PairGraphPrepared43
namespace D1Bound5
open PairGraphPrepared43
example :
    pairClosureIndexedWitnessBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 witnesses destinations = true := PairGraphPrepared43.indexed_checked
end D1Bound5
namespace D1Bound5
open PairGraphPrepared43
example :
    pairClosureBool smallPairA_43 smallPairB_43
      (10^1100) smallPairClosure_43 = true := smallPairClosure_43_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared43.indexed_chunk13_checked, `D1Bound5.PairGraphPrepared43.indexed_chunk14_checked, `D1Bound5.PairGraphPrepared43.indexed_chunk15_checked, `D1Bound5.PairGraphPrepared43.indexed_checked, `D1Bound5.smallPairClosure_43_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
