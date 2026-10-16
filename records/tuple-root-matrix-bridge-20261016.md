# Tuple-to-symmetric-root-matrix bridge (2026-10-16)

## Accepted mathematics

Source `D1Bound5/TupleRootMatrixBridge.lean`, copied byte-identically from the prior isolated proof `exploration/TupleRootMatrixBridgeTrial.lean` (SHA256 `18bf68c70f7461d132ff1bb7a87d58364bb611e213e0471f018bd1b883568dd6`).

`IsD1Tuple.exists_symmetric_root_matrix` is uniform in any commutative ring and finite size. For distinct indices, choose one square root corresponding to the unordered pair `(min i j, max i j)`; equality of those ordered pair representatives under swapping ensures the symmetric matrix. The diagonal is exactly the tuple. Neither nonzero radicands nor distinct moduli are needed.

`IsD1Tuple.productFour_large_growth` applies this matrix to an actual ordered D(1)-quadruple in the full ring of integers of every imaginary quadratic field. It derives `B >= 3` from `A >= 3`, obtains `D > 2BC` from the already accepted full tail-irregularity result, and applies the previously checked `full_ring_productFour_large_growth`. Thus `A >= 3` implies `D > 2ABC` without independent matrix or tail hypotheses.

## Validations

Pinned Lean 4.33.1, mathlib `0df444a360eaa60ab8c11dca51a86af692955474`, branch `main`. Target and integrated root build EXIT 0 (3020 jobs). Dedicated transitive axiom audit EXIT 0: for both theorems only `propext`, `Classical.choice`, and `Quot.sound`. The elaborated types were printed. Installed same-kernel targeted replay EXIT 0. Source/import scan EXIT 0, 57 modules and 284 explicit theorems. Source and verification-tool SHA256 manifests refreshed and both validated EXIT 0. Relevant receipts: `local-logs/tuple-root-hourly11-*.log`. No independent reviewer, fresh clean checkout or complete whole-root kernel replay.

## Open dependencies

The second, weighted case of manuscript `lem:product-four`, `A >= 1, B >= 3 => D > (3/2)ABC`, is still OPEN. The manuscript uses weighted perturbation bounds `<1/18` for the first row and `<1/64` for its 3x3 complement, then a weighted spectral estimate `<11/96`. This must be formalized without assuming the desired growth result. Bennett's arbitrary-order determinant identity, finite graph/descent coverage, product-five and the sextuple exclusions remain OPEN. `MainStatement` is still only a proposition.
