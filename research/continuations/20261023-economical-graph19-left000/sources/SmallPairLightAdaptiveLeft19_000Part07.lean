import D1Bound5.SmallPairLightData19Sieve
import D1Bound5.SmallPairLightData19LeftVertices
import D1Bound5.SmallPairLightData19LeftCached
import D1Bound5.SmallPairLightData19LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 95, each checked against its complete tail. -/
theorem left_prefix_000_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 12
      (PairLightPrepared19.leftCached.drop 84)
      (PairLightPrepared19.leftRows.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared19
