# Minimal analytic parameter definition repairs

The two `.lean` files are based on exact current remote source bytes read from `/Users/tp/Lean/D1Bound5/D1Bound5` on 2026-10-18. Their untouched preimages are saved as `.before.txt`; SHA256 values are in `SOURCE_MANIFEST.json`.

Each patch inserts only `noncomputable section` before `namespace D1Bound5`. Deleting that inserted byte string reproduces the preimage exactly. No statement, hypothesis, proof, definition body, or import was changed. Original drafts in `analytic_next` were not overwritten. Their only observed differences from the remote preimages were the removed trailing `#print axioms` commands.

Reason: both files define Real-valued expressions using division via plain `def`. Pinned mathlib `0df444a360eaa60ab8c11dca51a86af692955474`, `Mathlib/Data/Real/Basic.lean:124`, declares `Inv ℝ` noncomputable. Neither source had a noncomputable section. Current continuation build receipts had no acceptance entry for either module at the inspection time.

The patches are source-only and have not been compiled by this agent. Root owns source intake and the serial compiler. article_audit independently reviewed both exact diffs and confirmed that only the noncomputable section was inserted; no imports, definitions, theorem statements, or proofs changed. Compiler validation remains pending.
