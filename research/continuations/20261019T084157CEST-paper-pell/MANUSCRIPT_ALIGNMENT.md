# Focused alignment with the frozen v4 manuscript

## Scope and evidence

This note answers the author's 19 October 2026 question about following the article with justified local adaptations. It is a focused comparison of the current unit-pair/Pell branch, not a new independent review of the entire formalization or a claim that every historical deviation was necessary. The immutable source is `/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex`, SHA256 `776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`. The passage read in this run is lines 2567–2732, especially labels `sm:five-unit-cubic` and `sm:bs7-unit-pair`. No manuscript change is made.

## Preserved mathematical structure

The article's unit-pair branch first classifies the axes and the common field parameter, excludes mixed axes and unsuitable parities, proves cubic growth and its three-step iteration, derives the first-extension bound below 10^4, and reduces to squarefree 7 <= d < 10000 with d congruent to 7 modulo 8. It then computes every norm-two Pell extension in the closed radius-10^550 disk by ordinary continued fractions, tests the signed graph, and combines the absence of triangles with the previously established size cutoff.

The corresponding working chain is `UnitPairSymmetric`, `UnitPairArithmeticModel`, `UnitPairRealReduction`, `UnitPairCubicNumeric`, `UnitPairCubic`, `UnitPairCubicIteration`, `UnitPairFirstExtensionBound`, `UnitPairFieldBound`, followed by the Pell continued-fraction and matching certificates. This preserves the full ring, all field parameters, both signs, equal-modulus allowance before exclusions, and zero square witnesses. Generic scalar or abstract-ring lemmas are intermediate dependencies; their extra premises must be discharged at the full-ring endpoints.

## Actual local adaptations, with reasons

**Cubic gap.** In `sm:five-unit-cubic`, the article defines analytic square roots and estimates the even binomial series for L = u+v-2z. The current `UnitPairCubic` keeps this same cancellation form, the same square equations u^2=z^2+w and v^2=z^2-w, the same nonvanishing argument, the integral lower bound |L|>=1, and the same endpoint D>C^3/2. It chooses signs of existing integral roots using `exists_sign_root_perturbation`, then uses the exact identity 2zL = -((u-z)^2+(v-z)^2). This avoids an additional branch-membership/series argument in this local lemma. `UnitPairCubicNumeric` proves the remaining rational inequalities with no new premise in the actual tuple endpoint. This is a genuine local alternative proof, not a literal translation of the binomial estimate. It is justified by retaining the same objects, mechanism and required conclusion; no claim is made that the alternative was mathematically unavoidable.

**Symmetric obstruction.** The article temporarily adjoins -b to permit swapping a and b. The formal proof `discrete_unit_pair_symmetric_obstruction` splits on the ordering of their moduli and uses the square witnesses for the appropriate entry. It uses the article's same factorization (G-J)(G+J)=(a^2-1)^2 and the same integral contradiction, without constructing an auxiliary larger tuple. This is bookkeeping, not a different exclusion strategy.

**Pell enumeration.** `PellLightCF` uses the article's integer m,Q,a recurrence and the same numerator/denominator recurrence. The stored preceding/current convergents account for the shifted initial indexing. The numerical cutoff X=10^275 is exactly floor(sqrt(10^550+1)); the original completeness bridge handles the closed endpoint and signed solutions. A checked prefix may contain a few steps beyond the first crossing, but solutions are filtered by p<=X and the final p>X is proved. Completeness is supplied by the existing continued-fraction/Legendre and stopping lemmas, not inferred from a long enough empirical trace.

**Graph exclusion.** The article tests both signs and reports that the only edges are x--(-x). The light certificates prove for every pair of different positive magnitudes x,y that xy+1 is not an ordinary square and xy-1 is not d times a square. They use finite square-residue masks, whose validity is proved, as witnesses of these negative square tests. The complete triangular list shape is checked recursively. The soundness bridge transports these checks to the original square criterion; the signed-graph theorem then supplies the no-three conclusion. This replaces an external numerical square test by kernel-checked arithmetic, without deleting vertices, signs or edges needing examination. Success of one field does not establish the 1016-field aggregate.

**Pure-Init and subdivision.** Integer lists and modular masks live in small modules importing `Init`, with proved bridges to the original mathlib-facing definitions. The current field-specific and 16-parameter blocks change compilation granularity, not the mathematical domains. Every subcertificate must still be joined into the original full-ring endpoint. No aggregate is claimed solely from the number of prepared or compiled modules.

## This run's new proof work

The unchanged modules `PellLightMatchingField23` and `PellLightMatchingField31` check all 13366 and 3081 unordered distinct-magnitude pairs, respectively, on lists of 164 and 79 magnitudes. `PellLightPrefixData6` and `PellLightPrefixData7` check the next 32 field-specific continued-fraction prefixes. The exact types, source hashes, compilation results, transitive axioms and targeted installed-kernel replay receipts are stored separately. Counts obtained by parsing source lists are corroborating metadata, not substitutes for the checked theorems.

## Remaining limits

The current work does not by itself establish every finite certificate, any unbounded enumeration by brute force, the complete unit-pair exclusion, root integration or MainStatement. The final manuscript-to-root statement audit, independent review, clean-checkout build and full kernel/axiom gates remain necessary. Future nontrivial deviations should name the replaced manuscript step, preserve its required endpoint and record a concrete formalization reason, rather than silently substituting an unrelated route.
