# Resource observation for the pending clean audits

This is an external measurement wrapper, prepared without running Lean or either
audit. `/usr/bin/time` is unavailable in this container. The wrapper uses Linux
`wait4` to obtain the kernel's resource-usage record for the unchanged outer audit
invocation. It does not modify the reviewed audit scripts, their invocation JSON,
the clean checkout, the build, the audit environment, or the final kernel checker.

Use the exact arrays in `PREPARED_COMMANDS.json` only after the root coordinator
authorizes the corresponding audit. The clean 118 checks require the completed,
drained clean source build; the broad audit additionally requires the successful
clean 118 result. The prepared commands are dry runs. Appending `--execute` runs
the existing audit once. Run from the recorded workspace directory. No extra
Lean trial is part of this recipe.

The observer validates the invocation SHA, nested invocation SHAs and runner SHA, then inherits the
caller's current directory, environment and standard streams. The audit retains
its own clean-runtime checks, timeout and acceptance criteria. The observer
starts a separate child session solely to forward interruption signals to its
owned child group. It imposes no new resource limit. A second interruption sends
SIGKILL only to that owned group. Normal exit codes are preserved; termination
by signal N is reported as shell exit code 128+N.
An unexpected observer exception terminates and reaps its still-owned child,
with a five-second SIGTERM grace period before SIGKILL, and writes an incomplete
observation record. Already-reaped children are never signalled by this cleanup.

Each new output directory contains `START.json` and, after the waited process
exits, `RESOURCE_USAGE.json`. The latter records elapsed wall time, raw wait
status, child exit code, all raw `wait4` resource fields, signal forwarding, and
before/after invocation, runner and observer hashes. Existing output directories
cannot be overwritten. Output is confined to this directory's `observations/`
subdirectory and excluded from the audit's own protected paths.

On Linux, `ru_maxrss` is in KiB. Accounted descendants contribute when the
intervening parents wait for them, as these sequential audit runners do. This
is a largest-process high-water mark, **not** the simultaneous memory footprint
of an entire process tree. It does not identify which process reached the peak:
the outer Python runner and its preflight subprocesses are included along with
the sequential Lean children. `ru_utime` and `ru_stime` are cumulative accounted
CPU time. No per-process RSS sampling is performed and no whole-system memory
statistics are collected by the observer.

The measurement describes these audits only. A small audit memory peak does not
prove that the full fresh kernel replay fits its 6 GiB sampled RSS ceiling:
fresh replay reconstructs the imported environment and checks all reachable
declarations. The audit's own receipts remain the only audit acceptance record;
`RESOURCE_OBSERVATION_COMPLETE` does not mean a proof or audit passed. If the
observer is killed before writing its result, its incomplete `START.json` is
not a resource measurement or an acceptance claim.

The fixture test exercises only small Python processes: no Lean compiler,
checker, or audit is launched. It verifies dry-run behavior, rejection of an
incorrect invocation digest, unchanged argv/cwd/environment, a nonzero exit,
waited descendant resource accounting, owned signal forwarding/reaping, and
cleanup after an injected observer exception.

Semantics reference: Linux man-pages, `getrusage(2)`, especially
`RUSAGE_CHILDREN` and `ru_maxrss`:
https://www.man7.org/linux/man-pages/man2/getrusage.2.html
The Python `os.wait4` API returns the process ID, exit status and resource usage:
https://docs.python.org/3/library/os.html#os.wait4

The resource-only wrapper is supplementary operational evidence. Its code and
results neither weaken nor replace any source, artifact, axiom, clean-build,
or full fresh kernel replay gate.
