import D1Bound5.SmallPairLightData43Left
import D1Bound5.SmallPairLightData43Right
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 128 through 139, each checked against its complete tail. -/
theorem right_prefix_001_part03_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
      (PairLightPrepared43.rightCached.drop 128)
      (PairLightPrepared43.rightRows.drop 128) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared43
