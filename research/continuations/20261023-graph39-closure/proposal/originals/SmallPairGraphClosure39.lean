import D1Bound5.SmallPairGraphWitnessData39
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared39

theorem PairGraphPrepared39.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_39_checked :
    pairClosureBool smallPairA_39 smallPairB_39
      (10^1100) smallPairClosure_39 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_39 smallPairB_39 anchorRoot
    (10^1100) smallPairClosure_39 witnesses destinations PairGraphPrepared39.indexed_checked

end D1Bound5
