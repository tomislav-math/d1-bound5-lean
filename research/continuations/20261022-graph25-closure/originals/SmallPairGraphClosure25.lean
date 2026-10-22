import D1Bound5.SmallPairGraphWitnessData25
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared25

theorem PairGraphPrepared25.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_25_checked :
    pairClosureBool smallPairA_25 smallPairB_25
      (10^1100) smallPairClosure_25 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_25 smallPairB_25 anchorRoot
    (10^1100) smallPairClosure_25 witnesses destinations PairGraphPrepared25.indexed_checked

end D1Bound5
