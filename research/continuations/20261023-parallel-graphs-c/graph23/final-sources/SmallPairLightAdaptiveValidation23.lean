import D1Bound5.SmallPairLightAdaptiveData23

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared23.leftCached.map Prod.fst = PairLightPrepared23.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared23.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared23.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared23.rightCached.map Prod.fst = PairLightPrepared23.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared23.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared23.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared23
