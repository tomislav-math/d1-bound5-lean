# PROGRESS — reciprocal-anchor interpolation bridge

Observed time: 2026-10-17 14:29:33 CEST.

Six new algebraic theorem declarations were successfully elaborated in `exploration/ReciprocalAnchorTrial.lean` using pinned Lean 4.33.1 and cached mathlib; trial09 EXIT 0. All six explicit transitive axiom checks list only propext, Classical.choice, Quot.sound.

Theorems include an exact product identity for reciprocal Vandermonde differences, pointwise weighted reciprocal-node transfers, the parity correction, an all-order finite-sum transfer, and the first nonzero reciprocal-anchor moment `sum_i 1/a_i / product_{j != i}(a_i-a_j) = (-1)^(m-1) / product_i a_i` for nonzero distinct nodes. This closes the `n=m` boundary of the manuscript interpolation identity, NOT the arbitrary-order complete-homogeneous formula.

Saved trial compile logs: `local-logs/reciprocal-anchor-1414-trial{01,02,03,04,05,06,07,08,09}.log`. The source remains outside accepted root imports. Next: preserve independently under research/, build .olean, targeted installed leanchecker replay, inspect source/axioms and attempt reviewed private Git synchronization under explicit policy. Do not overwrite staged prior work.
