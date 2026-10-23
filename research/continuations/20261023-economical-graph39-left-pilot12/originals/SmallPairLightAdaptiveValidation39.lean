import D1Bound5.SmallPairLightAdaptiveData39

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared39.leftCached.map Prod.fst = PairLightPrepared39.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared39.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared39.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared39.rightCached.map Prod.fst = PairLightPrepared39.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared39.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared39.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared39
