import D1Bound5.SmallPairLightData5Sieve
import D1Bound5.SmallPairLightData5LeftVertices
import D1Bound5.SmallPairLightData5LeftCached
import D1Bound5.SmallPairLightData5LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 413 through 430, each checked against its complete tail. -/
theorem left_prefix_002_part06_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 18
      (PairLightPrepared5.leftCached.drop 413)
      (PairLightPrepared5.leftRows.drop 413) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared5
