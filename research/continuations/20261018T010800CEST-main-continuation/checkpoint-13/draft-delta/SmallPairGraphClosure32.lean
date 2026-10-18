import D1Bound5.SmallPairGraphWitnessData32
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared32

theorem PairGraphPrepared32.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_32 smallPairB_32 anchorRoot
      (10^1100) smallPairClosure_32 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_32_checked :
    pairClosureBool smallPairA_32 smallPairB_32
      (10^1100) smallPairClosure_32 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_32 smallPairB_32 anchorRoot
    (10^1100) smallPairClosure_32 witnesses destinations PairGraphPrepared32.indexed_checked

end D1Bound5
