# Build and provenance record

## Environment

Lean `leanprover/lean4:v4.33.1`, executable commit
`819816b2e0a3bf405af45ae5c7af2491d8f5bee6`.
Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
Mac arm64. `lake-manifest.json` pins all dependencies.

## Historical 40-theorem milestone

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


### Completed integrated validation of source 62292f0

Command (from the main working copy):

    PATH=/Users/tp/.elan/bin:$PATH LEAN_NUM_THREADS=1 PYTHON=/Users/tp/.local/bin/python3.12 bash scripts/check.sh

EXIT 0. Integrated build: 2985 jobs including dependency jobs. Source/import
coverage: 37 modules, 209 explicit theorems. Transitive axiom audit: 420
project declarations, only propext, Classical.choice, Quot.sound.
Exact successful output: recovery-build-axioms-20261015.log.
Two harmless style/linter warnings in EvenDeterminant remain; no compile
or audit errors remain in this accepted run.

The subsequent command `lake env lean --run scripts/SequentialReplay.lean`
with the TEN explicit modules in recovery-kernel-20261015.json completed
with EXIT 0 and ten REPLAY_PASS receipts. See recovery-kernel-20261015.log.
The replay function is byte-identical to replayFromImports in the installed
Lean 4.33.1 LeanChecker.lean. Only its scheduling/selection driver differs.
This uses the same Lean kernel and trusts imports. No independent kernel,
whole-project fresh replay, or new clean checkout is claimed.

The first private push of source 62292f0 was rejected because main had
received commits 26b4cd0 and 80bbb69 independently. Inspection showed those
commits touched only paper/, verification/, and README.md. They were merged
unaltered into a91af24, which was pushed successfully. All Lean source and
configuration hashes still match 62292f0. No force push was used.

The frozen original manuscript SHA256 remains
776933702a89ba3ee6bee39045f3f1643fd899541586cc2acbcc420b1fa03ef3.
Source and verifier fingerprints are in proof-source-sha256.txt and
verification-tools-sha256.txt. Python's generator reproduces the explicit
source lists, but neither its successful execution nor any file hash is
used as mathematical proof.


### Later concurrent hourly continuation

After all ten targeted replays finished successfully, the final working-tree
hash check detected one mismatch: D1Bound5.lean had gained an import of the
new DeterminantNormalization module from the independent hourly invocation.
No checked individual proof module or build configuration had changed.
Every manifest entry was verified against the actual 62292f0 Git source;
each current individual checked module was also verified unchanged. The
new module/import was preserved and was NOT counted in the 209-theorem,
420-declaration or ten-module replay results. Its own records govern its
acceptance. This is a later continuation, not a failure of the saved proofs.

### Determinant normalization (22:17–22:40 Europe/Zagreb, 15 October 2026)

Pinned environment unchanged: Lean 4.33.1, mathlib
0df444a360eaa60ab8c11dca51a86af692955474.

Observed command results from /Users/tp/Lean/D1Bound5:

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean D1Bound5/DeterminantNormalization.lean`: EXIT 0 after repairing initial elaboration errors.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.DeterminantNormalization`: EXIT 0, 1432 jobs.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: PASS for 38 modules and 216 explicit theorems, root imports covered.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5`: EXIT 0, 2986 jobs.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/DeterminantNormalizationAudit.lean`: EXIT 0, all 11 new declarations audited. Only propext, Classical.choice and Quot.sound.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.DeterminantNormalization`: EXIT 0, exact installed Lean kernel replay of the new module.

Raw outputs are in local-logs/det-normalization-20261015T2217-01.log,
-02.log, -03-build.log, -source-audit.log, -integrated.log,
-axioms-02.log and -replay.log. The first module build exited 1
because of redundant tactics, a product-power rewrite orientation and
an incorrect linear-combination sign; the patched module compiled.
The first targeted audit exited 1 due to an invalid doc-comment
before run_cmd; the corrected audit was rerun with exit 0.
Neither failed attempt is counted as successful validation.

This newly integrated root was not subjected to a full fresh
clean-checkout verification or an independent external statement audit.
The earlier 420-declaration whole-project axiom check and ten-module
kernel replay apply to the previous 209-theorem baseline. The current
new module was audited and replayed separately, with all its transitive
dependencies checked by the installed kernel.

## Root-error magnitude continuation — 15 October 2026

Pinned Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474.

- `lake env lean exploration/RootErrorMagnitude.lean`: trial 01 failed on a strict-monotone typeclass; repaired trials 02 and 03 exited 0.
- `python3.12 scripts/source_audit.py`: `SOURCE_AUDIT_PASS`, 39 modules, 221 explicit theorems.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5`: exit 0 (2987 jobs).
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/RootErrorMagnitudeAudit.lean`: exit 0, all five theorem dependencies limited to propext, Classical.choice, Quot.sound.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.RootErrorMagnitude`: exit 0, installed Lean kernel replay of this module.

Raw local logs: `local-logs/root-error-magnitude-trial-01.log` through `-trial-03.log`, `-integrated-01.log`, `-axioms-01.log`, `-replay-01.log`. Earlier determinant normalization has its own separately successful targeted audit and kernel replay. Entire-root replay and clean-checkout verification remain pending.

## Simultaneous symmetric root-matrix signs (15 October 2026)

Proof source: `D1Bound5/RootMatrixSigns.lean`.
Run START: `records/runs/20261015T211600Z-hourly3-START.md`.
All commands ran from /Users/tp/Lean/D1Bound5 under pinned Lean 4.33.1
and mathlib 0df444a360eaa60ab8c11dca51a86af692955474.

The first direct `lake env lean D1Bound5/RootMatrixSigns.lean`
compiled the signed-pair and matrix-choice lemmas, exit 0. A subsequent
matrix variant failed because a disequality was incorrectly invoked as
`h.symm`; repaired with `Ne.symm h`. Direct source compilation then
exited 0. The final source, including the corollary choosing four complex
square roots, compiled again with exit 0. Trial logs:
`local-logs/root-matrix-signs-001.log` through
`local-logs/root-matrix-signs-004.log`.

Final integrated checks were run sequentially:
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: exit 0,
  40 project modules and 225 explicit theorem declarations.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5`: exit 0,
  2988 Lake jobs, source root including new module.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/RootMatrixSignsAudit.lean`:
  exit 0; transitive axioms checked for one definition and four theorems.
  Exactly propext, Classical.choice, Quot.sound.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.RootMatrixSigns`:
  exit 0. This is replay by Lean's installed kernel, not an external checker.

Receipts: `local-logs/root-matrix-signs-source-005.log`,
`root-matrix-signs-build-005.log`, `root-matrix-signs-axiom-005.log`,
`root-matrix-signs-replay-005.log` in the same directory.
`records/proof-source-sha256.txt` and
`records/verification-tools-sha256.txt` were regenerated and
verified with `shasum -a 256 -c`, exit 0.

No complete fresh whole-root kernel replay, whole-project axiom audit
or new clean GitHub checkout was performed. Prior accepted milestones
remain distinct. MainStatement is still a proposition, not a theorem.

## Four-by-four operator norm (16 October 2026)

Pinned Lean 4.33.1; mathlib 0df444a360eaa60ab8c11dca51a86af692955474. Working project: `/Users/tp/Lean/D1Bound5`. No competing project-owned compiler was observed before starting. Existing staged files from prior runs were preserved.

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.MatrixOperatorNorm D1Bound5.RootMatrixOperatorBound`: exit 0, 2903 jobs.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: exit 0, 42 modules and 228 explicit theorems, with root-import coverage.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5`: exit 0, 3005 jobs.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/MatrixOperatorBoundAudit.lean`: exit 0, three final exported theorem types inspected; transitive axioms were exactly the permitted set `propext`, `Classical.choice`, `Quot.sound`.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.MatrixOperatorNorm`: exit 0.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.RootMatrixOperatorBound`: exit 0.

Raw logs are retained under `local-logs/matrix-operator-{targeted,source,integrated,axioms,replay-norm,replay-root}-20261015T2239.log`. Source code of the two modules was already saved by the preceding interrupted proof unit; this invocation completed their compilation, integration, audit and kernel replay. Whole-root axiom scan, fresh clean checkout and external statement review were not performed. The main theorem is still unproved.

## Exact reference determinant/inverse/adjugate (16 October 2026)

Pinned Lean 4.33.1 and mathlib `0df444a360eaa60ab8c11dca51a86af692955474`. All commands ran in `/Users/tp/Lean/D1Bound5`, with existing staged/unstaged work preserved.

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean D1Bound5/ReferenceMatrixSpectral.lean`: final exit 0, after repairs to finite-conditional simplification and `dotProduct` name.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ReferenceMatrixSpectral D1Bound5`: exit 0 (3006 jobs).
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: exit 0, 43 modules and 234 explicit theorem declarations; root import coverage passed.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/ReferenceMatrixSpectralAudit.lean`: final exit 0 after replacing an invalid doc-comment before `run_cmd`; seven declarations audited and inspected, only `propext`, `Classical.choice`, `Quot.sound`.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.ReferenceMatrixSpectral`: exit 0, exact installed Lean kernel replay of the new module.

The first direct source trials and the first audit failed and were corrected before these passes. No fresh all-module kernel replay, clean GitHub checkout, independent external review or proof of the global main theorem is claimed. The exact mathematics and limits are in `records/reference-matrix-spectral-20261016.md`.

## Exact reference inverse norm (16 October 2026)

Pinned Lean 4.33.1, mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
Workspace `/Users/tp/Lean/D1Bound5`. Before modification no project-owned
Lean compiler or checker was active. Existing staged/unstaged work and the
separate tail-analytic worktree were preserved.

- `LEAN_NUM_THREADS=1 lake env lean exploration/ReferenceInverseNormTrial.lean`:
  the upper bound compiled at trial 01, exit 0; an initial lower-bound
  trial exited 1 due to unreduced matrix-one entries and a misapplied
  ordered-multiplication lemma; corrected trial 03 exited 0.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ReferenceInverseNorm D1Bound5`:
  exit 0, 3007 jobs; source includes the root import.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`:
  exit 0, SOURCE_AUDIT_PASS, 44 modules and 243 explicit theorems.
- `/Users/tp/.elan/bin/lake env lean scripts/ReferenceInverseNormAudit.lean`:
  exit 0; transitive axiom dependencies checked on all ten new project
  declarations and exact principal theorem types inspected; only
  propext, Classical.choice and Quot.sound were found.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.ReferenceInverseNorm`:
  exit 0, actual replay of the new module by installed Lean kernel.

A first audit command was rejected by the command-access guard with an
indeterminate safety-status response. A permitted simpler invocation
succeeded without changing settings or permissions. No unsupported
replay or source scan is counted as a pass.

The source fingerprint list now includes the new module and updated root;
it was checked against actual SHA-256 hashes. The audit-tool fingerprint
list includes the new targeted checker. Mathematical detail:
`records/reference-inverse-norm-20261016.md`.

No new full-project axiom audit, whole-project kernel replay, clean
checkout or independent external statement review occurred. The
main theorem and lem:product-four remain unproved.

## Quantitative nonsingular perturbation and inverse bound — 16 October 2026

Working directory: `/Users/tp/Lean/D1Bound5`. Lean 4.33.1 and mathlib `0df444a360eaa60ab8c11dca51a86af692955474`; no pin changes. The prior Git staging area and older local source changes were preserved; no competing D1 project-owned Lean process was observed before compilation.

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/ReferencePerturbationTrial.lean`: both final trial elaborations exit 0. The initial one contained the determinant proofs; the second also compiled the strict inverse norm and ring-valued sign-selection corollary.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: exit 0, `SOURCE_AUDIT_PASS: 45 modules, 247 explicit theorems`, including root import coverage.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ReferencePerturbation D1Bound5`: exit 0, build completed successfully (3008 jobs).
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/ReferencePerturbationAudit.lean`: exit 0, the elaborated types and all four new transitive axiom dependencies checked; only `propext`, `Classical.choice`, `Quot.sound`.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.ReferencePerturbation`: exit 0, targeted replay using Lean's installed kernel (not an independent checker).

Audit and replay raw logs: `local-logs/reference-perturbation-axioms-20261016.log` and `local-logs/reference-perturbation-replay-20261016.log`. The direct build and source-audit receipts were observed in the remote command output, not falsely described as stored raw files. No full root kernel replay, fresh clean checkout or independent external statement audit was performed. The original manuscript is unchanged, the main theorem remains unproved, and no Prove2Me mission was opened.

Git receipt for this milestone: `git add` of the new module, audit, current records and hashes returned exit 0. `git commit -m 'Verify matrix root perturbation, determinant nonvanishing and inverse norm bounds'` returned exit 0, producing local commit `8b686a8889fa10ba834b32453d2ac3a95a9f9aac` with checked preceding continuations. GitHub remote visibility was confirmed `PRIVATE`. A request to execute ordinary `git push origin main` was blocked by the tool safety guard before execution. An authenticated read-only comparison returned remote main `980cc19e008a0120098d32a50c11031ae8df1558`; no push was performed. Full run details: `records/runs/20261016T012105Z-detperturb-FINISH.md`.


## Product-four rank-one and numerical unit (16 October 2026)

Pinned Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474; project /Users/tp/Lean/D1Bound5.
Commands and observed results:

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ProductFourNumericalClosure D1Bound5`: PASS, exit 0, 3011 jobs.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: PASS, 48 modules, 256 theorems.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/ProductFourNumericalAudit.lean`: PASS, nine transitive axiom audits, only propext, Classical.choice and Quot.sound.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env leanchecker --verbose D1Bound5.RankOneDeterminantBound`: PASS, exit 0.
- The same leanchecker command on `D1Bound5.ScaledRootRankOneBound`: PASS, exit 0.
- The same leanchecker command on `D1Bound5.ProductFourNumericalClosure`: PASS, exit 0.
- SHA-256 source and verification-tool manifests regenerated and file checks returned OK.

The numerical closure retains explicit unproved det/adjugate upper-bound assumptions. No new fresh clone or whole-root replay was performed. Frozen manuscript unchanged; main theorem still open.
