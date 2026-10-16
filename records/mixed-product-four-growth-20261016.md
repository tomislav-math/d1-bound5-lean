# Mixed product-four branch assembled (2026-10-16)

`D1Bound5.IsD1Tuple.productFour_mixed_growth` proves for any imaginary quadratic number field K, any homomorphism phi : K ->+* C, and any indexed D(1)-quadruple in its FULL ring of integers with ordered norms A<=B<=C<=D, that A>=1 and B>=3 imply D>(3/2)ABC. No extra matrix, tail growth, nonzero square, half-integral exclusion or strict modulus separation assumption is exposed.

Proof route: symmetric original-ring root matrix, complete irregular tail lemma, one common mixed signed root choice, weighted Schur nonsingularity, joint mixed determinant (<3/10) and adjugate (<(155/96)*(59/96)^2) bounds, rank-one bound, full-ring determinant lower bound, squared-size estimate and exact numerical closure.

New root module: `D1Bound5/MixedProductFourGrowth.lean`, six proved declarations. Complete isolated elaboration EXIT 0; target/root Lake build EXIT 0 (3029 jobs); six transitive axiom checks EXIT 0 (only propext, Classical.choice, Quot.sound); targeted installed same-kernel leanchecker replay EXIT 0; source/import audit EXIT 0 (66 modules, 328 theorems); source/tool SHA-256 manifests 69/28 PASS. Logs `local-logs/mixed-assembly-hourly17-full02.log` and `local-logs/mixed-growth-hourly17-*`.

No fresh clean checkout, full project kernel replay or independent review. MainStatement is UNPROVED. Next: product-five, Bennett arbitrary-order determinant identity, certified finite graph/descent completeness and sextuple exclusions.
