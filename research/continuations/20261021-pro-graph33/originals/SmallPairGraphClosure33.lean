import D1Bound5.SmallPairGraphWitnessData33
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared33

theorem PairGraphPrepared33.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_33 smallPairB_33 anchorRoot
      (10^1100) smallPairClosure_33 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_33_checked :
    pairClosureBool smallPairA_33 smallPairB_33
      (10^1100) smallPairClosure_33 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_33 smallPairB_33 anchorRoot
    (10^1100) smallPairClosure_33 witnesses destinations PairGraphPrepared33.indexed_checked

end D1Bound5
