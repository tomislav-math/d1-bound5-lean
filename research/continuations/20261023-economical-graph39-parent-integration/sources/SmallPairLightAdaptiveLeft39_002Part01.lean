import D1Bound5.SmallPairLightData39Sieve
import D1Bound5.SmallPairLightData39LeftVertices
import D1Bound5.SmallPairLightData39LeftCached
import D1Bound5.SmallPairLightData39LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 257 through 280, each checked against its complete tail. -/
theorem left_prefix_002_part01_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
      (PairLightPrepared39.leftCached.drop 257)
      (PairLightPrepared39.leftRows.drop 257) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared39
