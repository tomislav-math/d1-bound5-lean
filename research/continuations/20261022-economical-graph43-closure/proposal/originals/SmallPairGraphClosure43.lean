import D1Bound5.SmallPairGraphWitnessData43
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared43

theorem PairGraphPrepared43.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_43 smallPairB_43 anchorRoot
      (10^1100) smallPairClosure_43 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_43_checked :
    pairClosureBool smallPairA_43 smallPairB_43
      (10^1100) smallPairClosure_43 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_43 smallPairB_43 anchorRoot
    (10^1100) smallPairClosure_43 witnesses destinations PairGraphPrepared43.indexed_checked

end D1Bound5
