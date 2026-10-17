# All-order interpolation weights — proof record

Status: COMPLETED_UNIT. Integrated root build, complete 22-declaration type/axiom audit, fresh same-kernel replay, source/import scan and both strict fingerprint checks PASS. MainStatement remains UNPROVED.

## Mathematical result

For every field F, nonempty finite index set S, pairwise distinct node values a_i, and k>=0, the Lagrange moment of degree card(S)-1+k is exactly mathlib hsymm_k evaluated at the nodes. Zero node values are allowed. For pairwise distinct nonzero anchors, the negative-power sum equals (-1)^(card(S)-1)/product(a_i) times hsymm_k evaluated at their reciprocals. This is the arbitrary-order n>=m interpolation-weight branch in frozen v4 before eq:coherent-exact.

Nine genuinely new theorem declarations were proved. Twelve previously separately verified current-continuation theorems were root-integrated and rechecked, without counting them again as new. The five modules contain 21 theorems plus one definition. The conservative source scanner counts 407 lexical theorem declarations in 87 root-imported modules; its count does not count an attribute-prefixed theorem on the same line.

## Canonical accepted-source candidates and SHA256

- `D1Bound5/HomogeneousSymmetric.lean` — `9ca0c1b5630feef5d0a34c972d9c43d84be51f3ce74b855f5c9873ea76bd8466`
- `D1Bound5/LagrangeAdjunction.lean` — `8078b0e0b630a0efdfdb1b29b441485777d7118007ce69e74197ac884086e248`
- `D1Bound5/LagrangeHomogeneous.lean` — `b4a9130e2e09325e0a7c90a60c13433e1e3d45746589329d45719e084b45b442`
- `D1Bound5/ReciprocalAnchors.lean` — `0eef21f646e4e303b7482f6be00f9e043fad50634704078870004bfb326da97b`
- `D1Bound5/InterpolationWeights.lean` — `f0694cf6e24749b6ebbea5b804a44acbab942bf3fc03c6d3a67996fffcda18a7`

The two recovered module bodies are byte-identical to their current-continuation sources after removal of trailing #check/#print audit directives. No research/snapshots module or exploration import is an accepted proof dependency.

## Actual checks

- Initial Lagrange adjunction trial: PID 91227, EXIT 0, 30.73 seconds.
- First two all-order bridge trials: actual Lean type/API errors, EXIT 1; repaired without changing theorem hypotheses. Corrected trial03: PID 91547, EXIT 0, no warnings.
- First root integration: PID 91345, EXIT 0, 3048 jobs.
- Final root build `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.InterpolationWeights D1Bound5`: PID 91597, EXIT 0, 3051 jobs. New modules compiled without warnings; existing unrelated root warnings were retained.
- `lake env lean scripts/InterpolationWeightsAudit.lean`: PID 91734, EXIT 0. All 22 exact declaration types exposed and their complete transitive axiom lists enforced to be subsets of {propext, Classical.choice, Quot.sound}.
- Source/import coverage PASS; strict SHA256 checks PASS for 90 source/config and 47 verification-tool entries.
- Fresh installed kernel replay of D1Bound5.InterpolationWeights and its full imported closure: PID 91788, EXIT 0, output collected, runtime 267.27 seconds. This is the SAME installed Lean kernel, not an independent implementation, reviewer, clean checkout or whole-root replay.

Full sources, failed and successful trial logs, exact-type output and authoring statement review are in `research/continuations/20261017T164243CEST-interpolation-recovery/`.

## Remaining dependency

The combinatorial all-k moment/hsymm identity is now proved, rather than deferred again. Next prove the complex hsymm norm envelope and analytic interpolation remainder/summability estimates. The arbitrary-order Bennett determinant, exhaustive finite checker coverage, descent termination, final sextuple exclusions and the faithful final MainStatement proof are still open.

Frozen handoff/manuscript and pins unchanged. No permissions, automations, paid API agents, CI settings, unrelated projects or remote credentials were altered. A direct out-of-environment leanchecker --help diagnostic returned an object-search exception; it was not a proof replay and is not counted among the passing checks. The proper pinned lake-env replay is recorded separately.
