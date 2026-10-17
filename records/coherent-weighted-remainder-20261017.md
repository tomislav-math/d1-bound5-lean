# Weighted complete-homogeneous interpolation remainder — 17 October 2026

Source: `D1Bound5/CoherentWeightedRemainder.lean`. The root imports this module, which depends on `D1Bound5.CoherentMajorant` and the verified complex homogeneous norm bound. The isolated source is `research/continuations/20261017T201654CEST-coherent-remainder/CoherentWeightedRemainderTrial.lean`.

## Exact mathematical theorem

Let `I` be a nonempty finite index type, `a : I -> C`, `f : N -> C`, and `m : N`. Let `C0,rho,t >= 0`, assume `|a_i| <= rho` for every index and `rho*t<1`, and assume for every `j>=0` that

    |f_(m+j+1)| <= C0 * t^(m+j+1).

Then the complex series of weighted complete homogeneous coefficients

    sum_(j>=0) f_(m+j+1) h_(j+1)(a)

is absolutely summable, and its norm is bounded by

    C0 * t^m * ((1-rho*t)^(-|I|) - 1).

This is the exact geometric/homogeneous summation factor in equation `eq:coherent-tail` of the immutable v4 manuscript. When the separate square-root coefficient estimate `|f_n(x,y)| <= 4 |binom(1/2,m+1)| P^(-n)` for all `n>=m+1` is formalized, substitution `t=1/P`, `rho=1/A_1` and `C0=4|binom(1/2,m+1)|` yields that inequality. **The square-root coefficient estimate is still OPEN; no unconditional manuscript tail bound is claimed here.**

## Proof method

Combine the exact complex hsymm monomial count with `negative_binomial_positive_tail_tsum`, use pointwise multiplication of the coefficient estimate and homogeneous polynomial bound, obtain norm-summability by a nonnegative series comparison, and apply the norm estimate for `tsum` followed by the exact negative-binomial tail identity. No node distinctness or nonvanishing is needed. The only extra mathematical hypotheses are those explicitly present in the theorem type.

## Verification status

- Isolated pinned Lean 4.33.1 elaboration: EXIT 0 on the repaired third trial, exact type and allowed axioms printed.
- Pinned integrated `lake build D1Bound5.CoherentWeightedRemainder D1Bound5`: EXIT 0, 3060 jobs, log `research/continuations/20261017T201654CEST-coherent-remainder/integrated-build.log`.
- Dedicated `scripts/CoherentWeightedRemainderAudit.lean`: EXIT 0, transitive axioms only `propext`, `Classical.choice`, `Quot.sound`; log `axiom-audit.log`.
- Source/import audit: EXIT 0, 95 modules and 417 explicit theorem declarations.
- Installed fresh same-kernel replay: EXIT 0, `lake env leanchecker --fresh --verbose D1Bound5.CoherentWeightedRemainder`, runtime 467.12 s, log `kernel-fresh.log`. This is not an independent external review.
- Source and verification-tool SHA-256 manifests: both EXIT 0, with 98 proof source/configuration records and 54 verification-tool records. Source/import audit EXIT 0, 95 modules and 417 explicit theorems. Read-only private Git preflight PASS with matching local/remote starting HEAD and ADMIN permission. Git commit/push status is recorded separately; a preflight PASS is not publication.

No source in the frozen manuscript or handoff changed. No independent statement review or clean-checkout build has been performed; `MainStatement` remains UNPROVED. Further dependencies include analytic binomial convolution bounds, Bennett's arbitrary-order determinant, formally complete finite descent/coverage, and the final sextuple exclusions.
