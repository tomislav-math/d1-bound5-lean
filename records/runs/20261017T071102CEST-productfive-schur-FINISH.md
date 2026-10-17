# FINISH — Product-five Schur proximity

Outcome: COMPLETED_UNIT (five new accepted root theorems; main theorem still UNPROVED).

Start 2026-10-17 07:11:02 CEST; final mathematical audits completed before 07:20 CEST. Main worktree, branch `main`, original HEAD `122b4cd`. No competing project-owned compiler was observed. Prior staged and unrelated unstaged work were preserved.

New accepted module: `D1Bound5/ProductFiveSchurNear.lean`; five theorems: a four-by-four full-entry operator norm bound; reference proximity from entrywise Schur correction; a scalar correction bound <9/100; conditional Schur complement norm proximity <1/2; and the coordinate ratio <1/18 from ordered last-four product growth. This is a genuine proved dependency, not a proof for all actual ordered D(1) quintuples.

Isolated trial01 EXIT 1 (three redundant `ring` tactic invocations); corrected trial02 EXIT 0. Root + target pinned Lake build EXIT 0, 3042 jobs. Exact types and transitive axiom audit EXIT 0 (only propext, Classical.choice, Quot.sound for all five). Targeted installed same-kernel `leanchecker` replay EXIT 0. Root source/import audit EXIT 0 (79 modules, 380 explicit theorems). Both source and verification-tools SHA-256 manifest checks EXIT 0 (82/43 paths). All detailed logs and the mathematical report are saved; no independent review, clean checkout or whole-project replay.

Git preflight verified PRIVATE `tomislav-math/d1-bound5-lean`, ADMIN, local HEAD equals remote HEAD `122b4cd`, and all fingerprints. The reviewed commit/push procedure is a separate step after this record; no Git outcome is claimed in this FINISH. Record any subsequent push or denial separately.

Open: specialize the stated Schur hypotheses to one actual full-ring signed ordered D(1) quintuple and combine existing determinant/arithmetic interfaces to close `lem:product-five`. Bennett's genuine arbitrary-order determinant identity, finite checker soundness/exhaustive coverage/descent, final sextuple exclusions and `MainStatement` remain OPEN. No changes to the separate worktree, pinned toolchain, frozen manuscript, paid services or automation schedule.
