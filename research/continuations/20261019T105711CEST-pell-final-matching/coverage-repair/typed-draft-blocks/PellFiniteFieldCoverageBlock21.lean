import D1Bound5.PellFiniteFieldCoverageData

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 1050 through 1099. -/
theorem pellFieldCoverageBlock21_checked :
    ∀ k : Fin 50, PellFieldCoverageAt (1050+k.val) := by
  decide +kernel

end D1Bound5
