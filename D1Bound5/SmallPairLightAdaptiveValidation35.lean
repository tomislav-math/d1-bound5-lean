import D1Bound5.SmallPairLightAdaptiveData35

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared35.leftCached.map Prod.fst = PairLightPrepared35.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared35.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared35.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared35.rightCached.map Prod.fst = PairLightPrepared35.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared35.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared35.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared35
