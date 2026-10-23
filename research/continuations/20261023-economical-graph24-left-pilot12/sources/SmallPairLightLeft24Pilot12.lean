import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft24_Pilot12Part00

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_pilot12_direct_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 12
      (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := by
  have h000 : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 12
      (PairLightPrepared24.leftCached.drop 0) (PairLightPrepared24.leftRows.drop 0) = true := left_pilot12_part00_checked
  exact h000
end D1Bound5.PairLightAdaptivePrepared24
