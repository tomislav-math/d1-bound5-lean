# PROGRESS — Adjugate coverage

The first exploratory version failed because `simpa` did not normalize `-(-1/8)` to `+1/8` in the twelve off-diagonal adjugate entries. Repaired with `sub_neg_eq_add` and `neg_div`.

The second targeted Lean invocation (`local-logs/adjugate-coverage-trial-02.log`) exited 0, proving both (a) an exact sixteen-entry adjugate matrix formula and (b) the unconditional adjugate operator-norm bound for an arbitrary six-entry symmetric zero-diagonal complex matrix whose entries are within 128/8649 of 1/2. Transitive `Lean.collectAxioms` reported only propext, Classical.choice and Quot.sound for both theorems.

A third theorem transferring this estimate to arbitrary symmetric zero-diagonal four-by-four complex matrices is being checked in `exploration/AdjugateCoverageTrial.lean`, log `local-logs/adjugate-coverage-trial-03.log`. No outcome is claimed before its process exit. No root integration or installed kernel replay has yet been performed.
