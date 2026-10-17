# No four small entries: draft proof unit

Status: UNCOMPILED DRAFT. The coordinator is the sole remote writer and compiler.

Target: the cardinality assertion of manuscript Lemma 7.12, not the classification of its 24 small triples or the radius-10^40 extension lists.

## Complete mathematical strategy

1. Use the already proved full-ring quadratic coordinate equivalence with normalized trace tau=0 or 1, positive discriminant Delta=4nu-tau^2, and coordinate norm equal to squared complex modulus.
2. The strict modulus bound 3 is exactly the integral norm bound at most 8.
3. If Delta<=32, positivity and the normalized trace imply 1<=nu<=8. This gives sixteen models, deliberately including nonmaximal orders. For each model an explicit list is proved equal to the already proved exhaustive closed disk. A nested Boolean clique checker is proved sound from the necessary-and-sufficient square test. Both each disk equality and its no-four-clique output are checked with `decide +kernel`.
4. If Delta>32, the completed-square norm identity forces every small entry to have imaginary coordinate zero. Three distinct nonzero integers in [-2,2] always contain a pair of product 2. Its square condition would require 3 to be a square. The previously proved rational-square classification rules this out in every positive-discriminant quadratic coordinate ring.
5. Combine both cases, transfer actual square roots along the full-ring equivalence, and select four elements of the small-entry filter to obtain the finite-set cardinality bound at most three.

Files, in dependency order:
- D1Bound5/SmallQuadrupleCheck.lean: checker and mathematical soundness.
- D1Bound5/SmallQuadrupleData.lean: sixteen explicit norm-eight disks and kernel certificates.
- D1Bound5/SmallQuadruple.lean: large-discriminant argument, complete coordinate theorem, full-ring indexed and finite-set endpoints.

Important semantic safeguards: zero square roots are included; zero may occur in the disk list but is forbidden as a tuple entry; all distinctness tests are explicit; both trace models are handled; no squarefree assumption is added; no mutation/closure completeness claim is made; no native evaluation, sorry, axiom, or untrusted Python result enters the Lean proof terms.

A separate untrusted exact Python generation-time check confirmed all sixteen graphs have no four-clique. This is diagnostic only. Acceptance requires compiling the actual Lean files, checking exact endpoint types/transitive axioms, and replaying the kernel as required by the existing project policy.
