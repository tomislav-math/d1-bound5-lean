import D1Bound5.SmallPairLightData24Sieve
import D1Bound5.SmallPairLightData24LeftVertices
import D1Bound5.SmallPairLightData24LeftCached
import D1Bound5.SmallPairLightData24LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 197 through 220, each checked against its complete tail. -/
theorem left_prefix_001_part04_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
      (PairLightPrepared24.leftCached.drop 197)
      (PairLightPrepared24.leftRows.drop 197) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared24
