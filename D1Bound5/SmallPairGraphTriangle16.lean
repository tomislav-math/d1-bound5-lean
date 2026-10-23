import D1Bound5.SmallPairGraphInputs16
import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairSieve_0_2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem PairGraphPrepared16.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_16 = true := by
  decide +kernel

theorem smallPairNoTriangle_16_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_16 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_zero (by decide)
    smallPairSieve_0_2 smallPairSieve_0_2_valid smallPairLarge_16
    PairGraphPrepared16.all_trace_zero_checked

end D1Bound5
