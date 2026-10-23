import D1Bound5.SmallPairLightData4Sieve
import D1Bound5.SmallPairLightData4RightCached
import D1Bound5.SmallPairLightData4RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 22 through 33, retaining complete original tails. -/
theorem right_prefix_000_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 12
      (PairLightPrepared4.rightCached.drop 22)
      (PairLightPrepared4.rightRows.drop 22) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
