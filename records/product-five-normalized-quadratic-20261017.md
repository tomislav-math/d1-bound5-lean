# Normalized quadratic estimates for product-five — 2026-10-17

Status: ROOT-INTEGRATED, COMPILED, AXIOM-AUDITED AND TARGETED SAME-KERNEL REPLAYED.

Source: `D1Bound5/ProductFiveNormalizedQuadratic.lean`.
Audit: `scripts/ProductFiveNormalizedQuadraticAudit.lean`.

Two exact conditional results:

1. `productFive_quadratic_q_div_norm_lt`: for an arbitrary complex 4x4 matrix F, vector w and nonzero d, assume `||F - halfOffDiagonal|| < 1/8` and `||w||_2 < ||d||/9`. Then `||(w dot (F^-1*w))/d^2|| < 8/243`. No Hermitian or symmetry assumptions. Proof combines the previously established inverse operator estimate `||F^-1|| < 8/3`, the complex *bilinear* Cauchy--Schwarz bound, and the normalized Euclidean vector inequality.

2. `productFive_p_div_sq_norm_lt`: for arbitrary complex p,d, `||p||<1` and `||d||>=54` imply `||p/d^2||<1/2916`. The last inequality is strict because the numerator bound is strict; equality at ||d||=54 is allowed.

These precisely match the q/d^2 and p/d^2 hypotheses of `productFive_schur_det_upper_of_bilinear_bounds`. They remain CONDITIONAL scalar/analytic lemmas, not the full product-five growth theorem. Deriving ||w||_2<||d||/9 from a genuine ordered quintuple and proving the Schur proximity/nonvanishing are still required. The prefix-size/cross lemma in `exploration/ProductFivePrefixSizeContinuationTrial.lean` remains ISOLATED, not imported.

Validation:
- Isolated trial01 EXIT 1, two multiplication-order mismatches in final normalized expressions; corrected without changing any theorem hypothesis.
- Trial02 EXIT 0: `local-logs/product-five-quadratic-run9-trial02.log`.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ProductFiveNormalizedQuadratic D1Bound5`: EXIT 0, 3041 jobs, `local-logs/product-five-quadratic-run9-build.log`.
- Exact elaborated types and enforced transitive-axiom filter: EXIT 0, two declarations, only `propext`, `Classical.choice`, `Quot.sound`; `local-logs/product-five-quadratic-run9-axioms.log`.
- `lake env leanchecker --verbose D1Bound5.ProductFiveNormalizedQuadratic`: EXIT 0, installed SAME kernel, `local-logs/product-five-quadratic-run9-replay.log`.
- `scripts/source_audit.py`: EXIT 0, 78 root-imported modules and 375 explicit theorems; `local-logs/product-five-quadratic-run9-source-audit.log`.
- Both SHA-256 manifests updated for verified missing files; `shasum -a 256 -c` EXIT 0 on both; logs `local-logs/product-five-quadratic-run9-{source,tool}-hashes.log`.
- No independent external review, fresh clean-checkout proof replay or global theorem acceptance was performed.

The main bound-five theorem remains UNPROVED; Bennett, finite completeness and sextuple exclusions remain open.
