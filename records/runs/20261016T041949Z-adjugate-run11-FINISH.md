# Formalization continuation — FINISH

- Verified Mac start: 2026-10-16 06:19:49 CEST (04:19:49 UTC).
- Verified final observation: 2026-10-16 06:30:25 CEST (04:30:25 UTC).
- Outcome: COMPLETED_UNIT (isolated scalar lemma). Main theorem remains UNPROVED.
- Worktree: /Users/tp/Lean/D1Bound5, branch main, HEAD 8b686a8.
- No project-owned Lean/lake/leanchecker process observed at beginning or final check.
- Existing staged and unstaged work preserved without overwrite.

## Actual mathematics

Established `D1Bound5.nearHalf_offDiagonal_cofactor_bound` for six arbitrary complex variables within epsilon=128/8649 of 1/2:

    ‖w²x-wzu-wyv+1/8‖ < 197/10000.

The Lean proof closes the exact cubic deviation identity and all four groups of norm inequalities, followed by exact rational `norm_num`. Details in `records/offdiagonal-cofactor-20261016.md`.

## Verification

- Command: `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/AdjugateOffdiagTrial.lean` from the pinned project root.
- Final exit: 0. Log `local-logs/adjugate-offdiag-run11-03.log`.
- Transitive `Lean.collectAxioms`: PASS, exactly propext, Classical.choice, Quot.sound.
- No sorry, admit, custom axioms or native-evaluation shortcuts. Three harmless unused-simp warnings.
- Source SHA256: 204e5a3d85e744a5ce1309a44f4ae39db417a6765338b5043019345bb3ebc2a0.
- Log SHA256: 9a51202eef2bb356b26ad6cab26663b91b9c6fce0b062ec2a69a75b8e9300ac1.
- Attempts 01 and 02 exited 1; their specific denominator-normalization and additive-bound blockers were repaired before the final passing run.
- Integrated root build, installed leanchecker replay, clean-checkout build and independent audit were NOT executed for this isolated trial.

## Persistence

Saved source in ignored `exploration/AdjugateOffdiagTrial.lean`, logs in `local-logs/`, detailed mathematical note, and updates to STATUS.md, open-obligations.md, paper-to-lean.md and build-record.md. No new commit or GitHub push. The latest local HEAD remains 8b686a8; no remote state has been freshly asserted.

## Next

Prove that each of the twelve off-diagonal entries of the adjugate of a symmetric zero-diagonal 4x4 matrix has the required near-half error, using finite index coverage or proved adjugate permutation symmetry. Combine with the already proved diagonal estimate and conditional `four_adjugate_bound_of_entry_bounds`. Then integrate and run root checks only by permitted operations. The separate A>=1,B>=3 branch, all-orders Bennett identity, large finite graph coverage, and final sextuple exclusions remain OPEN.
