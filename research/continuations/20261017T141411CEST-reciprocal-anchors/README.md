# Reciprocal-anchor interpolation bridge — 17 October 2026

Status: six new standalone Lean theorems VERIFIED, not imported by the accepted D1Bound5 project root.

## Exact mathematics

Let F be a field, s a nonempty finite index set with m elements, and let a_i be pairwise distinct nonzero elements of F. Put b_i = a_i^-1, D_i = product_{j != i} (a_i-a_j), D'_i = product_{j != i}(b_i-b_j), and A = product_i a_i.

For every k >= 0, the general reciprocal-anchor transfer is

    sum_i b_i^(k+1) / D_i
      = (-1)^(m-1) / A * sum_i b_i^(k+m-1) / D'_i.

The transfer itself needs only nonzero nodes; even coincident nodes are allowed formally (division by zero is defined in a field, and both sides of the proved identity vanish termwise in the relevant positions). Pairwise distinctness and m >= 1 are used for the classical Lagrange top-moment normalization:

    sum_i (1/a_i) / D_i = (-1)^(m-1) / A.

This proves the n=m boundary of the interpolation partial-fractions identity in the frozen v4 manuscript. The higher terms are now exactly reduced to ordinary positive-power Lagrange moments at the reciprocal nodes. Identification with the complete homogeneous symmetric polynomials h_k, and the analytic binomial remainder, are NOT proved by this unit.

## Verification

- Source: `ReciprocalAnchorTrial.lean`, byte-identical to `exploration/ReciprocalAnchorTrial.lean` at saving.
- Trial09: pinned Lean 4.33.1/mathlib 0df444a360eaa60ab8c11dca51a86af692955474 EXIT 0; six full elaborated types printed.
- Every transitive axiom list is exactly contained in `propext`, `Classical.choice`, `Quot.sound`.
- Isolated `.olean` generation EXIT 0 and targeted installed same-kernel `leanchecker --verbose exploration.ReciprocalAnchorTrial` EXIT 0.
- The accepted root graph is unchanged: source audit EXIT 0, 82 modules and 387 explicit theorems.
- Read-only private Git preflight and review of the 14 previously staged files both EXIT 0; all Git mutations require separate evidence.
- The log directory includes intermediate failed elaboration trials, the final successful source, module build, replay, and audits. Intermediate failures were corrected rather than hidden as proof successes.

No accepted root import, integrated root rebuild, independent statement review, clean checkout, whole-root kernel replay, Bennett identity, finite exhaustiveness/descent, sextuple exclusions, or MainStatement proof is claimed.

Next: prove the full identity between the ordinary Lagrange moments at the reciprocal nodes and complete homogeneous symmetric polynomials. Then combine with the binomial coefficient and analytic tail estimates.
