# Installed-kernel final replay plan

Prepared 2026-10-23. No final checker has been launched by this plan. The companion Python orchestrator changes no Lean executable, kernel, importer, evaluator, or proof declaration.

## Required final gate

After the genuine clean project source build, original-type checks, and allowed-transitive-axiom audits pass, freeze the final effective project source inventory and the clean build artifact search paths. Candidate artifacts, including accepted historical imports, cannot enter this final gate. Stop other large jobs. Run the **unmodified official Lean 4.33.1 `leanchecker --verbose --fresh D1Bound5`**, with the reviewed executable-path compatibility shim and `LEAN_NUM_THREADS=0`. This exact canonical umbrella imports `MainTheorem` and the retained project modules; its combined source manifest must include `clean-checkout/D1Bound5.lean` as well as every reachable source under `clean-checkout/D1Bound5/`.

This is one exact module argument. There is no empty target, guessed help flag, module-prefix sweep, custom proof checker, or modified trust setting. A resource-limit failure remains an incomplete final gate. The supporting serial mode is never reported as a successful fresh replay.

## What the official source actually does

* `LeanChecker.lean`, `replayFromFresh`: `withImportModules #[{module}] {}` loads the root's actual compiled imports, then `(mkEmptyEnvironment).replay env.constants.map₁` sends that integrated constant map through replay. `Lean/Environment.lean` defaults to the `.private` import level; private data is included, extension initialization is disabled, and compact regions are freed after the action.
* `Lean/Replay.lean`: recursively follows declaration dependencies, uses `Kernel.Environment.addDeclCore`, and checks constructors/recursors against kernel-generated ones. It skips unsafe and partial declarations. It accepts axiom declarations, so a separate exact-type and transitive-axiom audit remains essential. This is the installed Lean kernel, not an independent external verifier.
* Ordinary `replayFromImports` loads the selected module's exported/server/private artifact parts, replays its new declarations, and trusts its imports during that invocation. Serial replay of every source-inventory project module is useful supporting evidence; it does not equal the fresh integrated gate, and the source inventory itself is not a proof-acceptance ledger.
* Recognized checker flags are only `-v`, `--verbose`, and `--fresh`. Unknown flags are ignored; with no positional argument the checker infers a project target, possibly anonymous. **Never call `leanchecker --help`.** Lean's separate compiler CLI has different flags.
* Nonfresh target selection uses structural `Name.isPrefixOf`, not a textual prefix: `Data4` does not select `Data40`. A dotted descendant of a module target would be selected. Fresh target selection is exact and requires precisely one matching module.
* The checker calls `SearchPath.findAllWithExt` for each positional target. This walks all search roots each time. Passing thousands of arguments repeats that scan thousands of times. Nonfresh mode also eagerly creates an `IO.asTask` for every selected module before waiting.

## Serial task setting and memory limits

The official runtime `runtime/object.cpp` reads `LEAN_NUM_THREADS`. With value `0`, `lean_init_task_manager_using` creates no task manager; `lean_task_spawn_core`, task map, and task bind execute synchronously. With value `1`, worker waits can temporarily increase `m_max_std_workers` and spawn a worker, so one is not an absolute concurrency guarantee. Zero is the source-supported synchronous path; it has not yet been exercised by this final plan.

Use **one checker process**, no parallel fresh replays. Virtual address space and resident memory have separate budgets: the default Linux `RLIMIT_AS` hard limit is 32768 MiB, the sampled child RSS budget is 6144 MiB, and the cgroup reserve is at least 1024 MiB. Admission requires the physical RSS budget plus measured anonymous/kernel/dirty/shared memory plus the reserve to fit the actual finite cgroup limit. The virtual cap is not charged as physical RAM. Clean file cache is reclaimable and is not counted as permanently occupied. An observed ordinary Lean process used about 4.71 GiB of virtual space while resident memory was about 0.48 GiB; a 6 GiB virtual cap could therefore reject a physically feasible integrated import.

Before executing the official checker, the child reports its actual `/proc/self` directory through a pipe. This avoids this environment's mismatch between process namespace PIDs and the mounted `/proc` PIDs. The supervisor samples RSS, peak RSS, virtual size, and cgroup usage, and terminates only its own process group when the physical budget, cgroup reserve, or time bound is crossed. The RSS and reserve checks are **sampled watchdogs, not hard per-process RAM limits**: a rapid allocation can cross a threshold between samples. The hard actual-memory bound remains the enclosing 8 GiB cgroup. Exit status, termination cause, memory samples, and cgroup OOM events remain part of the evidence. A budget termination or OOM is an incomplete verification, never a kernel rejection or a passed theorem. The orchestrator lock prevents two instances of this orchestrator; the coordinator must also keep unrelated compilers/checkers quiescent. Admission cannot prevent another process from allocating memory later.

The official fresh implementation retains both an imported constant map and the reconstructed kernel environment. Even synchronous execution may exceed the available 8 GiB; the plan cannot promise success or a runtime estimate without measurement. If it cannot fit, retain the failure receipt and obtain sufficient authorized compute capacity, or finish supporting serial replay while clearly leaving fresh verification pending.

## Commands and evidence

All commands below run from the offload directory. Preparation and dry runs never execute Lean:

```text
python3 final-kernel-plan/final_kernel.py plan
python3 final-kernel-plan/final_kernel.py freeze \
  --project-root /workspace/scratch/fed64f41ca78/clean-checkout \
  --project-build-root /workspace/scratch/fed64f41ca78/clean-build/artifacts \
  --lean-env final-kernel-plan/CLEAN_ENV.json \
  --source-lock CLEAN_SOURCE_LOCK.json \
  --runtime-lock FRESH_RUNTIME_LOCK.json \
  --manifest integration-owned/CANONICAL_SOURCE_INVENTORY.json
python3 final-kernel-plan/final_kernel.py run
python3 final-kernel-plan/final_kernel.py run --execute
```

The final inventory must be regenerated after all accepted edits and must include every root-reachable project's source hash and dependency list, including the canonical `D1Bound5.lean` umbrella itself. `CANONICAL_SOURCE_INVENTORY.json` above is the required combined inventory regenerated by integration; an existing MainTheorem-only inventory is insufficient. The old 3990-source Mac snapshot intentionally differs from newer graph sources and cannot be used unchanged. Schema 3 requires explicit source, build, and environment paths. Derive `CLEAN_ENV.json` from `clean-build/ORIGIN.json` at `identity.environment`; the checker deliberately changes only its task setting to synchronous mode and scrubs unneeded environment keys. Empty or relative `LEAN_PATH` components are rejected; the child receives canonical absolute roots. The official builtin `lib/lean` root must be explicit, because Lean appends it implicitly. The old offload candidate source/build roots and any second search root owning the `D1Bound5` package are rejected. Every selected project artifact must resolve under the clean build directory.

Freeze checks each inventoried source and validates the portable DAG runner's `ORIGIN.json`, `SUMMARY.json`, and all immutable accepted module receipts: initially empty project output, identical source/build/environment identity, complete exact module set, successful compiler exit, exact source and artifact parts, compiler log hash, and the complete dependency receipt chain. The original reviewed source/runtime locks must match the hashes in the clean origin; source records and dependencies must equal the final inventory, runtime/cache files must retain their recorded hashes, and every receipt must contain the exact official compiler command with `-j1 -DautoImplicit=false -R CLEAN_SOURCE -o ATTEMPT/stage/MODULE.olean CLEAN_SOURCE/MODULE.lean`. The original clean runner itself is hash-pinned. The full compiler environment is checked against that runner's minimal recipe; final replay changes its task mode to synchronous zero. It pins these records for the duration of replay. A directory populated by copied historical artifacts without this clean-origin chain is insufficient. This is provenance validation, not a substitute for the installed kernel. Schema 2 freezes cannot be executed by this version. It hashes all `.olean`, `.olean.server`, `.olean.private`, `.ir.sig`, and `.ir` files in the full search universe, not only a guessed source dependency closure. The official private importer derives `.ir.sig` and `.ir` beside the selected `.olean` and loads available IR parts even with `loadExts=false`; their addition, removal, and modification are therefore guarded too. It pins all bundled distribution shared libraries, the checker, kernel, shim, approved environment, manifests, and orchestrator too. The child environment contains only the pinned `PATH`, `LEAN_PATH`, `LD_PRELOAD`, `LEAN_NUM_THREADS=0`, and fixed locale; inherited `LD_LIBRARY_PATH`, `LD_AUDIT`, and other overrides are excluded. The host operating-system loader and system libraries remain within the operating-system trust boundary. Before and after replay, the pins and full artifact universe must still match. Artifact/source binding and acceptance receipts remain the responsibility of the build/import ledger and the exact-type/axiom audits; this script does not fabricate that relationship from file timestamps or existence.

For supporting evidence only:

```text
python3 final-kernel-plan/final_kernel.py freeze --target D1Bound5.MainTheorem --project-root CLEAN_SOURCE --project-build-root CLEAN_BUILD/artifacts --lean-env CLEAN_ENV.json --source-lock EXACT_SOURCE_LOCK.json --runtime-lock FRESH_RUNTIME_LOCK.json --manifest EXACT_MAIN_ONLY_SOURCE_INVENTORY.json --freeze final-kernel-plan/MAIN_ONLY_FREEZE.json
python3 final-kernel-plan/final_kernel.py run --target D1Bound5.MainTheorem --freeze final-kernel-plan/MAIN_ONLY_FREEZE.json --mode project-serial --output final-kernel-plan/serial-run --execute
```

That mode calls the unmodified official checker once per exact module in dependency order and returns `PROJECT_IMPORT_CONTEXT_REPLAY_PASS_NOT_FRESH`. The umbrella `D1Bound5` is explicitly rejected in serial mode, because the ordinary checker would expand it to the full project prefix. Serial supporting evidence must use its own exact-module clean build and freeze, as above. A completed umbrella build has a larger receipt set and is deliberately not represented as a different smaller clean build. It adds subprocess and repeated search-path scanning overhead, but each process releases all its memory before the next starts. It never upgrades a partial run or a changed-input run to PASS. There is deliberately no resume based on loose artifact existence.

Fresh success is recorded only as `FRESH_INTEGRATED_KERNEL_REPLAY_PASS` after exit zero, the exact verbose banner, unchanged frozen inputs, and no new cgroup OOM event. Every command, exit status, duration, output hash, memory limit, and cgroup snapshot is preserved. Separate original-type/axiom results must accompany this receipt when stating the theorem is complete.

## Review and limitations

The script was syntax-checked and exercised only in no-checker planning mode, plus schema-3 temporary path/receipt fixtures (candidate paths, second package owners, relative paths, omitted builtin root, symlink escape, nonempty origin, incomplete summary, changed receipt, and broken dependency chain are rejected), plus lightweight Python validation of module names, the umbrella source-manifest traversal, artifact suffix selection, approved environment, and the child `/proc` identity pipe. The latter launched only a short-lived Python process, not Lean or leanchecker. It has not yet run a final fresh target, frozen the incomplete artifact tree, or tested its process supervisor against Lean. The final effective closure and source-to-artifact acceptance ledger are still evolving. No claim of final theorem completion follows from this design artifact.

Official source copies/hashes are recorded in `SOURCE_REVIEW.json`; they are from the pinned 4.33.1 distribution and matching upstream runtime source archive. The preexisting narrow `readlink(/proc/currentPID/exe)` compatibility shim is documented in the parent offload evidence and is unchanged.
