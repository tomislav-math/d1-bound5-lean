# Finite weighted-pole remainder limit (17 October 2026)

## Precise result

Let S be an arbitrary finite index set, let a_i,w_i,z be complex numbers, and assume |z| < |a_i| for each i in S. Then

    lim_(n -> infinity) z^n * sum_(i in S) w_i / (a_i^n * (a_i-z)) = 0.

No distinctness, nonemptiness, or nonzero-weight assumption is needed. The hypothesis implies all necessary nonzero denominators for i in S. This convergence is for each fixed finite node configuration; no parameter-uniform estimate is claimed.

## Proof mechanism

The algebraic identity

    z^n * w_i / (a_i^n * (a_i-z)) = (z/a_i)^n * (w_i/(a_i-z))

allows the geometric limit theorem for each i, because |z/a_i|<1. Finite-sum continuity yields convergence of the rational remainder. The Lean proof uses tendsto_pow_atTop_nhds_zero_of_norm_lt_one, tendsto_finsetSum, and ring normalization.

## Formal status and next dependency

Corrected isolated source WeightedPoleLimitTrial02.lean compiled with pinned Lean 4.33.1 (exit 0, 34.91 s). Its printed transitive axioms are exactly propext, Classical.choice and Quot.sound. An earlier trial without the complex normed-ring import failed and remains saved. Root source is D1Bound5/WeightedPoleLimit.lean and the root import is in D1Bound5.lean. Integrated compilation, dedicated axiom audit, kernel replay and current-source manifest validation are separate gates.

The result complements the exact finite partial-fraction identity weighted_poles_finite_tail. A further formal step should establish its associated infinite-series HasSum identity, then relate reciprocal Lagrange coefficients to the homogeneous-polynomial generating series, and finally address the stronger square-root remainder inequality of the frozen manuscript. The arbitrary-order Bennett determinant, complete certified finite descent and sextuple exclusions remain open. MainStatement is UNPROVED.

## Completed formal verification

- Corrected isolated trial: pinned Lean EXIT 0; allowed transitive axioms only.
- Root-integrated command: lake build D1Bound5.WeightedPoleLimit D1Bound5, EXIT 0, 3057 jobs.
- Dedicated exact-type and transitive-axiom audit: EXIT 0, only propext, Classical.choice, Quot.sound.
- Fresh installed same-kernel target-closure replay: EXIT 0, 409.32 seconds.
- Root source/import coverage: SOURCE_AUDIT_PASS, 92 modules and 413 explicit theorem declarations.
- NOT performed: fresh clean checkout, independent formal proof review, whole-root fresh kernel replay, SHA-256 manifest refresh, authorized Git commit and verified remote push. Git preflight invocation was blocked before execution; see the PRE_EXECUTION_DENIED record.
