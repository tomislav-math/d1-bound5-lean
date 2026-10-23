import D1Bound5.SmallPairGraphWitnessData26
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared26
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem indexed_coverage_checked :
    decide (anchorRoot * anchorRoot = smallPairA_26 * smallPairB_26 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_26) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared26
