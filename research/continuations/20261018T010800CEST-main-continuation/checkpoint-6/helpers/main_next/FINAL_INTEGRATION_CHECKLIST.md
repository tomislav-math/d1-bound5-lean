# Final integration checklist — source complete, acceptance pending

Read-only audit of the authorized project on 18 October 2026, 01:40 UTC.
No compiler, remote source/index mutation or queue change was performed by this reviewer.
`FINAL_INTEGRATION_SNAPSHOT.json` records the exact dependency/queue snapshot.
Private checkpoint `d6ebd0c` is a research backup, not mathematical acceptance.

## Exact target and concrete assembly

`D1Bound5.MainStatement.{u}` in `Specification.lean` asserts cardinality at most five for every finite D(1) set in the full mathlib ring of integers of every degree-two totally complex number field. Entries are distinct and nonzero; square roots may be zero; equal complex moduli are permitted.

The actual proof is `D1Bound5.main_statement : MainStatement.{u}` in `MainTheorem.lean`, SHA256 `0d4652828c5f48475a6e80d8d00fa209e39c0638a58ebd99fd719e271c2670f6`. It uses `mainStatement_iff_three_ordered_cases`, which in turn uses `card_bound_iff_no_ordered_sextuple`. There is no analytic or finite-certificate premise in the final type.

| Ordered branch | Actual endpoint used by MainTheorem |
|---|---|
| First modulus at least 3 | `IsD1Tuple.all_large_impossible` |
| First modulus below 3, second at least 3 | `IsD1Tuple.not_one_small` |
| Second and third moduli below 3 | `IsD1Tuple.not_three_small` |
| Second below 3, third at least 3, first radicand nonzero | `IsD1Tuple.two_small_nondegenerate_impossible` |
| Second below 3, third at least 3, first radicand zero | `IsD1Tuple.degenerate_first_pair_impossible` |

The final split is exhaustive, including threshold equalities and zero roots. The degenerate endpoint itself requires no smallness hypothesis. Source/type review passes; compiled proof acceptance does not follow from that review.

## Dependency gates that must not be hidden by top-level imports

The inspected main closure contains **653 project modules**, with no missing source import. The accepted root currently reaches **107 modules** and does not import MainTheorem. There are **557 modules in the main closure not reachable from that accepted root**. These counts are snapshots, not build successes.

| Gate | Concrete dependency path and required evidence |
|---|---|
| Nondegenerate two-small finite bound | `TwoSmallNondegenerateImpossible` → `TwoSmallSextuple` → `SmallPairBoundedExtensions` → `SmallPairOrbitProperties` → `SmallPairRepresentativeProperties` → `SmallPairGraphs` → **`SmallPairGraphData1` through `SmallPairGraphData48`**. All 48 graph certificates, exact closure/edge checkers, symmetry and full-ring transport must compile. The analytic `TwoSmallFifthBound` is a separate required input. |
| Modular sieve performance gate | `CoordinateSquareMaskCheck` → eleven `SmallPairSieve_tau_nu` modules → `SmallPairSieves`; all 275 original masks require kernel-checked proofs. The modulus97 `CoordinateSquareMaskPilot` is a benchmark, not proof of the remaining masks. Read-only receipt saw its successful standalone build; whole sieve and graphs remained gated. |
| Rational degenerate pair | `DegeneratePairImpossible` → `UnitPairImpossible` → `UnitPairFiniteReduction` → `PellUnitPairBounded` → `PellFiniteFields`. Required finite sources: **`PellMatchingPilot`, `PellMatchingData1..26`, `PellFinitePilot`, `PellFiniteData1..64`**. `PellFiniteFields` must prove exhaustive coverage of all 1016 squarefree field parameters, not assume the generated list. |
| Pell completeness and same field | `PellFiniteCertificate` depends on `PellCFPrefixCheck` → `PellConvergentCompleteness`, `PellMatchingCheck`, `UnitPairRealReduction` and the same `UnitPairArithmeticModel`; `UnitPairFieldBound` supplies the actual field bound. Full prefix/list equality, stopping numerator and both signs are essential. An accepted small matching pilot does not certify all prefixes or all fields. |
| Nonrational degenerate pair | Actual `DegeneratePairClassification`, `EisensteinPellDescent`, `EisensteinExceptionalPair` and `EisensteinImaginaryExtensions`, composed directly in `DegeneratePairImpossible`. The optional separately packaged `EisensteinExceptionalBound` is not imported by MainTheorem. |
| Three-small finite classification | `ThreeSmallExclusion` → `ThreeSmallSextuple` → `SmallTripleBoundedExtensions` → `SmallTripleOrbitProperties` → `SmallTripleRepresentativeProperties` → `SmallExtensionSymmetry` → `SmallTripleExtensions` and `SmallTripleClassification`. All ten closure certificates and the reversible descent/complete seed enumeration must compile. |
| One-small exact data and analysis | `OneSmallImpossible` → `OneSmallFirstPairReduction`/`FiveRegionImpossible` and `OneSmallReducedImpossible`. Requires all actual finite-family intervals, five-region rational comparisons, 41-pair geometry, 57 fixed cutoffs, full finite first-triple classification and the universal signed rational (1,3,8) branch. No Gaussian coordinate equivalence may be substituted for the rational case. |
| All-large analytic families | `AllLargeImpossible` → `AllLargeForcedPWindow` and `FinitePInterval`, with Q/N2/P/A3/M/N3/N3bs/A4/A5 and the all-order ordinary tail. The actual P tail and interval closure are dependencies, not accepted merely because their source files exist. |

The live queue explicitly blocked six graph aggregators (`SmallPairBoundedExtensions`, `SmallPairGraphSymmetry`, `SmallPairOrbitProperties`, `SmallPairRepresentativeProperties`, `SmallPairGraphs`, `TwoSmallSextuple`) and 92 Pell modules (26 matching batches, 64 prefix batches, `PellFiniteFields`, `PellUnitPairBounded`). The JSON snapshot records all 98 names exactly. A top-level build must not be treated as complete until their actual current source/artifact fingerprints pass; stale `.olean` presence is insufficient.

## Optional queue targets and root reachability

Of the 411 queued targets, exactly four were outside the final main closure:

- `CoordinateSquareMaskPilot`: deliberate benchmark; observed passing in the inspected receipt.
- `CoupledPhaseDerivativePilot`: diagnostic pilot; retain only if needed for performance validation.
- `SmallSextupleReduction`: optional reduction theorem, not needed by the concrete final assembly.
- `EisensteinExceptionalBound`: optional packaged cardinality theorem; main uses the direct obstruction.

The last two can be deferred without changing the actual main dependency graph. No queue changes were made. After adding only `import D1Bound5.MainTheorem`, the current `scripts/source_audit.py` would still reject five unimported project sources: the four above plus `TwoSmallFiniteReduction`. At final integration, either compile and deliberately root-import these accepted optional modules, or keep them outside the accepted project namespace as clearly marked research. Do not weaken the scanner's every-project-module-reachable requirement.

## Ordered acceptance actions — coordinator only

1. Freeze the intended source/configuration hashes; finish current standalone dependency and certificate builds. Confirm success belongs to the exact source bytes and unchanged dependency artifacts, with no timeout, interruption, imported stale artifact or failed child hidden by an aggregate receipt. The scheduling trusted-baseline file is not a final theorem audit.
2. Build `D1Bound5.MainTheorem` with its entire current closure. Inspect `#check @D1Bound5.main_statement`, `#print D1Bound5.MainStatement`, and `#print axioms D1Bound5.main_statement`. Include an explicit type-checking assignment/example of `MainStatement.{u}` to the theorem in the final audit. Only `propext`, `Classical.choice`, `Quot.sound` are permitted.
3. **Only after closure passes**, deliberately update `D1Bound5.lean` with the main import and resolve the five optional-source reachability decisions above. `lakefile.lean`, `lean-toolchain` and `lake-manifest.json` need no dependency or trust-baseline change for this work.
4. Keep `scripts/source_audit.py` and its forbidden-token/reachability policy unchanged. Run it, the integrated pinned root build, and `scripts/Audit.lean`. The latter already collects transitive axioms for all exported D1Bound5 declarations; update its stale main-unproved comment and add explicit main type/axiom output only at accepted integration. A separate final targeted audit file is useful but does not replace the whole-root audit.
5. Replay the accepted root using the installed same-kernel checker and retain exact logs/source hashes before and after. Existing `scripts/check.sh --replay` calls `leanchecker --verbose D1Bound5`, **without `--fresh`**; a fresh replay therefore requires the separate explicit `lake env leanchecker --fresh --verbose D1Bound5` command or a reviewed runner update. `SequentialReplay.lean` is alternative sequential scheduling of the same kernel and must receive the full accepted explicit module list. Do not describe either as an independent kernel implementation.
6. Regenerate `records/proof-source-sha256.txt` for the exact accepted root, every accepted proof module and the pinned three config files; regenerate `records/verification-tools-sha256.txt` only for the actual reviewed audit/replay tooling. Verify them before release. Existing `scripts/git_sync_preflight.py` checks these fingerprints but does not prove the theorem. `verification/FILES.sha256` covers the frozen paper/numerical supplement and needs no change unless those deliverables changed.
7. Write precise accepted receipts to `records/build-record.md`, update `records/paper-to-lean.md`, `records/statement-review.md` and `records/open-obligations.md`, and add a new current `STATUS.md` entry only after the corresponding gates succeed. Preserve historical failed/uncompiled records. Update current incomplete-main statements in `README.md` and `verification/README.md` only when acceptance is established; distinguish kernel certificates from diagnostic Python regeneration and distinguish source review from compilation.
8. Complete the recorded clean-checkout/reproduction gate before claiming it. Record private git synchronization separately from mathematical verification; preserve user-requested paused automations. No public release, new licence or paid CI action is implied.

The source checklist is complete; none of these pending acceptance actions was performed by this reviewer.
