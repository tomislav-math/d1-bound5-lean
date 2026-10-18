# Two-slot driver proposal

This separate proposal retains `lake build D1Bound5.<name>` and its trace bookkeeping. It defaults to a dry run; only the parent may copy, review and start it with `--execute`. The existing serial driver was not modified or stopped.

Before starting:

1. Stop and reap the old serial compiler driver and any other owned Lake builds. Its code does not honor the new driver ownership lock.
2. Provide `continuation-trusted-baseline.json` with `accepted[module].fingerprint` equal to the source-closure fingerprint and `accepted[module].artifacts` mapping repository-relative artifact paths to exact SHA256 hashes. This is required for **all old accepted rows without artifact hashes**, including queued modules. A prior successful static trial/full Lake build is the provenance; artifact existence alone is never accepted.
3. Queue the nine untracked dependencies identified by the parent. The driver refuses to start any target while an untracked, nonqueued dependency exists. Use `blocked_modules` for the held modules; any target whose closure intersects that set is ineligible.
4. Update intake code to take an exclusive flock on `continuation-intake.lock`. While holding it, read `continuation-active.json`, reject any source write in its **protected_closure union**, and reject changes to immutable toolchain/manifest/lakefile inputs. Publish queue changes under this same lock. The `closure` field is also the union for compatibility with older readers, but the shared lock is still necessary to eliminate the check/write race.

Each launch requires every transitive D1 dependency to have accepted current source fingerprints and unchanged artifacts. Therefore the uncompiled closure contains only the requested target; held or unaccepted dependencies cannot be hidden inside a Lake build. Shared accepted source closures and their artifacts remain frozen. Two target process groups are the hard maximum. Each timeout terminates only its owned process group, escalates after10 seconds, and records failure. Any prior failed fingerprint is never retried unchanged, even if the timeout is increased.

Completion acceptance requires success, unchanged source closure, unchanged shared dependency artifacts, unchanged build configuration, an output olean, and no timeout/interruption. The driver saves target artifact hashes for future gating. A changed shared artifact causes rejection and drains/stops the whole driver.

Important Lake qualification: the trusted baseline must come from a currently fresh successful Lake build/trial, including valid trace files. Hash equality does not independently prove that Lake considers a trace fresh. If Lake rewrites a shared dependency despite the trusted baseline, the post-check rejects the builds and stops; this is a guard, not a guarantee against Lake's internal rebuild choices. The driver does not claim isolation from arbitrary uncooperative writers. Parent-reviewed fresh traces plus the intake lock are required for the proposed two-slot mode.

Local validation: `python continuation_driver_parallel_dummy_test.py` passes five tests. The tests use temporary files and dummy Python child processes only—no Lean, Lake, network, or remote writes. They verify two simultaneous independent targets, dependency ordering, complete active-closure union, held-closure blocking, untracked-dependency blocking, failed-fingerprint suppression, owned-process-group timeout cleanup, and rejection/stopping on shared-artifact mutation.
