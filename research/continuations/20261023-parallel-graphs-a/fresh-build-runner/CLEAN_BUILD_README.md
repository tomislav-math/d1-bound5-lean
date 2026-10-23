# Reproduce the clean project build

This package is a local verification candidate until its production manifest is matched to a published repository commit. A fresh build compiles every selected D1Bound5 source into an initially empty project artifact directory. The only reused proof artifacts are from the pinned public Lean/Mathlib distribution and cache.

## Required inputs

- Git; Python 3.8+ with the standard library; Linux or macOS.
- The Lean 4.33.1 distribution, including `lean`, `lake`, and `leanchecker`.
- This candidate's exact `D1Bound5.lean`, all root-reachable `D1Bound5/*.lean`, `lean-toolchain`, `lakefile.lean`, and `lake-manifest.json`.
- `scripts/fresh_project_build.py`, the source-policy gate, and `verification/FinalTargetAudit.lean` plus `verification/FinalIntegrationAudit.lean`.
- A separate public Mathlib checkout/cache at commit `0df444a360eaa60ab8c11dca51a86af692955474`, with package revisions fixed by this candidate's `lake-manifest.json`. No private source file or old D1Bound5 artifact is required.

The reviewed runner SHA256 is `d2b952a6e59bcaf4a55d172bf64996bbc8ce3d661ca2972ff4018690d096dd66`. Its 15 lifecycle checks and a real three-module Lean smoke build passed; exact smoke resume reused all three validated artifacts. These tooling tests are not the 4406-module project build.

Pinned package revisions:

| Package | Revision |
|---|---|
| mathlib | 0df444a360eaa60ab8c11dca51a86af692955474 |
| plausible | b7eb3304aeae834b12dda98993a37f6a41f6f0bb |
| LeanSearchClient | 5f4d51b81cbd3f6b32b156bfad9056621a040404 |
| importGraph | 16f02aa7642864af59f1ff0e384a015994db9118 |
| proofwidgets | 4be2e3d5087eeb272cf5a8853b8f9dd025ef5957 |
| aesop | 3448c0bcc5ce01b2d1546e483ec3620e32df3d0e |
| Qq | 92c15be17b7caf78c2ad767ec40f89052d908d81 |
| batteries | 4488d40d070b9700d4d5a6aa342f0d40c31b2a2d |
| Cli | 6130a47896ce867c6a4a55373441e59e565bad0f |

## 1. Make an immutable clean source copy

Set absolute paths appropriate to the machine. The build and cache directories must be outside the source checkout.

```sh
D1_CANDIDATE=/absolute/path/to/candidate-repository
D1_COMMIT=exact_candidate_commit
D1_WORK=/absolute/path/to/new-verification
D1_TOOLCHAIN=/absolute/path/to/lean-4.33.1
D1_CACHE=/absolute/path/to/public-mathlib-cache
mkdir -p "$D1_WORK"
git clone --no-local "$D1_CANDIDATE" "$D1_WORK/source"
git -C "$D1_WORK/source" checkout --detach "$D1_COMMIT"
git -C "$D1_WORK/source" rev-parse HEAD
git -C "$D1_WORK/source" status --porcelain
D1_SOURCE="$D1_WORK/source"
D1_RUNNER="$D1_SOURCE/scripts/fresh_project_build.py"
```

The status output should be empty. Record the commit and tree identity. Run the source-policy/reachability gate against this source copy before accepting the build. Run `python3 "$D1_SOURCE/verification/scan_final_sources.py" --project "$D1_SOURCE" --root-module D1Bound5 --out "$D1_WORK/source-audit"`. Inspect any `REVIEW_REQUIRED` findings, including benign Omega imports/options, against the independently reviewed inventory; scanner exit 0 alone is not source-policy acceptance. The expected production closure is 4406 modules including the root; the final source lock must independently establish that count.

If a public cache must be prepared, clone the public Mathlib repository outside the source copy, check out the pinned revision, and run the pinned toolchain's `lake exe cache get` there. Preserve its pinned manifest and verify the package revisions above. This preparation must not copy any D1Bound5 build artifacts.

## 2. Freeze source and external runtime identities

```sh
python3 "$D1_RUNNER" prepare-source-lock \
  --source-root "$D1_SOURCE" --roots D1Bound5 \
  --out "$D1_WORK/source-lock.json"
```

Generate the runtime lock from the separate public cache. This automatically includes the Lean distribution and the existing public package artifact directories; a package without an artifact directory is not added to the search path.

```sh
python3 - "$D1_RUNNER" "$D1_TOOLCHAIN" "$D1_CACHE" "$D1_WORK/runtime-lock.json" <<'PY'
import pathlib, subprocess, sys
runner, toolchain, cache, output = sys.argv[1:]
cache = pathlib.Path(cache)
paths = [cache / ".lake/build/lib/lean"]
paths += sorted(p for p in (cache / ".lake/packages").glob("*/.lake/build/lib/lean") if p.is_dir())
args = [sys.executable, runner, "prepare-runtime-lock",
        "--toolchain", toolchain, "--expected-version", "4.33.1", "--out", output]
for path in paths:
    args += ["--external-path", str(path.resolve())]
subprocess.run(args, check=True)
PY
```

For this frozen candidate, the independently matched `CLEAN_SOURCE_LOCK.json` SHA256 is `b3be4592f1c30e40abb6677cb5319d0420538adb20f6d05e743205be19d59d3c`. Regeneration from an identical source tree should match. Review the generated module set, external paths, and pins. The runner rejects project artifacts in external roots. Do not write to the pinned runtime/cache during the build.

On the current execution host, the prepared `FRESH_RUNTIME_LOCK.json` has SHA256 `c50d017cd71b3ee22d299302c15a64d5e82a9b71f95ef6040ca077dc56dbd404` and inventories 128001 files. It contains absolute host paths, so another machine must generate its own lock. The current host also needs a recorded `LD_PRELOAD` compatibility shim for its process-path environment; ordinary Lean installations do not need that shim. Any required loader override must be supplied through `prepare-runtime-lock --environment` and is included in the runtime identity.

## 3. Compile into an empty project artifact tree

Set the two SHA256 values to the reviewed lock hashes printed by the preparation commands:

```sh
D1_SOURCE_SHA=reviewed_source_lock_sha256
D1_RUNTIME_SHA=reviewed_runtime_lock_sha256
python3 "$D1_RUNNER" run \
  --source-root "$D1_SOURCE" --build-dir "$D1_WORK/build" \
  --source-lock "$D1_WORK/source-lock.json" --source-lock-sha256 "$D1_SOURCE_SHA" \
  --runtime-lock "$D1_WORK/runtime-lock.json" --runtime-lock-sha256 "$D1_RUNTIME_SHA" \
  --expected-modules 4406 --jobs 4
```

Each compiler uses `-j1 -DautoImplicit=false`. The scheduler admits jobs conservatively based on actual memory pressure and distinguishes heavy modules. Use `--jobs 1` or `--jobs 2` on a smaller machine; the cap does not force that many jobs to run. Per-module timeout/memory overrides can be supplied with `--hints`. The current reviewed `FRESH_COST_HINTS.json` has SHA256 `7b4b05fa015976e0f34094c6fc36a5a5fe5b934cc57da2e9a89708abaec8cbed`; it reserves 4900 MiB and up to 600 seconds for the two measured matrix cases, with longer timeouts for three other measured modules. Hints affect scheduling, not accepted proof identities. Keep other heavy compilation or replay processes stopped.

Only a zero exit plus `FRESH_PROJECT_SOURCE_BUILD_PASS` in `build/SUMMARY.json` establishes completion of an uninterrupted fresh run. If interrupted, repeat the same command with `--resume`; only recursively validated receipts from this same initially empty run are reused. A completed resumed run is explicitly labeled `PROJECT_SOURCE_BUILD_COMPLETE_RESUMED`. Failed attempts remain in `build/attempts`.

Do not copy development or historical project artifacts into this tree. Do not substitute an ordinary cached `lake build` for this fresh-origin gate.

## 4. Finish statement, axiom, and installed-kernel gates

Compilation alone is not the complete release gate. Using the same clean source and fresh artifact tree:

1. Check the exact main theorem type with `verification/FinalTargetAudit.lean`.
2. Run the 114 declaration type and transitive-axiom audit in `verification/FinalIntegrationAudit.lean`, accepting only `propext`, `Classical.choice`, and `Quot.sound`.
3. Run the reviewed, separately hashed final checker orchestration against the same source/runtime/artifact manifest. Its official fresh command is `leanchecker --fresh D1Bound5`, with the final umbrella root frozen to the complete reviewed union. Run it alone under the agreed memory guard. Never invoke `leanchecker --help`; this pinned checker does not implement that flag.

The audit subprocess environment must be created by the runner's `clean_environment(runtime_lock, build/artifacts)` helper, so it cannot accidentally import the development project's artifacts. Use explicit `-j1 -DautoImplicit=false` for Lean audit commands. Preserve all audit/checker commands, logs, exit codes, source/artifact hashes, and the final summary. Do not report pending, failed, timed-out, or interrupted replay as PASS.

The final checker orchestration can be packaged after compilation begins because it is a verification tool rather than a proof-source dependency. Before use, bind its exact code hash to the candidate commit and fresh build manifests. Publishing a later repository commit requires byte-identical production-source, pin, and runner manifests before reusing this candidate's verification result.
