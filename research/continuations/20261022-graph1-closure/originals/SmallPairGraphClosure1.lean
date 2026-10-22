import D1Bound5.SmallPairGraphWitnessData1
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared1

theorem PairGraphPrepared1.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_1_checked :
    pairClosureBool smallPairA_1 smallPairB_1
      (10^1100) smallPairClosure_1 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_1 smallPairB_1 anchorRoot
    (10^1100) smallPairClosure_1 witnesses destinations PairGraphPrepared1.indexed_checked

end D1Bound5
