import D1Bound5.SmallPairLightData19Sieve
import D1Bound5.SmallPairLightData19RightVertices
import D1Bound5.SmallPairLightData19RightCached
import D1Bound5.SmallPairLightData19RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 440 through 445, each checked against its complete tail. -/
theorem right_prefix_002_part08_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared19.sieve 6
      (PairLightPrepared19.rightCached.drop 440)
      (PairLightPrepared19.rightRows.drop 440) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared19
