import D1Bound5.SmallPairGraphWitnessData35
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared35

theorem PairGraphPrepared35.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_35_checked :
    pairClosureBool smallPairA_35 smallPairB_35
      (10^1100) smallPairClosure_35 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_35 smallPairB_35 anchorRoot
    (10^1100) smallPairClosure_35 witnesses destinations PairGraphPrepared35.indexed_checked

end D1Bound5
