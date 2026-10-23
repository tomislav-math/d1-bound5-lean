import D1Bound5.SmallPairLightData5Sieve
import D1Bound5.SmallPairLightData5RightVertices
import D1Bound5.SmallPairLightData5RightCached
import D1Bound5.SmallPairLightData5RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 250 through 271, each checked against its complete tail. -/
theorem right_prefix_001_part06_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 22
      (PairLightPrepared5.rightCached.drop 250)
      (PairLightPrepared5.rightRows.drop 250) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared5
