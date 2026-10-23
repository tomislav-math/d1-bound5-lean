import D1Bound5.SmallPairLightData7Sieve
import D1Bound5.SmallPairLightData7RightVertices
import D1Bound5.SmallPairLightData7RightCached
import D1Bound5.SmallPairLightData7RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 202 through 225, each checked against its complete tail. -/
theorem right_prefix_001_part04_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
      (PairLightPrepared7.rightCached.drop 202)
      (PairLightPrepared7.rightRows.drop 202) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared7
