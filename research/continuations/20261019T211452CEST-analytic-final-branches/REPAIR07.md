# Repair 07

2026-10-19T22:02:54.809880+02:00

The actual N2 residue identity failed before polynomial checking: simplification did not specialize the reciprocal-pole expressions after fin_cases introduced constructor indices. Use explicitly proved exhaustive equalities i=0/1/2 and j=0/1/2, and rewrite the corresponding pole expression with the original proved zero/one/two lemmas. All nine original matrix entries are retained; no statement or coefficient changes. Compilation remains required. The active retained-start closure is disjoint.

```diff
--- FiniteN2BennettIdentity.attempt01
+++ FiniteN2BennettIdentity.attempt02
@@ -27,13 +27,18 @@
   have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
   have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
   have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
-  fin_cases i <;> fin_cases j
+  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
+  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
+  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
   all_goals
     unfold bennettTwoClearedEntry bennettClearedResidue
-    simp only [bennettTwoOtherPoles_zero, bennettTwoOtherPoles_one,
-      bennettTwoOtherPoles_two, bennettTwoNodes_zero, bennettTwoNodes_one,
-      bennettTwoNodes_two]
-    rw [bennettClearedTaylor_two_poles_scaled_eval]
+    first
+    | rw [bennettTwoOtherPoles_zero, bennettTwoNodes_zero,
+        bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [bennettTwoOtherPoles_one, bennettTwoNodes_one,
+        bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [bennettTwoOtherPoles_two, bennettTwoNodes_two,
+        bennettClearedTaylor_two_poles_scaled_eval]
     norm_num [hanti1, hanti2, Finset.antidiagonal_zero,
       Ring.choose_zero_right, Ring.choose_one_right, finite_choose_two,
       finiteN2RowFactor, finiteN2Matrix, finiteN2DividedMatrix,
```
