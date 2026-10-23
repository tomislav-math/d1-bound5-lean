import D1Bound5.SmallPairGraphWitnessData15
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared15

theorem PairGraphPrepared15.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_15 smallPairB_15 anchorRoot
      (10^1100) smallPairClosure_15 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_15_checked :
    pairClosureBool smallPairA_15 smallPairB_15
      (10^1100) smallPairClosure_15 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_15 smallPairB_15 anchorRoot
    (10^1100) smallPairClosure_15 witnesses destinations PairGraphPrepared15.indexed_checked

end D1Bound5
