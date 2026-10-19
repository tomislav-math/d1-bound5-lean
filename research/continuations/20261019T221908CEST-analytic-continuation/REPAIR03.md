# Repair 03

2026-10-19T22:27:11.765734+02:00

The next N2 compiler log leaves only vector evaluation at the third coordinate. The pinned VecNotation source provides cons_val_two but it is not a simp lemma. Add it and its head/tail reductions explicitly. Transfer the already diagnosed antidiagonal and finite-index normalizations to the prepared N3 identity. Sources edited only under intake lock and outside the entire active protected closure. No statements or polynomial data changed.

```diff
--- FiniteN2BennettIdentity.before
+++ FiniteN2BennettIdentity.after
@@ -49,7 +49,7 @@
     norm_num [hfin01, hfin02, hfin10, hfin12, hfin20, hfin21, hanti1, hanti2, hanti0,
       Ring.choose_zero_right, Ring.choose_one_right, finite_choose_two,
       finiteN2RowFactor, finiteN2Matrix, finiteN2DividedMatrix,
-      Matrix.mul_diagonal, finiteN2Constant, finiteN2Left, finiteN2Right]
+      Matrix.mul_diagonal, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons, finiteN2Constant, finiteN2Left, finiteN2Right]
     field_simp [hx, hy, hd, hd']
     <;> ring
 
--- FiniteN3BennettIdentity.before
+++ FiniteN3BennettIdentity.after
@@ -29,6 +29,13 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     bennettTwoClearedEntry x y c 3 i j =
       4 * finiteN3RowFactor x y i * finiteN3Matrix x y c i j := by
+  have hfin01 : (0 : Fin 3) ≠ 1 := by decide
+  have hfin02 : (0 : Fin 3) ≠ 2 := by decide
+  have hfin10 : (1 : Fin 3) ≠ 0 := by decide
+  have hfin12 : (1 : Fin 3) ≠ 2 := by decide
+  have hfin20 : (2 : Fin 3) ≠ 0 := by decide
+  have hfin21 : (2 : Fin 3) ≠ 1 := by decide
+  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
   have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
   have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
   have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
@@ -41,10 +48,10 @@
       bennettTwoOtherPoles_two, bennettTwoNodes_zero, bennettTwoNodes_one,
       bennettTwoNodes_two]
     rw [bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1, hanti2, hanti3, Finset.antidiagonal_zero,
+    norm_num [hfin01, hfin02, hfin10, hfin12, hfin20, hfin21, hanti1, hanti2, hanti3, hanti0,
       Ring.choose_zero_right, Ring.choose_one_right, finiteN3_choose_two, finiteN3_choose_three,
       finiteN3RowFactor, finiteN3Matrix, finiteN3DividedMatrix,
-      Matrix.mul_diagonal, finiteN3Constant, finiteN3Left, finiteN3Right]
+      Matrix.mul_diagonal, Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons, finiteN3Constant, finiteN3Left, finiteN3Right]
     field_simp [hx, hy, hd, hd']
     <;> ring
 
```
