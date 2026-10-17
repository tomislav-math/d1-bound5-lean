import D1Bound5.FiniteTail

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000

/-- Kernel evaluation of the complete Gaussian small-tail certificate. -/
theorem D1Bound5.gaussian_small_tail_check : D1Bound5.SmallTailCheck 0 1 := by
  unfold D1Bound5.SmallTailCheck
  decide +kernel

#print axioms D1Bound5.gaussian_small_tail_check
