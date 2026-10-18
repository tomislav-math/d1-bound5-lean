import D1Bound5.SmallPairLightAdaptiveData13

namespace D1Bound5.PairLightAdaptivePrepared13
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared13.leftCached.map Prod.fst = PairLightPrepared13.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared13.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared13.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared13.rightCached.map Prod.fst = PairLightPrepared13.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared13.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared13.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared13
