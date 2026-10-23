import D1Bound5.SmallPairLightAdaptiveData26

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared26.leftCached.map Prod.fst = PairLightPrepared26.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared26.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared26.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared26.rightCached.map Prod.fst = PairLightPrepared26.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared26.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared26.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared26
