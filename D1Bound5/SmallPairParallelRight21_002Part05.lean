import D1Bound5.SmallPairLightData21Sieve
import D1Bound5.SmallPairLightData21RightCached
import D1Bound5.SmallPairLightData21RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 244 through 255, with every original tail comparison. -/
theorem right_parallel_002_part05_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 12
      (PairLightPrepared21.rightCached.drop 244) (PairLightPrepared21.rightRows.drop 244) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
