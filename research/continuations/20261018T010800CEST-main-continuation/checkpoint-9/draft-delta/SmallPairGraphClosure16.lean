import D1Bound5.SmallPairGraphWitnessData16
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared16

theorem PairGraphPrepared16.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_16 smallPairB_16 anchorRoot
      (10^1100) smallPairClosure_16 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_16_checked :
    pairClosureBool smallPairA_16 smallPairB_16
      (10^1100) smallPairClosure_16 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_16 smallPairB_16 anchorRoot
    (10^1100) smallPairClosure_16 witnesses destinations PairGraphPrepared16.indexed_checked

end D1Bound5
