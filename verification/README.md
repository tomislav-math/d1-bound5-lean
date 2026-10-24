# Numerical verification archive

The current numerical supplement is maintained in the
[article repository](https://github.com/tomislav-math/diophantine-tuples-bound-five/tree/main/verification).
Use its guide to reproduce all eleven groups of checks.

This directory preserves earlier executable checks and recorded outputs for the finite
arithmetic and polynomial calculations in *A uniform bound of five for
Diophantine tuples in imaginary quadratic integer rings*, by Zrinka Franušić
and Tomislav Pejković.

The [dated manuscript](../paper/Diophantine_tuples_bound_five_2026-10-15.pdf) differs from the verified
v4 source only by `\date{15 October 2026}`. The unchanged, undated inputs are
retained because the existing programs verify their SHA-256 digests. Run
`python3 verification/verify_date.py` from the repository root to check this
relationship. Authors, funding, declarations, references and mathematics are
unchanged.

## Reproduce the archived checks

The labels v2, v3 and v4 identify successive working versions of the manuscript
and the checks recorded for each version. They do not identify separate current
releases.

Use Python 3.10 or newer. These archived checks use only the Python standard library.
Do not pass `-O`, because the checkers use assertions.

From the repository root:

```sh
python3 verification/verify_integrity.py
python3 verification/verify_date.py
python3 verification/v4/revision_v4/run_checks.py
```

The last command runs six scoped v4 checks and writes new results to a
timestamped directory. It does not overwrite the supplied evidence.
It does not rerun the large historical graphs.

To reproduce the historical computations as well, run the following in a
temporary copy, since these older entry points overwrite their result files:

```sh
work=$(mktemp -d)
cp -R verification/historical-v2 "$work/historical-v2"
(cd "$work/historical-v2" && python3 verify.py --full)
cp -R verification/review-v3 "$work/review-v3"
(cd "$work/review-v3" && python3 review_v3_comments/run_checks.py)
```

The complete v2 run includes all 48 extension graphs up to modulus `10^550`,
the graphs for the pair {-1,1} in 1016 fields, and the ten small-triple closures.
These are bounded descent or continued-fraction computations, not searches
through every lattice point in a disk of that radius.

## Coverage

Paths in this table are relative to this directory. JSON files and logs beside
the checkers record their original results.

| Calculation | Program |
|---|---|
| Tail enumeration, counts 90/118/16/0, six orbits and determinant constants | `historical-v2/revision_v2/checks/structural_v2.py` |
| Five finite approximation families, integrality, divisibility, determinant and coefficient identities, P/Q rows | `historical-v2/revision_v2/checks/approximation_exact.py` |
| 72 small-pair classes and 48 graphs through modulus `10^550` | `historical-v2/revision_v2/checks/small_v2_exact.py pairs` |
| Pair {-1,1}, 1016 fields and Pell enumeration | `historical-v2/revision_v2/checks/small_v2_exact.py pell` |
| Small triples and closures through `10^40` | `historical-v2/revision_v2/checks/small_v2_exact.py triples` |
| Section 7 transformation identities and constants | `historical-v2/revision_v2/checks/small_v2_constants.py` |
| Five regions, 40 pair representatives, 41 coefficient tuples, overlaps, 57 triples and final cutoffs | `v4/revision_v4/checks/completion_v4.py` |
| Independent reconstruction of the region, pair and cutoff calculations | `v4/revision_v4/reviews/interval_referee_independent.py` |
| Revised structural estimates and exact constants | `v4/revision_v4/checks/math_review_checks.py` |
| Interval endpoints, reduced coefficients and all-large joins | `v4/revision_v4/checks/interval_equivalence.py` |
| Approximation normalization checks and root-transfer estimates | `v4/revision_v4/checks/approximation_local.py` |
| Independent review preceding v4 | `review-v3/review_v3_comments/checks/` |

Run individual historical programs from their package root so that their
original relative paths remain valid. The package READMEs give further detail.
`history/` preserves additional earlier implementations and their inputs and
outputs. Its own README identifies older Python/SymPy requirements and the
limits of legacy checks. Editorial tools and private conversation records
are not part of this computational supplement.

## Recorded results and scope

The archived complete historical runs give:

- 48 graphs with 36,931 vertices, 36,854 edges and no triangles.
- 1,016 fields for the pair {-1,1}, 409 nonempty graphs, 19,612 vertices,
  9,806 edges and no triangles.
- Ten small-triple closure sizes
  `61, 89, 64, 105, 71, 112, 112, 57, 83, 55`.

All six scoped v4 jobs passed in the recorded v4 checks. The date-only release
on 15 October 2026 rechecked source equivalence, compilation and the affected
PDF pages. It did not rerun these mathematical computations. Historical logs
are preserved with their original scope and are not presented as new runs.

The finite decisions use exact integer and rational arithmetic; decimal
diagnostics are not certificates. The completeness of the enumerations also
uses the descent and continued-fraction arguments in the article. Sample
checks of a determinant identity do not prove the identity for arbitrary
order. These Python checks accompany the completed Lean formalization; the main
theorem and its local verification results are recorded in [STATUS.md](../STATUS.md).

The separate external-review archive named `D1_bound5_finite_checks.zip` was
not available to the authors' working session and is not included. This
supplement contains the available implementations, including complete code
for the substantive finite calculations listed above.

## Integrity and historical inputs

`FILES.sha256` covers the delivered paper and numerical supplement. The
verification script checks these files without modifying them. Original
package manifests are retained for provenance; a manifest ending in
`.original` may refer to omitted page images or archive containers.
The current manifest is authoritative for this repository copy.

Frozen historical manuscript files are verification inputs, not alternative
current versions of the article. The current reading copy is in `paper/`.
