import D1Bound5.SmallPairGraphInputs37
import D1Bound5.PairTraceZeroGraph
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem PairGraphPrepared37.all_trace_zero_checked :
    pairAllTraceZeroBool smallPairLarge_37 = true := by
  decide +kernel

theorem smallPairNoTriangle_37_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_37 = true :=
  pairGraphTriangleFreeBool_of_trace_zero_tau_one (by decide)
    smallPairSieve_1_2 smallPairSieve_1_2_valid smallPairLarge_37
    PairGraphPrepared37.all_trace_zero_checked

end D1Bound5
