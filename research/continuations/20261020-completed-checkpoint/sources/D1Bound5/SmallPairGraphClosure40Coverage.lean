import D1Bound5.SmallPairGraphWitnessData40
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared40
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem indexed_coverage_checked :
    decide (anchorRoot * anchorRoot = smallPairA_40 * smallPairB_40 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_40) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared40
