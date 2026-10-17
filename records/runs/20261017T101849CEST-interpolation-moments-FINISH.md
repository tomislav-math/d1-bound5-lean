# FINISH — arbitrary-anchor interpolation moments

Outcome: PARTIAL. Start 2026-10-17 10:18:49 CEST; final local checks
2026-10-17 10:32:46 CEST. Main worktree branch main, initial and current
HEAD a348619; no competing project-owned compiler observed.

## New proved mathematics

Five Lean theorems in `exploration/InterpolationMomentsTrial.lean` prove the
exact Lagrange weighted-moment cancellation for any finite injective set of
anchors over ANY field. In particular, for all m>=1, distinct a_i and
0<=n<m,

    sum_i a_i^(m-1-n) / prod_{j != i} (a_i-a_j) = (if n=0 then 1 else 0).

The stronger generic theorem identifies the sum of values of any polynomial
of degree <m weighted by inverse nodal denominators with its coefficient
of degree m-1. The two intermediate results give all n<m power moments,
strictly lower vanishing and the first nonzero moment. This is the exact
initial-term cancellation in the manuscript's `coherent-exact` formula.

## Trust and limits

Pinned `Mathlib.LinearAlgebra.Lagrange` target build EXIT 0, 1748 jobs;
trial07 `lake env lean` EXIT 0 for all five theorems; final isolated
elaborated-type/#print axioms replay EXIT 0. Only `propext`,
`Classical.choice`, `Quot.sound` appear. No sorry/admit, custom axioms,
or native proof shortcuts. Final trial SHA256:
`f4ed07c587c01039adc23a99c8b673f85aa037f1d10fd3422e87090564b636c7`.

Root integration into `D1Bound5/InterpolationMoments.lean` was
PRE_EXECUTION_DENIED, as recorded verbatim in PROGRESS. The denied command
was not retried or bypassed. Consequently these five are ISOLATED, NOT
ACCEPTED ROOT DEPENDENCIES, and do not increase the root theorem count.
Read-only root source/import audit PASS: 82 modules, 387 explicit theorems;
Git private/admin preflight PASS, with no staged changes at that check.
No new pinned ROOT build, target OLean replay, clean-checkout build, or
independent review was conducted. All previous accepted files and toolchain
pins remain untouched.

The full higher-order homogeneous symmetric polynomial identity,
analytic binomial-series remainder and interpolation bounds, Bennett's
actual arbitrary-order determinant, formal finite coverage/descent,
sextuple exclusions and MainStatement are UNPROVED.

The source remains saved on the Mac under exploration/. See the precise
mathematical and next-action description in
`records/interpolation-moments-20261017.md`. A separate Git outcome must
be recorded only after an actually executed commit/push. No change to
automations, frozen manuscript, handoff or separate historical worktree.
