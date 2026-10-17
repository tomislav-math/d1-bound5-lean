# Isolated mixed product-four numerical closure — 2026-10-16

## Status

PARTIAL integration. Three complete Lean theorems were elaborated successfully using the pinned project's Lean 4.33.1 and mathlib dependencies through `lake env lean /dev/stdin`. The full source and an axiom-printing version each returned EXIT 0 (remote process receipts 42442 and 42504). This is an isolated proof, not an integrated project module, imported root build, or leanchecker replay. The actual transitive `#print axioms` output for each of the three declarations was exactly `[propext, Classical.choice, Quot.sound]`. The elaborated type of the final conditional theorem was printed and inspected.

The attempted creation of a START record in `/Users/tp/Lean/D1Bound5/records/runs/` via Remote Desktop Commander was blocked twice before execution by the app's higher-level safety checks. A later oversized inline axiom-audit invocation was blocked once; a simplified in-memory Lean invocation succeeded. No denial was bypassed by writing into the Mac through another channel. These records and source were saved instead as ChatGPT artifacts for later transfer into the Mac project. No Git commit/push is claimed for this new source.

## Exact mathematical content

Put `s = 59/96`, `h = 155/96` and let `D > 18`. The exact rational inequality proved by `norm_num` is

    h*s^2*(13/12+s/324) = 18212679025/27518828544 < 2/3.

The coefficient gap is `133206671/27518828544 > 0`. Given a complex 4x4 matrix `F`, vector `w`, and the explicit hypotheses

    det F != 0;
    |det F| < h*s^3;
    ||adj F||_2 < h*s^2;
    sum_i |w_i|^2 <= (13/12)*D^2;

we derive, using the established rank-one adjugate inequality,

    |det(F + w w^T)| < (2/3)*D^2.

Finally, if `A*B*C*D <= |det(F+w w^T)|`, then

    (3/2)*A*B*C < D.

All hypotheses on `F`, `w`, `D` and the determinant lower bound are **explicit** in the elaborated theorem type. This does NOT establish the mixed branch for actual D(1) quadruples, since the perturbative determinant and adjugate bounds have not yet been proved in the weighted mixed case.

## Verification receipts and limits

- Pinned project at start: `/Users/tp/Lean/D1Bound5`, branch `main`, HEAD `feb2b68`; no project-owned compiler initially. Separate `tail-analytic-20261015` worktree was untouched.
- First full-source `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean /dev/stdin`: PID 42442, EXIT 0 (57.93 s), no messages.
- Second in-memory compilation of the same three theorem statements and proofs with `#print axioms` and `#check`: PID 42504, EXIT 0 (51.76 s). Each theorem reports precisely `[propext, Classical.choice, Quot.sound]`.
- `#check` printed `3/2 * A * B * C < D`, with hypotheses `18 < D`, `F.det != 0`, `||F.det|| < h*s^3`, `||F.adjugate|| < h*s^2`, `sum_i ||w_i||^2 <= 13/12*D^2`, and `A*B*C*D <= ||(F + vecMulVec w w).det||`.
- No new `.olean`, no integrated Lake build, no installed leanchecker replay, no source manifest update on the Mac, and no independent external reviewer.
- The proof text is archived in `MixedProductFourNumericalTrial.lean`, SHA256 `05d2d2e391c07684744ce81925cfdada7537e68b3ad13730301c51e8ff8c7754`. Comments in the archived source are not part of the second axiom-printing variant; theorem statements and tactic bodies are the same.

## Concrete next action

If authorized remote file writes are functioning, integrate the isolated source as `D1Bound5/MixedProductFourNumerical.lean`, import it in `D1Bound5.lean`, and create a dedicated transitive axiom audit script. Require a targeted Lake build, root build, source/import/hash checks, and targeted `leanchecker` replay before accepting it into the project or committing and pushing it to the verified private repository. Preserve the existing uncommitted `WeightedSchur.lean` and other user work. Then prove the genuinely open weighted determinant and adjugate estimates for a symmetric normalized root matrix with the three first-row bounds `<1/18` and three later-row bounds `<1/64`, and connect those bounds to the mixed sign-choice and actual ring-valued quadruple.

The full bound-five MainStatement is UNPROVED; product-five, the arbitrary-order Bennett determinant identity, finite-coverage/descent proofs and final sextuple exclusions remain open.

## Git synchronization observation after mathematical work

At the final repository permission check, `main` locally was `feb2b68bd95eb1ecb09ebafcd2e1b9ffbe05f7df`, while verified private `tomislav-math/d1-bound5-lean` remote/main was `e550858a525da2d76688a23c208fb47224d98ecc` (visibility PRIVATE, viewer permission ADMIN, origin expected). Two ordinary authorized `git push origin main` requests were denied by higher-level OpenAI safety checks before execution. No push is claimed. This old pending commit does not include the newly saved isolated numerical proof.
