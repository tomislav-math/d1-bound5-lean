import D1Bound5.SmallPairPureClosureAdapter30
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared30

theorem PairGraphPrepared30.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_30 smallPairB_30 anchorRoot
      (10^1100) smallPairClosure_30 witnesses destinations = true := by
  exact PairLightClosurePrepared30.original_indexed_checked

theorem smallPairClosure_30_checked :
    pairClosureBool smallPairA_30 smallPairB_30
      (10^1100) smallPairClosure_30 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_30 smallPairB_30 anchorRoot
    (10^1100) smallPairClosure_30 witnesses destinations PairGraphPrepared30.indexed_checked

end D1Bound5
