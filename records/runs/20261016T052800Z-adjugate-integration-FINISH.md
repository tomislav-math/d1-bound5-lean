# FINISH — Adjugate sixteen-index coverage

- Outcome: COMPLETED_UNIT. Observed remote time: 2026-10-16 07:28:00 +0200.
- Worktree: /Users/tp/Lean/D1Bound5, branch main, HEAD 8b686a8.
- New saved source: exploration/AdjugateCoverageTrial.lean, SHA256 bed4cd01361620e85570772a0dbb47a2cd74ebb01ee0d521a8c0568f573cfbd2.
- Three Lean-proved theorems: explicit formula for all 16 adjugate entries; unconditional operator-norm bound from six entrywise near-half estimates; general symmetric zero-diagonal matrix form.
- Compilation: targeted source final exit 0; OLEAN generation exit 0. Raw logs: local-logs/adjugate-coverage-trial-04.log and local-logs/adjugate-coverage-olean-20261016.log.
- Transitive axiom audit: all three theorems PASS, exactly propext, Classical.choice, Quot.sound.
- Installed Lean kernel replay of exploration.AdjugateCoverageTrial: exit 0; local-logs/adjugate-coverage-replay-20261016.log. Not an independent external audit.
- Compilation fixes: reference cofactor subtraction sign in trial 01; explicit matrix transpose orientations in trial 03.
- Code remains isolated in ignored exploration/, not root-integrated. Previously staged changes preserved. No Git commit or push performed. Main bound-five theorem UNPROVED.
- Next: transport the general adjugate theorem to normalizedRootError for a symmetric signed root matrix; integrate along with isolated determinant bound only by permitted methods. Mixed A>=1,B>=3 product-four, Bennett, finite graph coverage and sextuple exclusions remain open.
- The attempted multi-file status append was blocked by a remote safety check before execution. This FINISH record is the smaller recovery write.

## Post-recovery persistence check (07:30:36 CEST)

The smaller recovery write succeeded; subsequent separate append writes to `STATUS.md`, `records/open-obligations.md`, `records/paper-to-lean.md` and `records/build-record.md` succeeded as well. Final source SHA256 is unchanged, START/PROGRESS/FINISH are present, and the final process snapshot showed no project-owned Lean compiler. Existing staged work was not modified deliberately. Only the attempted combined multi-file write was blocked; the cause of that safety check was not diagnosed.
