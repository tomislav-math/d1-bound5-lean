# Product-four: the A >= 3 branch

Source: `D1Bound5/ProductFourLargeBranch.lean` (copied from a successfully compiled isolated proof).

## Mathematics

Let A<=B<=C<=D be the complex moduli of the four integral entries. In the first branch A>=3, the already-proved irregular-tail growth inequality is 2BC<D. Hence B>=3, D>6C and D>18. As 0<=A<=B<=C, the squared-size correction satisfies

`A^2+B^2+C^2+D^2 <= 3*C^2+D^2 < (13/12)*D^2`.

The new full-ring theorem takes an actual symmetric integral root matrix with diagonal entries a_i and off-diagonal squares a_i*a_j+1. From A>=3 and monotonicity, all six pair products have modulus >=9. The sign-selection theorem constructs ONE symmetric ring-valued signed matrix S and complex square roots u. For the resulting same matrix F=normalizedRootError and w_i=phi(a_i), the existing proven results yield F.det != 0, `||F.det||<h*s^3`, `||F.adjugate||<h*s^2`, and the exact rank-one identity `F+ww^T=scaledRootMatrix u (S.map f)`. The established full-ring even-dimensional integral determinant lower bound gives `ABCD<=||det(F+ww^T)||`. The numerical rank-one closure then proves `D>2ABC`.

The statement does NOT presuppose D>2ABC, any distinct modulus, nonzero roots, or a field-specific integral basis. It DOES assume a symmetric integral root matrix and the previously established weaker inequality D>2BC; converting an `IsD1Tuple` into that symmetric matrix is a separate interface obligation. The mixed case A>=1,B>=3 remains OPEN, as do the Bennett identity and finite-graph main exclusions.

## Verification

The first two lemmas compiled in the isolated 43-line version, exit code 0 (`local-logs/product-four-size-trial01.log`). An initial larger compilation exposed a missing `open Module`; that run exited 1 (`local-logs/product-four-size-trial02.log`). The corrected complete trial with the full-ring theorem compiled with exit code 0 and only an unused simp warning. That unused simp argument was removed before integration. Final root build, transitive axiom audit, source/import audit and targeted kernel replay must be recorded with their actual exit codes before acceptance.

## Final verification receipt

Accepted module: `D1Bound5/ProductFourLargeBranch.lean`, imported by root `D1Bound5.lean`. Integrated pinned build EXIT 0 (3019 jobs). Source/import audit EXIT 0 (56 modules, 282 proved declarations). Three new elaborated theorem types and their transitive axioms audited EXIT 0 with only `propext`, `Classical.choice`, `Quot.sound`. Targeted installed `leanchecker` EXIT 0 (same kernel, not independent external verification). Regenerated source and tool SHA256 manifests each checked EXIT 0. Original v4 manuscript unchanged. No clean-checkout release gate completed.
