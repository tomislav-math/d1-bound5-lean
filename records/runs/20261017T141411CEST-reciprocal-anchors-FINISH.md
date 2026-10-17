# FINISH — reciprocal-anchor interpolation transfer

Outcome: COMPLETED_UNIT (six standalone Lean theorems proved and targeted same-kernel replayed; not imported by the accepted project root).
Observed start: 2026-10-17 14:14:11 CEST. Latest observed time: 2026-10-17 14:34:05 CEST.
Project branch main; base HEAD e0f90380049e2e9d64e8f1ca06302202a2868c68.

## New mathematics

For nonzero anchors a_i and b_i=1/a_i, the exact Vandermonde reciprocal-product identity is proved. It yields, with m nodes and k >= 0,

    sum_i b_i^(k+1) / prod_{j!=i}(a_i-a_j)
      = (-1)^(m-1)/(prod_i a_i)
        * sum_i b_i^(k+m-1) / prod_{j!=i}(b_i-b_j).

The transfer needs no distinctness assumptions. For distinct nonzero anchors and m >= 1, the standard Lagrange moment gives

    sum_i (1/a_i) / prod_{j!=i}(a_i-a_j)
      = (-1)^(m-1)/(prod_i a_i).

This is the manuscript interpolation identity at n=m. All higher orders are reduced to ordinary positive-power Lagrange moments of reciprocal nodes, but identifying them with h_k is still OPEN.

## Formal verification

Six declarations compiled in pinned Lean 4.33.1/mathlib 0df444a360eaa60ab8c11dca51a86af692955474, trial09 EXIT 0; all exact elaborated types inspected and all six transitive axiom audits yield only propext, Classical.choice, Quot.sound. Isolated .olean build EXIT 0, targeted installed SAME-kernel `leanchecker --verbose exploration.ReciprocalAnchorTrial` EXIT 0. Source SHA256: 0cae6a3c08118e62fb50c0736edb21dfd5ec34570d03dd0fb1a6a97accd1732b. The existing accepted source/import audit PASS remains 82 modules, 387 explicit theorem declarations. Read-only private Git preflight and prior 14-file staged-index review both PASS; repo PRIVATE with ADMIN access and local/remote HEAD matching at inspection.

Proof source and logs: research/continuations/20261017T141411CEST-reciprocal-anchors/. Detailed record: records/reciprocal-anchor-transfer-20261017.md. Intermediate elaboration errors were preserved separately, corrected, and never treated as proved results.

## Boundary and next action

The six proofs are preserved outside the accepted root import graph. No attempt to bypass the previously refused root-copy operation was made. No integrated root rebuild, independent statement review, clean checkout, or whole-root replay occurred. MainStatement remains UNPROVED; analytic binomial tail, h_k formula, Bennett arbitrary-order determinant, formally exhaustive finite descent/coverage and sextuple exclusions are still open.

At this record's preparation, Git synchronization of this new unit has not yet been executed; any later commit or push must have its own independently checked receipt. Existing 14 reviewed staged files from the prior run were not overwritten.

Next: establish the complete homogeneous symmetric polynomial expression for all higher reciprocal moments, then the analytic tail estimate. Continue independently of Git availability.
