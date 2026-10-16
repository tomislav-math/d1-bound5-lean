# FINISH — Product-four large-entry branch

Status: COMPLETED_UNIT.
Device: 788d1b22-4569-4161-bfbe-d886d48c6a75.
Worktree: `/Users/tp/Lean/D1Bound5`, branch `main`, starting HEAD `2928fd8`, UTC observed 2026-10-16T08:15:34Z.

## Proven

Three new theorems in `D1Bound5/ProductFourLargeBranch.lean`. The main theorem `full_ring_productFour_large_growth` proves `D>2ABC` over every imaginary quadratic FULL ring of integers, for an ordered symmetric integral root matrix with A>=3 and the separately established tail hypothesis 2BC<D. The same original-ring signed root matrix underlies the determinant, adjugate, invertibility, rank-one upper, and arithmetic determinant lower estimates. Auxiliary theorems formally prove the sharp square-sum bound and D>18. No extra mathematical axioms, no `sorry`, no exclusion of zero square roots or equal moduli.

## Checks

- Targeted isolated numeric unit `ProductFourSizeBridgeTrial.lean` EXIT 0; initial full proof attempt EXIT 1 from missing namespace `Module`, fixed; final complete trial EXIT 0 (221.81 s) with a nonfatal unused simp warning, then that unused simp removed.
- Root integration: `lake build D1Bound5.ProductFourLargeBranch D1Bound5`: EXIT 0, 3019 jobs, log `local-logs/product-four-large-run-build.log`.
- Source/import audit: EXIT 0, 56 modules and 282 explicit proved theorems.
- Transitive axiom audit of all 3 elaborated declarations: EXIT 0, exactly `propext`, `Classical.choice`, `Quot.sound`.
- Targeted installed Lean kernel replay for `D1Bound5.ProductFourLargeBranch`: EXIT 0 (same kernel, not independent verification).
- SHA256 source and verification-tools manifests: refreshed, both `shasum -a 256 -c` EXIT 0.
- No clean-checkout or whole-project kernel replay and no independent proof reviewer.

## Remaining gap

Package an arbitrary `IsD1Tuple` as a symmetric integral root matrix and invoke the already accepted tail result. The separate weighted `A>=1,B>=3` part of `lem:product-four` remains open. The product-five, arbitrary-order Bennett identity, complete finite-graph coverage and all sextuple exclusions are not closed; `MainStatement` is still only a proposition.

## Persistence

Source, imported module, dedicated axiom-audit script, current status and inventory, detailed mathematical record and build receipts are saved on the authorized Mac. Prior pre-staged checked modules and unrelated unstaged older run notes were preserved. Git commit/push outcome is to be appended only after actual receipts. Task remains enabled; no resident Lean worker remains.

## Git outcome

Both ordinary Git commit attempts were blocked by OpenAI tool safety checks before shell execution, first via `cd && git commit`, then once through `git -C ... commit`. Guard cause UNKNOWN. No new commit was created, and no push was attempted. The existing 35 intended source, verified historical proof, audit and documentation files remain staged locally, including this proof module and its audit script; older unrelated run-note edits and exploratory files remain separate. Current verified local and private GitHub commit before these attempts is `2928fd8`.

The staged diff check has one pre-existing, nonmathematical warning: a blank final line in `D1Bound5/SymmetricFourDetBound.lean`, whose passing compiled bytes have been preserved. An additional trailing space in the newly appended STATUS entry was corrected and restaged. These warnings do not affect the new theorem's exit-zero build and independent statement/axiom audit.
