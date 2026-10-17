# Product-five prefix Euclidean size and normalized cross form

Status: ISOLATED, elaborated and axiom-inspected, NOT root-integrated.

Source: `exploration/ProductFivePrefixSizeContinuationTrial.lean`.
SHA-256 after audit directives: `1f5151784b66fe465fd49f3692677d88b3abcc90c4847499154b4c8a2d8239df`.

Three declarations:
1. `productFive_prefix_sq_lt_last_div_nine`: from 0<=A<=B<=C<=S, B>=3, and 2*B*C*S<D, obtain A^2+B^2+C^2+S^2<(D/9)^2.
2. `productFive_prefix_l2_lt_last_div_nine`: for complex ordered t indexed by Fin 5, obtain ||fivePrefixValues t||_2 < ||t 4||/9 with the exact large-growth numerical input.
3. `productFive_cross_div_norm_lt_11_108`: for symmetric complex Fin4 matrix F and d!=0, from ||w||_2<||d||/9 and ||F^-1 v||_2<11/12, deduce |(v dot F^-1 w)/d|<11/108. The dot product is complex bilinear; symmetry and the previously verified bilinear Cauchy--Schwarz theorem are used.

Mathematics: B*C>=9, so 18*S < D. Each prefix modulus is <=S, giving four-square total <=4*S^2<(D/9)^2. The cross form is swapped by symmetry; Cauchy--Schwarz gives |h| < (D/9)*(11/12).

Verification: trial01 EXIT 0 for first two lemmas; trial02 EXIT 1 because Matrix transpose notation was not opened; fixed using `open Matrix`. Trial03 EXIT 0 for all three. Trial with explicit #print axioms and #check EXIT 0; each transitive axiom list is exactly [propext, Classical.choice, Quot.sound]. Logs: `local-logs/five-prefix-size-run8-trial{01,02,03}.log` and `local-logs/five-prefix-size-run8-axioms.log`. Root source/import audit EXIT 0 but counts only 77 existing modules and 373 accepted theorem declarations.

Root integration was PRE_EXECUTION_DENIED before Mac execution by Desktop Commander safety checks. The compiled trial remains in exploration and is not an accepted project theorem. No root build, targeted leanchecker replay, refreshed SHA manifests or private Git commit/push was run for this unit. Read-only Git preflight EXIT 1 because `D1Bound5.lean` is missing its current fingerprint, an inherited manifest mismatch; no mutation made.

Next: when permitted, review/copy this exact source into an importable root module, add one root import, refresh manifests, and perform pinned target/root build, exact-type/axiom audit and same-kernel replay. Then derive the product-four input for the last four entries of an actual ordered D(1) quintuple, specialize the cross-form bound to its single signed witness, and continue q/d^2, p/d^2 and the Schur distance bound.
