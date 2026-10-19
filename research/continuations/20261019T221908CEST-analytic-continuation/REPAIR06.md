# Repair 06

2026-10-19T23:00:24.680650+02:00

All N2 downstream proofs and the all-large overlap theorem compiled successfully. The N3 identity failed at pole expansion after fin_cases produced constructor-form indices and simp left the pole product unreduced. Use the same explicit three-case equalities and branch-specific pole rewrite already kernel-elaborated in N2. Public theorem headers, integer polynomials and the nine-case coverage are unchanged.

```diff
--- before
+++ after
@@ -41,13 +41,18 @@
   have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
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
     norm_num [hfin01, hfin02, hfin10, hfin12, hfin20, hfin21, hanti1, hanti2, hanti3, hanti0,
       Ring.choose_zero_right, Ring.choose_one_right, finiteN3_choose_two, finiteN3_choose_three,
       finiteN3RowFactor, finiteN3Matrix, finiteN3DividedMatrix,
```
