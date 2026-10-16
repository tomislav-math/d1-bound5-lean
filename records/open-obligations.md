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
lower bound. The four-by-four simultaneous symmetric integral sign
selection is now proved for all pair products of modulus at least 9,
including independent complex square-root choices. The A>=3 four-by-four L2 spectral perturbation estimate now follows
from three kernel-proved permutation-matrix matchings and the uniform
entrywise error bounds. The mixed-row A>=1,B>=3 sign choice and its
weighted operator-norm estimate remain open. The reference matrix H=(J_4-I_4)/2 now has a proved explicit inverse, det H=-3/16 and exact adjugate entries. The sharp spectral norm `‖halfOffDiagonalInverse‖=2` and the contraction bound `‖halfOffDiagonalInverse*(F-halfOffDiagonal)‖<1` under the previously proved uniform error hypothesis are now proved. The *perturbative* adjugate/determinant upper bounds and the weighted A>=1,B>=3 branch of lem:product-four remain open. Complete the analytic determinant size and gap bounds,
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


### Auxiliary statement packaging

Before using `full_ring_negative_integer_square` as a fixed-field
classification, strengthen its conclusion to retain the ring equivalence
and a single field parameter d uniformly over the negative integers.
The existing conclusion forgets that identification. Its coordinate
lemmas are available; the complete tail and even determinant do not use
the weaker wrapper. See the latest statement-review entry.

## Quantitative matrix perturbation update (16 October 2026)

The four-by-four normalized matrix's nonsingularity and the inverse bound `‖F⁻¹‖<8/3` for `‖F-(J-I)/2‖<1/8` are now proved without extra mathematical axioms. The simultaneous signed-root construction has a formally proved corollary with the same inverse bound when all pair products have modulus at least nine. For `lem:product-four`, the still essential next proof unit is the **upper** bound `|det F|<hs³` and `‖adj F‖<hs²` from the singular-value perturbation estimates, followed by the rank-one determinant estimate and the separately required weighted `A≥1,B≥3` branch. The current inverse estimates alone do not prove either product-four inequality.
