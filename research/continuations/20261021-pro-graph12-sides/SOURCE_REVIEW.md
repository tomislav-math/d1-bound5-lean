# Graph12 side-source review

The existing sources are preserved byte-for-byte in originals/ and candidates/.
The model remains QuadInt 0 1. Both sides retain the original complete vertex
lists, sieve, cached signatures and floor-witness rows. Their exact consecutive
prefixes have 138 and 221 heads. Each prefix checks every selected head against
its entire original remaining tail. The consumers use the existing prefix/drop
lemma, the independently checked coverage and signatures, and an empty final
tail. No hypotheses, checker, data, theorem header or proof body is altered.

This is this continuation's source review, not an independent external audit.
The numeric data are not asserted correct from Python inspection. Acceptance
requires the actual guarded Lean builds, exact public-type/axiom checks, and
targeted installed SAME-kernel replay. No new mathematical axioms or native
computation shortcuts are introduced.

The graph35 publication preparation and graph48 assembly refusals are separate
recorded boundaries. Their denied operations are not repeated by this unit.
