import D1Bound5.SmallPairLightAdaptiveData6

namespace D1Bound5.PairLightAdaptivePrepared6
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared6.leftCached.map Prod.fst = PairLightPrepared6.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared6.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared6.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared6.rightCached.map Prod.fst = PairLightPrepared6.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared6.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared6.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared6
