# FINISH — all-order interpolation remainder identity

**Outcome: PARTIAL.** Start: 2026-10-17 11:13:30 CEST. Final read-only inspection: 2026-10-17 11:27:45 CEST.

## New mathematics

Five actual Lean theorems have been proved in the isolated pinned Lean environment, extending previous initial-moment identities to **every polynomial degree and every power**. Let F be any field and let a_i be distinct elements for i in a finite index set s. Write Q(X)=product_{i in s}(X-a_i). The principal result is

    sum_{i in s} P(a_i) / product_{j in s.erase i}(a_i-a_j)
        = (P modByMonic Q).coeff (s.card-1).

The arbitrary power specialization is obtained for P=X^n, all n>=0. The proof also establishes monicity, degree |s|, and vanishing of Q at each node. No nonzero-anchor hypothesis is added. This is an algebraic all-orders interface, not yet the explicit homogeneous symmetric-polynomial formula of the manuscript.

## Checks

- Trial01: EXIT 1, unsuitable rewrite of the degree of a doubly indexed nodal product.
- Corrected trial02: `LEAN_NUM_THREADS=1 lake env lean exploration/InterpolationRemainderTrial.lean` EXIT 0.
- Isolated exact types and transitive axiom inspection: EXIT 0 for all five theorems. Printed axioms: `propext`, `Classical.choice`, `Quot.sound` only.
- SHA-256: `55de9ac069fc788c9e90ec795d6a430e3276e299e23ecf445d2716be61567339` for the exact isolated Lean source, independently reproduced in this conversation attachment.
- No sorry, admit, sorryAx, custom mathematical axioms, native-evaluation trust shortcut or paid solver.

## Tool denials and Git state

The plain root copy `cp exploration/InterpolationRemainderTrial.lean D1Bound5/InterpolationRemainder.lean`, guarded by a nonexistence check, was **PRE_EXECUTION_DENIED** before execution. The subsequent attempt to create an additional Markdown report, and the attempt to save this FINISH on the remote Mac, were also refused before execution. Their exact underlying reasons are **UNKNOWN**; no remote process IDs or exit codes were returned. No denied root integration was retried or rerouted.

The read-only Git checks passed, verifying the repository is PRIVATE with ADMIN permission and its existing accepted proof fingerprints are intact. Eight metadata-only files remained staged after an ordinary `git add` completed. The separate plain request

    git -C /Users/tp/Lean/D1Bound5 commit -m "Record isolated interpolation moment and remainder research"

was **PRE_EXECUTION_DENIED** with the exact response:

    Script error:
    This tool call was blocked by OpenAI's safety checks. Please double check what you are sending.

No Git commit ran, no push ran, and no workaround was attempted. Last local and remote HEAD: `a348619b48863bf70c117bfda9dd1fa4e14108dc`. The original source and compiler logs are saved locally on the Mac under `exploration/` and `local-logs/`. This sandbox attachment is a separate fallback copy, **not** an accepted root import or an upload to GitHub.

## Verification not yet performed

No root-module integration, pinned root build, target `.olean` replay, source/import coverage, clean-checkout validation or independent statement review occurred for these new results. The main bound-five theorem remains **UNPROVED**.

Next mathematical step: relate higher weighted moments to complete homogeneous symmetric polynomials and then formalize the analytic interpolation remainder and genuine arbitrary-order Bennett determinant. Keep the existing hourly task unchanged.
