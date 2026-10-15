# Open mathematical obligations

The main theorem is UNPROVED in Lean. None of the items below is assumed
as a custom axiom or silently supplied as a hypothesis of a claimed proof.

## Full-ring bridge: now proved

The continuation constructs the full ring equivalence for every imaginary
quadratic field, including squarefree d, tau=0/1 and the exact half-integral
branch. It identifies coordinate, integral algebraic and complex squared
norms. No bridge assumption is inserted into the final target. See
`full-ring-bridge.md` and the latest build/axiom/replay record.

## Analytic and structural arguments

`lem:irregular-growth` and its exact quadratic inequality are now proved
in every imaginary quadratic full integer ring. `lem:tail-irregular` is now compiled in full, including its finite C<4
case and D>2BC for B>=3. The arithmetic nonsingularity assertion for
even-dimensional root matrices is also compiled, with its integral-modulus
lower bound. Complete the analytic determinant size and gap bounds,
interpolation identities and analytic remainder estimates. The extension-product identity is connected to the norm bound and the
full real endpoint proof; it is no longer the only completed part of
`lem:irregular-growth`.
Prove the explicit ordinary and finite approximation families and their
coefficient, divisibility, determinant and remainder bounds.

Bennett's arbitrary-order determinant identity is a genuine dependency.
Tests at small orders are not a proof for all orders. Prove the required
identity (or an equivalent replacement) with its exact normalization and
hypotheses. The generic interval-chain lemma now proved does not discharge
this dependency or the domain-specific interval estimates.

## Finite computations and completeness

The exhaustive disk enumeration and full-ring square-test criteria are now
proved. The complete small-tail exclusion is proved directly over all
thirty normalized models, avoiding a symmetry-classification dependency.
Its list coverage and full Boolean checks have kernel proofs. The six old
modular obstructions alone were insufficient; the new certificate closes
that gap. See tail-complete-proof.md and the current validation receipts.

Complete the analytic contraction in `sm:bs7-descent`, its well-founded
termination, and reverse-chain coverage of the bounded extension sets.
The mutation and inverse identities are already proved without division.
Prove that every admissible vertex and relevant edge is represented by the
checked graph, including zero/anchor-coincident intermediate extensions.
Then kernel-check the compact certificates. Do not scan a disk of radius
10^550 naively, and do not use native-evaluation axioms as final evidence.

The historical graphs, exceptional product-minus-one pairs, Pell/continued-
fraction enumeration, small triple orbits, forty first-pair representatives,
fifty-six triples, and rational pair (1,3) require full coverage arguments.
No large historical graph was regenerated during the initial local session.

The rationality part of `lem:pr-one-three` is now proved both in every
positive-discriminant coordinate model and in the full integer ring of
EVERY imaginary quadratic field. The separate signed-cardinality argument
remains open. See `one-three-proof.md` and `full-ring-bridge.md`.

## Final assembly and release gates

Prove the three main exclusions: no small entry, exactly one small entry,
and at least two small entries. Then use the proved sextuple reduction.
Re-audit the fully elaborated target and transitive dependency closure.
Require an independent statement back-translation, clean-checkout build,
reproducible certificate checks, and final kernel replay.

No independent reviewer or paid agent was used in this session.
Prove2Me is deferred until local completion; no mission has been opened.
The v4 proof does not use He-Togbe-Ziegler, and that dependency has not been
introduced into the Lean project.
