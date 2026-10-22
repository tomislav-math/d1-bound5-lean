import D1Bound5.SmallPairLightAdaptiveData3

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared3.leftCached.map Prod.fst = PairLightPrepared3.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared3.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared3.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared3.rightCached.map Prod.fst = PairLightPrepared3.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared3.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared3.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared3
