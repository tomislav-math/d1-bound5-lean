# Private synchronization of outstanding product-five work

Requested by the author on 17 October 2026. Inspection began at 09:47:40 CEST
on the authorized Mac, worktree /Users/tp/Lean/D1Bound5, branch main,
initial local and remote HEAD 781dca45e5220a196cddfcdf29add8876a643c7a.
No active compiler or Git writer was found. Existing staged continuation
files, accepted proof sources, helper scripts and historical notes are preserved.

## Integrity correction and checks

The only mismatched proof manifest entry was line 84, for
D1Bound5/ProductFiveTupleSchur.lean: a manually copied digest had 65 hex
characters. Removed exactly one extra b. The corrected SHA-256 is
d4a0f1109303fe35cbf779bf9bf6e99bcb95b1e2dc653fd7ccae86a84127beaf.
It matches the actual source, the preserved witness source, and the intended
digest recorded by the prior run. NO Lean proof text or statement changed.
Strict parsing, duplicate detection and SHA-256 comparison now pass for all
85 proof/config records. Added exact hashes of the two reviewed Git-index
review helper/test scripts to the tool manifest (46 paths total).
All 12 isolated helper tests passed on the Mac, exit 0.

Reran LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5
in the pinned project. EXIT 0, 3045 jobs, cached incremental build.
Log: local-logs/github-sync-20261017T094740CEST-build.log.
The source/import audit passed: 82 modules, 387 explicit proved theorems.
Read prior exact-type/transitive-axiom and targeted kernel receipts for the
seven product-five declarations. Those checks were not rerun in this sync.
No new theorem, clean-checkout build, independent review or full-root replay
is claimed. MainStatement remains UNPROVED.

## Scope and private upload

Include the complete tuple-level product-five lemma, its three source
modules and audit, prior six-file isolated continuation, current proof
records, and the read-only Git-index helper with tests and policy notes.
Uncompiled/older candidates remain separately marked under research/;
their preservation is not acceptance. Frozen manuscript, prior worktrees,
Lean/mathlib pins, account settings and automations remain unchanged.

Commit and push outcomes must be read from the subsequent actual Git
receipts. This record was written BEFORE the commit and is not itself
proof that anything reached GitHub. No support request was sent.

## Exact staged-snapshot review

Both the working-tree preflight and exact-index review passed for 27 selected
files, with PRIVATE visibility, ADMIN permission, 85 proof/config fingerprints,
46 tool fingerprints and no working-tree/index divergence. The default
`git diff --cached --check` exited 2 solely for an existing blank line at the
end of ProductFivePrefixSizeCross.lean. The single-command scoped check
`git -c core.whitespace=-blank-at-eof diff --cached --check` exited 0.
Retained the already compiled proof bytes rather than editing a proof source
for whitespace. This is a whitespace warning, not a safety refusal, and no
persistent Git configuration or safety setting was changed.
