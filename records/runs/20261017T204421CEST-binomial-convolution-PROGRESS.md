# PROGRESS — isolated half-binomial convolution

Pinned project: Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474. Source: research/continuations/20261017T204421CEST-binomial-convolution/HalfBinomialConvolutionTrial.lean; SHA-256 8c007f6e1ffb64ec58247ba7460e942af98ca9f43b962fbed033821a5c48c61a.

New mathematical statements:
1. (n + 1) choose(1/2,n+1) = choose(1/2,n) (1/2 - n), proved using Ring.choose_smul_choose.
2. For n >= 2, the exact finite half-binomial convolution sum over Finset.antidiagonal n equals zero, proved using Ring.add_choose_eq and Nat.choose 1 n = 0.

An initial Lean invocation failed because Mathlib.RingTheory.Binomial had no cached olean; its pinned target build then succeeded (1438 jobs, exit 0). The first elaboration identified an omitted noncomputable declaration marker and a mistargeted rewrite; both were repaired. Final isolated lake env lean invocation EXIT 0 in 101.13 seconds, exact checks reported correct types and only [propext, Classical.choice, Quot.sound] as axioms for both theorems. No sorry, admit, custom axiom or native trust shortcut.

Another worker independently started the half-binomial recurrence/absolute contraction shortly after this run, so the recurrence must NOT be counted as a separate new imported lemma. The convolution-zero specialization is the distinct result of this unit. A third worker developed a different full-tail identification; one compiler overlap occurred after both workers had independently observed an idle machine. Subsequent work stopped launching compilers until the others finished. Neither worker's files, staged item nor processes were changed.

The source is an ISOLATED VERIFIED trial, not yet a root-accepted module. No installed fresh leanchecker replay, source/import audit of a changed root, fresh clean checkout or independent reviewer is claimed. MainStatement, coefficient sign/envelope, Bennett, finite completeness/descent and final sextuple exclusions remain open.
