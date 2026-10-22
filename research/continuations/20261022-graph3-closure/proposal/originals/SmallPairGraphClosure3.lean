import D1Bound5.SmallPairGraphWitnessData3
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared3

theorem PairGraphPrepared3.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_3 smallPairB_3 anchorRoot
      (10^1100) smallPairClosure_3 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_3_checked :
    pairClosureBool smallPairA_3 smallPairB_3
      (10^1100) smallPairClosure_3 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_3 smallPairB_3 anchorRoot
    (10^1100) smallPairClosure_3 witnesses destinations PairGraphPrepared3.indexed_checked

end D1Bound5
