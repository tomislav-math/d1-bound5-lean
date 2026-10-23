import D1Bound5.SmallPairLightData39Sieve
import D1Bound5.SmallPairLightData39LeftVertices
import D1Bound5.SmallPairLightData39LeftCached
import D1Bound5.SmallPairLightData39LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 145 through 168, each checked against its complete tail. -/
theorem left_prefix_001_part02_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
      (PairLightPrepared39.leftCached.drop 145)
      (PairLightPrepared39.leftRows.drop 145) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared39
