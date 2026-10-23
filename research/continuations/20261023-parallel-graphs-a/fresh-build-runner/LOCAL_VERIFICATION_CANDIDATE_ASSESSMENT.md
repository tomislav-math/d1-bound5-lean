# Local verification candidate assessment

2026-10-23. Independent assessment of the coordinator's proposal while the Mac connector is unavailable.

A new isolated local Git commit is a valid origin for a genuine fresh source build. Publication to an existing remote repository is not a mathematical proof requirement. The evidence must identify this as a LOCAL_VERIFICATION_CANDIDATE and must not imply that its commit already exists in the private repository.

Required boundaries:

1. Commit the exact reviewed production root closure, currently expected to be 4406 source modules including D1Bound5.lean, together with lean-toolchain, lakefile.lean, lake-manifest.json, the canonical source/type/axiom audit scripts, and the reviewed portable runner. Derive and verify the final count; do not accept an expected count in place of closure equality.
2. The frozen root must import MainTheorem and the intended additional previously verified project modules. Run the source-policy/import-reachability check inside the candidate itself.
3. Record the local commit, full Git tree, and a separate SHA256 path manifest of production sources, pins, and gate scripts. Keep proof-source identity distinct from research/documentation history.
4. Clone or export that immutable local commit to a fresh source directory containing no project build artifacts. Use an empty external project artifact directory and only the pinned external Lean/Mathlib cache. No development .olean, historical project artifact, or private source directory may satisfy an import.
5. Run the same fresh compilation, exact statement, strict axiom, and agreed installed-kernel gates. Preserve their real outcomes independently; a new commit does not turn pending gates into PASS.
6. When the Mac/remote returns, publish the byte-identical production source and pin/runner manifest through the already authorized repository workflow. Before associating the local verification result with that later commit, require exact path/hash equality. If production files differ, the old gate is evidence only for its original local candidate.

Additional research or documentation files may produce a different full Git tree while preserving the reviewed production manifest. Report both identities explicitly. This avoids falsely claiming a remote commit was tested while retaining useful, genuine clean-checkout proof evidence.

No external publication, new remote, compiler launch, or canonical source edit was performed by this review.
