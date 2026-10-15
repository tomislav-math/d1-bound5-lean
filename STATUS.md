# Status

2026-10-15. **IN PROGRESS. MAIN THEOREM UNPROVED.**

## Accepted local mathematical work

The project currently has 40 explicit proved theorems in eleven Lean modules
(counting the root import module). They cover faithful definitions, integral
square roots, sextuple selection with ties, coordinate norm formulas,
regularity algebra, reversible mutation algebra, six modular square
obstructions, interval-chain logic, the coordinate rationality theorem for the pair {1,3},
and boundary regressions.

The complete project builds with Lean 4.33.1 and the pinned mathlib revision.
The current source-policy scan passes. Transitive axiom collection for all
66 exported project declarations passes with only `propext`,
`Classical.choice`, and `Quot.sound`. The target itself is a proposition
specification, not an asserted theorem. See `records/statement-review.md`.

## Completion gates

- Local build and source audit: PASS.
- Current transitive axiom audit: PASS, 66 declarations.
- Bundled kernel replay: PASS for all eleven project modules, exit 0.
- Clean-checkout rebuild: PASS for commit 96af5c0 (36 theorems); the
  40-theorem source revision has passed local checks and awaits the new clean run.
- Independent external statement review: not performed.
- Full ring-coordinate equivalence, analytic dependencies, complete finite
  classifications, Bennett all-orders identity and main theorem: OPEN.
- Prove2Me mission / server acceptance: not started.

## Environment and source preservation

Actual access to the requested Mac and all four startup files was confirmed.
The local handoff manifest passed SHA256 verification. Python 3.12.15 was
installed user-locally, leaving the system Python unchanged. All six frozen
v4 verification jobs were rerun unchanged and passed. They are external
supporting evidence only. The historical radius-10^550 graphs were not rerun.

The original manuscript and old Freiman source projects have not been edited.
Only public dependency caches were reused in this separate project. GitHub
identity `tomislav-math` and the repository's PRIVATE visibility were verified.
A manual-only CI workflow is prepared. No CI run, paid API agent, spending
change, public publication, or Prove2Me mission was initiated.

## Recovery

Use this project's `records/build-record.md`, `records/paper-to-lean.md`, and
`records/open-obligations.md`, followed by the corresponding source modules.
Run `bash scripts/check.sh --replay` from the project directory. Do not rely
on global Lean defaults. Do not overwrite this project or restart from the
initial skeleton. The frozen source remains in the separate handoff tree.
