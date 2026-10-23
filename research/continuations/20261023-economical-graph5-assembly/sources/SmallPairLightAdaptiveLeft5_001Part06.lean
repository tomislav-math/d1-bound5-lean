import D1Bound5.SmallPairLightData5Sieve
import D1Bound5.SmallPairLightData5LeftVertices
import D1Bound5.SmallPairLightData5LeftCached
import D1Bound5.SmallPairLightData5LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 249 through 268, each checked against its complete tail. -/
theorem left_prefix_001_part06_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 20
      (PairLightPrepared5.leftCached.drop 249)
      (PairLightPrepared5.leftRows.drop 249) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared5
