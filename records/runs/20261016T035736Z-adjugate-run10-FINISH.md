# Formalization continuation FINISH

- Start observed on Mac: 2026-10-16 05:41:54 CEST (03:41:54 UTC).
- Last observed time: 2026-10-16 05:57:36 CEST (03:57:36 UTC).
- Outcome: COMPLETED_UNIT (isolated six-theorem source; full adjugate bound and main theorem remain unproved).
- Project: /Users/tp/Lean/D1Bound5, branch main, local HEAD 8b686a8.
- No concurrent project-owned Lean compiler was observed at start or finish.

## Mathematical work

Six proved declarations in `exploration/AdjugateFourTrial.lean`. The significant new bridge states that the diagonal/off-diagonal adjugate entry errors (<23/1000 and <197/10000) imply the exact desired operator bound <h*s². The exact reference norm is 3/8 and the rational margin is proved by norm_num. A general bound ||E||<a+3b, two explicit symmetric cofactors and the diagonal cofactor error estimate are also formally proved. The off-diagonal cubic error inequality and coverage of all 16 entries remain outstanding; no theorem silently supplies these hypotheses.

## Actual verification

- Final: `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/AdjugateFourTrial.lean`: exit 0.
- `Lean.collectAxioms` on all six theorems: PASS, only propext, Classical.choice, Quot.sound.
- File: `local-logs/adjugate-four-trial-final-20261016.log`.
- Source SHA256: 15bdee70bf886a2ea7a986b929b9f6d88b1c926b79e4334a349303c9747a038c.
- Log SHA256: 196d1775cf74a0a3cfc113e875b5ce4add22420b60ce5eae73afc640b6ff24b5.
- There were three harmless unused-simp-argument warnings.
- No installed-leanchecker replay or integrated root import/build on this new source; earlier successful receipts must not be reinterpreted as current successes.

## Preservation

New mathematics saved in `exploration/AdjugateFourTrial.lean` and `records/adjugate-entry-reduction-20261016.md`. Updated `STATUS.md`, `records/paper-to-lean.md`, `records/open-obligations.md` and `records/build-record.md`. Original manuscript, previous exploration, worktrees, pinned toolchains and unrelated files were not modified. Existing staged and unstaged work was preserved.

No Git commit or push was attempted for this isolated unintegrated proof unit. Prior safety guard blocked the corresponding normal integration of the direct determinant trial; this guard was not bypassed. Local main HEAD 8b686a8, private GitHub latest separately confirmed in earlier run as 980cc19 (not freshly queried here).

## Next

Formalize the exact off-diagonal cubic expansion and bound <197/10000, then all 16 cofactor entry bounds for the symmetric zero-diagonal matrix and use `four_adjugate_bound_of_entry_bounds`. Integrate only when allowed and rerun source audit, root build, transitive axiom checks and installed leanchecker. Separately close mixed A>=1,B>=3 and subsequent Bennett/approximation/finite-graph obligations. MainStatement remains a definition, not the final theorem.
