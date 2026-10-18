import D1Bound5.SmallPairLightAdaptiveData11

namespace D1Bound5.PairLightAdaptivePrepared11
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared11.leftCached.map Prod.fst = PairLightPrepared11.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared11.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared11.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared11.rightCached.map Prod.fst = PairLightPrepared11.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared11.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared11.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared11
