import D1Bound5.SmallPairLightAdaptiveData1

namespace D1Bound5.PairLightAdaptivePrepared1
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared1.leftCached.map Prod.fst = PairLightPrepared1.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared1.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared1.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared1.rightCached.map Prod.fst = PairLightPrepared1.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared1.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared1.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared1
