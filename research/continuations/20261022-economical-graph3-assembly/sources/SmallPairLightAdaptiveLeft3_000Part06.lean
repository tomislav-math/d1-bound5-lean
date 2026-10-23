import D1Bound5.SmallPairLightData3Left
import D1Bound5.SmallPairLightData3LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 72 through 83, each checked against its complete tail. -/
theorem left_prefix_000_part06_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared3.sieve 12
      (PairLightPrepared3.leftCached.drop 72)
      (PairLightPrepared3.leftRows.drop 72) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared3
