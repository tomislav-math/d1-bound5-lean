import D1Bound5.SmallPairLightData3Left
import D1Bound5.SmallPairLightData3Right
import D1Bound5.SmallPairLightData3RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 303 through 305, each checked against its complete tail. -/
theorem right_prefix_001_part08_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 3
      (PairLightPrepared3.rightCached.drop 303)
      (PairLightPrepared3.rightRows.drop 303) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared3
