# Independent reproducibility review

Reviewed on 2026-10-23. This is a plan and source review, not a claim that the final clean build or global replay has passed. The parent coordinator owns the release candidate, root import module, canonical audit scripts, staging, and launches. The bounded fresh build runner is owned by the graph-A worker.

## Acceptance boundary

A passing fresh project build must start from an immutable export of the reviewed release commit with an empty project artifact directory. It may use the public external cache pinned by lean-toolchain and lake-manifest.json. No D1Bound5 proof artifact from the development checkout or historical artifact transfer may enter its import search path. Resuming work produced by this same fresh run is allowed only after validating exact source, runtime, dependency, and output hashes.

Keep three outcomes separate in status reports:

1. Cached project-artifact validation: prior project proof objects are checked against current sources and dependency/runtime identities. This is useful integration evidence, but is not a fresh source build.
2. Fresh project-source compilation: every module in the exact root import closure, including the root D1Bound5.lean, is compiled from source into a project artifact directory that was empty at run creation. External pinned Mathlib and Lean caches are permitted and disclosed.
3. Installed kernel replay: the installed Lean checker replays a specifically identified module or import environment. This is additional kernel validation, not an independent verifier implementation.

The number of modules must be derived from the final reviewed manifest; do not hardcode historical counts such as 4405. A successful fresh run must prove that its source set equals the reviewed root closure, not merely that a queue has drained.

## Concrete gate sequence

1. Freeze the final release commit and record its SHA, tree identity, lean-toolchain, lakefile.lean, lake-manifest.json, all project source paths/hashes, and canonical check/audit scripts. Include D1Bound5.lean itself.
2. Export that commit into a new source directory. Run source-policy and import-reachability checks in this export. Research snapshots are not project modules; abandoned fallback canonical modules must not be silently included or silently accepted as checked.
3. Create a new run directory and an empty project artifact directory. Record their initial inventory. Resolve all LEAN_PATH roots before starting; reject every alternate path that can supply D1Bound5 or D1Bound5.* artifacts. Deduplicate the final search path.
4. Record exact Lean compiler/checker binaries, relevant shared runtime identities, environment, toolchain, external package revisions, and external artifact identities. LD_PRELOAD is currently needed by this Linux container and must be recorded and hashed; it is not a project proof shortcut.
5. Run the bounded direct DAG compiler with explicit -j1 and -DautoImplicit=false. Start with two processes only after other heavy work is quiescent. Four processes require an explicit resource decision. Each module needs immutable source/dependency/runtime input identities, its exact command, timestamps, exit code, preserved output, output hashes, and before/after guards.
6. Require one valid fresh-run PASS receipt for every exact manifest module. Reject missing, blocked, failed, timeout, changed-source, changed-dependency, or unexpected-artifact outcomes. A scheduler exit with no running jobs is not enough.
7. Revalidate the complete source/metadata/runtime/output manifest after compilation. Run exact main theorem type and strict transitive axiom checks against these fresh artifacts, including an example of type MainStatement at the appropriate universe and an explicit main_statement axiom check.
8. Run the agreed global installed-kernel gate with all other heavy processes stopped. The coordinator's final gate uses the exact umbrella command form leanchecker --fresh D1Bound5 after the root has been frozen to the reviewed union; preserve evidence that the entire imported environment was replayed. A check of D1Bound5.MainTheorem alone would establish only that theorem's import closure and would need to be reported with that narrower scope.
9. Archive the fresh-run receipts, source and artifact manifests, full failure history, type/axiom logs, replay logs, and final summary. Record fresh compilation, axiom audit, and replay as separate fields. Never relabel cached or interrupted work as fresh PASS.

The fresh build runner is a build mechanism, not a replacement for source-policy, exact-statement, axiom, or replay checks.

## Current canonical script findings

These observations apply to the inspected 2026-10-23 snapshots; the parent may replace them as part of the release.

- lean-toolchain pins leanprover/lean4:v4.33.1.
- lakefile.lean pins Mathlib commit 0df444a360eaa60ab8c11dca51a86af692955474 and autoImplicit=false. Its default lean_lib D1Bound5 compiles the root closure, not every orphan source file: pinned Lake LeanLibConfig defaults roots to the library name and globs to one exact module per root.
- D1Bound5.lean in the inspected snapshot has 110 import lines, repeats TupleRootMatrixBridge, and has not yet imported MainTheorem. The final candidate must be checked independently after the coordinator updates it.
- scripts/source_audit.py scans the root plus flat D1Bound5/*.lean, rejects trust shortcuts, and requires every scanned module to be root-reachable. Running it over a development directory containing abandoned fallback files will fail or misrepresent the intended release. Run it in the immutable release export. Nested modules would require an extension to its flat discovery, if ever introduced.
- scripts/check.sh runs source audit, a normal Lake build, the axiom audit, and optional ordinary replay. It does not itself empty the project artifact directory, so CHECKS_PASS from this script is not by itself evidence of a fresh source build.
- The current optional replay uses the module prefix D1Bound5. Stale artifact modules can therefore enlarge its scope in a dirty artifact tree. Its target set must be frozen or run in the fresh artifact tree.
- scripts/Audit.lean checks exported names under the D1Bound5 prefix and allowed axioms propext, Classical.choice, Quot.sound. Private names have an _private prefix and are not included by that filter. Transitive checks on public theorems still catch their used private dependencies. A complete all-project-declaration claim should include private project names or module-origin metadata.
- The inspected Audit.lean still describes MainStatement as unproved. The final audit must include the actual main theorem with an exact type assertion and remove stale status prose.
- scripts/fetch_cache.sh fetches public Mathlib imports, not private project objects. Its simple grep covers the current ordinary import form but would miss public import, multiline import, or root-only external imports if those appear. Resolve external imports from the actual final manifest rather than assuming the grep is complete.
- Copied .olean files do not establish valid Lake trace-cache hits. A later Lake build may legitimately rebuild them. This does not make direct guarded compilation unsound; it does mean that the status and mechanism must be named accurately.

## Pinned task/runtime behavior

Inspected local sources from the pinned Lean 4.33.1 distribution and matching C++ source tree establish:

- runtime/object.cpp reads LEAN_NUM_THREADS for the default task-manager initialization used by compiled Lean executables. With zero workers, the manager remains null.
- lean_task_spawn_core and lean_task_bind_core execute synchronously when the manager is null. runtime/io.cpp routes BaseIO.asTask through that spawn function.
- Lake Job.async uses BaseIO.asTask. Thus LEAN_NUM_THREADS=0 can serialize this task mechanism.
- The Lean compiler shell separately creates a task manager from ShellOptions.numThreads, whose default is hardware concurrency. Explicit -j1 remains necessary for compiler subprocesses; LEAN_NUM_THREADS=0 alone is not a reliable compiler thread bound.
- IO.Promise.new panics when no manager exists. Consequently zero-thread execution is a conditional fallback for a reviewed path, not a blanket guarantee that every Lake/runtime operation is safe.
- A positive worker count is not a guaranteed cap on all operating-system threads or process-level memory consumption. Prefer a bounded external DAG scheduler whose process limit is explicit.

The Linux container's actual cgroup limit is 8 GiB. Host free-memory figures are misleading here. memory.current includes reclaimable file cache, so a headroom guard that refuses to start the first job solely because of cache use can deadlock. It must preserve progress at a conservative one-job floor when no work is active, or use a suitable reclaim-aware measure. Heavy root compilation, all-declaration audits, and global replay should be serialized.

## Installed checker behavior

The pinned LeanChecker.lean only recognizes --verbose/-v and --fresh among options used here. Do not run leanchecker --help: unsupported flags are ignored and an empty target set selects broad default scope. This already caused a canceled diagnostic memory incident; it is not a valid help command.

Ordinary replay discovers modules by prefix and launches tasks for their environments. Explicit single-module milestone logs should contain exactly the intended replayed module. Fresh replay accepts one exact module and replays the imported environment into a new empty kernel environment.

Lean/Replay.lean invokes kernel declaration checking, orders dependencies, and checks inductive declarations and generated constructor/recursor consistency. It imports axioms as axioms and skips unsafe/partial declarations. Hence source-policy and transitive axiom whitelist checks remain separate mandatory evidence. This is the installed Lean kernel replay implementation, not an external independent checker.

## Runner review checklist

- No artifact reuse from outside the fresh run.
- Exact root closure; unresolved project imports and cycles fail.
- No project source omitted from the reviewed release manifest.
- Source parser handles current public/ordinary import syntax, comments, duplicate imports, and explicit Init imports conservatively.
- Per-module outputs are written only to owned paths; stale or partial outputs cannot satisfy a later PASS.
- Failed attempts and their source/command identities remain immutable on resume.
- Resume requires source, source closure, dependency artifacts, all loaded external artifacts, compiler/runtime, command/options, and output identities to match.
- Runtime fingerprint is revalidated, not just recorded once.
- A dependency receipt alone is insufficient if its current artifact has changed.
- Module IDs and relative paths cannot escape output roots.
- Threads/processes terminate on timeout or interruption without leaving orphan compiler children.
- Cross-run concurrent writes to the same output directory are refused.
- Final exit is nonzero unless all required modules have valid receipts.
- Selfchecks cover a real tiny import DAG, reuse after success, changed source, changed dependency artifact, missing artifact, timeout/failure, and unexpected preexisting output. Such tests exercise the build trust boundary; they do not mirror mathematical implementation details.

## Snapshot identities

Canonical inspected SHA256 values:

- lean-toolchain: 3aac669c7a910ec2389f4e4f921b605adf6ebf2d1e0c9b9cd0be4d33f3f5db71
- lakefile.lean: fa17c8e0e386fe8ffadcab88a9a328337c3db37cc7d64681e7ca26836c73bfb3
- lake-manifest.json: 7ba6f92faaef8900c85a20ac695495111285a1b0c355cb1441a69b34ba9500f4
- D1Bound5.lean: 33c5f8a0eb94b1ab1196054d8189a968dbe6da8f19ae818d962e435ea72a43c2
- scripts/check.sh: 5168d9c6bafca978068d2ae1a3c6d537c5ff2e0442c419ebb7da8c7f2d79b8ac
- scripts/source_audit.py: 0536a2d41b5cfbdf5b60e967b1be826f785ee19cc42cb29cc96be35f88fae472
- scripts/Audit.lean: 940982c822825c7d4b9e40b9c8897e84ff0682c61f6aef7a22e90796b13823e8
- scripts/fetch_cache.sh: 07667de7227f21c97c6ad5f8b768cbbef32a1e1a8e657b1595d52387b38d40de

Pinned runtime/source identities are in PINNED_RUNTIME_SOURCE_HASHES.json.

## First runner draft review (not final approval)

The graph-A runner draft was independently read without edits. Its fresh-origin identity, recursive dependency receipt chain, isolated artifact directory, exact reviewed locks, sidecar bundles, and final completeness check are appropriate. The owner is addressing interrupt cleanup, final receipt-hash revalidation, and runtime guard cost before production.

A read-only test of source_lock on the current local pair of roots D1Bound5 and D1Bound5.MainTheorem resolved 4406 modules and 185858624 source bytes in 30.9 seconds, with no missing modules, cycles, or unsupported import syntax. This is a historical union check, not acceptance of a final root-only export.

The first draft fingerprinted the entire runtime/cache inventory before and after every module. The toolchain bin/lib and Mathlib artifact roots contain at least 123086 files / 9563813102 bytes. A 5057-file fingerprint sample took 0.145 seconds; a linear extrapolation implies about 8.65 hours of serialized fingerprint work for twice-per-module checks over 4406 modules. This is an estimate, not a completed full-run benchmark. The owner agreed to full start/end inventory guards, per-module executable/loader and relevant external bundle guards, and an explicit frozen-cache/no-writers assumption, with optional periodic full checks.

The parent explicitly selected a default four-worker cap with adaptive admission, overriding this review's initial conservative two-worker suggestion. The configured cap is not a claim that four large Lean jobs should run simultaneously.
