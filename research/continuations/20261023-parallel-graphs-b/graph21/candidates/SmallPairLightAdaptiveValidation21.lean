import D1Bound5.SmallPairLightAdaptiveData21

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared21.leftCached.map Prod.fst = PairLightPrepared21.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared21.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared21.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared21.rightCached.map Prod.fst = PairLightPrepared21.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared21.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared21.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared21
