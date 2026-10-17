import D1Bound5.FiniteTailComputable
open D1Bound5
set_option maxRecDepth 120000
set_option maxHeartbeats 20000000
-- First isolate the cost of reducing a sorted finite disk in the kernel.
example : (diskOrderedList 0 2).length = 31 := by decide +kernel
-- Small positive-discriminant test, to measure nested kernel evaluation.
example : smallTailCheckBool 1 9 = true := by decide +kernel
