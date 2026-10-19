# Transfer already diagnosed proof repairs

2026-10-20T00:17:05.504188+02:00

These three unbuilt A3 proof bodies have the same diagnosed finite-index and norm-rewrite issues as the already verified N3 bodies. Use explicit Fin3 numerals before the reciprocal-pole rewrites, exact vector coordinate lemmas, the qualified complex numeral norm, and explicit scalar calculations. All original theorem signatures, polynomial coefficients and constants are retained. Each file was outside the active protected closure; none is a pending target of the live wave01. No additional compiler was started.

```diff
--- FiniteA3Residual.lean.before
+++ FiniteA3Residual.lean.after
@@ -58,7 +58,7 @@
     have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < 35/32768))
     convert hm using 1 <;> ring
   rw [← finiteA3_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
-  norm_num only [norm_ofNat] at hbound
+  norm_num only [Complex.norm_ofNat] at hbound
   exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])
 
 private theorem finiteA3_rowfactor_scalar (X Y delta r : ℝ)
```
```diff
--- FiniteA3ResidueIdentity.lean.before
+++ FiniteA3ResidueIdentity.lean.after
@@ -12,23 +12,35 @@
     (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
     finiteUnequalClearedEntry x y c 3 2 i j =
       4*finiteA3RowFactor x y i*finiteA3Matrix x y c i j := by
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
   have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
   have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
-  fin_cases i <;> fin_cases j
+  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
+  have hj : j = 0 ∨ j = 1 ∨ j = 2 := by omega
+  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl | rfl
   all_goals
     unfold finiteUnequalClearedEntry
-    simp only [finiteUnequalOtherPoles_zero x y 3 2 (by decide) (by decide),
-      finiteUnequalOtherPoles_one x y 3 2 (by decide) (by decide),
-      finiteUnequalOtherPoles_two x y 3 2 (by decide) (by decide),
-      bennettTwoNodes_zero,bennettTwoNodes_one,bennettTwoNodes_two]
-    rw [bennettClearedTaylor_two_poles_scaled_eval]
-    norm_num [hanti1,hanti2,hanti3,Finset.antidiagonal_zero,
+    first
+    | rw [finiteUnequalOtherPoles_zero x y 3 2 (by decide) (by decide),
+        bennettTwoNodes_zero, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_one x y 3 2 (by decide) (by decide),
+        bennettTwoNodes_one, bennettClearedTaylor_two_poles_scaled_eval]
+    | rw [finiteUnequalOtherPoles_two x y 3 2 (by decide) (by decide),
+        bennettTwoNodes_two, bennettClearedTaylor_two_poles_scaled_eval]
+    norm_num [hfin01,hfin02,hfin10,hfin12,hfin20,hfin21,hanti0,hanti1,hanti2,hanti3,
       finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
       finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
       finiteA3RowFactor,finiteA3Matrix,finiteA3DividedMatrix,Matrix.mul_diagonal,
+      Matrix.cons_val_two,Matrix.head_cons,Matrix.tail_cons,
       finiteA3Constant,finiteA3Left,finiteA3Right]
     field_simp [hx,hy,hd,hd']
     <;> ring
```
```diff
--- FiniteA3Approximation.lean.before
+++ FiniteA3Approximation.lean.after
@@ -63,8 +63,9 @@
           ‖z‖*(‖(x*L)*(sX/(x*z)-θX)‖+‖(y*R)*(sY/(y*z)-θY)‖) := by
         gcongr
         exact norm_add_le _ _
-      _ = _ := by rw [norm_mul,norm_mul,norm_sub_rev (sX/(x*z)),
-          norm_sub_rev (sY/(y*z))]
+      _ = _ := by
+        simp only [norm_mul, norm_sub_rev (sX/(x*z)) θX,
+          norm_sub_rev (sY/(y*z)) θY]
   have herrors :
       ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) ≤
         (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) := by
@@ -83,13 +84,19 @@
       ‖z‖*(‖x*L‖*‖θX-sX/(x*z)‖+‖y*R‖*‖θY-sY/(y*z)‖) <
         2265*‖y‖^6*‖c‖^4/‖z‖ := by
     apply herrors.trans_lt
-    have hm := mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
-    convert hm using 1 <;> dsimp [L,R] <;> ring
+    calc
+      (‖c‖/‖z‖)*((101/100 : ℝ)*(‖L‖+‖R‖)) <
+          (‖c‖/‖z‖)*(2265*‖y‖^6*‖c‖^3) :=
+        mul_lt_mul_of_pos_left hheight (div_pos hC hZ)
+      _ = 2265*‖y‖^6*‖c‖^4/‖z‖ := by ring
   have hres := mul_lt_mul_of_pos_left
     (finiteA3_residual_norm_lt x y c hx hy hc hxy hXY hXC i) hZ
   have hres' : ‖z‖*‖finiteA3Residual x y c i‖ <
       (35/16 : ℝ)*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^5) := by
-    convert hres using 1 <;> ring
+    calc
+      ‖z‖*‖finiteA3Residual x y c i‖ <
+          ‖z‖*((35/16 : ℝ)*‖y‖^3/(‖x‖^4*‖c‖^5)) := hres
+      _ = (35/16 : ℝ)*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^5) := by ring
   exact hnorm.trans_lt (by linarith only [herr,hres'])
 
 /-- The actual A3 inequality for arbitrary full imaginary quadratic
```
