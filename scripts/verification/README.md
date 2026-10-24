# Reproduce the Lean verification

Run `scripts/check.sh` with the source and runtime locks prepared below and
the `--replay` option. Success means **`COMPLETE_VERIFICATION_PASS` and exit
code 0**. The command checks source policy, builds all 4,406 project modules
from initially empty outputs, checks 114 declaration types and transitive
axioms plus four independent targets, and replays the complete root through
the official Lean kernel.

Allow several hours, depending on the machine. The recorded fresh kernel
replay alone took about **2 hours 54 minutes**, with a peak resident memory
of about **5.1 GiB**. Compilation takes additional time and memory. Allow
headroom for the operating system and reduce `--jobs` on smaller machines.
The [recorded verification](../../research/continuations/20261023-parallel-offload/evidence/final-kernel-plan/FINAL_CLOSEOUT_AUDIT.json)
identifies the measured run.

## Download only the verification files

The proof check needs `D1Bound5/`, `scripts/`, `records/` and the root
Lean and Lake files. The manuscript, numerical archive and `research/`
are not required as build inputs.

```sh
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/tomislav-math/d1-bound5-lean.git
cd d1-bound5-lean
git sparse-checkout set D1Bound5 scripts records
```

Use a clean committed checkout. Keep the build, evidence and public cache
directories outside it. The verifier checks file contents against both
the manifests and Git, including files hidden from ordinary status by Git flags.

## Prepare the environment

Use Git, Python 3.8+ with its standard library, and Linux or macOS. Install
the official **Lean 4.33.1** distribution named by `lean-toolchain`, including
`leanchecker`. Prepare a separate public Mathlib checkout/cache at revision
`0df444a360eaa60ab8c11dca51a86af692955474`; its package revisions must match
`lake-manifest.json`. The pinned distribution's `lake exe cache get` may be
used in that external checkout.

The external cache must contain only public dependencies. Do not copy old
D1Bound5 build artifacts into it or into the new project build directory.

Set absolute paths for this machine:

```sh
D1_SOURCE=/absolute/path/to/d1-bound5-lean
D1_WORK=/absolute/path/to/new-verification-work
D1_TOOLCHAIN=/absolute/path/to/lean-4.33.1
D1_CACHE=/absolute/path/to/public-mathlib-checkout
D1_RUNNER="$D1_SOURCE/scripts/fresh_project_build.py"
mkdir -p "$D1_WORK"
```

## Prepare and check the locks

Generate the source lock:

```sh
python3 "$D1_RUNNER" prepare-source-lock \
  --source-root "$D1_SOURCE" --roots D1Bound5 \
  --out "$D1_WORK/source-lock.json"
```

The expected SHA256 of this lock is:

```text
511466d8d0ea4a23e7d8d6746a5ad3efec153184a02ca4e44ec8789b7788d5ed
```

This value covers the 4,406-module source closure and pinned configuration,
and is independent of the checkout location. The
[source comparison record](../../records/documentation-update/README.md)
identifies the documentation-only change from the verified proof sources.
The verification command below checks the lock against this expected value.

Generate a separate runtime lock for this machine:

```sh
python3 - "$D1_RUNNER" "$D1_TOOLCHAIN" "$D1_CACHE" "$D1_WORK/runtime-lock.json" <<'PY'
import pathlib, subprocess, sys
runner, toolchain, cache, output = sys.argv[1:]
cache = pathlib.Path(cache)
paths = [cache / '.lake/build/lib/lean']
paths += sorted(p for p in (cache / '.lake/packages').glob('*/.lake/build/lib/lean') if p.is_dir())
command = [sys.executable, runner, 'prepare-runtime-lock', '--toolchain', toolchain,
           '--expected-version', '4.33.1', '--out', output]
for path in paths:
    command += ['--external-path', str(path.resolve())]
subprocess.run(command, check=True)
PY
```

Review the runtime lock's toolchain, dependency revisions and external search
paths against the pinned inputs above. Its hash cannot be shared between
machines because it records absolute paths and the local runtime files.
Keep the public cache unchanged during verification. If a loader environment
override is necessary, supply it explicitly to `prepare-runtime-lock
--environment` so that it becomes part of the recorded runtime identity.

## Run the complete verification

After reviewing the generated runtime lock, calculate its hash and run:

```sh
D1_SOURCE_SHA=511466d8d0ea4a23e7d8d6746a5ad3efec153184a02ca4e44ec8789b7788d5ed
D1_RUNTIME_SHA=$(python3 -c 'import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$D1_WORK/runtime-lock.json")
bash "$D1_SOURCE/scripts/check.sh" \
  --source-lock "$D1_WORK/source-lock.json" --source-lock-sha256 "$D1_SOURCE_SHA" \
  --runtime-lock "$D1_WORK/runtime-lock.json" --runtime-lock-sha256 "$D1_RUNTIME_SHA" \
  --build-dir "$D1_WORK/build" --evidence-dir "$D1_WORK/evidence-001" \
  --jobs 4 --hints "$D1_SOURCE/scripts/verification/resource_hints.json" --replay
```

The build directory must initially be empty. The scheduler runs each compiler
with one thread and records its inputs, outputs and logs. The optional
`--hints` file supplies per-module timeout and memory estimates; it does not
change proof identities. The default build timeout is 1,200 seconds per module,
with individual hint timeouts taking precedence.

| Result | Meaning |
|---|---|
| `COMPLETE_VERIFICATION_PASS`, exit 0 | All required checks, including fresh kernel replay, passed |
| `SOURCE_BUILD_AND_AUDITS_PASS_FRESH_REPLAY_PENDING`, exit 3 | Source, build and audit checks passed, but replay was omitted |
| Exit 1 | An error or interruption occurred; inspect the saved logs |

The only permitted transitive axioms are `propext`, `Classical.choice` and
`Quot.sound`. Fresh replay uses `leanchecker --verbose --fresh D1Bound5`
with `LEAN_NUM_THREADS=0`. Lowering build concurrency does not reduce the
memory required by this single replay process.

To resume an interrupted build, repeat the command with `--resume` and a
new empty evidence directory, keeping the source, runtime and build identities
unchanged. Accepted modules are reused only if their complete receipt chains
still match. A new machine, changed runtime or different build directory
requires a new initially empty build.

## Optional checks

The broad audit in `scripts/Audit.lean` is separate from the required checks
above. The wrapper reports it as `NOT_RUN_PENDING_SEPARATE_GATE`.

For a source-only inspection:

```sh
python3 "$D1_SOURCE/scripts/source_audit.py" \
  --project "$D1_SOURCE" --out "$D1_WORK/source-policy-only"
```

`SOURCE_POLICY_PASS_SOURCE_ONLY` with exit 0 establishes source-policy
compliance only. It does not establish compilation, theorem types, axioms
or kernel replay.

## Maintaining the manifests

Ordinary users should use the committed manifests. After an intentional,
reviewed edit, maintainers can prepare replacements outside the checkout:

```sh
python3 "$D1_SOURCE/scripts/verification/prepare_manifests.py" \
  --project "$D1_SOURCE" --source-lock "$D1_WORK/source-lock.json" \
  --source-lock-sha256 "$D1_SOURCE_SHA" \
  --prior-tools-manifest /absolute/path/to/previous-verification-tools-sha256.txt \
  --updated-tool scripts/verification/README.md \
  --out "$D1_WORK/manifest-proposal"
```

List every intentionally changed tool with `--updated-tool`. Review the
proposed differences and commit the updated files and manifests together.
Refresh the published source-lock hash if source bytes change. Preparing
manifests does not produce proof-verification evidence.

Earlier operational details and resource incidents are preserved in the
[archived guide](../../records/verification-history/documentation-guide-before-cleanup.md).
