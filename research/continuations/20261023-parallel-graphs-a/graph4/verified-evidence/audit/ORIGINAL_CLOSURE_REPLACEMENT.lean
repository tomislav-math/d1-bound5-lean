import D1Bound5.SmallPairPureClosureAdapter4
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared4

theorem PairGraphPrepared4.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_4 smallPairB_4 anchorRoot
      (10^1100) smallPairClosure_4 witnesses destinations = true := by
  exact PairLightClosurePrepared4.original_indexed_checked

theorem smallPairClosure_4_checked :
    pairClosureBool smallPairA_4 smallPairB_4
      (10^1100) smallPairClosure_4 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_4 smallPairB_4 anchorRoot
    (10^1100) smallPairClosure_4 witnesses destinations PairGraphPrepared4.indexed_checked

end D1Bound5
