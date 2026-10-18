# Read-only Lean build performance diagnosis

Inspected 2026-10-18, approximately 03:45–03:52 UTC. No compiler, benchmark, process control, remote mutation, or configuration change was performed. The only process/memory measurement was one short `ps` / `vm_stat` / `sysctl` snapshot. Further remote calls read existing source, build records, logs and configuration. This is a performance diagnosis, not a new verification result.

## Result

The existing evidence does **not** support a drop-in launch flag, artifact relocation, or safe extra parallel slot that removes the 30–90 second cost. Most elapsed time is inside the target's Lake build action, which includes a fresh Lean process, import loading, elaboration/checking, code generation and output processing. Current observations strongly suggest substantial memory pressure; the available data do not isolate those internal phases quantitatively.

One small, safe-in-principle coordinator optimization is available: while the sole slot is occupied, avoid recomputing the entire scheduling snapshot every two seconds. Keep queue/pause/stop handling, static-input checks, the protected active closure and all fresh launch/completion checks. No implementation was changed. This removes avoidable source reads/stats and graph work; it is not a proposed cure for the dominant Lean cost.

## Measured separation of costs

The current remote driver is byte-identical to local `continuation_driver_parallel.py`, SHA256 `5e2ba86e07e28d0febbe3a811019fbf46197acc7367799b3598fa9077b6f0081`.

Among 42 recent records with a matching successful `Built D1Bound5.<target> (<time>)` log line, the median difference between the coordinator's total and Lake's target build time is **7.44 s**, with range **5.07–14.23 s**. Lake prints rounded durations; these are not sub-second profiles. The difference includes Lake loading/dependency bookkeeping, polling and completion integrity checks, not just Python overhead.

| Target | Source lines | Import-map entries | Coordinator total | Lake target build |
|---|---:|---:|---:|---:|
| `SmallPairFloorWitnessData34` | 471 | 462 | 11.06 s | 5.3 s |
| `PairNegativeIntegerObstruction` | 73 | 1523 | 30.07 s | 23 s |
| `SmallTripleExtensionData1` | 98 | — | 32.06 s | 25 s |
| `BennettDeterminantNonzero` | 55 | — | 37.26 s | 30 s |
| `PairCachedFloorWitnesses` | 148 | 2955 | 62.07 s | 57 s |
| `SmallPairGraphCachedData34` | 472 | — | 77.12 s | 71 s |

Import counts come from each actual `.setup.json` `importArts` map. They do not mean that all listed artifacts are simultaneously resident. There is no blanket `import Mathlib` or `import Mathlib.Tactic` in these maps. In particular, proof text length is a poor predictor of the environment that a new process must load.

The last 24 records give 23 inferred gaps between the previous completion and the next launch: median **0.214 s**, minimum **0.060 s**, maximum **0.373 s**. The driver is not leaving a 30-second idle interval between jobs.

An existing `CoherentIntegralForms` receipt took 3.00 s, but its log says **Replayed**, not **Built**. It only demonstrates a warm unchanged Lake invocation; it must not be presented as a fresh compile timing.

## One live memory/process snapshot

At 03:45:11 UTC:

- Physical memory: 8 GiB; 8 logical CPUs.
- Swap in use: 11,525.50 MiB.
- Page size: 16 KiB; wired pages 190,911 = 2.913 GiB; compressor pages 261,739 = 3.994 GiB; free pages 5,133 = 0.078 GiB; file-backed pages 11,059 = 0.169 GiB.
- Active Lean process: `SmallPairGraphLeft34`; elapsed 8:17, accumulated CPU 1:31.53, instantaneous CPU 5.5%, RSS 75,168 KiB.
- Its Lake parent: elapsed 8:23, accumulated CPU 2.94 s.
- Python coordinator: elapsed 36:29, accumulated CPU 2:02.32, instantaneous CPU 4.6%.

The low resident set is not evidence that Lean needs only 75 MiB: macOS compression/swapping and the large difference between CPU and elapsed time prevent that interpretation. This snapshot shows severe memory occupancy but does not measure the current process's page-fault rate. It cannot by itself assign all waiting time to paging.

The existing bounded two-sieve trial (`bounded-two-sieve-trial.json`, SHA256 `5bcbd1192db34edb2c7473227068fd9622b34bc671d58e7f851ab4702ee12d3f`) supplies actual interval evidence: over roughly 51 seconds, system swap-in counters rose by **4.256 GiB**, swap-out by **4.529 GiB**. Both certificates passed, but that trial did not establish a throughput gain. The earlier reviewed two-slot trial made a graph rebuild take 445 s rather than about 69 s. These observations support retaining one compiler slot.

## Pinned Lake behavior and practical consequences

Read the installed Lean 4.33.1 sources, not an assumed current API:

- `Lake/CLI/Build.lean:71–77`: a plain module target selects `leanArts`.
- `Lake/Build/Module.lean:969–980`: the target build action constructs setup, clears output artifacts, invokes Lean, then computes artifact hashes.
- `Lake/Build/Actions.lean:28–83`: a new Lean process receives `-o`, `-i`, `-c`, `--setup`, and `--json`; `LEAN_PATH` is supplied by Lake.
- `Lake/Build/Module.lean:1120–1138`: the `olean` facet calls the same `leanArts.fetch`. Thus `lake build ...:olean` does **not** skip the C/ilean work in this pinned version.
- `Lake/Build/Common.lean:307–331`: displayed target build time includes the build action and trace writing. It does not separate import loading, elaboration, kernel work and output generation.

The existing root, `.lake`, `.lake/build`, and `.lake/build/lib/lean/D1Bound5` resolve to themselves on the same filesystem device. No cloud/network artifact redirect was found. Tiny proof modules generate tiny C files (negative obstruction: 6.2 KB; determinant nonzero: 1.7 KB) yet still take tens of seconds. There is no measurement supporting artifact-output relocation as the main remedy. A RAM disk would consume already scarce memory and is not recommended.

### Options, in priority order

1. **Minor scheduler optimization, independently reviewable:** when `max_parallel = 1` and one job remains active after `reap()`, read control state and check immutable configuration, but do not perform an eligibility/source/artifact scheduling snapshot until a slot exists. Preserve every current launch/completion hash check and the active protected closure. The current driver spent about 5.6% of one CPU in this observation; the gain is bounded and unmeasured.
2. **Keep related ready modules adjacent**, without changing sources or allowing more than one child. This may help filesystem/import cache locality, but the effect is unmeasured under current pressure. Current snapshots show very little file-backed memory, so no large benefit should be promised.
3. **A future bounded serial batch within one Lake invocation** could amortize part of the observed 5–14 s outer overhead. It does not share Lean environments: Lake still launches Lean for every module. An ordinary multi-target command can schedule independent jobs concurrently; it is not a safe drop-in replacement. A genuinely serial dependency chain or explicitly reviewed batch scheduler would need union source protection, per-module success/artifact receipts, and unchanged dependency/configuration checks. No batch was prepared or launched.
4. **Do not replace Lake with raw Lean as a quick fix.** The raw command would require the exact current setup/options/import artifacts and would omit Lake's trace/hash maintenance. Mixing its outputs with normal Lake builds can trigger rebuilding or invalidate the present acceptance provenance. Isolated proof checks are possible in principle, but are not a proven faster equivalent of this current workflow.
5. **Do not concatenate established modules or blanket-trim imports during convergence.** Combining sources can share one import load, but changes module/private-name/section boundaries and artifact provenance. Narrowing imports is sound only after recompilation and may invalidate many accepted downstream fingerprints. No concrete redundant import was established here.

A precise split of import-loading versus proof and code-generation cost would require timing/profiling an authorized future compiler invocation. That was outside this read-only task, so the diagnosis intentionally stops short of claiming a measured speedup.

## Reproducible evidence files

- `lean_runtime_readonly_snapshot.json`: exact current driver, configuration, selected receipt/log text, artifact sizes, and the recent timing records used above.
- `lean_runtime_pinned_lake_api.json`: pinned Lake source hashes and relevant snippets.
- `lean_runtime_imports.json`: exact import headers, setup-map counts and additional pinned source snippets.

All are local audit artifacts; no proof source or runtime was modified.
