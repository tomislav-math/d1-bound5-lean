# Documentation update

This update simplifies the public documentation and preserves the development
history in `HISTORY.md`. The former private synchronization policy is archived
in `records/GIT_SYNC_POLICY.md`. Numerical reproduction now points to the
article repository as the canonical supplement.

The only change in the 4,406-module Lean source closure removes an obsolete
acceptance-status sentence from the documentation comment in
`D1Bound5/MainTheorem.lean`. Its code, theorem statement and imports are unchanged.
All other production Lean files remain byte-identical to the baseline identified
in [baseline.json](baseline.json).

The exact source commit and checksum are listed in [release.json](release.json).
The current source-lock SHA256 is:

```text
511466d8d0ea4a23e7d8d6746a5ad3efec153184a02ca4e44ec8789b7788d5ed
```

[validation.json](validation.json) records the source comparison and integrity
checks. [manifest-proposal.json](manifest-proposal.json) records the manifest
refresh. These checks establish the scope and integrity of the documentation
update. They are not a new full source build or a new kernel replay.

The earlier full verification evidence remains attached to the exact source
snapshot recorded there. A subsequent source comment change does not rewrite
those historical receipts.

The Prove2Me description update explains the statement-card placeholder and
retains the manuscript date and the formalization completion date. Its [read-back record](prove2me-description.json)
confirms that the theorem remains `Proved` and its formal statement is unchanged.
