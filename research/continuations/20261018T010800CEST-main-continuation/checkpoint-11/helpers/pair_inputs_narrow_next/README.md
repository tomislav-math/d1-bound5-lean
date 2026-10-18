# Expanded row 22 import-only candidate

This is a **new, uncompiled candidate**, prepared locally for the sole compiler
owner. Nothing has been installed, no Lean process was launched, and the frozen
expanded sources and their generator were not modified.

The source is `pair_backend_next/expanded22_timeout_fallback`, whose manifest SHA256
is `8dbdf530c318fd2d4f52149ebb78af2ababf65e18ce4205e0c2c50044bbddc20`.
The six candidate modules are in `expanded22/D1Bound5/`.

Exactly two initial import blocks change:

| Module | Import change | Reason |
| --- | --- | --- |
| SmallPairGraphInputs22 | `SmallPairGraphCheck` → `Coordinates` | The five definitions contain only coordinate/list/natural literals. `Coordinates` defines the existing `QuadInt` abbreviation and namespace. |
| SmallPairGraphArithmetic22 | Add explicit `SmallPairGraphCheck` | Its checked filter theorem uses `largePairVertices`, which was previously imported indirectly through Inputs. |

Every byte after the initial import block is identical in all six modules.
WitnessData, Closure, Triangle, and Data are completely byte-identical.
The final graph theorem still imports the same arithmetic, indexed closure, and
structural triangle theorem owners. Every `decide +kernel` proof is unchanged.

The other consumers already have the necessary explicit imports:

- WitnessData imports `PairClosureWitness`, providing its witness types and API.
- Closure imports `PairClosureIndexedWitness`.
- Triangle imports `PairTraceZeroGraph` and the original sieve. That graph adapter
  imports `PairGraphNoThreeTransfer`, which imports `SmallPairGraphCheck`.
- Data imports Arithmetic, Closure, and Triangle.

The pinned primary-source evidence is in
`audit_next/pair_inputs_minimal_import_api.json`. In particular, Coordinates imports
`Mathlib.Algebra.QuadraticAlgebra.Basic` and `Mathlib.Tactic.Linarith`; its existing
setup has 1520 package imports, compared with 2948 for SmallPairGraphCheck. Thus the
Inputs import environment is predicted to fall from 2949 to 1521 package modules.
WitnessData and Closure also avoid the graph geometry import path; the actual
checker modules keep their required graph imports. This is an import-graph
prediction, **not a measured speedup or a kernel acceptance claim**.

Reproduce into a new, disjoint output directory:

```sh
python3 pair_inputs_narrow_next/narrow_expanded_inputs.py \
  --source-root pair_backend_next/expanded22_timeout_fallback \
  --manifest-sha256 8dbdf530c318fd2d4f52149ebb78af2ababf65e18ce4205e0c2c50044bbddc20 \
  --row 22 \
  --output NEW_OUTPUT_DIRECTORY
```

The portable helper validates the manifest and every source SHA/byte count, checks
the five-literal-definition Inputs schema, preserves complete import-free bodies,
refuses existing/overlapping output directories, and rejects accepted pilot rows
16, 34, and 41. It never executes either frozen generator. Compact bundled Inputs
are deliberately rejected because they contain additional witness/cache data.

`expanded22/manifest.json` records exact pre/post source and body hashes;
`expanded22/source_manifest.before.json` is an exact copy of the pinned original
manifest. The candidate totals 1,664,515 bytes versus 1,664,487 original bytes.

Independent source review by source_audit passed at these exact candidate hashes.
The report is `audit_next/narrow_expanded22_review.json`, SHA256
`93ddcde49582c21c9ff3cd7345fef871f117232bdaa24eb8677f662d0e1e7d9a`.
It independently checked all six bodies, all five public definition types, all four
unchanged files, the complete helper source, and the explicit consumer imports.
Root can use this candidate as the first expanded22 trial rather than first
compiling the broad-import expanded copy. Compiler acceptance remains outstanding.
