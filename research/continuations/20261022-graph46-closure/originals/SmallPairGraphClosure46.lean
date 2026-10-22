import D1Bound5.SmallPairGraphWitnessData46
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared46

theorem PairGraphPrepared46.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_46_checked :
    pairClosureBool smallPairA_46 smallPairB_46
      (10^1100) smallPairClosure_46 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_46 smallPairB_46 anchorRoot
    (10^1100) smallPairClosure_46 witnesses destinations PairGraphPrepared46.indexed_checked

end D1Bound5
