import D1Bound5.SmallPairGraphWitnessData31
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared31

theorem PairGraphPrepared31.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_31 smallPairB_31 anchorRoot
      (10^1100) smallPairClosure_31 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_31_checked :
    pairClosureBool smallPairA_31 smallPairB_31
      (10^1100) smallPairClosure_31 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_31 smallPairB_31 anchorRoot
    (10^1100) smallPairClosure_31 witnesses destinations PairGraphPrepared31.indexed_checked

end D1Bound5
