# Build and provenance record

## Environment

Lean `leanprover/lean4:v4.33.1`, executable commit
`819816b2e0a3bf405af45ae5c7af2491d8f5bee6`.
Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
Mac arm64. `lake-manifest.json` pins all dependencies.

## Current 40-theorem milestone

`proof-source-sha256.txt` fixes all eleven modules and the build configuration.
The exact theorem inventory is in `paper-to-lean.md`.
Actual command, in the main D1Bound5 working copy:

```sh
PYTHON=/Users/tp/.local/bin/python3.12 LEAN_NUM_THREADS=1 bash scripts/check.sh --replay
```

**Exit 0**, full output in `checks-012.log`.
Source-policy check: 11 modules, 40 explicit theorems, PASS.
`lake build`: PASS, 2958 jobs (including dependency jobs, not theorem count).
Transitive axiom audit: PASS, all 66 project declarations, with only
`propext`, `Classical.choice`, and `Quot.sound`.
Bundled `leanchecker`: PASS, all eleven project modules replayed.
This reuses Lean's kernel and trusts imported environments; it is neither
a fresh replay of all mathlib nor an independent external verifier.

The new OneThree module proves the rationality assertion in the coordinate
model for every positive discriminant. Its separate standalone compilation
also returned exit 0. The source manuscript was not edited.

**The main theorem is unproved in Lean.** The elaborated target has been
self-reviewed. The successful checks validate only the partial formalization
and the explicit hypotheses of its existing lemmas.

## Earlier verified checkpoints

Initial skeleton: commit `034702f`.
First mathematical checkpoint: `96af5c0e4296423f99f40f128e0f1d1b30c16c1d`,
36 theorems. `checks-010.log` records the exit-0 local build/audit/replay.
`clean-checkout-011.log` records an exit-0 run of the same complete procedure
in a fresh private GitHub clone, with no project proof objects inherited.
Only pinned public dependency caches were copied. The public-cache fetch,
source hashes, fresh compilation, axiom audit and kernel replay all passed.
Current source checkpoint: `49dda62363d663bce06709c9a4b99185901cc158`.
`clean-checkout-014.log` records **exit 0** for all 40 theorems in another
fresh private GitHub clone, `/Users/tp/Lean/D1Bound5Clean-49dda62`.
There were no project proof objects before compilation. Only pinned public
dependency caches were reused. All source/configuration hashes passed.
The public-cache fetch, fresh build, 66-declaration axiom audit, and kernel
replay of all eleven modules passed. Code, scripts and build configuration
remain unchanged from this tested commit; subsequent commits update records only.

## Source preservation and supporting Python checks

The handoff SHA256 manifest passed before and after this session, exit 0,
including all 259 listed files. User-local uv 0.13.1 was downloaded from the
official astral-sh/uv release, with archive SHA256
`cfe454573412ff7380d15fc7dae5997ab53ffce72fce0a78e91ddbc84001acd2`
verified against release metadata. Python 3.12.15 was installed user-locally;
the system Python and shell configuration were not replaced.

The unchanged `verification/revision_v4/run_checks.py` returned exit 0 using
Python 3.12.15. All six jobs passed. See `python-verification-summary.json`.
Full logs remain in the separate handoff check directory. Large historical
graphs were NOT regenerated. Python results are not Lean proofs.

The public Prove2Me setup document confirmed the Lean/mathlib pin. An
unauthenticated environments query returned HTTP 401. No credential was
read, no mission opened, and no paid API agent used.

## CI and preserved setup issues

The private repository contains a manual-only, commit-pinned workflow.
Its YAML and shell syntax were checked. No workflow run was initiated;
GitHub's run list was empty. Existing free allowance must be verified before
manual execution. No spending setting or public release was enabled.

Early raw logs are retained under `local-logs/initial-session`. Fixed issues
included dotted-module cache arguments, embedding coercions, explicit
modular casts, unfolding the decidable predicate, and doc-comment syntax
before `run_cmd`. The failed first audit was superseded by exit-0 audits.
An initial unqualified Lean lookup selected the global 4.35 default and was
interrupted; no project pins changed. An outside-project checker probe also
used the wrong global environment. Every accepted command used the recorded
project-local 4.33.1 environment. Original manuscript and Freiman sources
were not edited; only public dependency caches were reused separately.


## Continuation: full-ring bridge and irregular growth

Actual start 2026-10-15 17:17:21 UTC. Starting HEAD was 8abb662.
The full-ring bridge compiled separately and integrally, then was pushed
in commit 7275216ffe00ab35a32e26e8dbd29221edfef870 (64 theorems).
The complete irregular-growth module subsequently compiled with exit 0.

Command from /Users/tp/Lean/D1Bound5:

    LEAN_NUM_THREADS=1 PYTHON=/Users/tp/.local/bin/python3.12 bash scripts/check.sh --replay

Actual result: exit 0. Source scan: 19 modules, 70 explicit theorems.
Integrated build: 2967 jobs completed successfully. Transitive axiom audit:
117 project declarations, only propext, Classical.choice and Quot.sound.
Kernel replay: all nineteen project modules passed. Full receipt:
`records/continuation-checks-015.log`. Root import-coverage checking was
added to the source audit and separately rerun successfully on this source.

The kernel replay uses the bundled Lean checker, not an independent
external kernel implementation. No clean checkout of the new 70-theorem
source has yet been run; the earlier clean-checkout receipts are retained
with their original 40-theorem scope. The current source fingerprint list
is updated in `proof-source-sha256.txt`. This checked milestone is committed
with the message "Accept kernel-audited full-ring bridge and irregular growth".

## Direct recovery, 2026-10-15 beginning 19:48 UTC

The existing hourly task was enabled but had reported a generic failure.
Its prompt was updated, without adding a second task or claiming the unknown
platform failure was repaired. Actual Mac access was verified. The main
worktree's preserved finite developments were resumed, and the four analytic
modules were imported byte for byte from source commit 3a8f9ff.

New targeted commands, each with LEAN_NUM_THREADS=1 and the pinned
/Users/tp/.elan/bin/lake in /Users/tp/Lean/D1Bound5:

- build D1Bound5.SmallTailData0_1: EXIT 0; generic soundness plus Gaussian
  explicit-list completeness and full finite checker.
- build D1Bound5.SmallTailAllData: EXIT 0; all thirty normalized models,
  including the earlier (0,15) certificate. No certificate hypothesis remains.
- build D1Bound5.TailIrregular: EXIT 0; complete full-field tail lemma and
  D>2BC, no auxiliary C>=4 restriction.
- build D1Bound5.EvenDeterminant: EXIT 0 after explicit matrix-application
  and mapMatrix coercion repairs. Two harmless style/linter warnings remain.

The initial generic explicit-list proof had a Boolean-coercion elaboration
error; it was repaired and rebuilt successfully. The first determinant
attempt also failed elaboration and was superseded by the exit-zero retry.
No failed attempt is counted as an accepted proof. Raw local logs are in
local-logs/recovery-20261015T1949/. Current integrated audit/replay results
will be appended only after their actual completion.

Source and root-import coverage: PASS, 37 modules and 209 explicit theorem
statements. Most new statements are finite certificate helpers. The exact
source/configuration hashes are recorded in recovery-source-sha256.txt.
The original manuscript hash remained unchanged. No independent referee,
new clean checkout, paid service or Prove2Me mission has been used.
