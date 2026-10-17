import D1Bound5.FiniteTailComputable

namespace D1Bound5

set_option maxRecDepth 100000 in
set_option maxHeartbeats 10000000 in
theorem trial_small_tail_q2 : smallTailCheckBool 0 2 = true := by decide +kernel

end D1Bound5
