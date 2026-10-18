# Actual unequal-pole families A3, A4, A5

These local sources are complete through actual full-ring closed-interval
endpoints, but **uncompiled**. Root owns remote writes, the serial compiler
and Git. No source is accepted merely because it exists here.

The exact Fraction polynomial generator independently reproduces all three
manuscript coefficient tables and determinant constants after the common
row division:

| Family | k,m,g | det of full matrix | M | R* |
|---|---|---|---|---|
| A3 | 3,2,4 | -2450 xy c (x-y)^11 | 2265 | 35/16 |
| A4 | 4,3,2 | 2910600 (xy)^2 c (x-y)^15 | 165763 | 63/8 |
| A5 | 5,4,4 | -62432370 (xy)^3 c (x-y)^19 | 3113013 | 495/64 |

The divided matrix removes an additional x,y from root columns, making its
vector an actual integral signed-root-product vector. Its determinant is
the table determinant divided by xy. All coefficients are explicit integers.

The main new analytic unit `UnequalPoleResidual` generalizes the existing
proved Bennett residue theorem to arbitrary multiplicities e_j+1 with
e_j≤k. The actual residual Taylor coefficient is the actual local residue
moment; cancellation lasts through total pole order minus two. Repeated-node
complete homogeneous polynomials and the existing convergent majorant give
the precise tail bound. For the A families, the tail degree is 3k-1, and
the exact beta values are 35/32768, 63/524288, 495/33554432. No contour
formula or cancellation premise is assumed.

The actual coefficient vectors are kept row by row. In A3, taking
coordinatewise maxima across rows would slightly miss the manuscript's
constant 2265. `FinitePolynomialHeight` proves the normalized power bound
for all T≥1000, and each actual row's rational slack is checked separately.

Compile shared modules first:

1. `UnequalPoleResidual` (imports the existing Bennett evaluation/majorant).
2. `FiniteUnequalEntry` and `FiniteChooseFive`.
3. `FinitePolynomialHeight` (imports Bennett agent's `FiniteHomogeneousTwo`).

Then, for k=3 first, followed by 4,5:

1. `FiniteA{k}Matrix`: actual polynomial matrix, determinant, nonvanishing.
2. `FiniteA{k}Coefficients`: exact homogeneous decomposition and coefficient sums.
3. `FiniteA{k}IntegralRows`: source-ring transport and actual norm≥1 row.
4. `FiniteA{k}ResidueIdentity`: finite expansion equals the actual unequal residue.
5. `FiniteA{k}Height`: actual height with the paper's M.
6. `FiniteA{k}Residual`: exact beta, pointwise row-factor residual and uniform R*.
7. `FiniteA{k}Approximation`: actual integral roots/signs, triangle transfer,
   and full-ring inequality. Uses source_audit's finite root-error improvement.
8. `FiniteA{k}Interval`: actual Fin4 tuple, X≤Y, XC≥1000, C≥200Y,
   C≤D and the closed lower/upper endpoints imply False.

The endpoints are `IsD1Tuple.finiteA3_closed_interval_excluded` and the
corresponding A4/A5 names. There is no supplied family exclusion premise.
The generic row joins were adapted from source_audit's current N3 chain;
the A-family algebra and unequal-pole analysis are separately established.

`manuscript_finite_families.tex` preserves the actual public article excerpt,
identical mathematically to the frozen v4 baseline. The Python generators
are diagnostics/proposers only: Lean ring, exact arithmetic and analytic
proofs are the acceptance gate. No `sorry`, `native_decide` or new axiom.

The fixed-anchor refinement now has ten additional complete draft modules:
`FiniteFixedCoefficientNorm`, and `FiniteA{k}FixedHeight`,
`FiniteA{k}HeightRefinement`, `FiniteA{k}FixedInterval` for k=3,4,5.
The height certificate `FiniteA{k}FixedBound a b M w` checks the exact norm
of each evaluated integer coefficient against a rational square bound,
using radius 1000 or 200B. Its full-ring transfer preserves every embedding
and simultaneous sign/conjugation symmetry. No coefficient absolute-value
bound is taken until after evaluation at the actual anchors.

The residual refinement uses A≤|a-b| and the explicit distance comparison
alpha |a-b|^(2k)≤R B^(2k), where alpha is respectively 707/40960,
6363/409600, 9999/2621440. These are exactly the manuscript's fixed-anchor
R constants after distance normalization. The final finite-set endpoint
`full_ring_finiteA{k}_fixed_interval_of_bounds` constructs roots and a
nonzero integral row and excludes the complete closed window from those
proved coefficient and distance bounds.

`fixed_root_coefficients.json` gives the exact divided coefficient vectors
used by the Lean definitions. The analytic-bridge agent independently
reconstructed all 57 printed M3, all 57 M4, and all 57 M5 values from these
vectors using exact quadratic-integer arithmetic and directed square-root
enclosures. Their concrete Lean certificates and row-specific joins live
under `one_small_analytic_next/`; they still require compiler acceptance.
