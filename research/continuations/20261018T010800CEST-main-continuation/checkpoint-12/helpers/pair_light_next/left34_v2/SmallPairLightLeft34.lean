import D1Bound5.SmallPairLightData34

namespace D1Bound5.PairLightPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Only the isolated arithmetic computation. Connection to the original
class requires the separately checked data equalities and exact bridge. -/
theorem left_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true := by
  decide +kernel

end D1Bound5.PairLightPilot34
