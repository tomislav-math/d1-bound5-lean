import D1Bound5.SmallPairLightData5Sieve
import D1Bound5.SmallPairLightData5RightVertices
import D1Bound5.SmallPairLightData5RightCached
import D1Bound5.SmallPairLightData5RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 106 through 129, each checked against its complete tail. -/
theorem right_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 24
      (PairLightPrepared5.rightCached.drop 106)
      (PairLightPrepared5.rightRows.drop 106) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared5
