import D1Bound5.SmallPairGraphWitnessData17
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared17

theorem PairGraphPrepared17.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_17_checked :
    pairClosureBool smallPairA_17 smallPairB_17
      (10^1100) smallPairClosure_17 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_17 smallPairB_17 anchorRoot
    (10^1100) smallPairClosure_17 witnesses destinations PairGraphPrepared17.indexed_checked

end D1Bound5
