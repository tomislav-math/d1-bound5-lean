import D1Bound5.SmallPairGraphWitnessData48
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared48
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem indexed_coverage_checked :
    decide (anchorRoot * anchorRoot = smallPairA_48 * smallPairB_48 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_48) = true := by
  decide +kernel

end D1Bound5.PairGraphPrepared48
