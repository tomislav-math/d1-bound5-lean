import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft5_Pilot12Part00

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_pilot12_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
      (PairLightPrepared5.leftCached.drop 0) (PairLightPrepared5.leftRows.drop 0) = true := by
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared5.sieve 12
      (PairLightPrepared5.leftCached.drop 0) (PairLightPrepared5.leftRows.drop 0) = true := left_pilot12_part00_checked
  exact h000
end D1Bound5.PairLightAdaptivePrepared5
