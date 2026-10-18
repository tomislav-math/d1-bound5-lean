import D1Bound5.SmallPairGraphWitnessData22
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared22

theorem PairGraphPrepared22.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_22 smallPairB_22 anchorRoot
      (10^1100) smallPairClosure_22 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_22_checked :
    pairClosureBool smallPairA_22 smallPairB_22
      (10^1100) smallPairClosure_22 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_22 smallPairB_22 anchorRoot
    (10^1100) smallPairClosure_22 witnesses destinations PairGraphPrepared22.indexed_checked

end D1Bound5
