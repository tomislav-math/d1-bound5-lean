import D1Bound5.SmallPairGraphWitnessData28
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared28

theorem PairGraphPrepared28.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_28 smallPairB_28 anchorRoot
      (10^1100) smallPairClosure_28 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_28_checked :
    pairClosureBool smallPairA_28 smallPairB_28
      (10^1100) smallPairClosure_28 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_28 smallPairB_28 anchorRoot
    (10^1100) smallPairClosure_28 witnesses destinations PairGraphPrepared28.indexed_checked

end D1Bound5
