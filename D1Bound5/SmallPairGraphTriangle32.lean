import D1Bound5.SmallPairGraphInputs32
import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairSieve_0_6

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem PairGraphPrepared32.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_32 = true := by
  decide +kernel

theorem smallPairNoTriangle_32_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_6 smallPairLarge_32 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_zero (by decide)
    smallPairSieve_0_6 smallPairSieve_0_6_valid smallPairLarge_32
    PairGraphPrepared32.all_trace_zero_checked

end D1Bound5
