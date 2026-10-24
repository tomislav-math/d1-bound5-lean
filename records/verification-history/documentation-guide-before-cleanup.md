# Archived verification guide

This preserves the earlier operational instructions and incident history.
Use [the current guide](../../scripts/verification/README.md) for reproduction.

# Reproduce the release verification

The required gate consists of four separate checks: accepted source policy, an initially empty project build, 114 exact declaration type/transitive-axiom checks plus four independent target checks, and the installed official Lean checker's fresh replay of the complete `D1Bound5` root. Only their combined success produces `COMPLETE_VERIFICATION_PASS` and exit 0. The only permitted axioms are `propext`, `Classical.choice`, and `Quot.sound`.

The optional broad compatibility audit remains at `scripts/Audit.lean`. It preserves the historical `AUDIT` lines, `AXIOM_AUDIT_PASS` marker, and named diagnostics, then adds exact target and private-project checks. It is a separate gate: `check.sh` reports it as `NOT_RUN_PENDING_SEPARATE_GATE`. The original file and manifests are preserved under `records/verification-history/20261023/`; those historical receipts do not certify changed files.

## Inputs

Use Git, Python 3.8+ with its standard library, and Linux or macOS. Install the exact Lean distribution named by `lean-toolchain` (`leanprover/lean4:v4.33.1`), including `leanchecker`. Prepare a separate public Mathlib checkout/cache at revision `0df444a360eaa60ab8c11dca51a86af692955474`; its package revisions must match `lake-manifest.json`. Public cache preparation may use the pinned distribution's `lake exe cache get` in that external checkout. Do not copy any previous D1Bound5 artifact into the verification build or external cache.

Clone the selected repository commit into a clean source directory. Keep build, evidence, and external cache directories outside it. Commit the selected production sources, configuration pins, verification tools and manifests before running the gate. `check.sh` verifies their actual Git blob contents, including files hidden from ordinary status by Git flags.

Use the final repository commit containing the reviewed production sources, configuration, verification tools and manifests. The verifier derives its source root and Git commit/tree from this clone; it does not require the earlier local verification-candidate commit or that machine's receipts. An ordinary user of the release should not regenerate committed release manifests. Manifest preparation below is a maintainer operation after intentional reviewed changes.

Set absolute paths for this machine:

```sh
D1_SOURCE=/absolute/path/to/clean-committed-checkout
D1_WORK=/absolute/path/to/new-verification-work
D1_TOOLCHAIN=/absolute/path/to/lean-4.33.1
D1_CACHE=/absolute/path/to/public-mathlib-checkout
D1_RUNNER="$D1_SOURCE/scripts/fresh_project_build.py"
mkdir -p "$D1_WORK"
```

## Freeze sources and the public runtime

```sh
python3 "$D1_RUNNER" prepare-source-lock \
  --source-root "$D1_SOURCE" --roots D1Bound5 \
  --out "$D1_WORK/source-lock.json"
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

Review both generated locks, including all external search paths. The release scope is exactly 4406 project modules, including the umbrella. The source lock is independent of the checkout location; a runtime lock contains absolute machine paths and must be regenerated on another machine. Every selected runtime/cache file is hashed. External roots containing a D1Bound5 artifact owner are rejected. Keep this public cache immutable during verification. Any necessary loader environment override must be explicitly supplied to `prepare-runtime-lock --environment` and included in its recorded runtime identity.

Generate both locks in the new work directory and review them against the committed release inputs. Do not copy an old machine's runtime lock or build receipts. A new machine, relocated checkout, changed runtime, or different build directory requires a new initially empty build. `--resume` is for the same frozen checkout/runtime/build identity only; every invocation still requires a new empty evidence directory.

Set `D1_SOURCE_SHA` and `D1_RUNTIME_SHA` to the reviewed SHA256 values, rather than treating an unreviewed fresh hash as approval. Configuration and verification tool fingerprints are separately checked against the committed release manifests.

## Run the complete gate

```sh
D1_SOURCE_SHA=reviewed_source_lock_sha256
D1_RUNTIME_SHA=reviewed_runtime_lock_sha256
bash "$D1_SOURCE/scripts/check.sh" \
  --source-lock "$D1_WORK/source-lock.json" --source-lock-sha256 "$D1_SOURCE_SHA" \
  --runtime-lock "$D1_WORK/runtime-lock.json" --runtime-lock-sha256 "$D1_RUNTIME_SHA" \
  --build-dir "$D1_WORK/build" --evidence-dir "$D1_WORK/evidence-001" \
  --jobs 4 --hints "$D1_SOURCE/scripts/verification/resource_hints.json" --replay
```

The project build directory must initially be empty. The scheduler runs each compiler with one thread and records source, dependency, runtime, artifact, command and log identities. Use fewer jobs on smaller machines. Optional `--hints` supplies reviewed per-module timeout/memory scheduling estimates; it does not change proof identities. The wrapper defaults to `--build-timeout 1200` seconds per module because the initial 240-second setting timed out on three unchanged sources in the genuine clean build. The three original timeout cases subsequently compiled unchanged under increased resource limits. Completion of the whole build is determined separately by its recorded gate outcome. Individual hint timeouts override the default; measured heavy matrix hints retain their 4900 MiB reservation and 600-second limit. Use `--build-timeout` to set a different positive default. Failed and interrupted attempts remain recorded. The included `scripts/verification/resource_hints.json` is byte-identical to the operational `RESOURCE_HINTS_V3.json` (SHA256 `3d4d6a8d901fb0076ee375ade19916ec1b39e4afbf7909016361919941a9ae95`). It retains the previous 11 entries and adds 2048 MiB admission estimates for the 64 numeric prefix-data modules after an aggregate-memory OOM. The unchanged prefix43 source then compiled in an isolated retry in 17.18 seconds, with observed peak resident memory of approximately 1772 MiB. These are scheduling estimates, not proven memory bounds. The preserved JSON text about a remaining prefix phase capped at two jobs records the original proposal; that phase was not executed. The selected full recovery run used seven configured jobs, with its observed reservation budget admitting at most three prefix jobs concurrently. Review scheduling estimates for the machine; they are optional execution inputs, not proof-source dependencies. Historical receipt names and proposal comments are provenance annotations; the scheduler does not open those paths or execute those comments. Completion of each verification gate must still be established by its actual terminal evidence.

To resume this same fresh-origin build, repeat with `--resume` and a **new** empty evidence directory. Accepted modules are reused only when their complete source/dependency/artifact receipt chain still matches. A completed resumed build is explicitly labelled `PROJECT_SOURCE_BUILD_COMPLETE_RESUMED`; it does not claim all modules were rebuilt in the last invocation.

Without `--replay`, successful source/build/audit checks end with `SOURCE_BUILD_AND_AUDITS_PASS_FRESH_REPLAY_PENDING` and exit **3**. This is deliberately not full success. Errors and interruptions exit **1**, preserve available logs, and cannot become complete acceptance. The wrapper invokes only `leanchecker --verbose --fresh D1Bound5`, with `LEAN_NUM_THREADS=0`, and verifies the exact root banner and the same frozen inputs used by the type/axiom audits. Do not invoke this pinned checker's unsupported `--help` flag or omit its module target.

These are reproduction instructions, not a record that this packaged command has already completed. Published evidence must identify the exact command, commit/tree, source/runtime locks, logs and gate outcomes. The portable wrapper uses the installed official checker directly; the separate Linux container watchdog used during development is not a required repository input. Reducing build jobs changes compilation concurrency, not the memory needed by the single fresh replay process. The broad compatibility audit remains a separately reported gate.

For a separate source-only inspection:

```sh
python3 "$D1_SOURCE/scripts/source_audit.py" \
  --project "$D1_SOURCE" --out "$D1_WORK/source-policy-only"
```

Only `SOURCE_POLICY_PASS_SOURCE_ONLY` with exit 0 accepts source policy. Its exact reviewed Omega imports/code-generation options are bound to source hashes and locations. Unreviewed findings fail. Source-only success does not establish compilation, theorem types, axiom closure or fresh replay.

## Release-maintainer manifest preparation

After reviewing intentional tool edits, prepare replacement manifests outside the checkout:

```sh
python3 "$D1_SOURCE/scripts/verification/prepare_manifests.py" \
  --project "$D1_SOURCE" --source-lock "$D1_WORK/source-lock.json" \
  --source-lock-sha256 "$D1_SOURCE_SHA" \
  --prior-tools-manifest "$D1_SOURCE/records/verification-history/20261023/verification-tools.before.sha256.txt" \
  --updated-tool scripts/Audit.lean --updated-tool scripts/check.sh \
  --updated-tool scripts/source_audit.py --out "$D1_WORK/manifest-proposal"
```

This preserves all historical tool entries, rejects unexpected historical changes, and adds the explicit required tool set in `release_pins.json`. It refuses disconnected production sources. Review the proposed manifest changes, then install and commit them through the repository's existing `GIT_SYNC_POLICY.md`. Manifest preparation is labelled `MANIFEST_PROPOSAL_ONLY_NOT_PROOF_ACCEPTANCE`; refreshing fingerprints never creates proof evidence. Repository publication helpers and historical audit scopes retain their separate policies.
