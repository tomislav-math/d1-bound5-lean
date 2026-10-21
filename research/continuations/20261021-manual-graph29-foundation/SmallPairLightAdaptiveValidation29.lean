import D1Bound5.SmallPairLightAdaptiveData29

namespace D1Bound5.PairLightAdaptivePrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared29.leftCached.map Prod.fst = PairLightPrepared29.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared29.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared29.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared29.rightCached.map Prod.fst = PairLightPrepared29.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared29.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared29.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared29
