import D1Bound5.SmallPairGraphWitnessData24
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared24

theorem PairGraphPrepared24.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_24 smallPairB_24 anchorRoot
      (10^1100) smallPairClosure_24 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_24_checked :
    pairClosureBool smallPairA_24 smallPairB_24
      (10^1100) smallPairClosure_24 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_24 smallPairB_24 anchorRoot
    (10^1100) smallPairClosure_24 witnesses destinations PairGraphPrepared24.indexed_checked

end D1Bound5
