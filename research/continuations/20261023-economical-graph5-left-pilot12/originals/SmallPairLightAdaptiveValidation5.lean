import D1Bound5.SmallPairLightAdaptiveData5

namespace D1Bound5.PairLightAdaptivePrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared5.leftCached.map Prod.fst = PairLightPrepared5.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared5.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared5.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared5.rightCached.map Prod.fst = PairLightPrepared5.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared5.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared5.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared5
