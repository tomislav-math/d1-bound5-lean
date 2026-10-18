# Public manuscript and literature audit

Audit date: 2026-10-17 UTC. Scope: read-only review of the actual public manuscript, proof dependencies, selected primary literature, and the exact extension-graph implementation. No remote files, Git state, or compiler processes were modified. The verification programs were inspected but not rerun by this auditor.

## Exact correspondence with the frozen formalization baseline

- Frozen Mac file: `/Users/tp/Lean/D1Bound5Handoff/verification/output/D1_bound5-v4.tex`.
- Frozen SHA256: `776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3`, 158236 bytes, 3883 lines.
- Public file: <https://github.com/tomislav-math/diophantine-tuples-bound-five/blob/main/verification/data/article.tex>.
- Public SHA256: `3653744c838aa8daae33a6e0ce52bf64034f14142af27a2343af7fa6610fe95f`, 158434 bytes, 3885 lines.
- Public manuscript Git blob: `b3fc449fdf46c32ccfb921e3383e7de05063c225`; inspected public main tree: `77566a92fa44e77ffe60d8a6ea567fd16dd01ace`.

A complete read-only unified diff of the actual files found exactly two preamble changes. The public file adds two lines of PDF title/author metadata, and changes `\date{}` to `\date{15 October 2026}`. There are **no mathematical, terminological, proof, table, bibliography, or document-body differences**. The public manuscript and the frozen v4 are therefore the same mathematical baseline. Different SHA256 values must not be mistaken for a mathematical revision.

## Theorem fidelity

Theorem 1.1 bounds by five the cardinality of every finite set of distinct nonzero elements of the full ring of integers of any imaginary quadratic field whose pairwise products plus one are squares. Zero square roots and equal moduli are allowed. Half-integral full rings for squarefree d congruent to 3 modulo 4 are included. No unique-factorization assumption is used.

The enumerations use only simultaneous negation, conjugation, and stated permutations as symmetries. Arbitrary unit multiplication is not a tuple symmetry. The mutation closure must retain zero and anchor coincidences until generation has finished. Closed disk bounds and strict versus weak interval endpoints must be preserved.

## Main proof dependencies

| Closing result | Essential dependencies |
|---|---|
| Proposition 6.1, no six entries of modulus at least 3 | Structural Lemmas 2.1–2.5; coherent interpolation Lemmas 3.1–3.7; ordinary approximation Lemmas 4.1–4.4; the explicit finite families and interval chain in Section 5 |
| Proposition 7.1, at least two small entries | Proposition 7.11 for exactly two small entries; Proposition 7.14 for three; Lemma 7.12 excludes four small entries |
| Proposition 9.1, exactly one small entry | Proposition 8.1; Lemmas 8.2–8.3; the forty-pair enumeration; Proposition 8.4 giving S<15; the fifty-six-triple enumeration; the Section 9 cutoffs and finite complements |

The two-small-entry branch combines the analytic cutoff C<10^550 in Lemma 7.4 with reversible descent to radius 33 in Lemma 7.5 and 48 triangle-free extension graphs in Lemma 7.6. The pair {-1,1} is treated separately in Lemma 7.9, including Pell enumerations in 1016 fields. Lemma 7.10 treats the other product-minus-one pair in the Eisenstein ring. Lemma 7.12 classifies 24 small triples into ten orbits and determines their extensions through radius 10^40.

**He–Togbé–Ziegler is not a dependency.** Lemma 8.2 proves directly that common extensions of {1,3} in the full ring are rational and excludes the negative branch. The remaining positive case reduces to (1,3,8); Section 9 gives N(t)<1024, hence T<32, whereas Lemma 2.2 gives T>48.

## Checked literature and legitimate reuse

1. Bennett, *Simultaneous rational approximation to binomial functions*, p. 1721: equations (2.1), (2.4), and the following unnumbered determinant identity match Lemma 4.1 under nu=1/2, x=1/N, alpha_0=0, alpha_j=H/a_j. The clearing-factor powers and sign agree. Extension to complex interpolation points by clearing denominators is valid. The general identity still needs a verified formal proof/import; finite determinant examples do not establish it.
   - Author PDF: <https://personal.math.ubc.ca/~bennett/B-Binom.pdf>
   - DOI: <https://doi.org/10.1090/S0002-9947-96-01480-8>
2. Jadrijevic–Ziegler, Section 7, especially Lemmas 7.3–7.4: the same residue construction and nonzero integral linear-form argument appear there. The current paper proves its own sharper coefficient/residual bounds, which cannot be replaced merely by citing the older generic constants.
   - Author PDF: <https://mapmf.pmfst.unist.hr/~borka/files/PellEqIJNTV3_kopija.pdf>
   - DOI: <https://doi.org/10.1142/S1793042106000735>
3. Wildner Fraga's Lemma 3.1 at the pinned commit reproduces the elementary crossblock determinant argument used in Lemma 7.2. The relevant directory contains a README, not a Lean proof. Neither the quantitative Subspace Theorem nor the remaining preprint is required here.
   - Pinned source: <https://github.com/natanaelwf/Solving-Open-Problems/blob/768dda32edc7166f9dd094b419df250b1e008531/dujella-problems-1.12-1.13/README.md>

## Algebraic unit communicated to the crossblock worker

The determinant nonvanishing part of Lemma 7.2 only needs a field of characteristic different from 2, distinct nonzero a_1,a_2,a_3, distinct b_1,b_2,b_3, and r_ij^2=a_i*b_j+1. Roots may vanish; norms, ordering, and cross-group distinctness are unnecessary.

After ruling out proportional rows, determinant zero gives row_3=lambda*row_1+mu*row_2 with lambda*mu nonzero. Squaring twice gives the polynomial identity (P*X+Q)^2=L*(a_1*X+1)*(a_2*X+1), where L=4*lambda^2*mu^2 is nonzero; agreement at the three distinct b_j establishes the identity. Coefficient comparison yields P^2=L*a_1*a_2, 2*P*Q=L*(a_1+a_2), Q^2=L. A ring calculation gives L^2*(a_1-a_2)^2=0, contradicting distinctness. This avoids simple-root multiplicity or derivative APIs.

## Computational trust boundary

The public recorded run reports all eleven checks passed on 15 October 2026. The current extension-graph implementation uses exact integer square roots, parity/divisibility checks, exhaustive radius-33 seeds, reversible mutation closure, necessary modular filters followed by exact square tests, and separate Pell enumeration. It refuses Python optimization that would disable assertions.

For kernel verification, prove the exact arithmetic checker, closure completeness via descent, and the relevant graph/table certificates. Saved PASS outputs and assumptions encoding the tables do not constitute a complete Lean proof. This focused source/fidelity audit found no false external dependency, but it is not a new line-by-line adversarial audit of all 58 pages.

## Continuation review: fixed one-small closure (2026-10-18 UTC)

Independent source review of `OneSmallCutoffReal`, `OneSmallFixedWindows`, `OneSmallFixedForcedP`, `OneSmallFixedCutoffBound`, and `CoherentFixedCutoffNorms` passes mathematically. The thirteen exact scalar ratios agree with the actual interval endpoints, including both maxima in the adaptive P height, the retained B^8 in the N3bs upper endpoint, and the B^-2 in the ordinary lower endpoint. The latter explains the final powers B^38 and B^44. All denominator positivity, A>=1 weakenings, strict endpoint propagation, and the infinite ordinary-tail comparison are justified in the source. The norm-only retained interface avoids imposing a Gaussian coordinate equivalence on rational triples. This review does not claim compiler or kernel acceptance.

The new `one_small_final_next/OneSmallNormalizedImpossible.lean` joins the actual normalized first-triple classifier to the analytic cutoff and the finite fourth-extension bound. It retains the exceptional normalized triple (1,-3,3), discharged using the full-ring negative-extension cardinality theorem after simultaneous negation when needed. The remaining fifty-six rows contradict the actual tail-growth lower bound T>2BS. Both source_audit and analytic_bridge independently reviewed this join and found no mathematical narrowing. The file is an uncompiled draft pending the coordinator's serial compiler gate.

Frozen reviewed sources:

- `one_small_analytic_next/OneSmallCutoffReal.lean`: `c3fd64c816b205cf5f0f1c7739f8c65e8198f15f32c9bffa82e05c18065064ab`
- `one_small_analytic_next/OneSmallFixedWindows.lean`: `4cab391b30ca4f57f90cac8d6929aba7bb0fe668567d9763bdebf8a2db295a78`
- `one_small_analytic_next/OneSmallFixedForcedP.lean`: `0f1c437e6fa432ff503744ba82ecc981d5de74e3be300952d722d49bfd7291da`
- `one_small_analytic_next/OneSmallFixedCutoffBound.lean`: `54bd2f225b9c37831e6f97da104a574245e2048a8f956876837628301f35867b`
- `one_small_analytic_next/CoherentFixedCutoffNorms.lean`: `a2c6355e43cbb498322e219bd1a17e94145b88868193c734fda6fcb04e7a84c7`
- `one_small_final_next/OneSmallNormalizedImpossible.lean`: `ec0d24000fd3914a62dd4954db77c423a7cfd120a688d6cb997d165bd8d5f5fe`

## Continuation review: five-region coefficient heights (2026-10-18 UTC)

Read all six ratio-height modules and the generic homogeneous/scalar transfer. The proof correctly retains the anchor ratio |x|/|y|, sums the two actual root columns within each row, and rescales with T=|y||c|>=1000. The resulting B exponents for N2,N3,A3,A4,A5 are respectively 4,7,6,9,12, with C exponents 2,3,3,4,5. The factor101/100 occurs exactly once. No coefficient bound is supplied as an unproved hypothesis.

An independent parser and exact integer polynomial implementation compared all30 actual Left/Right matrix polynomials to their coefficient vectors; all identities agree. Exact Fraction arithmetic verified all75 row-wise inequalities at the five ratios 1/8,3/8,7/12,2/3,17/18, establishing all25 printed numerical bounds diagnostically. The smallest additive slack is approximately0.02698051115 (A3); all inequalities are strict. These diagnostics do not replace kernel compilation. Reproducer and exact rational results: `audit_next/verify_five_region_ratios.py` and `audit_next/five_region_ratio_review.json`.

Reviewed module hashes:

- `five_regions_next/FiniteHomogeneousRatio.lean`: `7ef8f6baf6a0fddb360b8b89002f6bea22472aaa7a5f9ae87ae0df426fd44b37`
- `five_regions_next/FiniteN2RatioHeight.lean`: `acd86dd6afa56a2834a76abb67f2f38aa493cf97b505b550e022ae5087305669`
- `five_regions_next/FiniteN3RatioHeight.lean`: `3b19adaab7a046dd5d462fa93e9c3522cc668117966f660bde17388fd5b6b587`
- `five_regions_next/FiniteA3RatioHeight.lean`: `27b2537a7291f46ba40ab2ef86114e00a54ab264d685714a04d6c04c48ccdc06`
- `five_regions_next/FiniteA4RatioHeight.lean`: `5b4df987c695c8badb9cb845a13bf985b590b3489fe278d2c79f92ce6c54bf5c`
- `five_regions_next/FiniteA5RatioHeight.lean`: `8156d75baff709c14412e760a3cd21347478682252984a16891c19eb1ddb572a`

## Continuation review: Pell prefix API preflight (2026-10-18 UTC)

Read the complete PellConvergentCompleteness, PellCFPrefixCheck, and PellFiniteCertificate sources and checked the relevant theorem signatures directly in the pinned Mac Mathlib source. One definite namespace issue was repaired: isCoprime_iff_nat_coprime belongs to namespace Int in Mathlib/RingTheory/Int/Basic.lean. The three call sites are now qualified, with an explicit import. All other inspected continued-fraction, floor, irrationality, rational-denominator, gcd, and full-ring square interfaces agree with their uses.

The certificate retains the inclusive trace0..N while completeness returns an index n<N because the stopping numerator exceeds X. The recurrence matches ordinary real continued fractions, and the absolute-value conversion preserves both Pell signs. Full-ring square interpretation uses the same model parameter d as the Pell solution list. No other speculative edits were made. This is a static review, not compiler acceptance; the finite CF pilot remains required.

- `pell_next/PellConvergentCompleteness.lean`: `49569135459e8ee8b110bb33b9ef83915e1cf00e121ae6bc047c10eccf8c8379`
- `pell_next/PellCFPrefixCheck.lean`: `f6e34479707c3fc69b0f9830fd82f97a10ee38c66fb5e75c971c541a3caf473c`
- `finite_next/unit_pell/PellFiniteCertificate.lean`: `2bf16b7db5d3fcd397b763bbabe27877978ae5f84daeba0bc35f5d4e2272764f`

## Exact two-color graph certificates (2026-10-18, isolated pilot)

The original lazy row41 triangle certificate timed out after600 seconds. Static
counting showed413,292 calls to the fast square test on372 vertices. An
independent BFS over all48 diagnostic exact graphs found every graph bipartite.
This observation is used only to prepare color masks; the proof does not assume
that any computed graph or coloring is correct.

The new generic `PairBipartiteCheck` partitions an arbitrary vertex list using
an arbitrary natural-number bit mask, proves unconditional coverage, checks each
unordered within-color pair once, and derives the original triangle Boolean.
Cross-color edges need no test. Duplicate values are allowed; equality is the
only skipped pair condition. Zero square roots remain accepted by the same
existing square test. No norm bound, closure vertex, or full-ring assumption is
changed. Source_audit independently read the full source and pilot integration:
mathematical PASS. Compiler acceptance remains pending.

The isolated row41 pilot has186 vertices in each class,34,410 unordered tests,
and1,694 diagnostic modular survivors requiring exact-root rejection. Its372
original large vertices were copied byte-for-byte. Data, left-class check,
right-class check, and aggregate proof are separate targets. A second isolated
set exposes the original seed, closure, and filter computations separately, to
identify any remaining bottleneck without changing their algorithms. Both
sets have reproducible local generators and SHA256 manifests under
`finite_fast_next/graphs` and `finite_fast_next/graph_phases`.

I also independently reviewed the optional `PairClosureWitness` draft: supplied
roots cover all eight choices of three root signs, producing precisely two
mutation values, and exact witness projection preserves the original vertex
list. The inclusive norm cutoff and zero-root cases are unchanged. I flagged
the grounded pinned-Lean `Bool.and_eq_true.mp/.mpr` API issue to its author;
mathematical soundness passed, kernel acceptance remains pending.

Compiler update: the complete `PairBipartiteCheck` generic theorem passed the
Lean kernel in69.76 seconds, SHA256
`d1497b46c9dcbae577d7172e6c4401388a1797e68d33ba795d4e6a6a05dd4c0c`.
The final adapter explicitly splits the Boolean equality guards used by the
original checker and converts `decide P = true` via `of_decide_eq_true`.
Its data/color pilot remains the next computational gate. The coordinator also
reported kernel acceptance of the generic witness closure checker and both
Pell convergent-completeness and finite continued-fraction prefix theorems.

## Cached residue optimization review

Read all of `PairCachedResidues.lean`, SHA256
`8d30539028d401e948637a33f705cb33707d8ad4e1fe939eafd5ed7c690a9100`.
Mathematical and source-structure review PASS. Its verified coordinate signatures
preserve every sieve entry in order. The cached small-coordinate multiplication
is exactly the original product-plus-one mask computation for arbitrary
quadratic parameters and positive modulus k+1. Malformed signature lengths
reject. Modular survivors still run the exact root test; duplicate handling and
exact original vertex-list coverage are unchanged. The endpoint proves the old
independent-class Boolean, with no new mathematical assumptions. I read the
pinned quadratic-algebra definitions directly and checked all six referenced
coordinate lemmas and their formula order. No concrete API mismatch found;
compiler acceptance remains the coordinator's gate. No source changes made.

## Indexed closure witness review

Read `PairClosureIndexedWitness.lean` (SHA256 cf1974b83acff2e08dabccf8818b3a4f539024362890883b72209680ae904e55)
in full: mathematical/source review PASS. An index must resolve to exactly the
computed mutation; `none` is accepted only for norm strictly above the bound.
Thus an out-of-range index cannot pass, and equality at the cutoff still needs
membership. Exact witness projection and lockstep destination-list traversal
retain every original vertex and both mutation signs. Zero roots, duplicate
vertices, anchor coincidences and repeated destination indices are harmless.
Soundness supplies the already accepted witness Boolean and hence the original
closure Boolean. Direct pinned-API inspection confirmed `List.mem_of_getElem?`
at Lean4.33.1 core `Init/Data/List/Lemmas.lean:479` has exactly the used type.

Independently parsed the actual indexed pilot, supplied root data and closure
source, then recomputed every anchor/vertex root and both signed mutations.
All373 vertices passed:745 indexed destinations are exact and one candidate
has norm strictly above10^1100. The actual accepted mutation uses +2r0rs,
matching the supplied first/second destination order. Pins:

- Indexed pilot: aa955931a4521c8735423353db9d089a97667a50300a9fb2f5aca1b3277b29ee.
- Root data:38ab206ade22eb6de1a08e371b6d71713bc639bf68029e7c433f53babc6ff7fd.
- Phase data:95c24b71d27834fe4f16c6643582c88186bf124cb854123ec33fc14ed5c4b3a8.

Reproducer and exact fingerprints are in `audit_next/verify_indexed_closure41.py`
and `indexed_closure41_review.json`. No accepted source was edited, and these
independent diagnostics are not represented as kernel acceptance.

## Cached independence prefix decomposition

Full source review of `PairCachedIndependentChunks.lean`, SHA256
ce3bc5496ad1cbfec217cabf2597ba650c807568476c17e7d32f26513c8113ef:
mathematical/source PASS. Each selected prefix row compares its head against
the entire remaining original tail. Thus every pair crossing a chunk boundary
remains checked at its earlier index; this is not a check restricted to the
prefix's internal edges. The theorem is an exact Boolean factorization into
the prefix and the original checker on `drop n`. It covers zero, empty and
past-end cuts as well as repeated values. The final reconstructed certificate
retains exact full vertex projection and every original signature validation.
Pinned Boolean associativity/identity/iff and List.drop lemmas were read and
match the uses. No source changes or compilation performed. Details are in
`audit_next/cached_chunks_review.json`.

## Negative rational integer rejection

Full independent source review PASS for `PairNegativeIntegerObstruction`
(099be79d...) and `PairCachedIntegerObstruction` (7b88d466...), plus all3 new
row41 wrappers. Read the actual accepted `RationalSquares.lean` definitions and
theorems: the necessary divisibility conditions and their assumptions match.
The strict negative-real guard does not reject zero roots; unsupported traces
return false. Positive discriminant is required only to prove equality with the
existing exact-root Boolean. The cached sieve remains first, including its
malformed-signature behavior; full coverage, every signature and every list
occurrence remain unchanged. The pilot imports the unchanged original cached
data and color mask. Full fingerprints are in
`audit_next/integer_obstruction_review.json`; no source edits or compiler claims.

Independent diagnostic check: all884 left and810 right modular survivors are
negative rational integers congruent1 modulo7. More strongly, all372 original
large vertices are trace-zero and each color class has one strict sign of its
real coordinate. This permits a potential structural class proof with only
per-vertex checks; it has been proposed to the coordinator separately and is
not yet claimed as a kernel theorem.

## Structural trace-zero graph certificates

The non-Gaussian imaginary-axis algebra in `PairTraceZeroNoThree.lean`
(SHA05241394...) was independently read in full and passes mathematical review.
A same-sign compatible pair would force d to divide1 with d>1; three nonzero
vertices cannot all have pairwise opposite coordinate signs. The theorem does
not need distinctness and permits zero square roots. Gaussian nu=1 is explicitly
excluded. The new `pair_structural_next/` adapter preserves the exact original
triangle Boolean and checks the trace of every original list occurrence. The
row41 pilot uses the frozen372-entry list, without coordinates or bounds changed.
Source_audit independently passed the adapter, algebra and pilot. Applicable
rows are16,22,27,31,32,37,41. Compile status remains coordinator-owned.

## Sparse exact floor obstructions

Full independent mathematical/source review PASS for
`QuadSquareFloorObstruction.lean` (681d0293...) and
`PairCachedFloorWitnesses.lean` (344ed1b9...). Exact positive/negative rational
square classifications and norm multiplicativity justify the consecutive-square
checks. Pinned square-order and accepted source APIs were read and match.
The sparse traversal retains every full tail and consumes a witness exactly at
its actual pair; missing/extra witnesses reject. Original full vertex projection
and all signature checks remain, yielding exactly the prior independence Boolean.
Zero roots, unsupported traces, malformed signatures, duplicate occurrences and
empty tails have no new unchecked branch. Details and full pins are in
`audit_next/floor_obstruction_review.json`. No compilation or source edits.
