# Product-five arithmetic closure from Schur estimates

Date: 2026-10-16. Frozen manuscript: `D1_bound5-v4.tex`, Lemma `lem:product-five`. Source: `D1Bound5/ProductFiveArithmeticClosure.lean`.

## Mathematical statements

For a complex symmetric five-by-five root matrix `M` with `M_ii=t_i=u_i^2`, write `G` for the exact normalized four-by-four Schur complement previously defined by `productFiveSchur`. If the last entry `d=t_4` and `det G` are nonzero, the existing exact block identity

  (prod_i t_i) * det M = d^2 * det G

forces `det M != 0` without any invertibility assumption on the leading four-by-four prefix.

For every imaginary quadratic field K and its FULL ring of integers, map an original-ring symmetric matrix through an arbitrary complex field embedding. Under the same `det G != 0` condition, the mapped determinant is nonzero, hence so is the integral `det M`. The already proved `one_le_norm_integer` yields `1 <= |phi(det M)|`. Taking norms in the exact block identity gives

  (prod_i |t_i|) <= |d|^2 * |det G|.

If additionally `|det G| < 1/3` and `d != 0`, cancellation of the positive `|d|` proves

  3 * (prod_{i=0}^3 |t_i|) < |d|.

The operator norm condition `||G - H||_2 < 1/2`, where `H=(J_4-I_4)/2`, implies `det G != 0` because `||H^(-1)||_2 = 2`; this is a separate proved lemma. A final theorem packages the two analytic bounds and derives the growth conclusion with no determinant-nonzero hypothesis.

This is the arithmetic/structural endpoint only. The unconditional estimates `||G-H||_2 < 1/2` and `|det G| < 1/3` for an actual five-entry tuple remain to be formalized; no claim is made that Lemma product-five or MainStatement is proved.

## Validation status

Isolated pinned Lean trial01: EXIT 1, two elaboration problems (rewrite of map_det and an order-instance mismatch). Both repaired. Trial02: EXIT 0 (three theorems). Extended trial03: EXIT 0 (four theorems). Integrated pinned target+root Lake build EXIT 0 (3034 jobs). Exact-type/transitive-axiom audit EXIT 0 for four theorems (only propext, Classical.choice, Quot.sound). Targeted installed same-kernel leanchecker replay EXIT 0. Root source/import scan EXIT 0 (71 modules, 349 explicit proved theorems). Source/tool SHA-256 manifests and checks EXIT 0 (74/33 paths). Exact logs are in local-logs/product-five-arithmetic-hourly21-*. No clean checkout, independent reviewer or whole-project replay.
