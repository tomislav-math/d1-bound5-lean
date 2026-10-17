# Second complete homogeneous Lagrange moment — 2026-10-17

This is an ISOLATED, formally verified proof continuation. The accepted root does NOT import this source. The bound-five main theorem remains unproved.

## Actual newly proved statements

`SecondHomogeneousMomentTrial.lean` proves three declarations for arbitrary fields:
1. The coefficient of degree m-2 in the monic nodal polynomial equals e2 of the m nodes for m>=2.
2. For any m>=2 pairwise distinct nodes a_i, the Lagrange moment at degree m+1 is e1(a)^2-e2(a), mathematically h2(a).
3. For m>=2 pairwise distinct nonzero anchors, the third negative-power Lagrange sum is (-1)^(m-1) / product(a_i) times h2 of the reciprocal nodes, expressed explicitly as e1^2-e2.

The source does NOT establish all-k equality with MvPolynomial.hsymm, or any analytic estimate.

## Important duplicate excluded from achievement count

`LagrangeRecurrenceTrial.lean` compiled, but its two recurrence claims were already covered by the older, verified `InterpolationNodalRecurrenceTrial.lean`. They are retained only as a non-novel exploratory reproduction and are not claimed as new results. Trial01 compiled; the comparison with the pre-existing source was performed before the final report.

## Verification

- Pinned Lean 4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474.
- SecondHomogeneousMoment trial01 failed; fixed without weakening hypotheses. Trial02 and trial03 passed; final warning-free trial04 exited zero.
- Exact types and transitive axiom lists inspected in the final Lean log: only propext, Classical.choice and Quot.sound.
- Isolated `.olean` build EXIT 0, targeted installed same-kernel leanchecker EXIT 0. These are not an independent review.
- Candidate source SHA256: 758416a8bd474aa4a1e8de7552d3a32a2aa2eef923c1fed655f2eafb14004db2.
- Previous imported exploratory sources are byte-identical to their documented archived work. Accepted-root audit: 82 modules / 387 explicit theorems; source and tool manifests PASS. No new root import, clean checkout or whole-root replay.
- Logs live in `logs/`; the failed earlier trial is preserved honestly.

Next mathematical gap: arbitrary-order h_k identity, then the analytic interpolation remainder estimates, Bennett determinant identity, certified finite coverage/descent, final sextuple exclusions and MainStatement.
