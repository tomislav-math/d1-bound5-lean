# Historical numerical verification code

This collection preserves earlier numerical implementations used while developing
and independently reviewing the paper. It complements the current v4 checks and
the complete historical v2 enumeration package. It is not a replacement for those
recommended entry points, and the old manuscript versions below are frozen inputs,
not alternative current papers.

The 133 copied files, including 38 Python files, are byte-identical to their source
archives. `SOURCE_MAP.json` records each archive, archive member and SHA-256, and
lists excluded Python members. The three package trees are deliberately separate
so that each original script retains its relative imports and source paths.

Only static packaging checks were performed on 15 October 2026. All 38 Python
files parsed/compiled in memory, imports resolved to standard-library modules,
SymPy or included sibling modules, and inspected named input paths were present.
No historical mathematical computation was rerun for this packaging operation.
`PACKAGING_CHECKS.json` records the checks and their limits. The `.log` and `.json`
files beside the code record earlier runs, not new runs.

## Reproduction conventions

Work in a disposable copy, because these original scripts overwrite their result
files. Run from the indicated package root, not from this directory. Do not use
`python -O`, which disables assertions. The commands below describe the original
numerical entry points; their success has not been retested in this packaging
round. Some programs execute computations when imported, so importing all modules
is not a cheap environment check.

Use Python 3.12 for the initial audit. It requires SymPy 1.14.0 for the three
`approximation_*.py` programs. The v1 review needs Python 3.10+ and SymPy 1.14.0
only for `structural_v1_algebra.py`. The supplementary v1 checks were originally
run with Python 3.12; only `terminal_identity.py` requires SymPy. Other included
programs use the standard library. The original requirements files are retained.
No PDF, LaTeX installation, network access or custom style file is required for
these numerical entry points.

Initial `one_small.py` creates its own polynomial cache if absent. No prebuilt
pickle file is distributed. Its related scripts import it. The completion
scripts import `completion_verify.py`, which itself executes the earlier finite
completion calculation. Those imports intentionally take time.

## Initial audit

From `initial_audit/`, individual numerical commands are:

```sh
python3 audit/checks/structural_checks.py
python3 audit/checks/structural_uniform_s15.py
python3 audit/checks/approximation_exact.py
python3 audit/checks/approximation_residue.py
python3 audit/checks/approximation_v_dominance.py
python3 audit/checks/small_constants.py
python3 audit/checks/small_seed_crosscheck.py
python3 audit/checks/small_verify.py classify
python3 audit/checks/small_verify.py triples
python3 audit/checks/small_verify.py pairs
python3 audit/checks/small_verify.py pell
python3 audit/checks/one_small.py
python3 audit/checks/one_small_htz.py
python3 audit/checks/one_small_uniform.py
python3 audit/checks/completion_verify.py
python3 audit/checks/completion_intervals.py
python3 audit/checks/completion_htz_free.py
python3 audit/checks/completion_common_tau.py
```

These include the 90/118/16 tail calculation; finite polynomial and residue
identities; all 48 small-pair graphs to modulus 10^550; 1016-field Pell graphs;
ten small-triple closures; the 40-pair reduction; the uniform 41-pair estimate;
and the old 56-triple/fourth-entry calculation. `small_final_source_check.py`
and `completion_final_source.py` bind saved results to the frozen manuscript
revision and can be run after the numerical programs. They read previous
results and are not independent repetitions of the large computations.

## Independent v1 review

From `v1_review/`:

```sh
python3 review_v1/checks/structural_v1_exact.py
python3 review_v1/checks/structural_v1_algebra.py
python3 review_v1/checks/approximation_v1_applications.py
python3 review_v1/checks/approximation_v1_transfers.py
python3 review_v1/checks/completion_v1_all_large.py
python3 review_v1/checks/completion_v1_exact.py
python3 review_v1/checks/reduction_v1_checks.py
python3 review_v1/checks/reduction_v1_overlap_algebra.py
python3 review_v1/checks/root_stronger_gap.py
python3 review_v1/checks/small_v1_constants.py
python3 review_v1/checks/small_v1_exact.py triples pairs pell
```

`approximation_v1_applications.py` imports and executes the full
`approximation_v1_exact.py` checker, so a separate run of the latter duplicates
that work. These programs reconstruct overlapping polynomial, interval,
finite-pair, triple and graph calculations independently of the initial audit.
Some checks concern proposed improvements subsequently incorporated into later
versions; their old constants are not the constants of the current paper.

## Supplementary v1 checks

From `v1_comments/`:

```sh
python3 comments_v1/approximation/check_comments.py
python3 comments_v1/determinants/structural_independent.py
python3 comments_v1/finite_reduction/certify.py
python3 comments_v1/independent/completion_integer_certificate.py
python3 comments_v1/independent/irregular_gap.py
```

The approximation script extracts function definitions from the included v1
polynomial engine and compares results with the included earlier interval data.
The completion scripts independently reconstruct the 38/16/2 partition that
replaced the fourth-entry search. Their analytic cutoffs and third-entry list
are inputs from the previously reviewed paper.

Two optional exploratory files are also preserved:

```sh
python3 comments_v1/determinants/terminal_identity.py
python3 comments_v1/finite_reduction/explore.py
```

The former is an exact symbolic alternative; the latter uses floating-point
arithmetic and is exploratory only, not a certificate.

`comments_v1/literature/rank_cross_check.py` is retained unchanged as historical
numerical source, with its recorded output. Its endpoint algebra is followed by
checks of proposed manuscript edits. Those final checks require three editorial
proposal JSON files deliberately excluded from this numerical collection:
`comments_v1/approximation/current_proposal.json`,
`comments_v1/approximation/with_P02_proposal.json`, and
`review_v1/agents/P02_combined.json`.
Consequently this legacy combined script is **not a standalone runnable check**
here. Its numerical conclusions are reproduced by the current complete packages;
do not interpret this exception as a current proof dependency.

## Evidence boundaries and exclusions

No original source script was rewritten to remove tests or bypass source hashes.
Private prompts, prompt recoveries, unrelated editorial ledgers, rendered page
images, manuscripts assembled only as unapplied proposals, and editing/build
orchestration are excluded. In particular the old aggregate `verify.py`,
`verify_review.py` and `verify_assessment.py` commands are not supplied as
entry points: their full workflows depend on excluded editorial materials.

The collection contains the historical numerical implementations available in
this workspace. It does not contain the external reviewer's separately promised
`D1_bound5_finite_checks.zip`, which was not supplied. The finite arithmetic
checks are not proof-assistant formalizations; analytic bounds, descent
completeness and all-orders cited identities require the paper's arguments.
