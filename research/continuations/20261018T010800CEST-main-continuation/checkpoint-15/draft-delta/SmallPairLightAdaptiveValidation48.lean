import D1Bound5.SmallPairLightAdaptiveData48

namespace D1Bound5.PairLightAdaptivePrepared48
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared48.leftCached.map Prod.fst = PairLightPrepared48.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared48.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared48.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared48.rightCached.map Prod.fst = PairLightPrepared48.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared48.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared48.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared48
