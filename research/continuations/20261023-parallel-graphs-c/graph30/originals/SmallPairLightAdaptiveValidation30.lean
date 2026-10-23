import D1Bound5.SmallPairLightAdaptiveData30

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared30.leftCached.map Prod.fst = PairLightPrepared30.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared30.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared30.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared30.rightCached.map Prod.fst = PairLightPrepared30.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared30.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared30.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared30
