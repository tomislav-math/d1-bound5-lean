# Build and provenance record

## Pinned environment

Lean `leanprover/lean4:v4.33.1`, executable commit
`819816b2e0a3bf405af45ae5c7af2491d8f5bee6`.
Mathlib `0df444a360eaa60ab8c11dca51a86af692955474`.
Mac arm64. Commands below ran in the new D1Bound5 project, unless stated otherwise.
The initial compiling skeleton is commit `034702f`.

## Accepted first mathematical milestone

`records/proof-source-sha256.txt` fixes every proof module and pinned build
configuration used in this milestone. `records/paper-to-lean.md` gives all
36 explicit theorem names and their mathematical scope.

Actual command:

```sh
PYTHON=/Users/tp/.local/bin/python3.12 bash scripts/check.sh --replay
```

Result: **exit 0**, complete output in `records/checks-010.log`.
Source-policy check: 10 modules, 36 explicit theorems, PASS.
`lake build`: PASS, 2957 jobs (includes imported dependencies, not theorem count).
`lake env lean scripts/Audit.lean`: PASS, 56 project declarations, every
transitive axiom list a subset of propext/Classical.choice/Quot.sound.
`LEAN_NUM_THREADS=1 lake env leanchecker --verbose D1Bound5`: PASS, replayed
all ten project modules. This reuses Lean's kernel and trusts imported
module environments; it is not a fresh replay of all mathlib or an external verifier.

The elaborated target and its definitions were printed and self-reviewed.
The target is UNPROVED. The successful checks validate only the existing
partial formalization and its explicit hypotheses.

## External supporting checks

The handoff manifest passed `shasum -a 256 -c SHA256SUMS`, exit 0.
User-local uv 0.13.1 was downloaded from the official astral-sh/uv release;
archive SHA256 `cfe454573412ff7380d15fc7dae5997ab53ffce72fce0a78e91ddbc84001acd2`
was checked against release metadata before installation. Python 3.12.15
was then installed user-locally. The system Python and shell configuration
were not replaced.

The unchanged `verification/revision_v4/run_checks.py` ran with Python 3.12.15,
exit 0. All six jobs passed; their compact result is in
`python-verification-summary.json`. Full logs remain in the handoff's
separate local check directory. Large historical graphs were NOT regenerated.

The public prove2me/prove2me_workspace `references/lean-setup.md` confirmed
the chosen Lean/mathlib pair. An unauthenticated environments request returned
HTTP 401. No credential was read or mission opened.

## Reproducibility / CI gates

A clean-checkout test will be recorded separately with its actual source
commit and result. A manual-only CI workflow has been prepared and its YAML
and shell syntax checked. It has NOT been dispatched or claimed to pass.
The workflow requires an explicitly confirmed existing free allowance.
No spending setting was changed.

## Preserved failed setup/proof attempts

Raw early logs and public setup documents are retained under the ignored
`local-logs/initial-session` directory. Fixed issues include using dotted
Mathlib module names for cache retrieval; embedding coercions in the ring-
equivalence lemma; explicit cast homomorphisms in modular soundness; unfolding
the finite predicate before `decide`; and a doc-comment syntax error before
`run_cmd`. The failed first audit was superseded by an exit-0 audit.
An initial unqualified Lean command selected the global 4.35 default and was
interrupted; no project pins were changed. An outside-project checker probe
also used the wrong global environment. All accepted commands above used
project-local `lake env` and the recorded 4.33.1 pin.
