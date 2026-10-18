import D1Bound5.SmallPairGraphWitnessData47
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared47

theorem PairGraphPrepared47.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_47 smallPairB_47 anchorRoot
      (10^1100) smallPairClosure_47 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_47_checked :
    pairClosureBool smallPairA_47 smallPairB_47
      (10^1100) smallPairClosure_47 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_47 smallPairB_47 anchorRoot
    (10^1100) smallPairClosure_47 witnesses destinations PairGraphPrepared47.indexed_checked

end D1Bound5
