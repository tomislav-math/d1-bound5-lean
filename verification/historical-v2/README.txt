D1_bound5-v2 verification package

Extract the ZIP, then work from its D1_bound5-v2_verification directory.
The article is in output/D1_bound5-v2.tex and output/D1_bound5-v2.pdf.
Start with REVISION_REPORT.txt and revision_v2/agents/literature_style.md
for the changes and accepted-recommendation ledger.

Requirements

All mathematical verification scripts use Python 3.10+ and only the standard
library. No pickle, stored polynomial cache, network access or custom .sty file
is required. A LaTeX installation with the standard packages listed in the
source, including Latin Modern and microtype, is needed only to rebuild the PDF.

Commands

  python verify.py --integrity

Checks the SHA-256 manifest, registered source transformation, current result
bindings and aggregate counts. It does not repeat the mathematical computations.

  python verify.py --quick

Runs the structural, approximation, one-small, completion, constant and
cross-comparison programs. For the three Section 7 enumerations it checks the
archived outputs and exact source reconciliation without recomputing the graphs.

  python verify.py --full

Runs all those checks plus all 48 small-pair graphs, the Pell enumeration and
the ten triple closures. The pair graphs took about 150 seconds in the review
environment; total time depends on the machine. Execution logs are written to
verification_run_logs. A failed subprocess stops the runner.

These programs overwrite their JSON result files. Run them in an extracted copy
if the original archived outputs are to remain unchanged. The manifest is for
the delivered archive; rerun output bytes (especially timings) can differ.

  python revision_v2/build_v2.py

Regenerates v2 from the unchanged v1 and the accepted exact-replacement inputs.
Every replacement is guarded, and the source hash must match the delivered v2.
The legacy review/proposal files included under comments_v1 and review_v1 are
regeneration inputs or provenance, not competing current manuscript versions.

  latexmk -pdf -interaction=nonstopmode -halt-on-error output/D1_bound5-v2.tex

Rebuilds the PDF. Recompiled PDF bytes may differ because of timestamps or TeX
versions, even when the mathematical source is identical. Use the source hash,
clean compiler log and page inspection to assess the regenerated document.

Contents

  output/                  Final article source and PDF; earlier review text is
                           included only as an exact regeneration input.
  upload/                  Authoritative unchanged v1 source.
  revision_v2/agents/       Six scoped review ledgers.
  revision_v2/checks/       Executable checks, exact outputs and execution logs.
  revision_v2/build_final/  Final successful LaTeX logs.
  revision_v2/change_register.json
                           All 122 exact replacements and dispositions.
  revision_v2/D1_bound5-v1_to_v2.diff
                           Complete source diff.
  revision_v2/build_v2.py   Guarded regeneration of the new source.
  comments_v1/, review_v1/  Minimal earlier proposal/provenance inputs.
  SHA256SUMS.json           SHA-256 manifest of all other included files.

Evidence conventions

The Section 7 enumeration outputs retain the original initial-v2 hash at which
they were executed. small_v2_source_check.py recovers that exact earlier source
by reversing the four registered final editorial changes and proves that all
of Section 7 is byte-identical. Rerunning --full uses the final v2 source and
records its hash. This distinction is intentional.

The comparison scripts compare independently computed certificates. They do not
create independent mathematical results simply by rereading an existing JSON.
The final_controls script is similarly an aggregate integrity check.

The six ledgers describe mathematical read scopes and limits. No full copyrighted
reference PDFs are bundled. The literature ledger and accompanying source index
give the primary references and access limits. This package is reproducible
evidence for the review, not a proof-assistant formalization.
