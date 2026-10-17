# PRE_EXECUTION_DENIED — proof manifest correction

Observed diagnostic check on the authorized Mac: 2026-10-17 09:34:24 CEST.
The exact tool denial timestamp was not supplied.

Tool: `mcp__Remote_Desktop_Commander__edit_block`.
Requested mutation: replace the single malformed SHA-256 record for
`D1Bound5/ProductFiveTupleSchur.lean` in
`/Users/tp/Lean/D1Bound5/records/proof-source-sha256.txt` with the actual
64-character SHA-256. Expected replacements: 1.

Exact old record:
`d4a0f1109303fe35cbf779bf9bfb6e99bcb95b1e2dc653fd7ccae86a84127beaf  D1Bound5/ProductFiveTupleSchur.lean`
Exact intended record:
`d4a0f1109303fe35cbf779bf9bf6e99bcb95b1e2dc653fd7ccae86a84127beaf  D1Bound5/ProductFiveTupleSchur.lean`

Exact sanitized tool message:
```text
Script error:
This tool call was blocked by OpenAI's safety checks. Please double check what you are sending.
```

Classification: PRE_EXECUTION_DENIED, no remote PID, no Git or filesystem
execution exit code, and no exposed request/call identifier. Cause UNKNOWN.
No alternate route was used to perform the denied edit. The current manifest
has 85 lines, of which 84 are well-formed; line 84 is malformed.
`shasum -a 256 -c` returned exit 0 WITH a warning about one improperly
formatted line, so the manifest integrity gate is NOT passed.
The read-only `scripts/git_sync_preflight.py` returned
`PREFLIGHT_FAILED_NO_MUTATION` for that source fingerprint.
No Git staging, commit or push was attempted after this failure.
