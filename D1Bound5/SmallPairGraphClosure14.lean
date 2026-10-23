import D1Bound5.SmallPairPureClosureAdapter14
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared14

theorem PairGraphPrepared14.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_14 smallPairB_14 anchorRoot
      (10^1100) smallPairClosure_14 witnesses destinations = true := by
  exact PairLightClosurePrepared14.original_indexed_checked

theorem smallPairClosure_14_checked :
    pairClosureBool smallPairA_14 smallPairB_14
      (10^1100) smallPairClosure_14 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_14 smallPairB_14 anchorRoot
    (10^1100) smallPairClosure_14 witnesses destinations PairGraphPrepared14.indexed_checked

end D1Bound5
