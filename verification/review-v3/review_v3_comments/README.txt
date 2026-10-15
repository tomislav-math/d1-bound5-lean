D1_bound5-v3: review assessment and focused exact checks
======================================================

Read ASSESSMENT.txt first. It records a decision for every review item,
the limitations of this round, and the recommended scope of a future v4.
The article has not been edited. The file f3_optional_patch.tex is a
proposed replacement fragment, not a complete or compiled new article.

To rerun: extract the entire ZIP, retain its relative directory layout,
and run from its top-level directory:

  python3 review_v3_comments/run_checks.py

Python 3 and its standard library suffice. No network access, SymPy,
pickle files, or previously installed project modules are required.
Do not run with Python's -O option, which disables assertions.

The runner executes six programs, writes each .log and exact .json output,
and records exit codes in run_results.json. Agent reports explain the
analytic arguments, which are not proved solely by the numerical checks.

Checks and evidence:
* review_controls.py: frozen source hash, weighted contradiction bound,
  and the exponent identity in Bennett's normalization.
* small_checks.py: discriminant list, fresh 90/118/16/0 enumeration,
  local cutoff constants, tiny quadratic-form enumeration, and explicit
  preserved-record checks for the 1016 Pell graphs.
* structure_exact.py: tight margins, rational M bounds, improved 3/2
  product estimate, and one phase constant.
* constructions_check.py: fresh reconstruction of five finite families,
  all coefficient sums, all fifteen section 6 overlaps with reduced M,
  common overlap table, root transfer, R2 and a generalization obstruction.
* f3_exact.py: coefficient bounds, 24 determinant monomials, direct-four
  constants and both downstream uses, optional factor-ten cutoff analysis,
  and independent cross-check of the improved product estimate.
* vandermonde24_cross.py: independent second check of the elementary
  determinant proposal and its downstream constants.

Included supporting files:
* output/D1_bound5-v3.tex: exact frozen review target.
* output/D1_bound5-v2.tex: earlier source used only for a text-preservation
  check of the unit-pair proof.
* revision_v2/checks/approximation_exact.py: disclosed earlier polynomial
  constructor; thirteen function definitions are extracted by AST. The
  earlier full checker is not executed by this runner.
* revision_v2/checks/small_v2_pell.json: prior 1016-field computation record.
  Reading it is not a fresh graph enumeration.
* revision_v3/build/D1_bound5-v3.aux: previous compiled label numbers.
  No new manuscript compilation is claimed in this review.

The large 48-graph and 1016-field searches were not rerun. This is a
self-contained focused-review package, not a replacement for the complete
D1_bound5-v3_verification.zip computational archive. The external reviewer's
D1_bound5_finite_checks.zip was not available for inspection.

All payload files are listed with SHA256 hashes in MANIFEST.sha256.
