# Exact 4x4 reference determinant: progress checkpoint

Local project: `/Users/tp/Lean/D1Bound5`, branch `main`; pre-run HEAD `980cc19`. Existing staged/unstaged work from earlier invocations preserved.

New code `D1Bound5/ReferenceMatrixSpectral.lean`: inverse with diagonal -4/3, off diagonal 2/3; both product equalities; nonzero determinant; exact determinant -3/16 via the 1-by-4 rank-one determinant lemma; adjugate as determinant times the inverse; cofactor values 1/4 (diagonal) and -1/8 (off diagonal). These do not assume the main theorem or any analytic estimates.

Verified commands (pinned Lean 4.33.1, mathlib 0df444a360eaa60ab8c11dca51a86af692955474):

- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean D1Bound5/ReferenceMatrixSpectral.lean`: exit 0 after repairs.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake build D1Bound5.ReferenceMatrixSpectral D1Bound5`: exit 0, 3006 jobs.
- `/Users/tp/.local/bin/python3.12 scripts/source_audit.py`: PASS, 43 modules, 234 explicit theorems.
- `LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean scripts/ReferenceMatrixSpectralAudit.lean`: exit 0 after repairing invalid doc-comment; all seven new declarations allowed only propext, Classical.choice, Quot.sound. Types checked.

Kernel replay `leanchecker --verbose D1Bound5.ReferenceMatrixSpectral` started; outcome pending at writing. Earlier failed direct source iterations and the first audit exit 1 are not counted as passing.
