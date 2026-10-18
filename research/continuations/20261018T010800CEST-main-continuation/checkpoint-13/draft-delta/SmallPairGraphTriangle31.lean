import D1Bound5.SmallPairGraphInputs31
import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairSieve_0_5

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem PairGraphPrepared31.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_31 = true := by
  decide +kernel

theorem smallPairNoTriangle_31_checked :
    pairGraphTriangleFreeBool smallPairSieve_0_5 smallPairLarge_31 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_zero (by decide)
    smallPairSieve_0_5 smallPairSieve_0_5_valid smallPairLarge_31
    PairGraphPrepared31.all_trace_zero_checked

end D1Bound5
