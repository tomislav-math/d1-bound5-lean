# PROGRESS — weighted-pole analytic tail limit

A trial with incomplete complex-analysis imports failed elaboration (exit 1), and is preserved as WeightedPoleLimitTrial.lean. The repaired trial WeightedPoleLimitTrial02.lean compiled on pinned Lean 4.33.1 with EXIT 0 (34.91 s); its exact theorem's transitive axioms were printed as only propext, Classical.choice, Quot.sound. The sole warning was an unused simp argument, removed in the integrated source without altering the proof structure.

The result uses |z| < |a_i| for every i in the finite node set; it handles empty sets, repeated nodes and zero weights. Algebraically the tail is a finite sum of (z/a_i)^n times the fixed factors w_i/(a_i-z), so geometric convergence plus finite-sum continuity applies.

Root source D1Bound5/WeightedPoleLimit.lean was written, an additive import appended to D1Bound5.lean, and scripts/WeightedPoleLimitAudit.lean was saved. Pinned integrated compilation, fresh kernel replay and source/import audit are pending. No Git staging was touched. The combined read-only Git preflight/status command was explicitly blocked before execution; no Git checks from that command are claimed.
