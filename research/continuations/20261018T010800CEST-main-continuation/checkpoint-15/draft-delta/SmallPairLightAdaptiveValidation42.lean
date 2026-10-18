import D1Bound5.SmallPairLightAdaptiveData42

namespace D1Bound5.PairLightAdaptivePrepared42
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared42.leftCached.map Prod.fst = PairLightPrepared42.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared42.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared42.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared42.rightCached.map Prod.fst = PairLightPrepared42.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared42.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared42.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared42
