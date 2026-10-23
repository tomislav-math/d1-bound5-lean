import D1Bound5.SmallPairLightData4Sieve
import D1Bound5.SmallPairLightData4RightCached
import D1Bound5.SmallPairLightData4RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 550 through 595, retaining complete original tails. -/
theorem right_prefix_004_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 46
      (PairLightPrepared4.rightCached.drop 550)
      (PairLightPrepared4.rightRows.drop 550) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
