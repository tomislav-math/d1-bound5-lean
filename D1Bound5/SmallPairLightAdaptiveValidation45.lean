import D1Bound5.SmallPairLightAdaptiveData45

namespace D1Bound5.PairLightAdaptivePrepared45
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared45.leftCached.map Prod.fst = PairLightPrepared45.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared45.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared45.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared45.rightCached.map Prod.fst = PairLightPrepared45.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared45.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared45.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared45
