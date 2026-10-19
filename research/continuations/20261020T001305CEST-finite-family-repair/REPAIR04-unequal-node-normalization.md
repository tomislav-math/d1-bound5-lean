# Explicit pole nodes and unambiguous absolute-value multiplication

2026-10-20T00:25:18.157999+02:00

FiniteUnequalEntry failed only in explicit node normalization and a body-only lexer collision between the closing absolute-value bar and multiplication. Use literal Fin3 cases, and separate the tokens. The A3 height proof receives the already diagnosed third/fourth vector evaluation lemmas. Original public signatures and every constant are unchanged. Wave01 outer PID61683 was collected with exit1; the successful unequal-pole residual and coefficient proofs are reused.

```diff
--- FiniteUnequalEntry.lean.before
+++ FiniteUnequalEntry.lean.after
@@ -113,7 +113,8 @@
     exact (div_lt_one hprod).mpr hXC
   have hnodes : ∀ j, ‖bennettTwoNodes x y j‖ ≤ ‖y‖ := by
     intro j
-    fin_cases j
+    have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
+    rcases hj with rfl | rfl | rfl
     · simpa only [bennettTwoNodes_zero,norm_zero] using norm_nonneg y
     · simp only [bennettTwoNodes_one,le_refl]
     · simpa only [bennettTwoNodes_two] using hXY
@@ -147,7 +148,7 @@
     exact finiteUnequal_residual_scale ‖x‖ ‖y‖ ‖c‖ ‖x-y‖ hX hY hC k m
   rw [hrow,norm_mul]
   calc
-    _ ≤ ‖S‖*(|Ring.choose ((k : ℝ)+1/2) (m+2*k)|*
+    _ ≤ ‖S‖*(|Ring.choose ((k : ℝ)+1/2) (m+2*k)| *
         ‖(x*y*c)⁻¹‖^(m+2*k) /
           (1-‖y‖*‖(x*y*c)⁻¹‖)^(((m+2*k : ℕ) : ℝ)-((k : ℝ)+1/2))) :=
       mul_le_mul_of_nonneg_left hbound (norm_nonneg S)
```
```diff
--- FiniteA3Height.lean.before
+++ FiniteA3Height.lean.after
@@ -13,26 +13,26 @@
       (finiteHomogeneousTwo_norm_le 3 (finiteA3Coeff0 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 3 (finiteA3Coeff0 i 1) x y hxy)
     rw [← add_mul,finiteA3_coefficient_sums_0] at hh
-    simpa [finiteA3RootCoeff] using hh
+    simpa [finiteA3RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 4 (finiteA3Coeff1 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 4 (finiteA3Coeff1 i 1) x y hxy)
     rw [← add_mul,finiteA3_coefficient_sums_1] at hh
-    simpa [finiteA3RootCoeff] using hh
+    simpa [finiteA3RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 5 (finiteA3Coeff2 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 5 (finiteA3Coeff2 i 1) x y hxy)
     rw [← add_mul,finiteA3_coefficient_sums_2] at hh
-    simpa [finiteA3RootCoeff] using hh
+    simpa [finiteA3RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons] using hh
   · have hh := add_le_add
       (finiteHomogeneousTwo_norm_le 6 (finiteA3Coeff3 i 0) x y hxy)
       (finiteHomogeneousTwo_norm_le 6 (finiteA3Coeff3 i 1) x y hxy)
     rw [← add_mul,finiteA3_coefficient_sums_3] at hh
-    simpa [finiteA3RootCoeff] using hh
+    simpa [finiteA3RootCoeff, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons] using hh
 
 theorem finiteA3_coefficient_sums_nonneg (i : Fin 3) (ell : Fin 4) :
     0 ≤ (finiteA3CoefficientSums i ell : ℝ) := by
-  fin_cases i <;> fin_cases ell <;> norm_num [finiteA3CoefficientSums]
+  fin_cases i <;> fin_cases ell <;> norm_num [finiteA3CoefficientSums, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]
 
 /-- Exact rational row checks preserve the manuscript's sharp M=2265. -/
 theorem finiteA3_height_slack (i : Fin 3) :
```
