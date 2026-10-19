import D1Bound5.PellFiniteFieldCoverageData

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 450 through 499. -/
theorem pellFieldCoverageBlock09_checked :
    ∀ k : Fin 50, PellFieldCoverageAt (450+k.val) := by
  decide +kernel

end D1Bound5
