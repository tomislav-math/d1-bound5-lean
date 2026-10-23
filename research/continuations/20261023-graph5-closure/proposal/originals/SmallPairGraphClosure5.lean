import D1Bound5.SmallPairGraphWitnessData5
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared5

theorem PairGraphPrepared5.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_5 smallPairB_5 anchorRoot
      (10^1100) smallPairClosure_5 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_5_checked :
    pairClosureBool smallPairA_5 smallPairB_5
      (10^1100) smallPairClosure_5 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_5 smallPairB_5 anchorRoot
    (10^1100) smallPairClosure_5 witnesses destinations PairGraphPrepared5.indexed_checked

end D1Bound5
