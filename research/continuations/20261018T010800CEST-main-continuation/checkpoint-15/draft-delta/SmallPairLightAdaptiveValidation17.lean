import D1Bound5.SmallPairLightAdaptiveData17

namespace D1Bound5.PairLightAdaptivePrepared17
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared17.leftCached.map Prod.fst = PairLightPrepared17.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared17.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared17.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared17.rightCached.map Prod.fst = PairLightPrepared17.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared17.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared17.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared17
