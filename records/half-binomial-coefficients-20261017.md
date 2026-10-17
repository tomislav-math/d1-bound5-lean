# Half-binomial coefficient sign and monotonicity — 17 October 2026

## Mathematical statements

Put `b(n) = Ring.choose (1/2 : R) n` for real `R`. The new root-imported module `D1Bound5/HalfBinomialCoefficients.lean` proves, without additional mathematical axioms:

* `(n+1) b(n+1) = (1/2-n) b(n)` for every natural n.
* `0 <= (-1)^n b(n+1)` for every n. Thus the signed coefficients alternate from positive degree one onward.
* `|b(n+1)| <= |b(n)|` for n>=1, and `|b(k)| <= |b(j)|` for every 1<=j<=k. In particular `|b(n)|<=1/2` for n>=1.
* For i,j>=0, `0 <= (-1)^(i+j+2) b(i+1)b(j+1)`. This is precisely the common sign needed for all interior terms of the square-root convolution.
* `sum_(i+j=n) b(i)b(j)=0` for n>=2, by the exact Chu--Vandermonde identity `(1+T)^(1/2) (1+T)^(1/2)=(1+T)` at the formal coefficient level. The convolution-zero result was already separately checked in the 20:44 continuation; this root integration does not count it as an independent discovery.

The first three groups and common-sign specialization supply direct dependencies of the outstanding concrete coefficient envelope in v4 `eq:coherent-tail`: derive `sum_(i+j=n) |b(i)b(j)| = 4 |b(n)|` for n>=2 by splitting off both endpoints and using the signed cancellation, then combine with `|x|,|y|<=1/P` and `|b(n)|<=|b(m+1)|` for n>=m+1. This sharp absolute convolution equality, complex coefficient envelope, and the analytic sqrt-series identification remain OPEN and must not be inferred from the new theorems alone.

## Recorded verification

Toolchain `leanprover/lean4:v4.33.1`, mathlib pin `0df444a360eaa60ab8c11dca51a86af692955474`, no pin changes. Built the existing pinned Mathlib.RingTheory.Binomial dependency (1438 Lake jobs, exit 0). Isolated trial was repaired and compiled with exit 0, exact elaborated types and allowed transitive axioms shown in output. The imported project root build succeeded with 3064 jobs, exit 0. `scripts/HalfBinomialCoefficientsAudit.lean` compiled with exit 0 and enforced all seven transitive-axiom lists to contain only `propext`, `Classical.choice`, `Quot.sound`. Targeted SAME installed Lean-kernel replay `lake env leanchecker --verbose D1Bound5.HalfBinomialCoefficients` exit 0. The source/import audit passed: 96 root modules, 424 explicit proved theorem declarations. No independent reviewer, full fresh clean-checkout build, whole-root replay, or MainStatement theorem has been claimed.

Root source SHA256 `97b0412384b100b3ac306cb8297135156f099ce2af7ece88037027b2b15bd23b`; root import SHA256 `7d1fbe2f0288a74438a7de0d62a44c2237776a681281ac7ba622ce7b7cfac389`; audit source SHA256 `a088a47f09a1adb5273555149e6a9f961ab56ace6a85f9c449df37b74ec06276`.

## Publication boundary

The existing source/tool fingerprints have not yet been refreshed to this newly built root. Read-only `git_sync_preflight.py` returned `PREFLIGHT_FAILED_NO_MUTATION` with `Unmatched fingerprint: D1Bound5.lean`; it is a stale manifest, not a proof error. An independently started 21:30 PRIVATE Git synchronization writer is reviewing all pending sources, staged receipt, and manifest updates. Its files, index and Git operation have not been altered by this proof run. Until a verified reviewed commit and push are independently observed, this new module and this record are LOCAL ONLY; no GitHub publication is claimed. A future sync must refresh/check the exact manifest bytes after a successful current build, scan staged content, and use separate plain Git commands. No safety refusal occurred during this run.

MainStatement, the finite exhaustive certificate/descent coverage, Bennett's all-orders identity and all three sextuple exclusions are UNPROVED.
