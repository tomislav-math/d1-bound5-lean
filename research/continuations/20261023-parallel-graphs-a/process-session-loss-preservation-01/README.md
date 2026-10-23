# Process/session-loss preservation — historical observations only

This package preserves three explicitly selected root records and the five
files of graph39's frozen observer01 window, copied byte for byte.
The prior driver session 92469 and observer session 72015 have no observed
terminal exit code. No successful observer SUMMARY was produced. The stored
build summary is explicitly the last observed RUNNING snapshot, not a terminal
result. The cause of process/session loss is unestablished; no proof failure
or new OOM is inferred from these records.

The root resume invocation is a separate same-identity launch record. It does
not claim completion of that later run or any final build/audit/fresh gate.

Growing root-poll-* files, ROOT_PROGRESS_OBSERVATION.json, CURRENT_PROGRESS,
observer02 and current build outputs are excluded. Root's separate Mac progress
observation remains its own record. No source/control/process/Git operation was
performed by this preservation.
