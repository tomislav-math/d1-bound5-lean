# FINISH — Actual tuple-level product-five growth

Outcome: PARTIAL (mathematical lemma root-proved and kernel-replayed;
source fingerprint/Git acceptance gate blocked).

Observed run start: 2026-10-17 09:19:39 CEST.
Last final read-only inspection: 2026-10-17 09:36:19 CEST.

## New mathematics

The complete manuscript `lem:product-five` is proved as
`D1Bound5.IsD1Tuple.productFive_growth`. For EVERY imaginary quadratic
number field K, an ordered, pairwise distinct and nonzero D(1) quintuple
in the FULL ring of integers with second modulus at least 3 satisfies

```text
3 * (∏ i : Fin 4, ‖phi (a (Fin.castAdd 1 i) : K)‖)
  < ‖phi (a 4 : K)‖.
```

No new existential sign, matrix, growth, Schur or analytic assumption
is added. The first-modulus lower bound follows from full-ring integrality
and the tuple nonzero condition. Zero off-diagonal square roots and equal
entry moduli remain permitted. The proof builds one common original-ring
signed root matrix and connects its Schur proximity `< 1/2`, determinant
`< 1/3`, and the full-ring arithmetic determinant lower bound.

New root-imported modules:
- `D1Bound5/ProductFivePrefixSizeCross.lean` (3 theorems).
- `D1Bound5/ProductFiveTupleSchur.lean` (2 theorems).
- `D1Bound5/ProductFiveTupleGrowth.lean` (2 theorems).

## Actual verification

- Pinned dependency target build of first two modules: EXIT 0, 3023 jobs.
- Growth isolated trial01 EXIT 1 (too-strong existing radius requirement);
  corrected trial02 EXIT 0 without weakening the theorem.
- Integrated `lake build D1Bound5.ProductFiveTupleGrowth D1Bound5`:
  EXIT 0, 3045 jobs.
- Exact elaborated type and transitive axiom audit of all seven:
  EXIT 0. Only `propext`, `Classical.choice`, `Quot.sound`.
- Targeted same-installed-kernel `leanchecker --verbose`: EXIT 0 for
  all three modules, run sequentially, not independent review.
- Root source/import audit: PASS, 82 modules and 387 explicit theorems.
- Verification-tools SHA manifest: 44 files, PASS.
- Proof-source SHA manifest: INCOMPLETE. One malformed digest on line 84.
  `shasum` returned 0 but warned about an invalid line; NOT a pass.
- Read-only Git preflight: FAILED_NO_MUTATION on this exact fingerprint.

A precise single-line manifest correction was PRE_EXECUTION_DENIED by the
tool's safety checks before execution; see the companion evidence record.
No alternate correction or bypass was attempted. No new Git staging, commit
or push in this run. The six inherited staged files and newer unrelated
untracked Git-index-review files were preserved.

Last verified local and remote main:
`781dca45e5220a196cddfcdf29add8876a643c7a`, PRIVATE repository.
The new proof is saved on the Mac but not yet on GitHub.

## Next precise task

Resolve the legitimate permission boundary for the single malformed
source-manifest line, then rerun both fingerprint checks, read-only
preflight, reviewed explicit staging and separate ordinary commit/push.
Do not re-prove product-five. Next mathematics: the genuine arbitrary-order
Bennett identity and interpolation/approximation before the complete finite
certificates and final sextuple exclusions.

No independent statement review, clean-checkout build, whole-root kernel
replay or complete proof of `MainStatement` has been performed. No pinned
dependency, frozen manuscript, handoff, separate worktree, paid service
or automation schedule was changed.
