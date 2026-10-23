import D1Bound5.SmallPairLightData19Sieve
import D1Bound5.SmallPairLightData19RightVertices
import D1Bound5.SmallPairLightData19RightCached
import D1Bound5.SmallPairLightData19RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 95, each checked against its complete tail. -/
theorem right_prefix_000_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 12
      (PairLightPrepared19.rightCached.drop 84)
      (PairLightPrepared19.rightRows.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared19
