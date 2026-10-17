# PROGRESS — 17 October 2026, 17:26 CEST

Reused the preserved 16:47 finite-pole trial after discovering its actual proof error: an unnecessary second `rw [Finset.mul_sum]` failed because the earlier `simp_rw` had already distributed the sum. The repair consists solely of removing that redundant rewrite in this run's own copy. Pinned Lean compilation of the repaired proof succeeded with exit 0, and both elaborated theorems have only propext, Classical.choice, Quot.sound as transitive axioms. The original uncompiled trial and its failure record remain untouched.

Next: formally compose the exact finite reciprocal-pole expansion with the already root-proved all-degree negative-power interpolation formula, obtaining a finite generating function with explicit hsymm coefficients and exact rational remainder. Then perform targeted/root build, axiom audit and same-kernel replay before claiming acceptance.

## Root proof and audit milestone

Three theorems now ROOT-IMPORTED: `reciprocal_pole_finite_tail`, `weighted_poles_finite_tail`, and `reciprocal_pole_hsymm_finite_tail`. The last is a genuinely new exact finite generating-function/remainder consequence of the previously proved all-k reciprocal interpolation identity. Pinned target+root build EXIT 0 (3053 jobs); exact elaborated theorem types and transitive axioms audit EXIT 0, with only `propext`, `Classical.choice`, `Quot.sound`. Source/import scan PASS: 89 modules and 410 explicit theorem declarations. No mathematical trust shortcuts found by the source scan. Targeted installed same-kernel fresh replay is executing separately; do not infer its result before collection.

A planned source/tool SHA-256 manifest refresh was PRE_EXECUTION_DENIED before execution. Precise tool command and refusal message are in the separate denial record. The mathematical proof and actual compilation remain saved, but the project's fingerprint gate is PENDING; do not claim a passing manifest, reviewed Git release, commit or push for this unit. The old staged post-push receipt remains preserved.
