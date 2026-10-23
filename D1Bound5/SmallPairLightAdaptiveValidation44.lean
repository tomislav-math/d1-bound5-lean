import D1Bound5.SmallPairLightAdaptiveData44

namespace D1Bound5.PairLightAdaptivePrepared44
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared44.leftCached.map Prod.fst = PairLightPrepared44.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared44.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared44.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared44.rightCached.map Prod.fst = PairLightPrepared44.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared44.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared44.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared44
