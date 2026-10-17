# Signed five-entry prefix inverse and p-bilinear bound

Source: D1Bound5/ProductFiveSignedPrefixInverse.lean.
The five new theorem declarations prove, for one and the same original-ring signed five-entry root matrix:
1. ||F-H|| <= 11/96 for its normalized leading Fin4 prefix.
2. ||F^{-1}v||_2 < 11/12 for its normalized fifth column.
3. Complex bilinear Cauchy--Schwarz without a Hermitian assumption.
4. |v dot (F^{-1}v)|<1 from the two vector bounds.
5. Direct transfer of this p-bound to the SAME original-ring sign choice.

Validation: trial01 and trial02 EXIT 0; integrated pinned Lake target/root build EXIT 0 (3040 jobs); five-declaration actual-type/transitive-axiom audit EXIT 0 (only propext, Classical.choice, Quot.sound); installed same-kernel targeted replay EXIT 0; source/import audit EXIT 0 (77 modules, 373 explicit theorems). Precise evidence: local-logs/five-prefix-inverse-automation8-{trial01,trial02,build,axioms,replay,source-audit}.log.

Unfinished verification: an attempted single terminal command to refresh and check source/tool SHA-256 manifests was PRE_EXECUTION_DENIED by OpenAI safety checks, before command execution. No retry or alternate route. The new source and audit files have not passed refreshed manifest checks. No independent review or clean-checkout verification.

Open mathematics: normalized prefix-size bound for the actual quintuple; h/d, q/d^2, p/d^2 and Schur reference distance <1/2; then genuine product-five, arbitrary-order Bennett, certified finite exclusions and main bound-five theorem.
