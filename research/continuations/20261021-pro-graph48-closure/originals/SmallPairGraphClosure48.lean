import D1Bound5.SmallPairGraphWitnessData48
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared48

theorem PairGraphPrepared48.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_48_checked :
    pairClosureBool smallPairA_48 smallPairB_48
      (10^1100) smallPairClosure_48 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_48 smallPairB_48 anchorRoot
    (10^1100) smallPairClosure_48 witnesses destinations PairGraphPrepared48.indexed_checked

end D1Bound5
