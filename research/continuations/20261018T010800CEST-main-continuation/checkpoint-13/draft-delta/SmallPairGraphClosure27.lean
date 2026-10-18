import D1Bound5.SmallPairGraphWitnessData27
import D1Bound5.PairClosureIndexedWitness

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

open PairGraphPrepared27

theorem PairGraphPrepared27.indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_27 smallPairB_27 anchorRoot
      (10^1100) smallPairClosure_27 witnesses destinations = true := by
  decide +kernel

theorem smallPairClosure_27_checked :
    pairClosureBool smallPairA_27 smallPairB_27
      (10^1100) smallPairClosure_27 = true :=
  pairClosureBool_of_indexed_witness_checked (by decide) smallPairA_27 smallPairB_27 anchorRoot
    (10^1100) smallPairClosure_27 witnesses destinations PairGraphPrepared27.indexed_checked

end D1Bound5
