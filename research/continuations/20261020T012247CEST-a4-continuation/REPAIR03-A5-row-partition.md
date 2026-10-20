# Exact A5 row partition

2026-10-20T01:37:32.452962+02:00

Use three explicitly indexed row proofs to reduce single-node cost after the measured 219.82-second A4 identity. Each row theorem is proved for all x,y,c and all columns with the same field and nonzero hypotheses. The parent covers every i:Fin3 by i=0 or i=1 or i=2. No matrix entry, coefficient, hypothesis, heartbeat or timeout limit is changed. This is preparation, not compilation.

```diff
--- FiniteA5ResidueIdentity.before
+++ FiniteA5ResidueIdentity.after
@@ -1,6 +1,6 @@
-import D1Bound5.FiniteA5Matrix
-import D1Bound5.FiniteUnequalEntry
-import D1Bound5.FiniteChooseFive
+import D1Bound5.FiniteA5ResidueRow0
+import D1Bound5.FiniteA5ResidueRow1
+import D1Bound5.FiniteA5ResidueRow2
 
 namespace D1Bound5
 variable {F : Type*} [Field F] [CharZero F]
@@ -12,39 +12,10 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     finiteUnequalClearedEntry x y c 5 4 i j =
       4*finiteA5RowFactor x y i*finiteA5Matrix x y c i j := by
-  have hfin01 : (0 : Fin 3) ≠ 1 := by decide
-  have hfin02 : (0 : Fin 3) ≠ 2 := by decide
-  have hfin10 : (1 : Fin 3) ≠ 0 := by decide
-  have hfin12 : (1 : Fin 3) ≠ 2 := by decide
-  have hfin20 : (2 : Fin 3) ≠ 0 := by decide
-  have hfin21 : (2 : Fin 3) ≠ 1 := by decide
-  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
-  have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
-  have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
-  have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide
-  have hanti4 : Finset.antidiagonal 4 = {(0,4),(1,3),(2,2),(3,1),(4,0)} := by decide
-  have hanti5 : Finset.antidiagonal 5 = {(0,5),(1,4),(2,3),(3,2),(4,1),(5,0)} := by decide
-  have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
-  have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
   have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
-  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
-  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
-  all_goals
-    unfold finiteUnequalClearedEntry
-    first
-    | rw [finiteUnequalOtherPoles_zero x y 5 4 (by decide) (by decide),
-        bennettTwoNodes_zero, bennettClearedTaylor_two_poles_scaled_eval]
-    | rw [finiteUnequalOtherPoles_one x y 5 4 (by decide) (by decide),
-        bennettTwoNodes_one, bennettClearedTaylor_two_poles_scaled_eval]
-    | rw [finiteUnequalOtherPoles_two x y 5 4 (by decide) (by decide),
-        bennettTwoNodes_two, bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hfin01,hfin02,hfin10,hfin12,hfin20,hfin21,hanti0,hanti1,hanti2,hanti3,hanti4,hanti5,
-      finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
-      finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
-      finiteA5RowFactor,finiteA5Matrix,finiteA5DividedMatrix,Matrix.mul_diagonal,
-      Matrix.cons_val_two,Matrix.head_cons,Matrix.tail_cons,
-      finiteA5Constant,finiteA5Left,finiteA5Right]
-    field_simp [hx,hy,hd,hd']
-    <;> ring
+  rcases hi with rfl | rfl | rfl
+  · exact finiteA5_residue_row0 x y c hx hy hxy j
+  · exact finiteA5_residue_row1 x y c hx hy hxy j
+  · exact finiteA5_residue_row2 x y c hx hy hxy j
 
 end D1Bound5
```
