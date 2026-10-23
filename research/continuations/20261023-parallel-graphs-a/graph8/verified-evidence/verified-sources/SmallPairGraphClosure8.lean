import D1Bound5.SmallPairPureClosureAdapter8
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared8

theorem PairGraphPrepared8.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_8 smallPairB_8 anchorRoot
      (10^1100) smallPairClosure_8 witnesses destinations = true := by
  exact PairLightClosurePrepared8.original_indexed_checked

theorem smallPairClosure_8_checked :
    pairClosureBool smallPairA_8 smallPairB_8
      (10^1100) smallPairClosure_8 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_8 smallPairB_8 anchorRoot
    (10^1100) smallPairClosure_8 witnesses destinations PairGraphPrepared8.indexed_checked

end D1Bound5
