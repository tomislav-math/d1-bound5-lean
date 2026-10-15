# D1Bound5

Private, in-progress Lean 4/mathlib formalization of the main theorem of
*A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings*, v4.

**The main theorem has not been proved in this project.** `D1Bound5.MainStatement`
is its specification as a proposition, not an asserted theorem. No public
license or release has been selected.

The target quantifies over every degree-two totally complex number field and
its **full ring of integers**. Entries are distinct and nonzero. A value
`x*y+1` and its square root may be zero. Equal absolute values are permitted.

## Reproduce the current proof modules

Pinned Lean: `leanprover/lean4:v4.33.1`.
Pinned mathlib: `0df444a360eaa60ab8c11dca51a86af692955474`.
The complete dependency revisions are in `lake-manifest.json`.

With elan and Python 3 available, run from a clean checkout:

```sh
bash scripts/fetch_cache.sh
bash scripts/check.sh --replay
```

The script builds, scans proof sources, audits transitive axiom dependencies,
and replays project modules through the bundled Lean kernel checker. The
checker uses the same Lean kernel; it is not an independent external verifier.
The accepted axiom baseline is `propext`, `Classical.choice`, `Quot.sound`.
No private manuscript, old project, certificate service, or API key is needed
to build the proof modules currently committed here.

The manual-only GitHub workflow is prepared but is not automatically triggered
by commits. It requires prior confirmation of an existing free Actions
allowance. No paid service or spending setting is enabled by this project.

## Research records

- `STATUS.md`: current completion gates and recovery directions.
- `records/paper-to-lean.md`: exact accepted declarations and source labels.
- `records/statement-review.md`: specification back-translation and limitations.
- `records/open-obligations.md`: mathematical dependencies not yet formalized.
- `records/build-record.md`: actual commands, results and source commits.

The frozen manuscript remains outside the repository. Its SHA256 is
`776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`.
External Python checks are evidence only, never Lean proof terms. Historical
large extension graphs have not been regenerated in this session.
