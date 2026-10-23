import D1Bound5.SmallPairLightData19Sieve
import D1Bound5.SmallPairLightData19LeftVertices
import D1Bound5.SmallPairLightData19LeftCached
import D1Bound5.SmallPairLightData19LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 272 through 295, each checked against its complete tail. -/
theorem left_prefix_002_part01_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 24
      (PairLightPrepared19.leftCached.drop 272)
      (PairLightPrepared19.leftRows.drop 272) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared19
