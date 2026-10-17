# Status

2026-10-15. **IN PROGRESS. MAIN THEOREM UNPROVED.**

## Current accepted local work

There are 70 explicit proved theorems in nineteen Lean modules, counting
the root import module. The current integrated build, source-policy check,
root import-coverage check, transitive axiom audit and kernel replay PASS.
The axiom audit covers 117 project declarations and permits only
`propext`, `Classical.choice`, and `Quot.sound`.

The latest continuation closes the FULL integer-ring coordinate bridge
for EVERY imaginary quadratic field, including positive squarefree d,
the exact half-integral branch, and equality of coordinate, algebraic and
complex squared norms. It transfers the rationality of common extensions
of {1,3} to all these full rings. The complete `lem:irregular-growth`,
C>2AB, and the more precise `eq:irregular-quadratic` are now proved.
See `records/full-ring-bridge.md`, `records/irregular-growth-proof.md`,
and `records/continuation-checks-015.log`.

## Completion gates

- Current local build, source audit and root import coverage: PASS.
- Current transitive axiom audit: PASS, 117 declarations.
- Kernel replay: PASS for all nineteen modules, exit 0.
- The previous 40-theorem source commit 49dda62363d663bce06709c9a4b99185901cc158
  passed a clean GitHub-checkout build and all audits. A new clean checkout
  of this 70-theorem continuation has not yet been run.
- Independent external statement review: not performed.
- Main theorem, tail-irregularity, determinant/interpolation/approximation
  bounds, Bennett all-orders identity and complete finite exclusions: OPEN.
- Prove2Me mission/server acceptance: not started.

## Current exploration and next action

`exploration/SquareTest.lean` and `exploration/DiskEnumeration.lean` contain
new executable arithmetic procedures and attempted completeness proofs.
They are currently being compiled separately, not counted as accepted.
`exploration/FiniteTail.lean` prepares the finite small-tail soundness and
discriminant reduction; it is not compiled or accepted yet.
First finish and audit the square-test and disk procedures, then prototype
the exact small-tail certificate from the proved enumeration. Do not redo
the full-ring bridge or irregular growth.

## Environment, preservation and recovery

Lean 4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474 are pinned.
Python 3.12.15 is user-local; all six frozen v4 Python checks already passed.
Those checks are supporting evidence, not Lean proofs. The historical
radius-10^550 graphs were not rerun. No manuscript, handoff, previous
Freiman project, public release, paid service or Prove2Me mission was altered.
The GitHub repository tomislav-math/d1-bound5-lean remains PRIVATE.

Read `records/build-record.md`, `records/paper-to-lean.md` and
`records/open-obligations.md`, then the current sources. Run the project's
checks using the pinned local lake. Preserve all newer work and avoid
concurrent heavy compilers on this 8 GiB Mac. The main target remains only
a proposition specification in `Specification.lean`, not a proved theorem.
