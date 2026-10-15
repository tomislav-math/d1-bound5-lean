D1_bound5-v4 — manuscript and scoped verification package
=======================================================

Start with revision_v4/REVISION_REPORT.txt for changes, evidence and limits.

Released manuscript
  output/D1_bound5-v4.tex
  output/D1_bound5-v4.pdf

The source is a standalone article using ordinary TeX packages, with no
custom .sty files or external TeX inputs. The PDF has 58 pages. The same
source/PDF are mirrored under revision_v4/ where the verification scripts
expect them. These copies have identical SHA256 digests.

Run the current checks
----------------------

Requirements: Python 3.10 or newer; standard library only. No network access,
LaTeX installation or third-party Python library is required for these checks.
From the extracted package root:

  python3 revision_v4/run_checks.py

Six checks run sequentially in a temporary copy. Their fresh logs and JSON
results are saved in a new rerun_results/<timestamp>/ directory. The shipped
reports and logs are left untouched. Every job must exit successfully for the
runner to return status 0. Do not run Python with -O: checks use assertions.

The runner verifies the revised arguments, coefficient systems, relevant
finite inventories, interval calculations, cutoffs, source replay and supplied
compilation evidence. It does NOT repeat the historical 10^550 extension-graph
calculations and does not establish a proof-assistant formalization.

To recompile the article independently, a TeX Live installation containing
the article class, fontenc, lmodern, amsmath, amssymb, amsthm, booktabs,
longtable, microtype, geometry, xcolor and hyperref is sufficient.
With latexmk installed:

  mkdir -p rebuilt_pdf
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
    -outdir=rebuilt_pdf output/D1_bound5-v4.tex

The supplied final compilation log/auxiliary files are in
revision_v4/final_build/. A newly built PDF may differ in metadata or object
layout between TeX installations; byte identity with the supplied PDF is not
required. The manuscript source digest is the release identity.

Verification records
--------------------

revision_v4/change_register.json
  Exact 48-step change replay from the included frozen v3 source.

revision_v4/checks/
  Executable exact controls and the outputs recorded for this release.

revision_v4/checkpoints/
  Immutable mathematical packet and final integrated source used by the
  independent reviewers. final_controls.py binds accepted packet blocks
  to the release source.

revision_v4/reviews/
  Independent mathematical and interval reports; independent interval code;
  all-page visual-review records. The reviewer code was made portable by
  changing only path resolution and adding a checkpoint-hash guard.

revision_v4/render/
  The 58 full-page rendered images used for the display review.

revision_v4/reports/ and revision_v4/agents/
  Scoped preparation/provenance reports. Some name intermediate proposal
  files from the working session; those proposals are not required to run
  anything here. change_register.json records exactly what was applied.

prior_verification/
  The unchanged v3 verification archive, plus the subsequent v3 review
  assessment and its checks. The v3 archive contains earlier code and
  evidence, including nested prior-version archives. Their own READMEs
  describe their scope and reproduction instructions. Historical evidence
  is kept separate from fresh v4 results. No historical run is relabeled
  as a fresh v4 run, and no new public repository is claimed.

SHA256SUMS
  Integrity manifest for all delivered files other than the manifest itself.
  Before running individual scripts that overwrite shipped result files:

    sha256sum -c SHA256SUMS

The provided runner avoids overwriting those files and can be run repeatedly.
