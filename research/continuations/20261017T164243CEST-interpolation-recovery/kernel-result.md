# Fresh installed-kernel result

Command: `cd /Users/tp/Lean/D1Bound5 && LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --fresh --verbose D1Bound5.InterpolationWeights` with output redirected to kernel-fresh.log.
Remote PID 91788, actual output collected with read_process_output. EXIT 0, runtime 267.27 seconds. Output: `replaying D1Bound5.InterpolationWeights with --fresh`.
The pinned LeanChecker.lean implementation was inspected. Its --fresh mode replays the target's entire imported constant environment into an empty environment, using the SAME installed kernel. This is stronger than only replaying the leaf's new declarations, but is not an independent implementation/reviewer, clean checkout, or whole-root replay.
