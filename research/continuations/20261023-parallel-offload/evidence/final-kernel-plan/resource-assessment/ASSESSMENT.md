# Final fresh kernel replay: resource assessment

Prepared from existing receipts and pinned official source only. No Lean or leanchecker process, trial replay, or change to the reviewed `e04afcfff00b176bc3ffe51870d82c4c467415c9bac5769cbc28e89e63e21843` orchestrator was made for this assessment. This is a planning assessment, not proof acceptance.

## Recommendation

Keep the 24-hour timeout and the 6-GiB sampled RSS budget for the first authorized final fresh run, with the existing 32-GiB virtual-address limit and at least 1-GiB cgroup reserve. The timeout is a generous operational ceiling, not a measured completion forecast. Plan for a potentially long run measured in hours; the available evidence cannot justify a precise ETA or guarantee completion within 24 hours. Memory feasibility is more uncertain than time. Six GiB is a protective operating ceiling for this 8-GiB container, not evidence that the full root will fit.

Do not increase the physical budget just because the checker hits it. Preserve the resource-limit receipt and assess actual quiescent usage, peak RSS/anonymous/file pages and virtual mappings before choosing any transparent follow-up. A resource stop remains incomplete verification. No relaxed freshness, custom checker, trusted-import substitute, or candidate-artifact reuse follows from a memory failure.

## Measurements that support the assessment

There are 244 distinct successful timed scoped module replays in the local evidence. For 191, both the source hash and recorded compiled artifact hash match a successful compiler receipt. Their replay wall times total 1,120.67 seconds; the corresponding compiler times total 1,178.71 seconds. Replay median is 5.09 seconds, 90th percentile 8.52 seconds, and maximum 30.23 seconds. Where more than one accepted compiler receipt matched, the shortest duration was selected explicitly; these are not randomized or controlled benchmarks.

| Matched category | Modules | Median replay | Median compiler | Sum replay / sum compiler |
| --- | ---: | ---: | ---: | ---: |
| Numeric leaves | 88 | 7.31 s | 4.32 s | 1.49 |
| Data and validation | 46 | 3.00 s | 11.28 s | 0.30 |
| Parent and endpoint modules | 57 | 4.14 s | 1.41 s | 2.28 |

The other 53 timed replays have a matching final-source compiler receipt but lack a same-artifact binding in the collected replay record; they are excluded from the strict paired statistics. Complete selected records, receipt paths, and SHA256 values appear in `SCOPED_TIMING_PAIRS.json`.

Examples show why a single multiplier is unreliable: `SmallPairParallelLeft15_000Part00` took 7.781 seconds to replay versus 4.482 to compile; `SmallPairGraphClosure39Chunk01` took 7.242 versus 7.067; a cached data chunk took 2.774 versus 20.797; `SmallPairLightAdaptiveRight4_002` took 30.228 versus 0.980. These wall times include different background loads, imports, startup and file scanning. The samples primarily cover graph certificates, not the analytic proof families or the entire external dependency closure.

The source-header import proxy resolves 9,430 modules: all 4,406 project modules and 5,024 external modules, with no missing source or artifact names. Existing candidate artifact files for that proxy occupy:

| Artifact group | Bytes |
| --- | ---: |
| Project main `.olean` | 4,270,548,440 |
| External main `.olean` | 1,144,517,368 |
| External `.olean.private` | 2,449,446,728 |
| External `.olean.server` | 79,308,488 |
| External `.ir.sig` and `.ir` | 411,246,832 |
| Total | 8,355,067,856 (7.78 GiB) |

This is a source-header and file-stat proxy, not an actual importer trace and **not an RSS lower bound**. It ignores public/meta/private import attributes, counts available artifact parts conservatively, and includes extension/IR payloads that replay may not touch. Memory-mapped file pages may remain unresident or be reclaimed. Conversely, reconstructed environment maps, dependency sets, kernel checking scratch and runtime memory add allocations. The data therefore show a credible fit risk, not a proof that the run must exceed 6 GiB. The proxy currently uses the completed candidate artifacts; the clean source build may produce different artifact sizes, so rerun the stat-only estimate against the eventual clean artifact root if needed.

Existing memory evidence is sparse. The earlier unsupported `leanchecker --help` diagnostic reached approximately the full 8-GiB cgroup and was stopped; it implicitly selected many modules and spawned multiple replay tasks, while other compilers were active. It is evidence for avoiding that invocation, not a benchmark for the exact synchronous fresh root. A recorded ordinary Lean process had about 4.71 GiB virtual size and 0.48 GiB RSS. The `FiniteA5Matrix` compiler was observed by the coordinator near 4.45 GiB resident memory; that includes elaboration/tactic work, so it is not a kernel-replay memory bound. The completed candidate `MainTheorem` compile took22.0898seconds, the114-item candidate type/axiom audit28.3692seconds, and canonical-root compile43.3025seconds. Integration confirms these receipts contain timings only, with no RSS/VmSize or `/usr/bin/time` memory capture. These import-and-elaboration times do not include fresh replay of all imported declarations. No trustworthy full-root fresh peak-RSS measurement exists in the gathered evidence.

## Why scoped replay time is not a fresh-root forecast

The official nonfresh checker scans the search paths and imports trusted dependencies separately for every process, then replays only the selected module's new constants. The final fresh invocation scans once and imports once, but then replays the integrated imported constant map into an empty environment, including the external Lean/Mathlib dependency closure. The 191-module sum repeatedly pays startup/import/search overhead and omits those external replays. These effects work in opposite directions. Source compilation also includes elaboration and tactic execution absent from stored-term replay; arithmetic definitional equality may still be expensive in the kernel.

For scale only, multiplying the observed 191-module median by 4,406 project modules gives about 6.23 hours. This is deliberately **not an ETA**: it double-counts per-process overhead, assumes an unrepresentative module mix, ignores external replay, and ignores contention. It explains why a brief timeout would be unjustified; it does not validate a numerical forecast.

## Official-source limits and scope

`LeanChecker.replayFromFresh` keeps the imported environment available while `(mkEmptyEnvironment).replay env.constants.map₁` reconstructs a kernel environment. `Replay.Context.newConstants` retains the source constant map; replay additionally maintains remaining, pending, constructor, and recursor name sets. Declarations are processed through `addDeclCore 0 0`, so the wrapper's external timeout and memory watchdog are the practical operational limits. The source does not establish a fixed memory multiplier. `src/kernel/environment.cpp` adds `ConstantInfo` derived from the existing declaration, so expression objects can be shared: two environments do **not** imply two complete copies of the artifact payload. A fresh C++ `type_checker` and its caches are created for each safe definition/theorem/opaque and released afterward. The theorem sharing helper likewise has declaration-local lifetime. Thus checking work and reductions may recur, but these caches are not intentionally accumulated across every declaration. `getUsedConstantsAsSet` also scans each declaration's type/value separately with its own visited-expression set. The imported compacted regions themselves remain alive until the entire fresh callback finishes; there is no per-module release during the run.

The official importer normally maps compacted files with `MAP_PRIVATE` at their saved deterministic addresses. Unmodified pages can remain shared with the file cache. If an exact-address mapping fails, it instead allocates and reads the file into heap memory; relocated dependencies can trigger pointer-fixup writes in dependent mappings. That can worsen anonymous memory and import time. A read-only inspection of the88-byte official headers for29,526 proxy artifact parts found zero malformed headers and zero saved-address interval overlaps after4,096-byte Linux page rounding. This removes one candidate-set collision concern, but it does not rule out overlaps with runtime/ASLR mappings, different final-clean sizes, or actual importer-level differences. Whether fallbacks occur in the eventual final process is unmeasured; no memory multiplier is inferred.

Fresh mode uses one exact canonical `D1Bound5` target, not a per-module facade replay. It covers the actual compiled root imports, including retained umbrella imports beyond `MainTheorem`. `LEAN_NUM_THREADS=0` selects the official synchronous runtime path; it removes task-pool parallelism but cannot remove the integrated constant-map working set. The verbose checker prints the target banner and normally no per-declaration progress, so silence after that banner alone is not evidence of a stall.

The official replay skips unsafe and partial declarations and accepts declared axioms. The separate clean 118-item exact-type/transitive-axiom audit and source-policy checks remain necessary. Only the newly completed clean artifact tree may feed the final gate. The reviewed freeze checks the clean origin, original source/runtime locks, exact compiler commands and receipts, all imported artifact parts and runtime libraries. A successful scoped replay or a checksum does not replace the final fresh gate.

The 24-hour limit applies to the checker child loop, not the preparatory freeze or pre/post input hashing. That validation walks a large pinned runtime/cache inventory and can add wall time, especially with cold disk cache. The watchdog samples rather than hard-limits per-process RSS; the hard physical limit remains the shared cgroup. Compilers must be quiescent before admission and remain so throughout replay.

## Authorized capacity check and interpretation of an incomplete fresh run

Desktop Commander's device inventory returned one accessible online device, the already authorized Mac. Its read-only `hw.memsize` report is exactly8,589,934,592bytes (8GiB), with8physical/logical CPUs. At the observed instant it had about2.89GiB wired pages,2.73GiB compressor-resident pages, and about9.97GiB swap used. The Linux runtime likewise has an8GiB cgroup cap and an8-CPU quota; its host advertises approximately9.73GiB, which does not raise the cgroup limit. Linux reports no configured swap despite an unbounded cgroup swap policy. No larger accessible authorized machine was identified, and no new environment or service was provisioned.

The Mac is therefore not demonstrated additional-RAM capacity. Its compression/swap can change behavior, but its existing pressure makes it an unattractive unmeasured fallback; no fresh trial was run there. If the authorized Linux full-root fresh replay hits its resource cap, a clean source build, exact target/axiom audits, and prior scoped import-context kernel replays remain valid evidence with their stated scope. They cannot be relabeled as an empty-environment integrated fresh replay. The final fresh gate would remain pending until a suitable authorized run succeeds. This distinction concerns the additional verification gate, not an inferred mathematical counterexample or a kernel rejection.
