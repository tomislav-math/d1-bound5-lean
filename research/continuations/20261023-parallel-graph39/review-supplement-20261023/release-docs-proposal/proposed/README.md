# A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings

**Zrinka Franušić and Tomislav Pejković**

15 October 2026

Every D(1)-tuple in the full ring of integers of an imaginary quadratic field
has at most five elements. The paper combines structural and approximation
estimates with bounded exact computations.

| Material | Link |
|---|---|
| Paper, 58 pages | [PDF](paper/Diophantine_tuples_bound_five_2026-10-15.pdf) |
| Standalone manuscript source | [LaTeX](paper/Diophantine_tuples_bound_five_2026-10-15.tex) |
| Numerical programs, recorded outputs and reproduction instructions | [Verification guide](verification/README.md) |
| Lean proof progress and outstanding work | [Status](STATUS.md) |

The dated reading copy differs from the verified v4 manuscript only by its
displayed date. The numerical supplement includes the available current and
historical implementations, with their original evidence and clearly stated
reproduction requirements. The Lean theorem is assembled; its final acceptance
gates remain pending, as recorded below and in `STATUS.md`.
The repository is private; no public release or licence has been selected.

## Lean 4 formalization

Private Lean 4/mathlib formalization of the main theorem of
*A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings*, v4.

`D1Bound5.main_statement : D1Bound5.MainStatement` is assembled in
`D1Bound5/MainTheorem.lean`. It states the uniform upper bound `A.card ≤ 5`.
**Final verification is pending:** the clean source build, the 118 exact
statement/axiom checks, the separate broad compatibility audit, and the
full-root fresh kernel replay must all be tied to the same reviewed snapshot.
See `STATUS.md` for individual gate results and evidence references. No public
license or release has been selected.

The target quantifies over every degree-two totally complex number field and
its **full ring of integers**. Entries are distinct and nonzero. A value
`x*y+1` and its square root may be zero. Equal absolute values are permitted.

## Reproduce the formal verification

Pinned Lean: `leanprover/lean4:v4.33.1`.
Pinned mathlib: `0df444a360eaa60ab8c11dca51a86af692955474`.
The complete dependency revisions are in `lake-manifest.json`.

Follow [the verification instructions](scripts/verification/README.md) to
prepare a clean committed checkout, an immutable public Lean/mathlib cache,
and reviewed source/runtime locks. Keep the initially empty project build and
evidence directories outside the source checkout. From that checkout, run:

```sh
D1_WORK=/absolute/path/to/new-verification-work
D1_SOURCE_SHA=reviewed_source_lock_sha256
D1_RUNTIME_SHA=reviewed_runtime_lock_sha256
bash scripts/check.sh \
  --source-lock "$D1_WORK/source-lock.json" --source-lock-sha256 "$D1_SOURCE_SHA" \
  --runtime-lock "$D1_WORK/runtime-lock.json" --runtime-lock-sha256 "$D1_RUNTIME_SHA" \
  --build-dir "$D1_WORK/build" --evidence-dir "$D1_WORK/evidence-001" \
  --jobs 4 --hints scripts/verification/resource_hints.json --replay
```

The complete wrapper gate checks source policy, compiles all 4406 project
modules from an empty project artifact tree, checks 114 original declaration
types and transitive axioms plus four independent target checks, and runs
`leanchecker --verbose --fresh D1Bound5`. `COMPLETE_VERIFICATION_PASS` with
exit 0 records these combined checks. Without `--replay`, exit 3 means that
fresh replay is still pending. The broad compatibility audit has its own
separate result and must also be recorded for this project's final acceptance.

The checker uses the installed Lean kernel. The accepted axiom baseline is
`propext`, `Classical.choice`, `Quot.sound`. No private manuscript, historical
D1Bound5 build artifact, certificate service, or API key is required. Resource
requirements and the safe resume procedure are described in the full guide.

The manual-only GitHub workflow is prepared but is not automatically triggered
by commits. It requires prior confirmation of an existing free Actions
allowance. No paid service or spending setting is enabled by this project.

## Research records

- `STATUS.md`: current completion gates and recovery directions.
- `records/paper-to-lean.md`: exact accepted declarations and source labels.
- `records/statement-review.md`: specification back-translation and limitations.
- `records/open-obligations.md`: mathematical dependencies not yet formalized.
- `records/build-record.md`: actual commands, results and source commits.

The frozen undated manuscript is included at
`verification/v4/output/D1_bound5-v4.tex`. Its SHA256 is
`776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`.
External Python checks are evidence only, never Lean proof terms. Historical
large extension graphs have not been regenerated in this session.
