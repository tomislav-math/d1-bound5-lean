import D1Bound5.SmallPairLightAdaptiveData38

namespace D1Bound5.PairLightAdaptivePrepared38
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared38.leftCached.map Prod.fst = PairLightPrepared38.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared38.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared38.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared38.rightCached.map Prod.fst = PairLightPrepared38.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared38.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared38.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared38
