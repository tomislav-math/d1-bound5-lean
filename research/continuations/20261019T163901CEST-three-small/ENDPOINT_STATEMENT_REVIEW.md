# Endpoint statement review

This is an in-conversation mathematical back-translation, not independent review. It must be paired with the actual type/axiom and kernel receipts.

## Full-ring bounded-extension theorem

Let K be a number field of rational degree two with no real embeddings, phi a complex ring embedding, and (a,b,c) three distinct nonzero algebraic integers with every pair product plus one a square in the full ring of integers. Assume all three complex moduli are strictly less than 3. A proper common extension z is nonzero, is distinct from each of a,b,c, and has az+1,bz+1,cz+1 square in that same full ring. Among proper common extensions satisfying |phi(z)|^2 <= 10^80, there is at most one; every such extension has |phi(z)| < 85. No existence of a further extension is asserted.

The input contains no particular quadratic field parameter, coordinate table, field-list completeness assumption, mutation-closure certificate, or analytic assumption. These are supplied by the actual dependencies. The coordinate equivalence covers the full ring, including the half-integral bases. Classification does not assume the triple is ordered.

## Ordered sextuple consequence

For an injective six-tuple of nonzero algebraic integers satisfying the full D(1) condition, ordered nondecreasingly by modulus, if the third entry has modulus below 3, the fifth modulus exceeds 10^40. The fourth modulus is either below 85 or above 10^40. The sixth entry has no upper-bound assumption. Tied moduli are allowed, and pair roots may be zero.

If the fifth modulus were at most 10^40, both the fourth and fifth entries would be distinct proper extensions in the closed disk, contradicting uniqueness. The fourth-entry dichotomy follows by splitting on its membership in that closed disk. These are consequences of the bounded finite theorem, not the final analytic exclusion of every three-small sextuple.

## Exhaustive computation and descent

The small-triple checker visits every ordered triple from each completely covered norm-at-most-eight disk. The 24 unordered full-ring triples are covered by the ten simultaneous-sign/conjugation orbits. The nonmaximal trace-zero model (0,4) is removed by the proved maximal-ring squarefreeness criterion.

For the ten representative triples, PairExtensionComplete proves completeness of the pair lists by strong induction on the nonnegative integer coordinate norm. Every extension outside the seed disk has a strictly smaller full-ring mutation, and canonical-root reversal places the original extension in the checked closure. Seed coverage, both mutation signs, the norm-10^80 boundary, the third-anchor filter and final removal of zero/anchor coincidences are separate checked assertions. Zero and anchor coincidences are permitted during descent. No brute-force radius-10^40 enumeration, Python trust, or native evaluation is used as a proof.

## Verification boundary

The fifteen selected modules and all their relevant source/import/artifact hashes are in scope. Their original theorem signatures are preserved separately and reasserted as exact universal types. The Q family is not imported into this branch and its previously refused audit is not repeated. Accepted-root integration, full clean-checkout validation, independent final review and the global cardinality theorem remain separate gates.
