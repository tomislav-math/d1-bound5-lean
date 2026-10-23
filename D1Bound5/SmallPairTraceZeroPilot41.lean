import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairBipartitePilotData41
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Every original large vertex is checked once. This is the exact frozen
372-entry list; no pair, color or coordinate is omitted or replaced. -/
theorem smallPairPilotAllTraceZero_41_checked :
    pairAllTraceZeroBool smallPairPilotLarge_41 = true := by
  decide +kernel

/-- The original triangle predicate, obtained from the actual arithmetic
no-three theorem and the linear trace-coordinate certificate. -/
theorem smallPairPilotTraceZeroNoTriangle_41_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_one (by decide)
    smallPairSieve_1_2 smallPairSieve_1_2_valid smallPairPilotLarge_41
    smallPairPilotAllTraceZero_41_checked

end D1Bound5
