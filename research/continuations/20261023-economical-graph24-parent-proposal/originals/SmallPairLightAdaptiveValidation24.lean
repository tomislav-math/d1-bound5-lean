import D1Bound5.SmallPairLightAdaptiveData24

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared24.leftCached.map Prod.fst = PairLightPrepared24.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared24.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared24.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared24.rightCached.map Prod.fst = PairLightPrepared24.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared24.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared24.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared24
