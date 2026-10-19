# Manuscript terminology and pending-Q diagnosis

## Row 26

This is the 26th data row (numbering starts at one) of the frozen v4 longtable labelled sm:bs7-pair-table. The row is d=3, first anchor (-3,-1), second anchor (2,0), 1522 vertices, 1520 edges. Coordinates (u,v) represent (u+v*sqrt(-d))/2. Hence the pair is {(-3-sqrt(-3))/2, 1}, equivalently {-1-omega, 1} with omega=(1+sqrt(-3))/2, in the full Eisenstein integer ring.

The mathematical obligation is absence of a triangle among common extensions of modulus in [3,10^550]. It excludes three mutually compatible additional large elements in that disk. The graph is just one of 48 finite nondegenerate-small-pair cases, not a numbered main theorem and not a line of Lean code. The current proof uses an explicit two-color partition into two independent classes of 761 vertices. Its 578360 same-class index comparisons are not an edge count. The manuscript gives 1520 edges; this run does not certify that descriptive edge count. Full graph-data verification remains distinct from the verified class comparisons.

## Finite Q family

The exact manuscript subsection is "Five linear rows on four fixed entries". For anchors a,b,s,t, its five rows use the pairs ab, as, bs, at, bt and the five columns Q_0,Q_a,Q_b,Q_s,Q_t. These are auxiliary integral linear forms used for approximation, not a new family of number fields. The determinant is 180*a^2*b^2*s^2*t^2*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t). Nonsingularity supplies a nonzero integral form. Its lower bound by one and a residual estimate give 1 < 55*T^3*C^2/Z + 3*T*Z/(2*A^2*C^4), where Z is the modulus of a square root of cd+1. This excludes the original closed Q interval for the largest modulus.

## Why the audit had remained open

The eight Q modules already had pinned successful compilations. On 19 October at 16:16 the recorded combined metadata-edit/audit-launch tool call was refused before process execution. No Lean failure occurred in that refused call, and the record gives no mathematical reason for the refusal. Subsequent work retained Q as compiled-only and worked on independent branches. That later deferral was a work-priority decision; the prior refusal did not establish permanent unavailability of Q verification or a problem with the Mac.

At the current explicit user request the exact Q audit code was read, current locks/processes were checked, and an ordinary direct invocation of the reviewed Q checker was submitted using the same authorized tool. No permission, tool route, mathematical source or trust rule was changed, and the previous combined command was not rerun. Successful launch is not successful completion. Final results belong in VERIFICATION_SUMMARY.json only after collected exit codes, exact types, transitive axioms and unchanged source/artifact guards have been verified.

This text is explanatory evidence, not a Lean proof or an independent review. MainStatement remains unproved.
