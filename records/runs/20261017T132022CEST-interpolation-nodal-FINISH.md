# FINISH — all-order nodal interpolation recurrence and uniqueness

Outcome: PARTIAL (five Lean theorems proved and isolated-kernel replayed;
root integration explicitly denied before execution).
Observed start: 2026-10-17 13:20:22 CEST.
Last completed read-only private Git preflight: 2026-10-17 13:31:54 CEST.
Branch: main. Base HEAD: e0f90380049e2e9d64e8f1ca06302202a2868c68.

## Substantive new mathematics
For an arbitrary field, finitely many nodes a_i (including repetitions
and zeros), arbitrary weights b_i, and M_n = sum_i b_i a_i^n, let
Q(T) = prod_i (T-a_i) = sum_{k=0}^m q_k T^k, with m the number of indices.
Then all n >= 0 satisfy sum_{k=0}^m q_k M_{n+k}=0, whence
M_{n+m}=-sum_{k<m} q_k M_{n+k}. The first m moments uniquely determine
the whole sequence. The same equation is specialized to the ordinary
Lagrange barycentric moments, with no artificial node restrictions.
All five declarations are proved in
research/continuations/20261017T132022CEST-interpolation-nodal/InterpolationNodalRecurrenceTrial.lean.
This uses existing mathlib Lagrange.nodal instead of re-proving it.

## Trust and completeness evidence
- Pinned isolated trial01 EXIT 1 (ambiguous inferred rewrite).
- Corrected trial02 EXIT 0 (first four theorems).
- Trial03 EXIT 0 (all five with displayed exact elaborated types).
- All five transitive axiom lists contain exactly allowed axioms:
  propext, Classical.choice, Quot.sound.
- Isolated .olean build EXIT 0.
- Installed same-kernel leanchecker --verbose
  exploration.InterpolationNodalRecurrenceTrial EXIT 0.
- Trial and preserved research source SHA256:
  60672c5bfc19f671c1309378cb39a5056257989c83e5bf935ff63bf9db32b6da.
- Existing root source/import audit: PASS, 82 modules, 387 theorems.
- Both private Git preflights PASS; private destination and ADMIN confirmed.
  Git synchronization after this record is still pending, to be reported
  only after actually completed commit, push and read-back.

## Precise boundary
New accepted root module was not created. The ordinary attempt to copy
the novel isolated trial to D1Bound5/InterpolationNodalRecurrence.lean
was PRE_EXECUTION_DENIED by tool safety with no PID, no shell exit code
and unknown cause. See companion evidence record. No alternate action
was used to obtain that denied root integration. The accepted theorem
count is unchanged. The source is preserved separately under research/,
and all test logs are preserved there, outside the accepted import graph.

No new integrated project build, whole-root kernel replay, independent
statement review, clean-checkout validation or complete final theorem.
The explicit higher-order hsymm formula, analytic binomial tail,
arbitrary-order Bennett determinant, fully justified finite coverage
and descent, sextuple exclusions and MainStatement remain UNPROVED.

Next: integrate this already proved standalone unit when legitimately
possible, and derive the reciprocal-anchor complete homogeneous
interpolation moment formula with its original hypotheses. The existing
hourly task, pinned dependencies, frozen manuscript, handoff, Freiman
projects and other automations were not changed.
