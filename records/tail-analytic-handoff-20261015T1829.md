# Separate analytic-tail continuation — completed proof unit

Direct continuation begun 2026-10-15 18:29 UTC.
The main bound-five theorem remains UNPROVED.

Local worktree: /Users/tp/Lean/D1Bound5-TailAnalytic-20261015
Private repository branch: tail-analytic-20261015
Proof-source commit: 3a8f9ff711bdaf3dec07b3fe3dbbc9be6af336f9
Final validation-record commit: adcab626eb1b2e75bdf9f2b397f64a1ef9e6f357
Both commits have been pushed privately. Remote and local heads matched.
The isolated branch worktree was clean at completion.

## Mathematical result

The C>=4 branch of lem:tail-irregular is proved for EVERY imaginary
quadratic full integer ring. For an ordered D(1)-quadruple with B>=3 and
C>=4, the last three entries are irregular and D>2BC. Weak ordering allows
ties. No arithmetic square root is divided out. Both regular-completion
signs are covered. The norm input in the generic core is discharged by
the base's proved full-ring one_le_norm_integer theorem.

Nine new explicit theorems, branch total 79 in 23 modules, including root.
Four new modules: RootPerturbation, TailErrorBounds, TailAnalytic,
TailAnalyticMain. Highest declaration:
D1Bound5.IsD1Tuple.tail_irregular_and_growth_of_four_le.

## Validation actually completed

All new modules compiled, targeted build exit 0. The integrated 79-theorem
build also passed. Source-policy and complete root-import-coverage checks
passed. The whole-branch axiom audit passed for 133 declarations, allowing
only propext, Classical.choice and Quot.sound.

All FOUR NEW MODULES returned successfully from kernel replay using the
byte-identical replayFromImports function in installed Lean 4.33.1. A
sequential caller printed and flushed PASS only after each completed check.
It also replayed five unchanged base modules. The old 70-theorem source
was not changed and already had its accepted replay at 18af1df.

The all-at-once whole-project replay was stopped by its current owner.
The subsequent sequential repeat was also stopped during an optional
recheck of unchanged FullRingBasis, AFTER all four new modules passed.
Each overall interrupted command exited 143. Do NOT report a full current
23-module exit-0 replay or a new clean checkout. No independent external
referee or external kernel implementation was used.
Exact commands, types, hashes and receipts are in the isolated worktree's
records/tail-analytic-checks.md, tail-analytic-replay-receipt.json,
tail-analytic-build-and-axioms.log and tail-analytic-kernel-replay.log.
No validation process owned by this continuation remains running.

## Reconciliation and next task

This continuation did not modify the main worktree's live SquareTest,
DiskEnumeration, FiniteTail, FiniteTailComputable, root imports or STATUS.
Preserve their newer work. Reconcile the four compiled analytic modules
from the private branch, merging imports and records without reverting any
newer source. Do not blindly replace main STATUS with this branch's STATUS.

Complete the finite 3<=B<=C<4 certificate and its all-fields coverage, then
join it to the analytic result. Analytic square-root hypotheses use r^2;
the finite code currently uses r*r, connected by pow_two. No assumption of
unequal moduli or nonzero square values may be inserted.

Further determinant, interpolation, all-orders Bennett identity and large
finite graph/Pell exclusions remain open. The next-even-determinant note is
an implementation proposal, NOT a Lean proof. No Prove2Me mission, paid
agent, public license/release or manuscript change was made.
