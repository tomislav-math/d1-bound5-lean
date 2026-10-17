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
