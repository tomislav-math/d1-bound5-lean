import D1Bound5.SmallPairLightData21Sieve
import D1Bound5.SmallPairLightData21RightCached
import D1Bound5.SmallPairLightData21RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 515 through 523, with every original tail comparison. -/
theorem right_parallel_003_part15_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 9
      (PairLightPrepared21.rightCached.drop 515) (PairLightPrepared21.rightRows.drop 515) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
