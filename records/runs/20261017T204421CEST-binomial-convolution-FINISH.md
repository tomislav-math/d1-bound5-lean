# FINISH — isolated half-binomial convolution

Outcome: PARTIAL. Mathematical proof unit completed in an isolated Lean file, but root integration, fresh same-kernel replay and Git publication were deferred to avoid interfering with a concurrent project worker.

Local time: 2026-10-17 20:57 CEST. Source: research/continuations/20261017T204421CEST-binomial-convolution/HalfBinomialConvolutionTrial.lean. SHA-256: 8c007f6e1ffb64ec58247ba7460e942af98ca9f43b962fbed033821a5c48c61a.

Proofs: exact half-binomial recurrence at all n and vanishing degree-n convolution for n >= 2. Final isolated pinned Lean elaboration EXIT 0, and #print axioms lists only propext, Classical.choice and Quot.sound. The recurrence overlaps another worker's ongoing half-binomial proof, so only the convolution specialization should be considered for future unique integration. The square-root coefficient absolute convolution bound remains OPEN.

Concurrency: a separate tail-identification worker had an active leanchecker process at the last inspection. No additional compiler was started, no worker was killed or disturbed, and no root file or Git index was changed by this run.

Git: read-only preflight PASS, PRIVATE tomislav-math/d1-bound5-lean, ADMIN access, local and remote main both 2d293ea9000afaa71ff6102f8ec4a8240e0e5cc7, one preexisting staged historical POST_PUSH record preserved. This run made no commit or push. The isolated source and records remain local and unsynchronized.

Remaining gates: when no other writer is active, choose a unique convolution-only root declaration, recompile the exact source, perform transitive axiom and fresh installed same-kernel replay checks, audit source/imports and fingerprints, then attempt an ordinary reviewed private non-forced Git sync. The general coefficient sign and norm estimate, full eq:coherent-tail application, Bennett identity, exhaustive finite descent/coverage, final sextuple exclusions and MainStatement remain unproved. No fresh clean checkout or independent review is claimed.
