import D1Bound5.SmallPairPureClosureAdapter10
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared10

theorem PairGraphPrepared10.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_10 smallPairB_10 anchorRoot
      (10^1100) smallPairClosure_10 witnesses destinations = true := by
  exact PairLightClosurePrepared10.original_indexed_checked

theorem smallPairClosure_10_checked :
    pairClosureBool smallPairA_10 smallPairB_10
      (10^1100) smallPairClosure_10 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_10 smallPairB_10 anchorRoot
    (10^1100) smallPairClosure_10 witnesses destinations PairGraphPrepared10.indexed_checked

end D1Bound5
