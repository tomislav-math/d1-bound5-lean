import D1Bound5.SmallPairLightAdaptiveData14

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared14.leftCached.map Prod.fst = PairLightPrepared14.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared14.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared14.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared14.rightCached.map Prod.fst = PairLightPrepared14.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared14.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared14.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared14
