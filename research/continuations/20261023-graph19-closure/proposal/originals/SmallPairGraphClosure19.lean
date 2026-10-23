import D1Bound5.SmallPairGraphWitnessData19
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared19

theorem PairGraphPrepared19.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_19_checked :
    pairClosureBool smallPairA_19 smallPairB_19
      (10^1100) smallPairClosure_19 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_19 smallPairB_19 anchorRoot
    (10^1100) smallPairClosure_19 witnesses destinations PairGraphPrepared19.indexed_checked

end D1Bound5
