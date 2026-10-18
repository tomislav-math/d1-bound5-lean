import D1Bound5.SmallPairGraphWitnessData37
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared37

theorem PairGraphPrepared37.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_37 smallPairB_37 anchorRoot
      (10^1100) smallPairClosure_37 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_37_checked :
    pairClosureBool smallPairA_37 smallPairB_37
      (10^1100) smallPairClosure_37 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_37 smallPairB_37 anchorRoot
    (10^1100) smallPairClosure_37 witnesses destinations PairGraphPrepared37.indexed_checked

end D1Bound5
