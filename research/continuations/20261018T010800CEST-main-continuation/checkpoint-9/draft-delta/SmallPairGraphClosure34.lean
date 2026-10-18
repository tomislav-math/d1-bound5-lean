import D1Bound5.SmallPairGraphWitnessData34
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared34

theorem PairGraphPrepared34.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_34 smallPairB_34 anchorRoot
      (10^1100) smallPairClosure_34 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_34_checked :
    pairClosureBool smallPairA_34 smallPairB_34
      (10^1100) smallPairClosure_34 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_34 smallPairB_34 anchorRoot
    (10^1100) smallPairClosure_34 witnesses destinations PairGraphPrepared34.indexed_checked

end D1Bound5
