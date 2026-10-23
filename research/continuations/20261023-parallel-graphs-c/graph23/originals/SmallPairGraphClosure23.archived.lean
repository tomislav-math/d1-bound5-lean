import D1Bound5.SmallPairGraphWitnessData23
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared23

theorem PairGraphPrepared23.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_23 smallPairB_23 anchorRoot
      (10^1100) smallPairClosure_23 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_23_checked :
    pairClosureBool smallPairA_23 smallPairB_23
      (10^1100) smallPairClosure_23 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_23 smallPairB_23 anchorRoot
    (10^1100) smallPairClosure_23 witnesses destinations PairGraphPrepared23.indexed_checked

end D1Bound5
