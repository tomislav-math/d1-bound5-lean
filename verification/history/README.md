# Earlier verification work

`early/README.md` documents the curated numerical programs from the initial
audit and two v1 review collections, with their original inputs and outputs.

`v3/` retains available v3 checking code and evidence. Prefer its adapted
`revision_v3/checks/` programs to the inherited `prior_review` scripts.
The latter preserve older path assumptions and are provenance, not advertised
standalone entry points. In particular `prior_review/checks/approximation_check.py`
expects a different input location and `prior_review/agents/completion_check.py`
uses the original working-directory layout. `revision_v3/checks/final_controls.py`
requires PyMuPDF. No stdlib-only claim is made for this historical directory.

For reproduction of the current paper use the commands in
[the main verification guide](../README.md), which identify the current v4
checks, the complete v2 enumerations and the focused v3 independent review.
All original output logs retain their historical meaning. These legacy programs
were not rerun for the date-only release.
