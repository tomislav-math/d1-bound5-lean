import D1Bound5.SmallPairGraphWitnessData11
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared11

theorem PairGraphPrepared11.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_11_checked :
    pairClosureBool smallPairA_11 smallPairB_11
      (10^1100) smallPairClosure_11 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_11 smallPairB_11 anchorRoot
    (10^1100) smallPairClosure_11 witnesses destinations PairGraphPrepared11.indexed_checked

end D1Bound5
