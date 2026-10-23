import D1Bound5.SmallPairLightData7Sieve
import D1Bound5.SmallPairLightData7LeftVertices
import D1Bound5.SmallPairLightData7LeftCached
import D1Bound5.SmallPairLightData7LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 11, each checked against its complete tail. -/
theorem left_pilot12_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 12
      (PairLightPrepared7.leftCached.drop 0)
      (PairLightPrepared7.leftRows.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared7
