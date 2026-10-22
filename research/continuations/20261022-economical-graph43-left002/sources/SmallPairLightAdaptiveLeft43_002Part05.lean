import D1Bound5.SmallPairLightData43Left
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 332 through 355, each checked against its complete tail. -/
theorem left_prefix_002_part05_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 24
      (PairLightPrepared43.leftCached.drop 332)
      (PairLightPrepared43.leftRows.drop 332) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared43
