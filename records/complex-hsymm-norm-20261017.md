# Complex complete-homogeneous polynomial coefficient envelope

17 October 2026. Pinned Lean 4.33.1 and mathlib 0df444a360eaa60ab8c11dca51a86af692955474.

## Statement and proof

For any finite type I of cardinality m (including an empty type), any map b : I -> C, any nonnegative real rho bounding each |b_i|, and every natural k,

  |h_k(b)| <= binomial(m+k-1,k) * rho^k,

with natural-number subtraction as in mathlib. No nonzero, distinctness, real-valued or strict-radius condition on b is required.

Proof: use the existing equality of evaluated hsymm with the sum of products over the degree-k multisets. Every monomial has norm bounded by rho^k by induction on the multiset. Apply the triangle inequality to the finite multiset sum. The exact count of degree-k multisets is Sym.card_sym_eq_choose. This yields the claimed binomial coefficient with no approximation of the combinatorial factor. At k=0, including empty I, the estimate reads 1 <= 1.

## Formalization

Theorem: D1Bound5.hsymm_aeval_complex_norm_le_choose.
Accepted candidate: D1Bound5/ComplexHsymmNorm.lean.
Exploration and first failed compilation: research/continuations/20261017T175018CEST-hsymm-norm/ComplexHsymmNormTrial.lean.
Audit script: scripts/ComplexHsymmNormAudit.lean.

First trial compilation failed only because the last side condition of mul_le_mul was 0 <= rho, while the supplied term proved 0 <= rho^k. This was corrected by supplying hρ0 directly; the second trial elaborated successfully, exit 0, and #print axioms reported only propext, Classical.choice, Quot.sound. The previously uncached Mathlib.Data.Sym.Card module was built from the pinned source without any upgrade.

## Scope and remaining work

This is an exact coefficient envelope, not a summability proof, a uniform analytic Taylor-tail estimate, or a proof of the v4 square-root bound eq:coherent-tail. Next connect the bound with rho=1/A1, a geometric/binomial generating-function bound and the strict A1*P>1 hypothesis. The arbitrary-order Bennett determinant, certified finite exclusions and global MainStatement remain unproved.

Root build, full audit, installed kernel replay, fingerprint and Git outcomes must be recorded from actual tool receipts before marking them complete.
