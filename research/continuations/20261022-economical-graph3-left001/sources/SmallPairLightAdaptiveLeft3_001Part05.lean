import D1Bound5.SmallPairLightData3Left
import D1Bound5.SmallPairLightData3LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 232 through 255, each checked against its complete tail. -/
theorem left_prefix_001_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 24
      (PairLightPrepared3.leftCached.drop 232)
      (PairLightPrepared3.leftRows.drop 232) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared3
