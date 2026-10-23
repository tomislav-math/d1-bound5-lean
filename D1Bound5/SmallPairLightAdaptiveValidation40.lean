import D1Bound5.SmallPairLightAdaptiveData40

namespace D1Bound5.PairLightAdaptivePrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared40.leftCached.map Prod.fst = PairLightPrepared40.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared40.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared40.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared40.rightCached.map Prod.fst = PairLightPrepared40.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared40.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared40.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared40
