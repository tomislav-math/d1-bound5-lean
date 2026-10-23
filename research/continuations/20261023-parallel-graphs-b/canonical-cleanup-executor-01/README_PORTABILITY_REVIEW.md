# README portability review — proposal only

Reviewed on 23 October 2026. This is a read-only review of the proposed repository package, not an execution of its release command. No Lean/compiler/checker, clone, Git mutation, canonical-source edit, or existing README edit was performed.

**Conclusion:** the packaged `scripts/check.sh` can describe a new verification run from a later, clean remote clone with regenerated source/runtime locks and an initially empty build directory. Its executable path has no dependency on local candidate commit `102905a54…`, the local candidate's receipts, or Linux `/workspace` paths. Actual end-to-end execution of the packaged CLI remains pending.

## Why the instructions are relocatable

- `scripts/check.sh` locates its containing checkout, and `scripts/verification/check.py` derives `ROOT` from its own file. Repository validation reads that checkout's actual committed production/configuration/tool manifests and Git blob bytes. The wrapper captures its current `HEAD` and tree and passes those identities to the audit helper; it does not require the historical candidate commit.
- The source lock contains relative module paths, source hashes, imports, and configuration hashes. Its contents do not embed the source checkout's absolute location. The selected production scope remains exactly 4406 modules rooted at `D1Bound5`.
- Runtime-lock preparation resolves the new machine's Lean distribution and public Mathlib/package artifact paths, appends the Lean core directory, and hashes their actual files. The build identity then records the new checkout/build paths and generated clean environment. Historical project artifacts and a second `D1Bound5` owner in the external cache are rejected.
- The exact audit helper loads the packaged, hash-pinned build utility and checks the new build's fresh-origin receipt chain. Fresh replay invokes the checker from the regenerated runtime lock with the same audited artifact snapshot.
- The executable scripts and release pins contain no `/workspace`, `/Users`, `102905`, `clean-checkout`, `CLEAN_SOURCE_LOCK`, or `FRESH_RUNTIME_LOCK` dependency. The standalone research `BROAD_AUDIT_RECIPE.json` does contain historical absolute paths, but it is not opened by `check.sh`; it must not be presented as a portable executable recipe.
- The Python files parsed successfully using Python 3.8 grammar. The inspected APIs are standard-library/POSIX interfaces available on Linux/macOS. Linux cgroup memory inspection has a non-cgroup fallback; this is static code review, not a platform smoke test.

## Minimal README delta proposed

Add after the paragraph about cloning the selected commit:

> Use the final repository commit containing the reviewed production sources, configuration, verification tools and manifests. The verifier derives its source root and Git commit/tree from this clone; it does not require the earlier local verification-candidate commit or that machine's receipts. An ordinary user of the release should not regenerate committed release manifests. Manifest preparation below is a maintainer operation after intentional reviewed changes.

Add after the lock-generation explanation:

> Generate both locks in the new work directory and review them against the committed release inputs. Do not copy an old machine's runtime lock or build receipts. A new machine, relocated checkout, changed runtime, or different build directory requires a new initially empty build. `--resume` is for the same frozen checkout/runtime/build identity only; every invocation still requires a new empty evidence directory.

Add near the replay command/results paragraph:

> These are reproduction instructions, not a record that this packaged command has already completed. Published evidence must identify the exact command, commit/tree, source/runtime locks, logs and gate outcomes. The portable wrapper uses the installed official checker directly; the separate Linux container watchdog used during development is not a required repository input. Reducing build jobs changes compilation concurrency, not the memory needed by the single fresh replay process. The broad compatibility audit remains a separately reported gate.

Keep the existing explicit lock arguments, pinned public Lean/Mathlib preparation, optional resource hints, `--replay`, exit-3 pending status, and fresh-root command. Do not reinstate the old argument-free `bash scripts/check.sh --replay` example in the top-level README. The separate pending README/STATUS proposal already supplies the explicit lock-based invocation.

## Conditions before claiming reproduction or acceptance

The final clone must include the reviewed tool package and matching committed manifests. The public Mathlib checkout must be at `0df444a360eaa60ab8c11dca51a86af692955474`, with package revisions matching `lake-manifest.json`, and use the official `leanprover/lean4:v4.33.1` distribution for its platform. Keep the external cache immutable throughout verification. Source-policy success, clean compilation, 118 exact checks, and fresh replay retain their separate outcomes; broad compatibility remains separately recorded. Do not transform these instructions into a success claim until the matching actual evidence exists.

Any README change is itself a reviewed-tool change because `scripts/verification/README.md` is listed in `release_pins.json`. Install an accepted wording update before the final tool-manifest freeze, or explicitly refresh and review the manifest afterward. This review makes no such update.

## Reviewed byte identities

| File | SHA256 |
|---|---|
| `scripts/check.sh` | `54a9ab27026a78217bc0a45a29bf51f5e7e8bdcd109e760548c01c6d9b0bfedc` |
| `scripts/fresh_project_build.py` | `d2b952a6e59bcaf4a55d172bf64996bbc8ce3d661ca2972ff4018690d096dd66` |
| `scripts/verification/check.py` | `82749dc3164e32b2273ec91bf2cb4b178283d9b92a8eab543534d4b583879883` |
| `scripts/verification/clean_final_audits.py` | `6f2581bf0084f72447c007eb077bf2915590aac47dd6531abba636ed11d24f87` |
| `scripts/verification/README.md` | `9cb3caa4331ebbc1853fff3c3bb426cda974571186b2e7d77575e9f89241ee8d` |
| `scripts/verification/release_pins.json` | `0725e34a6da18722fe8b0efe620f6d29ba1557fbe0b6e908ed25f76cb7f4a51f` |
| `scripts/verification/resource_hints.json` | `ddb33bfc01f6a9279185c2444ad618b04fe05b96ffee1216955484fcd12791aa` |
