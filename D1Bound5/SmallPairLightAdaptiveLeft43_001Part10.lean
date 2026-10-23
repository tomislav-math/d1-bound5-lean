import D1Bound5.SmallPairLightData43Left
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 211 through 211, each checked against its complete tail. -/
theorem left_prefix_001_part10_checked :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 1
      (PairLightPrepared43.leftCached.drop 211)
      (PairLightPrepared43.leftRows.drop 211) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared43
