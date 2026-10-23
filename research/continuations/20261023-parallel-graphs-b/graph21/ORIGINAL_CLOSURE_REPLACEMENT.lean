import D1Bound5.SmallPairPureClosureAdapter21
namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared21

theorem PairGraphPrepared21.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_21 smallPairB_21 anchorRoot
      (10^1100) smallPairClosure_21 witnesses destinations = true := by
  exact PairLightClosurePrepared21.original_indexed_checked

theorem smallPairClosure_21_checked :
    pairClosureBool smallPairA_21 smallPairB_21
      (10^1100) smallPairClosure_21 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_21 smallPairB_21 anchorRoot
    (10^1100) smallPairClosure_21 witnesses destinations PairGraphPrepared21.indexed_checked

end D1Bound5
