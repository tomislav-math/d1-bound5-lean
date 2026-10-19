# Repair 05

2026-10-19T21:54:25.242773+02:00

Actual compiler failure: bad import Mathlib.Data.Complex.Norm. The installed pinned source was inspected. Mathlib.Analysis.Complex.Basic registers the complex NormedField and imports the needed norm theory. Replaced only the nonexistent import with this installed module. No installation, dependency revision, toolchain, mathematical definition or theorem statement was changed. The source was outside the active FiniteN2IntegralRows protected closure.

```diff
--- FiniteHomogeneousTwo.before
+++ FiniteHomogeneousTwo.after
@@ -1,5 +1,5 @@
 import Mathlib.Analysis.Normed.Ring.Basic
-import Mathlib.Data.Complex.Norm
+import Mathlib.Analysis.Complex.Basic
 import Mathlib.Algebra.BigOperators.Fin
 import Mathlib.Tactic.GCongr
 import Mathlib.Tactic.Ring
```
