# Private Git synchronization diagnosis and recovery

Author requested all outstanding proof work and historical research be
preserved in the existing PRIVATE tomislav-math/d1-bound5-lean repository.

## Observed facts

The reviewed 35-file product-five development was committed as 122b4cd
and an ordinary separate push succeeded on 16 October 2026. Earlier
pre-execution rejections are recorded in run notes, including subsequent
rejections while trying to save the signed-prefix module. Those notes do
not expose the internal decision that produced the refusal. No supported
root cause can be asserted beyond the observed pre-execution boundary.

Read-only inspections during this recovery found the expected repository,
ADMIN provider permission, app permission Allow all actions, a configured
Git identity, no index lock or active non-sample hooks, and no Git entry
in Desktop Commander's blocked command list. No credentials or security
configuration was changed. Successful later operations do not establish
that recurring platform-level denials have been permanently repaired.

The official OpenAI app-permission documentation, verified 16 October,
states that saved approvals do not override safety protections and some
sensitive requests may be denied instead of showing an approval prompt:
https://help.openai.com/en/articles/20001495-managing-app-permissions-in-chatgpt
This describes the general mechanism, NOT the specific reason for these
Git rejections.

## Procedure for subsequent invocations

GIT_SYNC_POLICY.md and the read-only scripts/git_sync_preflight.py preserve
the author's authorization for ordinary reviewed commits and non-forced
pushes during scheduled runs, verify the exact private destination and
staged content, and require plain separate Git calls. They do not bypass
or disable any safety mechanism. The existing hourly automation was
updated with that procedure without changing its cadence or enabling a
new task.

Record an actual rejection with time, nonsensitive command, returned
message and any exposed request identifier. Do not invent Git stderr or
an exit code when the process never ran. Stop explicitly denied actions;
a technical transient error is different from a safety refusal. Retain
local work and report the exact unresolved boundary for support review.

## Preservation scope

research/snapshots/20261016-github-recovery contains 61 old exploration
files, 317 text logs and eight conversation exports, separately labelled
NOT ACCEPTED PROOF DEPENDENCIES. A manifest preserves their original
paths and hashes. Original exploratory work, the frozen manuscript,
Lean dependencies, previous projects and credentials were not changed.
The current continuation and any later files are recorded separately.
Final commit and verified remote-head receipts must be appended only
after actually observed successful operations.
