# Exact low-degree half-binomial convolution factorizations

17 October 2026. Pinned Lean 4.33.1 / mathlib 0df444a360eaa60ab8c11dca51a86af692955474. Independent isolated proof unit for frozen v4 `eq:integrated-5`.

Define `b_n = Ring.choose (1/2 : R) n` and, for complex x and y,

    c_n(x,y) = sum_{i+j=n} (b_i*b_j : C) * x^i * y^j.

The new Lean theorems establish exactly

    c_2(x,y) = -(x-y)^2/8,
    c_3(x,y) = (x^2-y^2)*(x-y)/16,
    c_4(x,y) = -(x-y)^2*(5*x^2+6*x*y+5*y^2)/128.

These are the three expressions in frozen v4 `eq:integrated-5` and hold for arbitrary complex x,y, including zero and equal variables. Proof uses the existing exact half-binomial recurrence to show `b_0=1`, `b_1=1/2`, `b_2=-1/8`, `b_3=1/16`, `b_4=-5/128`; finite antidiagonal evaluation and the commutative ring normalization tactic then establish the factorizations. The source makes no extra mathematical assumptions. These low-degree expressions are relevant to the interpolation parameter estimates, separate from the earlier general sharp absolute convolution bound and the still-unfinished global D(1) bound.

## Exact source and verification

- Isolated proof source `LowDegreeConvolutionTrial.lean`, SHA256 `35d553182396ffbb42eaa90a0da0118d2bd6e9864b27227089d575b2c55e2bc9`.
- Trial01 `LEAN_NUM_THREADS=1 lake env lean .../LowDegreeConvolutionTrial.lean` EXIT 1. It left unsolved `Ring.multichoose` normalization goals; the resulting `sorryAx` printout was *not* accepted. No theorem hypothesis was changed.
- Trial02 with the recurrence-based coefficient proofs EXIT 0. Exact elaborated types for all three assertions and their complete `#print axioms` lists were obtained: each depends only on `propext`, `Classical.choice`, `Quot.sound`.
- Separate pinned `.olean` compilation of the same source EXIT 0, with the same explicit type/axiom log.
- Static forbidden-token scan of the final source found no `sorry`, `admit`, `sorryAx`, custom axioms or native-evaluation shortcuts.
- Targeted additional `leanchecker --verbose exploration.LowDegreeConvolutionTrial` was PRE_EXECUTION_DENIED by the external tool safety check before execution, with no PID or exit code. It was NOT run or rerouted. See the run-specific refusal record.

## Integration and publication boundary

The source is isolated in `research/`, not root-imported. Its local `private` helper definition must be reconciled with the existing separately verified `halfBinomialWeightedCoeff` when the latter becomes a root dependency. The previous author's staged index (24 paths) was left byte-for-byte unchanged. No local commit or private Git push occurred. The read-only source/import audit currently exits nonzero because another worker's pre-existing, unimported candidate `D1Bound5/HalfBinomialAnalytic.lean` lives under the accepted module directory. This is a pre-existing integration-status warning and not a Lean error in the new isolated proof. Current local and remote main remain identical at `bc07809978bb7b82c46eb94189dcff1f9fa64d5d`, destination verified PRIVATE with ADMIN permissions.

The three results form a completed isolated mathematical proof unit; the additional same-kernel replay, canonical root integration, updated fingerprints, Git publication, independent review and clean-checkout validation remain pending. `MainStatement` remains unproved.
