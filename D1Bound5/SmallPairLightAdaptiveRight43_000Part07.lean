import D1Bound5.SmallPairLightData43Left
import D1Bound5.SmallPairLightData43Right
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 91, each checked against its complete tail. -/
theorem right_prefix_000_part07_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 8
      (PairLightPrepared43.rightCached.drop 84)
      (PairLightPrepared43.rightRows.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared43
