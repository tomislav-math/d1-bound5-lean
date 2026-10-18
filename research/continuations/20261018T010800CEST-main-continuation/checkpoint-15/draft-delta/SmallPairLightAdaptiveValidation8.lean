import D1Bound5.SmallPairLightAdaptiveData8

namespace D1Bound5.PairLightAdaptivePrepared8
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared8.leftCached.map Prod.fst = PairLightPrepared8.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared8.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared8.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared8.rightCached.map Prod.fst = PairLightPrepared8.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared8.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared8.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared8
