import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveRight7_Pilot12Part00

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_pilot12_direct_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 12
      (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := by
  have h000 : pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 12
      (PairLightPrepared7.rightCached.drop 0) (PairLightPrepared7.rightRows.drop 0) = true := right_pilot12_part00_checked
  exact h000
end D1Bound5.PairLightAdaptivePrepared7
