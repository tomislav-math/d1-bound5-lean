import D1Bound5.SmallPairGraphInputs27
import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairSieve_1_1

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem PairGraphPrepared27.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_27 = true := by
  decide +kernel

theorem smallPairNoTriangle_27_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_27 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_one (by decide)
    smallPairSieve_1_1 smallPairSieve_1_1_valid smallPairLarge_27
    PairGraphPrepared27.all_trace_zero_checked

end D1Bound5
