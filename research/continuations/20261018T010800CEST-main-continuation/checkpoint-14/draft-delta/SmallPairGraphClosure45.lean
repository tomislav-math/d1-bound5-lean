import D1Bound5.SmallPairGraphWitnessData45
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared45

theorem PairGraphPrepared45.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_45 smallPairB_45 anchorRoot
      (10^1100) smallPairClosure_45 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_45_checked :
    pairClosureBool smallPairA_45 smallPairB_45
      (10^1100) smallPairClosure_45 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_45 smallPairB_45 anchorRoot
    (10^1100) smallPairClosure_45 witnesses destinations PairGraphPrepared45.indexed_checked

end D1Bound5
