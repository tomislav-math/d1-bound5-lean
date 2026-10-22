import D1Bound5.SmallPairLightData43Left
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 175 through 186, each checked against its complete tail. -/
theorem left_prefix_001_part07_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 12
      (PairLightPrepared43.leftCached.drop 175)
      (PairLightPrepared43.leftRows.drop 175) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared43
