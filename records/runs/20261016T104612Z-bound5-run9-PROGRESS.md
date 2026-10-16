# PROGRESS — weighted-row numerical certificate

Time: 2026-10-16, mid-run (Europe/Zagreb). Working on isolated `exploration/WeightedRowCertificateTrial.lean`; concurrent `MixedRootMatrixSigns.lean` and its import remain untouched.

Target: exact nonnegative symmetric four-by-four envelope with first-row entries 1/18, lower-three entries 1/64, weights `(3/2,1,1,1)` and weighted row bound 11/96. This finite certificate is a prerequisite for the genuinely still-open weighted spectral/operator-norm estimate in the manuscript's A>=1,B>=3 branch. Do not claim that the numerical row certificate alone proves the spectral inequality.

First Lean trial exited 1 (noncomputable real definitions, a symmetry simplifier recursion, unresolved finite-index normalizations); corrected those. Second trial exited 1 due to a recursive simplification in `Fin.ext_iff`, which has now been removed. Third trial is in progress. No proof acceptance is claimed without exit-zero compilation and axiom audit.
