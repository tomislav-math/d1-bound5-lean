import D1Bound5.SmallPairLightData48

namespace D1Bound5.PairLightPrepared48
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (leftCached.map Prod.fst = leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := by
  decide +kernel

theorem left_independent_checked :
    pairLightSelectedFloorIndependentBool 1 8 sieve leftCached leftRows = true := by
  decide +kernel

theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 8 sieve
      leftVertices leftCached leftRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨left_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨left_signatures_checked, left_independent_checked⟩⟩

end D1Bound5.PairLightPrepared48
