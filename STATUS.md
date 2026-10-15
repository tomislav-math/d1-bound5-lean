# Status

2026-10-15. MAIN BOUND-FIVE THEOREM UNPROVED.

## Analytic-tail continuation

Worktree: /Users/tp/Lean/D1Bound5-TailAnalytic-20261015.
Private branch: tail-analytic-20261015, based on accepted 18af1df.
Proof-source commit: 3a8f9ff711bdaf3dec07b3fe3dbbc9be6af336f9.
This branch contains 79 explicit theorems in 23 modules (root included).
Nine new theorems prove the C>=4 branch of lem:tail-irregular and its
D>2BC consequence for ordered D(1)-quadruples in EVERY imaginary quadratic
full integer ring. No unproved norm hypothesis remains in the wrapper.

## Checks actually completed

- All new modules compiled, actual targeted build exit 0.
- Integrated build passed, 2971 dependency jobs, not a theorem count.
- Source-policy and root-import coverage passed: 79 theorems / 23 modules.
- Whole-branch transitive axiom audit passed: 133 project declarations,
  only propext, Classical.choice and Quot.sound.
- All FOUR NEW MODULES returned successfully from kernel replay, using
  the byte-identical replayFromImports function from installed Lean 4.33.1.
  The sequential run also replayed five unchanged base modules.

The original all-at-once checker was stopped by this owner, exit 143.
The sequential run was then stopped during an optional repeat of the
unchanged FullRingBasis, after all new modules had passed. Its overall exit
was also 143. No complete 23-module exit-0 replay is claimed for this turn.
The base had already passed its own replay at 18af1df; its mathematical
sources and pinned dependencies are unchanged. See exact scope and logs in
records/tail-analytic-checks.md and tail-analytic-replay-receipt.json.
No verification process from this continuation is intentionally left running.

## Continuation

The finite 3<=B<=C<4 branch is being developed separately in the main
worktree /Users/tp/Lean/D1Bound5. Its live source and root imports were not
changed here. A new handoff is saved there under
records/tail-analytic-handoff-20261015T1829.md. Reconcile the four new analytic
modules without reverting newer main work, then join the two tail branches.
The highest-level new declaration is
D1Bound5.IsD1Tuple.tail_irregular_and_growth_of_four_le.
The mathematical proof and exact statement self-review are in records.
The next-even-determinant note is a proposal, NOT a proved Lean result.

The main cardinality theorem remains only a proposition specification.
Further determinant, interpolation, simultaneous approximation, all-orders
Bennett identity and complete finite graph/Pell exclusions remain open.
No independent external statement review or new clean checkout of the
79-theorem branch was performed. Earlier clean-checkout receipts retain
only their historical scope.

Lean 4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474 remain pinned.
Previously passed v4 Python checks were not rerun. The frozen manuscript
hash is unchanged. No handoff, Freiman project, public release or paid
service was modified. No Prove2Me mission was opened. Repository is private.
