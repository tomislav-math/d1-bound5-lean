# Linux verification runtime and first production batch

This setup is an isolated computation workspace for the existing private D1Bound5 project. It does not change the mathematical statement or the accepted root.

The official Lean 4.33.1 Linux release and exact mathlib commit 0df444a360eaa60ab8c11dca51a86af692955474 were downloaded from their public official repositories. All 8690 requested mathlib cache files were downloaded and decompressed successfully. Runtime file fingerprints are in RUNTIME_SETUP.json.

The host exposes a proc filesystem whose numeric process IDs do not match this command's PID namespace. The official Lean runtime constructs /proc/<getpid()>/exe and failed before --version. Upstream runtime/io.cpp, lines 1402–1405, confirmed the cause. The small proc_self_exe_compat.c shim changes only that current-process executable readlink query to /proc/self/exe, which is the same executable. It does not change the Lean kernel, imports, evaluation, arithmetic, security results or memory checking. The kernel shared library remains the official release binary. A supported LEAN_SYSROOT setting alone did not fix the executable query.

Initial archive extraction reported ownership-mapping errors; re-extraction with tar --no-same-owner completed successfully. No mathematical compilation occurred before the runtime was functional.

A Mac-produced PairLightArithmetic.olean was imported and replayed successfully by the official Linux 4.33.1 leanchecker. This establishes portability only for that exact artifact, whose hash is recorded. It is not a blanket acceptance of copied artifacts. Important final endpoints still require the agreed final verification gates.

The first graph4/graph15 batch compiled all 183 selected pure-Init modules plus two shared dependencies. Each invocation used -j1 -DautoImplicit=false, preserved complete project source and dependency-artifact fingerprints, recorded its exact command, elapsed time and exit, and retained output logs. This batch status is COMPILED_ONLY. Graph15's separate source-type, transitive-axiom and scoped installed-kernel verification records are maintained separately. Graph4's corresponding audits belong to the graph4 worker.

The guarded compiler now reuses a receipt only when the complete recorded project source closure, its own artifact and every recorded dependency artifact still match. Receipt scanning is restricted to modules in the requested closure, so unrelated mathlib units cannot break a pure-Init batch. Earlier loaded batch1 code preceded these two reuse-filter improvements; batch1 did not depend on any changed source or artifact.

This evidence archive deliberately excludes toolchain binaries, cache files and compiled proof objects. Source snapshots and full endpoint evidence remain in their owning graph continuation directories. MainTheorem is not claimed complete here.
