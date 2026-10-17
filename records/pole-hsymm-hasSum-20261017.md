# Infinite reciprocal-pole interpolation series

17 October 2026. Formal target: D1Bound5.reciprocal_pole_hsymm_hasSum_of_majorant.

Let S be a nonempty finite index set of pairwise distinct nonzero complex anchors a_i. Put D_i = product over j in S except i of (a_i-a_j) and c = (-1)^(|S|-1)/(product over S of a_i). Let h_k denote mathlib's complete homogeneous symmetric polynomial in the reciprocal anchors. For any z inside each anchor modulus, a real rho >= 0 with |1/a_i| <= rho for every i, and rho*|z|<1, the new theorem proves

    HasSum (fun k => z^k * (c * h_k((a_i^-1)_(i in S))))
           (sum_(i in S) 1/(D_i*(a_i-z))).

Proof: the accepted exact finite identity states that the right side is the kth partial sum plus z^n times a finite weighted reciprocal-pole remainder. The accepted complex remainder-limit theorem proves the latter tends to zero. The accepted hsymm summability theorem, together with multiplication by the constant c, proves the series is Summable. Therefore its partial-sum limit is its HasSum value. Every assumption is explicit in the elaborated type. No positivity, integrality or square-root branch choices are imposed.

This is an exact complex infinite-series identity. It does not prove the analytic binomial square-root tail bound in the frozen manuscript, Bennett's arbitrary-order determinant formula, finite certificate coverage/descent, sextuple exclusions or MainStatement.

Proof module: D1Bound5/PoleHsymmHasSum.lean, root-imported. Standalone corrected trial and original diagnostics: research/continuations/20261017T191530CEST-pole-hasSum/. Pinned Lean 4.33.1 root build EXIT 0 (3058 jobs). Explicit elaborated theorem type and transitive-axiom check EXIT 0 (only propext, Classical.choice, Quot.sound). Kernel/source/hash/Git receipts are recorded separately and must not be inferred from this file.
