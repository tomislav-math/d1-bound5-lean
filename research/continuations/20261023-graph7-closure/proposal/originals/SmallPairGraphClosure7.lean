import D1Bound5.SmallPairGraphWitnessData7
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared7

theorem PairGraphPrepared7.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_7 smallPairB_7 anchorRoot
      (10^1100) smallPairClosure_7 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_7_checked :
    pairClosureBool smallPairA_7 smallPairB_7
      (10^1100) smallPairClosure_7 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_7 smallPairB_7 anchorRoot
    (10^1100) smallPairClosure_7 witnesses destinations PairGraphPrepared7.indexed_checked

end D1Bound5
