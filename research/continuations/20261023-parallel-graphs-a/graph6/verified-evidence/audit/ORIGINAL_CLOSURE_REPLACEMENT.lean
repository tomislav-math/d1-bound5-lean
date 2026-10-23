import D1Bound5.SmallPairPureClosureAdapter6
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared6

theorem PairGraphPrepared6.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_6 smallPairB_6 anchorRoot
      (10^1100) smallPairClosure_6 witnesses destinations = true := by
  exact PairLightClosurePrepared6.original_indexed_checked

theorem smallPairClosure_6_checked :
    pairClosureBool smallPairA_6 smallPairB_6
      (10^1100) smallPairClosure_6 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_6 smallPairB_6 anchorRoot
    (10^1100) smallPairClosure_6 witnesses destinations PairGraphPrepared6.indexed_checked

end D1Bound5
