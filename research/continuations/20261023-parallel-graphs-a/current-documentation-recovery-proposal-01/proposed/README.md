# A uniform bound of five for Diophantine tuples in imaginary quadratic integer rings

**Zrinka Franušić and Tomislav Pejković**

Manuscript: 15 October 2026. Formalization checkpoint: 23 October 2026.

For every imaginary quadratic field K, a finite set of nonzero elements of
its full ring of integers with ab+1 a square for every distinct pair has at
most five elements. This is a uniform upper bound; no sharpness claim is made.

| Material | Link |
|---|---|
| Paper, 58 pages | [PDF](paper/Diophantine_tuples_bound_five_2026-10-15.pdf) |
| Standalone manuscript source | [LaTeX](paper/Diophantine_tuples_bound_five_2026-10-15.tex) |
| Numerical programs and recorded outputs | [Verification guide](verification/README.md) |
| Lean completion gates and preserved history | [Status](STATUS.md) |
| Latest operational checkpoint | [CURRENT_PROGRESS](research/continuations/20261023-parallel-resume/CURRENT_PROGRESS.json) |

The dated reading copy differs from the verified v4 manuscript only by its
displayed date. The repository is private; no public release or licence has
been selected.

## Lean proof and verification status

The frozen proof candidate contains
`D1Bound5.main_statement : D1Bound5.MainStatement` in
[D1Bound5/MainTheorem.lean](D1Bound5/MainTheorem.lean).
It quantifies over every degree-two totally complex number field and the
**full ring of integers**, including the half-integral basis cases. Elements
are nonzero; pair-square roots may be zero, and equal absolute values are
allowed.

The earlier candidate completed a fresh build of all **4,406 project
modules**, the exact audit with **114+4 declaration occurrences**, and the
corrected broad declaration audit. These are recorded historical successes.
The subsequent official fresh full-root kernel replay was interrupted after
the first environment file loss and did **not** pass. The surviving summaries
are preserved in the
[historical evidence package](research/continuations/20261023-parallel-target-audit/current-docs-clean-build-draft-01/);
missing original logs, artifacts and receipt bodies are not represented as
recovered.

A recovery build started from empty project outputs under a new recorded
runtime and build origin, with the same required source map. Resource failures
and retries have been retained. A second workspace loss at **18:07 UTC on
23 October** stopped its current invocation with actual exit 1. The Mac
repository and recovery runtime/artifacts under `/tmp` survived; restoration
and byte verification of the missing working sources/tools are pending at
this checkpoint.

**The recovery full-build, exact audit, broad audit and final fresh replay
gates remain pending.** Canonical umbrella/tool installation and the final
release identity bridge also remain pending. The earlier successes do not
satisfy these new gates. Consult the timestamped operational checkpoint above
before resuming work; later incident or resume records supersede this snapshot.

## Reproduction and continuation

Pinned Lean: `leanprover/lean4:v4.33.1`.
Pinned mathlib: `0df444a360eaa60ab8c11dca51a86af692955474`.
The complete dependency revisions are in `lake-manifest.json`.

The current umbrella and older scripts have not yet received the reviewed
final installation. Their historical subset checks are not a full verification
of the new theorem. The
[prepared verification guide](research/continuations/20261023-parallel-graphs-b/final-installation-plan-04/scripts/verification/README.md)
and [installation plan](research/continuations/20261023-parallel-graphs-b/final-installation-plan-04/FINAL_INSTALLATION_PLAN.md)
describe the intended full workflow; neither is a claim that the packaged
entrypoint has already run end to end.

Before publication, match every one of the 4,406 relative source paths and
hashes and all three configuration pins to the tested recovery candidate,
complete the actual gates, and record the installed/staged source identity.
The [documentation and identity checklist](research/continuations/20261023-parallel-graphs-a/current-documentation-recovery-proposal-01/APPLICATION_AND_IDENTITY_CHECKLIST.md)
states the distinction between source equivalence and execution history.

The axiom baseline is `propext`, `Classical.choice`, `Quot.sound`.
The bundled checker replays through the installed Lean kernel; it is not an
independent verifier implementation. External Python computations are evidence,
not Lean proof terms. Existing workflows remain manual-only; this checkpoint
does not enable paid services or automatic CI.

## Preserved records

`STATUS.md` retains the older dated record verbatim. Earlier open-obligation
and build records describe their own checkpoints and must be read with the
current status above.

The frozen undated manuscript is
`verification/v4/output/D1_bound5-v4.tex`, SHA256
`776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`.
