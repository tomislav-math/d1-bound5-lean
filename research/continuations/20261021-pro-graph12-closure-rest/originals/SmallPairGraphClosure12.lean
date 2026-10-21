import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared12

theorem PairGraphPrepared12.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_12_checked :
    pairClosureBool smallPairA_12 smallPairB_12
      (10^1100) smallPairClosure_12 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_12 smallPairB_12 anchorRoot
    (10^1100) smallPairClosure_12 witnesses destinations PairGraphPrepared12.indexed_checked

end D1Bound5
