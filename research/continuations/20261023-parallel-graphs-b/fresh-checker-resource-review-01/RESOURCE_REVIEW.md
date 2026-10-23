# Full-root fresh replay: resource review

Keep the current reviewed `LEAN_NUM_THREADS=0`, 6 GiB sampled RSS budget, 32 GiB virtual-address cap and 1 GiB reserve for the later serialized full-root attempt. The source review gives no reason to switch to eight checker workers, and it does not establish that the complete replay fits in 6 GiB. This is a configuration assessment, not a successful checker run or a new memory bound.

The exact command remains `leanchecker --verbose --fresh D1Bound5`. The separate builder's worker count does not configure this process; once all compilers drain, changing their previous concurrency does not create concurrent replay jobs. Other heavyweight jobs must remain absent during the final check so that the existing quiescent-memory admission and reserve retain their meaning.

## What the official source does

The installed distribution's `LeanChecker.lean`, `Lean/Replay.lean` and `Lean/Environment.lean` were read locally and compared byte-for-byte with the official `v4.33.1` tag. They are outside the runtime lock's bin/lib roots; the report does not mislabel them as runtime-pinned files. C++ runtime source is absent locally, so the exact tagged `object.cpp`, `thread.cpp` and kernel `environment.cpp` were retrieved read-only from the official repository. `SOURCE_PROVENANCE.json` records their Git blob IDs, SHA256 values and URLs. No runtime-wide hash sweep or binary rebuild was performed.

1. `LeanChecker.lean`'s fresh branch selects exactly one module and calls `replayFromFresh`. Its `IO.asTask` fan-out appears only in the non-fresh branch. The fresh function imports the root, then calls replay into an empty environment.
2. `Lean/Replay.lean` walks the remaining constants and recursively visits dependencies sequentially. It calls the kernel's `addDeclCore` directly; it does not enter the elaborator's asynchronous declaration-checking path. Eight task workers therefore do not make eight declarations of this fresh replay check simultaneously.
3. `object.cpp` reads `LEAN_NUM_THREADS`; zero leaves the task manager absent, and task spawn/map/bind execute synchronously. A positive number creates a task manager whose workers are spawned when tasks are queued. Merely setting eight does not guarantee eight active workers. The existing zero setting removes that task-queue concurrency.
4. Zero task workers does not mean zero additional operating-system threads. Tagged `thread.cpp` runs the Lean main routine on an `lthread` by default and uses a 1 GiB default virtual stack reservation on native64-bit builds unless overridden at build time. Additional task workers, when actually created, can add stack address reservations and live allocations. This is a source-default observation, not a measured installed-binary stack-size guarantee or a physical-RAM estimate. No stack/environment change is proposed.
5. `withImportModules` frees imported compacted regions only after the replay callback finishes. `finalizeImport` constructs constant maps and import metadata, while replay constructs a new kernel environment and remaining/pending sets. Imported expression objects can be shared; this is not a claim of two full deep copies. Nevertheless, full-import memory and the growing checked environment coexist, and individual checks can need temporary memory. The previous approximate3.2 GiB RSS/3.99 GiB HWM only measured a prefix of an interrupted attempt. Its interruption was filesystem loss, not OOM, and that observed peak is not an upper bound on completion.

## Exact supervisor limits

The reviewed supervisor is SHA `e04afcfff00b176bc3ffe51870d82c4c467415c9bac5769cbc28e89e63e21843`; the captured revision02 configuration retains 32768 MiB address space, 6144 MiB physical RSS, 1024 MiB reserve and an86400-second child timeout. Although the input build environment records `LEAN_NUM_THREADS=1`, `approved_environment` explicitly overwrites it with `0` for the checker and freezes that selected environment.

| Mechanism | Actual effect |
|---|---|
| `RLIMIT_AS=32 GiB` | Hard process virtual-address limit, including mappings/stacks; it is not a32 GiB RAM allocation. |
| RSS budget6 GiB | Current child `VmRSS` sampled every0.5 seconds; `VmHWM` records a peak but does not drive this threshold. |
| Reserve1 GiB | Stop when the cgroup's sampled resident floor exceeds its finite limit minus the reserve. The floor includes anon/kernel/shmem/dirty/writeback and excludes clean file cache. |
| Admission | Refuses launch unless6 GiB + current resident floor +1 GiB fits the actual finite cgroup limit. For an8 GiB limit, baseline floor must be at most1 GiB. |
| Termination | Sends TERM, then waits up to5 seconds before KILL. Sampling and grace can overshoot a threshold; the enclosing cgroup is the hard physical-memory boundary. |
| Result | A stop reason, nonzero exit, OOM-event change, missing exact fresh-root banner, or changed frozen inputs cannot become accepted success. |

The child timeout starts around process launch; it does not bound all pre/post input verification. The supervisor keeps memory samples in its own memory until the run finishes, so long runs add some supervisor demand; no numerical maximum for that overhead was measured here. Main-child RSS includes resident file mappings, so it differs from the cgroup's conservative resident-floor formula. A large clean page cache alone is not the reserve failure criterion.

## Actionable interpretation

- Retain threads0; eight workers offer no source-supported parallelism for this exact fresh path. Do not replace the full-root replay with parallel prefix checks, which would change the required verification scope.
- Wait for the complete source build and audits, all compilers to drain, and the existing memory-admission check. The recent build scheduling/OOM issue is a separate event from the old fresh replay's filesystem-loss interruption.
- Preserve the current cap/monitoring settings rather than extrapolating a safe limit from the old interrupted peak. A future RSS/reserve/address-space stop must be recorded as incomplete and examined from its actual memory samples and cgroup events before any separately reviewed retry configuration.
- Require the actual terminal exit0, exact root banner, unchanged input freeze and all other acceptance guards. This review does not certify a future run, a completion time, or a maximum RSS.

No Lean executable, `leanchecker`, unsupported `--help`, or compiler was launched by this review. No runtime, environment, configuration, production source, Git state, or existing receipt was changed. Only this owned research review and its source snapshots were written.
