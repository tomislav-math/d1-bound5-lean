# Two import-only reductions for unaccepted sources

Prepared at the parent's request, using exact current remote source bytes. No remote source, accepted module, driver or artifact was changed. Compilation remains the parent's gate.

## FiniteClosedWindow

Replace the unused `D1Bound5.FiniteRowRootTransfer` import with:

```lean
import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
```

Everything after the import block is byte-identical to the saved preimage. Both proofs use only complex norms and elementary real inequalities. The pinned `Complex.Basic` provides `NormedField ℂ` at line 63; `Complex.Norm` alone provides only the normed additive group and protected `Complex.norm_mul`/`Complex.norm_pow`, and therefore is insufficient for the original unqualified `norm_mul`, `norm_pow`, `norm_one` proof without further changes.

The header import DAG decreases from 2773 package modules to 1851. This is a dependency count, not a promised compile-speed improvement.

All 22 direct consumers were inspected. Twenty-one independently reach `BennettRootApproximation` without `FiniteClosedWindow`; the only declaration defined in the removed `FiniteRowRootTransfer` module is not referenced by consumers lacking another path to it. The remaining `FourAnchorVWindow` uses its own `FullRingThreeSelection` API and the two unchanged window lemmas. No consumer import patch is required by this source review.

## FrontierScalarReduction

Replace the unused `D1Bound5.FrontierCubicErrors` import with:

```lean
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.GCongr
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
```

The five definitions and two proofs are byte-identical. They use only real arithmetic; no removed D1 declaration is referenced. `Linarith` explicitly imports `NormNum` in the pinned source, so `FrontierTableNumeric` retains its `norm_num` tactic.

The direct consumer `FrontierTableNumeric` uses only the unchanged scalar definitions and quadratic-exclusion theorem. All nine further reverse-DAG consumers independently reach `FrontierCubicErrors`, through `FrontierTableTuple → FrontierMixedDeterminant → FrontierMixedCofactors`. No consumer edits are needed by this source review. Neither changed module had a recorded accepted build at inspection.

The old `FrontierTableNumeric` dependency count is 2992; the new scalar import set has 960 package modules, so the numerical table should have 961 after adding its scalar dependency. The counts come from parsed initial Lean import headers, validated against five existing Lake setup maps after excluding Lean's reserved `all` import modifier. No proof-body alteration or import assumption replaces compiler checking.

Exact pre/post hashes are in `SOURCE_MANIFEST.json`. Consumer source hashes and independent import paths are in the referenced audit JSON files.

Independent reviews completed: `article_audit` read the two `FiniteClosedWindow` proofs and verified the import-only diff; `crossblock` read all of `FrontierScalarReduction`, verified the byte-identical bodies and checked the direct consumer/independent cubic import. Both reported source-review PASS. Neither review is a compilation result.
