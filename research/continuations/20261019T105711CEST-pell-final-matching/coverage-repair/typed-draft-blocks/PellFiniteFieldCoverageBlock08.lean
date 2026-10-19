import D1Bound5.PellFiniteFieldCoverageData

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 400 through 449. -/
theorem pellFieldCoverageBlock08_checked :
    ∀ k : Fin 50, PellFieldCoverageAt (400+k.val) := by
  decide +kernel

end D1Bound5
