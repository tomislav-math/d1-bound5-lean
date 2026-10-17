import D1Bound5.FiniteTailComputable

namespace D1Bound5

set_option maxRecDepth 32768
set_option maxHeartbeats 4000000

theorem test_small_tail_trace_zero_15 : smallTailCheckBool 0 15 = true := by
  decide +kernel

theorem test_small_tail_trace_one_15 : smallTailCheckBool 1 15 = true := by
  decide +kernel

end D1Bound5
