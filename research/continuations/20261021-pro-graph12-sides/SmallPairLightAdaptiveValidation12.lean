import D1Bound5.SmallPairLightAdaptiveData12

namespace D1Bound5.PairLightAdaptivePrepared12
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared12.leftCached.map Prod.fst = PairLightPrepared12.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared12.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared12.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared12.rightCached.map Prod.fst = PairLightPrepared12.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared12.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared12.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared12
