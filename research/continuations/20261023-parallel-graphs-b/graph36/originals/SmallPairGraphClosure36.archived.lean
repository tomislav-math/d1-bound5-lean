import D1Bound5.SmallPairGraphWitnessData36
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared36

theorem PairGraphPrepared36.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_36 smallPairB_36 anchorRoot
      (10^1100) smallPairClosure_36 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_36_checked :
    pairClosureBool smallPairA_36 smallPairB_36
      (10^1100) smallPairClosure_36 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_36 smallPairB_36 anchorRoot
    (10^1100) smallPairClosure_36 witnesses destinations PairGraphPrepared36.indexed_checked

end D1Bound5
